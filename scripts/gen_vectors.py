#!/usr/bin/env python3
"""Generate the differential test vectors for moonstl.

For each package a generator fixes a set of inputs, computes the expected
results with the Python standard library, and writes ``src/<pkg>/gen_<pkg>.mbt``
holding the reference values as top-level ``let`` bindings and the tests that
replay the operations on the library. The same inputs and results are computed
by the Rust generator in ``scripts/rust_vectors`` with the Rust standard
library; ``scripts/check_vector_agreement.sh`` re-runs both and diffs their
manifests, so the two reference implementations must agree exactly. CI only
replays the committed vectors via ``moon test``; it never regenerates them.

Usage: python scripts/gen_vectors.py [--only pkg ...]
"""

import argparse
import math
import sys
from bisect import bisect_left, bisect_right
from itertools import combinations, combinations_with_replacement, permutations, product
from pathlib import Path

import vector_format as vf
from vector_format import data, test, ints, str_arr, char_arr, float_arr, fscalar, tuples, arr_of_arr


# ---------------------------------------------------------------------------
# Shared fixed inputs (identical literals in both languages).
# ---------------------------------------------------------------------------

SORTED_12 = [1, 2, 2, 3, 5, 5, 5, 8, 13, 21, 34, 55]
SEQ_VALUES = [3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5]

UINT64_MASK = (1 << 64) - 1


def _splitmix(state):
    state = (state + 0x9E3779B97F4A7C15) & UINT64_MASK
    z = state
    z = ((z ^ (z >> 30)) * 0xBF58476D1CE4E5B9) & UINT64_MASK
    z = ((z ^ (z >> 27)) * 0x94D049BB133111EB) & UINT64_MASK
    return state, z ^ (z >> 31)


def reservoir_sample(values, k, seed):
    """The draw `reservoir_sample` specifies: Algorithm R over SplitMix64.

    There is no standard-library sampler to compare against, so this is the
    algorithm written out a second time, in a second language, from the same
    stated rules; the statistical claim is checked by the library's own tests.
    """
    out = []
    state = seed & UINT64_MASK
    seen = 0
    for x in values:
        if len(out) < k:
            out.append(x)
        else:
            state, z = _splitmix(state)
            bound = seen + 1
            limit = UINT64_MASK - UINT64_MASK % bound
            while z >= limit:
                state, z = _splitmix(state)
            slot = z % bound
            if slot < k:
                out[slot] = x
        seen += 1
    return out



def gen_algo(src_root, vec_root):
    d, t = [], []

    d.append(data("algo_sorted", "Array[Int32]", ints(SORTED_12), SORTED_12,
                  "A sorted run with repeats, the shared bisect input."))
    left = [bisect_left(SORTED_12, p) for p in range(0, 60)]
    right = [bisect_right(SORTED_12, p) for p in range(0, 60)]
    d.append(data("algo_bisect_left", "Array[Int32]", ints(left), left,
                  "bisect_left of every probe 0..59 into algo_sorted."))
    d.append(data("algo_bisect_right", "Array[Int32]", ints(right), right,
                  "bisect_right of every probe 0..59 into algo_sorted."))
    t.append(test("differential: bisect matches the reference", [
        "for p in 0..<60 {",
        "  @test.assert_eq(@algo.bisect_left(algo_sorted[:], p), algo_bisect_left[p])",
        "  @test.assert_eq(@algo.bisect_right(algo_sorted[:], p), algo_bisect_right[p])",
        "  @test.assert_eq(@algo.equal_range(algo_sorted[:], p), (algo_bisect_left[p], algo_bisect_right[p]))",
        "}",
    ]))

    perms = [list(p) for p in permutations([1, 2, 3])]
    perms2 = [list(p) for p in permutations([1, 2, 3], 2)]
    combos = [list(c) for c in combinations([1, 2, 3, 4], 3)]
    combor = [list(c) for c in combinations_with_replacement([1, 2, 3, 4], 3)]
    cart = [list(p) for p in product([1, 2], [3, 4], [5])]
    powers = []
    for r in range(4):
        for c in combinations([1, 2, 3], r):
            powers.append(list(c))
    d.append(data("algo_perm_pool", "Array[Int32]", ints([1, 2, 3]), [1, 2, 3], "The permutation pool."))
    d.append(data("algo_combo_pool", "Array[Int32]", ints([1, 2, 3, 4]), [1, 2, 3, 4], "The combination pool."))
    d.append(data("algo_cart_pools", "Array[ArrayView[Int32]]", "[[1, 2][:], [3, 4][:], [5][:]]",
                  [[1, 2], [3, 4], [5]], "The three Cartesian pools."))
    d.append(data("algo_perms", "Array[Array[Int32]]", arr_of_arr(perms), perms,
                  "Every permutation of the pool, in itertools order."))
    d.append(data("algo_perms2", "Array[Array[Int32]]", arr_of_arr(perms2), perms2, "Length-2 permutations."))
    d.append(data("algo_combos", "Array[Array[Int32]]", arr_of_arr(combos), combos, "3-combinations."))
    d.append(data("algo_combor", "Array[Array[Int32]]", arr_of_arr(combor), combor, "3-combinations with replacement."))
    d.append(data("algo_cart", "Array[Array[Int32]]", arr_of_arr(cart), cart, "Cartesian product."))
    d.append(data("algo_powerset", "Array[Array[Int32]]", arr_of_arr(powers), powers,
                  "Every subset, ordered by size then position."))
    t.append(test("differential: generators match itertools", [
        "@test.assert_eq(@algo.Permutations::new(algo_perm_pool[:]).iter().to_array(), algo_perms)",
        "@test.assert_eq(@algo.Permutations::new(algo_perm_pool[:], length=2).iter().to_array(), algo_perms2)",
        "@test.assert_eq(@algo.Combinations::new(algo_combo_pool[:], k=3).iter().to_array(), algo_combos)",
        "@test.assert_eq(@algo.CombinationsWithReplacement::new(algo_combo_pool[:], k=3).iter().to_array(), algo_combor)",
        "@test.assert_eq(@algo.Product::new(algo_cart_pools).iter().to_array(), algo_cart)",
        "@test.assert_eq(@algo.Powerset::new([1, 2, 3][:]).iter().to_array(), algo_powerset)",
    ]))

    ordered = sorted(SEQ_VALUES)
    prefix = []
    acc = 0
    for v in SEQ_VALUES:
        acc += v
        prefix.append(acc)
    rotated = SEQ_VALUES[3:] + SEQ_VALUES[:3]
    d.append(data("algo_seq", "Array[Int32]", ints(SEQ_VALUES), SEQ_VALUES, "The shared sequence run."))
    d.append(data("algo_sorted_run", "Array[Int32]", ints(ordered), ordered, "The run sorted ascending."))
    d.append(data("algo_prefix", "Array[Int32]", ints(prefix), prefix, "Running sums of the run."))
    d.append(data("algo_rotated", "Array[Int32]", ints(rotated), rotated, "The run rotated three right."))
    d.append(data("algo_merge_left", "Array[Int32]", ints([1, 4, 7, 8]), [1, 4, 7, 8], "Left merge run."))
    d.append(data("algo_merge_right", "Array[Int32]", ints([2, 3, 5, 9]), [2, 3, 5, 9], "Right merge run."))
    d.append(data("algo_merged", "Array[Int32]", ints(sorted([1, 4, 7, 8, 2, 3, 5, 9])),
                  sorted([1, 4, 7, 8, 2, 3, 5, 9]), "The two runs merged."))
    t.append(test("differential: selection, order, prefix and merge match", [
        "let run : Array[Int32] = algo_seq",
        "@test.assert_eq(@algo.sorted(run[:]), algo_sorted_run)",
        "let probe = run.copy()",
        "@algo.nth_element_in_place(probe, 4)",
        "@test.assert_eq(probe[4], algo_sorted_run[4])",
        "@test.assert_eq(@algo.k_smallest(5, run[:]), algo_sorted_run[:5].to_owned())",
        "@test.assert_eq(@algo.k_largest(3, run[:]), algo_sorted_run[8:].to_owned().rev())",
        "@test.assert_eq(@algo.prefix_sum(run[:], op=(a, b) => a + b), algo_prefix)",
        "@test.assert_eq(@algo.rotate(run[:], mid=3), algo_rotated)",
        "@test.assert_eq(@algo.merge(algo_merge_left[:], algo_merge_right[:]), algo_merged)",
        "let a : Array[Int32] = algo_merge_left",
        "let b : Array[Int32] = algo_merge_right",
        "let merged = a.copy()",
        "@algo.merge_in_place(merged, b)",
        "@test.assert_eq(merged, algo_merged)",
    ]))

    d.append(data("algo_unique", "Array[Int32]", ints([1, 2, 3, 4]), [1, 2, 3, 4], "The run with repeats removed."))
    d.append(data("algo_dupes", "Array[Int32]", ints([1, 3]), [1, 3], "The repeated values."))
    t.append(test("differential: dedup and run queries", [
        "let v : Array[Int32] = [1, 1, 2, 3, 3, 3, 4]",
        "@test.assert_eq(@algo.unique(v[:]), algo_unique)",
        "@test.assert_eq(@algo.duplicates(v[:]), algo_dupes)",
        "@test.assert_eq(@algo.all_equal([7, 7, 7][:]), true)",
        "@test.assert_eq(@algo.all_unique([1, 2, 3][:]), true)",
        "@test.assert_eq(@algo.is_palindrome([1, 2, 1][:]), true)",
        "@test.assert_eq(@algo.mismatch([1, 2, 3][:], [1, 2, 4][:]), Some((2, 2)))",
        "@test.assert_eq(@algo.find_run([1, 4, 7, 1, 4, 9][:], [1, 4][:]), Some(0))",
        "@test.assert_eq(@algo.clamp(12, min=0, max=10), 10)",
    ]))

    windows3 = [SEQ_VALUES[i:i + 3] for i in range(len(SEQ_VALUES) - 2)]
    d.append(data("algo_seq_windows", "Array[Array[Int32]]", arr_of_arr(windows3), windows3,
                  "Every length-3 window of the run, left to right."))
    t.append(test("differential: windows match the reference slices", [
        "@test.assert_eq(@algo.windows(algo_seq[:], 3).to_array(), algo_seq_windows)",
        "@test.assert_eq(@algo.windows(algo_seq[:], 11).to_array().length(), 1)",
        "@test.assert_eq(@algo.windows(algo_seq[:], 12).to_array().length(), 0)",
    ]))

    for seed in (1, 7, 0x2545F4914F6CDD1D):
        drawn = reservoir_sample(SEQ_VALUES, 3, seed)
        name = "algo_sample_%x" % seed
        d.append(data(name, "Array[Int32]", ints(drawn), drawn,
                      "reservoir_sample(k=3, seed=%d) over the run." % seed))
    t.append(test("differential: a seeded draw matches the reference", [
        "@test.assert_eq(@algo.reservoir_sample(algo_seq[:].iter(), k=3, seed=1UL), algo_sample_1)",
        "@test.assert_eq(@algo.reservoir_sample(algo_seq[:].iter(), k=3, seed=7UL), algo_sample_7)",
        "@test.assert_eq(",
        "  @algo.reservoir_sample(algo_seq[:].iter(), k=3, seed=0x2545f4914f6cdd1dUL),",
        "  algo_sample_2545f4914f6cdd1d,",
        ")",
    ]))

    return vf.write("algo", d, t, src_root, vec_root)


def gen_map(src_root, vec_root):
    d, t = [], []

    ops = [
        ("apple", "incr", 1), ("banana", "incr", 1), ("apple", "incr", 1),
        ("cherry", "incr", 1), ("banana", "incr", 1), ("apple", "decr", 1),
        ("date", "incr_by", 4), ("date", "decr_by", 1), ("apple", "incr", 1),
    ]
    counter, order = {}, []
    totals, most = [], []
    for key, verb, amt in ops:
        if verb == "incr":
            counter[key] = counter.get(key, 0) + 1
        elif verb == "decr":
            counter[key] = counter.get(key, 0) - 1
            if counter[key] <= 0:
                del counter[key]
        elif verb == "incr_by":
            counter[key] = counter.get(key, 0) + amt
        else:
            counter[key] = counter.get(key, 0) - amt
            if counter[key] <= 0:
                del counter[key]
        if key not in order and key in counter:
            order.append(key)
        totals.append(sum(counter.values()))
        items = sorted(counter.items(), key=lambda kv: (-kv[1], order.index(kv[0])))[:2]
        most.append([(k, int(c)) for k, c in items])
    d.append(data("map_counter_totals", "Array[Int64]",
                  "[" + ", ".join(str(v) + "L" for v in totals) + "]", totals,
                  "The counter total after each step of the log."))
    d.append(data("map_counter_most", "Array[Array[(String, Int32)]]",
                  vf.arr_of_tuples(most),
                  [[list(x) for x in row] for row in most], "most_common(2) after each step."))
    t.append(test("differential: counter matches a reference", [
        "let counter : @map.Counter[String] = @map.Counter::new()",
        "let log : Array[(String, String, Int32)] = [",
        "  (\"apple\", \"incr\", 1), (\"banana\", \"incr\", 1), (\"apple\", \"incr\", 1),",
        "  (\"cherry\", \"incr\", 1), (\"banana\", \"incr\", 1), (\"apple\", \"decr\", 1),",
        "  (\"date\", \"incr_by\", 4), (\"date\", \"decr_by\", 1), (\"apple\", \"incr\", 1),",
        "]",
        "for step in 0..<log.length() {",
        "  let (key, verb, amount) = log[step]",
        "  if verb == \"incr\" { let _ = counter.incr(key) }",
        "  else if verb == \"decr\" { let _ = counter.decr(key) }",
        "  else if verb == \"incr_by\" { let _ = counter.incr_by(key, amount) }",
        "  else { let _ = counter.decr_by(key, amount) }",
        "  @test.assert_eq(counter.total(), map_counter_totals[step])",
        "  @test.assert_eq(counter.most_common(n=2), map_counter_most[step])",
        "}",
    ]))

    flat_keys = [5, 1, 4, 2, 3, 1, 5, 0, 9, 2]
    d.append(data("map_flatset_from", "Array[Int32]", ints(flat_keys), flat_keys, "Keys fed to a FlatSet."))
    d.append(data("map_flatset_sorted", "Array[Int32]", ints(sorted(set(flat_keys))), sorted(set(flat_keys)),
                  "The FlatSet contents, kept sorted."))
    d.append(data("map_flatset_range", "Array[Int32]", ints([2, 3, 4, 5]), [2, 3, 4, 5],
                  "range(start=2, end=5); the bounds are inclusive."))
    t.append(test("differential: flat set stays sorted", [
        "let set : @map.FlatSet[Int32] = @map.FlatSet::new()",
        "for k in map_flatset_from { let _ = set.insert(k) }",
        "@test.assert_eq(set.to_array(), map_flatset_sorted)",
        "@test.assert_eq(set.range(start=2, end=5).to_array(), map_flatset_range)",
        "@test.assert_eq(set.index_of(4), Ok(4))",
        "@test.assert_eq(set.index_of(9), Ok(6))",
        "// The absent key reports its insertion point, where it would sit in order.",
        "@test.assert_eq(set.index_of(7), Err(6))",
    ]))

    im_ops = [
        ("a", "set", 1), ("b", "set", 2), ("c", "set", 3), ("a", "set", 10),
        ("b", "shift_remove", 0), ("d", "set", 4), ("e", "set", 5),
        ("c", "shift_remove", 0), ("f", "set", 6),
    ]
    model, pos = [], []
    for key, verb, value in im_ops:
        if verb == "set":
            for i in range(len(model)):
                if model[i][0] == key:
                    model[i] = (key, value)
                    break
            else:
                model.append((key, value))
        else:
            for i in range(len(model)):
                if model[i][0] == key:
                    del model[i]
                    break
        present = [m[0] for m in model]
        pos.append(present.index(key) if key in present else -1)
    d.append(data("map_indexmap_final", "Array[(String, Int32)]", tuples(model), model,
                  "The IndexMap after the log, in order."))
    d.append(data("map_indexmap_pos", "Array[Int32]", ints(pos), pos,
                  "The position of each touched key after every step (-1 when absent)."))
    t.append(test("differential: index map positions match a list model", [
        "let m : @map.IndexMap[String, Int32] = @map.IndexMap::new()",
        "let log : Array[(String, String, Int32)] = [",
        "  (\"a\", \"set\", 1), (\"b\", \"set\", 2), (\"c\", \"set\", 3), (\"a\", \"set\", 10),",
        "  (\"b\", \"shift_remove\", 0), (\"d\", \"set\", 4), (\"e\", \"set\", 5),",
        "  (\"c\", \"shift_remove\", 0), (\"f\", \"set\", 6),",
        "]",
        "for step in 0..<log.length() {",
        "  let (key, verb, value) = log[step]",
        "  if verb == \"set\" { let _ = m.set(key, value) } else { let _ = m.shift_remove(key) }",
        "  let want = map_indexmap_pos[step]",
        "  if want < 0 { @test.assert_eq(m.get_index_of(key), None) }",
        "  else { @test.assert_eq(m.get_index_of(key), Some(want)) }",
        "}",
        "@test.assert_eq(m.to_array(), map_indexmap_final)",
    ]))

    rs = [(1, 4), (10, 12), (15, 20)]
    gaps = []
    prev = rs[0][0]
    for a, b in sorted(rs):
        if a > prev:
            gaps.append((prev, a))
        prev = max(prev, b)
    d.append(data("map_rangeset", "Array[(Int32, Int32)]", tuples(rs), rs, "Disjoint ranges."))
    d.append(data("map_rangeset_gaps", "Array[(Int32, Int32)]", tuples(gaps), gaps, "The gaps between them."))
    t.append(test("differential: range set gaps match", [
        "let set : @map.RangeSet[Int32] = @map.RangeSet::new()",
        "for r in map_rangeset { let _ = set.insert(start=r.0, end=r.1) }",
        "@test.assert_eq(set.gaps().to_array(), map_rangeset_gaps)",
    ]))

    return vf.write("map", d, t, src_root, vec_root)


def tuples_arr(rows):
    return "[" + ", ".join(vf.tuple_text(r) for r in rows) + "]"


def gen_heap(src_root, vec_root):
    d, t = [], []
    inserts = [7, 3, 9, 1, 5, 8, 2, 6, 4]
    d.append(data("heap_inserts", "Array[Int32]", ints(inserts), inserts, "Values pushed onto the heaps."))
    d.append(data("heap_min_order", "Array[Int32]", ints(sorted(inserts)), sorted(inserts),
                  "A min-heap pops them in this order."))
    d.append(data("heap_max_order", "Array[Int32]", ints(sorted(inserts, reverse=True)),
                  sorted(inserts, reverse=True), "A max-heap pops them in this order."))
    t.append(test("differential: d-ary heap pop order matches sorted", [
        "let h : @heap.DaryHeap[Int32] = @heap.DaryHeap::new()",
        "for v in heap_inserts { h.push(v) }",
        "@test.assert_eq(h.into_sorted_array(), heap_min_order)",
        "let mx : @heap.DaryHeap[Int32] = @heap.DaryHeap::new(order=@heap.Order::Max)",
        "for v in heap_inserts { mx.push(v) }",
        "@test.assert_eq(mx.into_sorted_array(), heap_max_order)",
    ]))

    pf = [11, 3, 7, 1, 9, 5, 2]
    d.append(data("heap_pf_values", "Array[Int32]", ints(pf), pf, "Values for the pairing and fibonacci heaps."))
    d.append(data("heap_pf_order", "Array[Int32]", ints(sorted(pf)), sorted(pf), "Both heaps pop them in this order."))
    t.append(test("differential: pairing and fibonacci heaps match sorted", [
        "let p : @heap.PairingHeap[Int32] = @heap.PairingHeap::new()",
        "let f : @heap.FibonacciHeap[Int32] = @heap.FibonacciHeap::new()",
        "for v in heap_pf_values { let _ = p.insert(v); let _ = f.insert(v) }",
        "@test.assert_eq(p.into_sorted_array(), heap_pf_order)",
        "@test.assert_eq(f.into_sorted_array(), heap_pf_order)",
    ]))

    mm = [5, 2, 9, 1, 7]
    # Alternate pop_min, pop_max: 1, 9, 2, 7, 5.
    d.append(data("heap_mm_values", "Array[Int32]", ints(mm), mm, "Values pushed onto the min-max heap."))
    d.append(data("heap_mm_seq", "Array[Int32]", ints([1, 9, 2, 7, 5]), [1, 9, 2, 7, 5],
                  "Alternating pop_min, pop_max, ... results."))
    t.append(test("differential: min-max heap alternates from both ends", [
        "let h : @heap.MinMaxHeap[Int32] = @heap.MinMaxHeap::new()",
        "for v in heap_mm_values { h.push(v) }",
        "@test.assert_eq(h.pop_min(), Some(heap_mm_seq[0]))",
        "@test.assert_eq(h.pop_max(), Some(heap_mm_seq[1]))",
        "@test.assert_eq(h.pop_min(), Some(heap_mm_seq[2]))",
        "@test.assert_eq(h.pop_max(), Some(heap_mm_seq[3]))",
        "@test.assert_eq(h.pop_min(), Some(heap_mm_seq[4]))",
    ]))

    d.append(data("heap_radix_key", "Array[Int32]", ints([9, 4, 1, 3, 7, 2, 5, 6, 8, 0]),
                  [9, 4, 1, 3, 7, 2, 5, 6, 8, 0], "Keys pushed onto a radix heap, non-decreasing from the last popped."))
    d.append(data("heap_radix_order", "Array[Int32]", ints([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]),
                  [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], "The keys pop out in this order."))
    t.append(test("differential: radix heap pops in key order", [
        "let h : @heap.RadixHeap[Int32] = @heap.RadixHeap::new()",
        "for k in heap_radix_key { let _ = h.push(k.to_uint64(), k) }",
        "for i in 0..<heap_radix_order.length() {",
        "  @test.assert_eq(h.pop_min(), Some((heap_radix_order[i].to_uint64(), heap_radix_order[i])))",
        "}",
    ]))

    return vf.write("heap", d, t, src_root, vec_root)


def gen_tree(src_root, vec_root):
    d, t = [], []
    arr = [1, 3, 2, 8, 1, 5, 4]
    n = len(arr)
    # prefix_sum(end) is the sum of the first `end` elements (exclusive end).
    prefix = [sum(arr[:i]) for i in range(n)]
    # range_sum(start, end) is the sum over [start, end) (exclusive end).
    ranges = [sum(arr[i:j]) for i in range(n) for j in range(i, n + 1)]
    d.append(data("tree_fenwick_arr", "Array[Int32]", ints(arr), arr, "Values loaded into a Fenwick tree."))
    d.append(data("tree_fenwick_prefix", "Array[Int32]", ints(prefix), prefix, "Sum of the first i elements, for i in 0..n."))
    d.append(data("tree_fenwick_range", "Array[Int32]", ints(ranges), ranges, "Sum over every [i, j) with i in 0..n and j in i..n."))
    t.append(test("differential: fenwick prefix and range sums match", [
        "let tree : @tree.Fenwick[Int32] = @tree.Fenwick::from_array(tree_fenwick_arr[:])",
        "for i in 0..<tree_fenwick_arr.length() { @test.assert_eq(tree.prefix_sum(i), tree_fenwick_prefix[i]) }",
        "let mut ri = 0",
        "for i in 0..<tree_fenwick_arr.length() {",
        "  for j in i..<(tree_fenwick_arr.length() + 1) {",
        "    @test.assert_eq(tree.range_sum(i, j), tree_fenwick_range[ri])",
        "    ri = ri + 1",
        "  }",
        "}",
    ]))

    seg = [3, 1, 4, 1, 5, 9, 2]
    queries = [(0, 7), (0, 4), (3, 7), (1, 6), (2, 5), (4, 7), (0, 1), (6, 7)]
    expected = [sum(seg[a:b]) for a, b in queries]
    d.append(data("tree_seg_arr", "Array[Int32]", ints(seg), seg, "Values loaded into a segment tree."))
    d.append(data("tree_seg_queries", "Array[(Int32, Int32)]", tuples(queries), queries, "The queried ranges."))
    d.append(data("tree_seg_expected", "Array[Int32]", ints(expected), expected, "Sum over each queried range."))
    t.append(test("differential: segment tree range sums match", [
        "let tree : @tree.SegmentTree[Int32] = @tree.SegmentTree::from_array("
        "tree_seg_arr[:], op=(a, b) => a + b, identity=0)",
        "for q in 0..<tree_seg_expected.length() {",
        "  let (a, b) = tree_seg_queries[q]",
        "  @test.assert_eq(tree.query(a, b), tree_seg_expected[q])",
        "}",
    ]))

    ds_ops = [(0, 1), (2, 3), (0, 2), (4, 5), (5, 6), (1, 4)]
    parent = list(range(7))

    def dsu_find(x):
        while parent[x] != x:
            parent[x] = parent[parent[x]]
            x = parent[x]
        return x

    def dsu_union(a, b):
        ra, rb = dsu_find(a), dsu_find(b)
        if ra == rb:
            return False
        parent[rb] = ra
        return True

    for a, b in ds_ops:
        dsu_union(a, b)
    roots = {dsu_find(x) for x in range(7)}
    checks = [(0, 6), (0, 4), (2, 1), (0, 3), (4, 6)]
    ds_count = len(roots)
    ds_conn = [(a, b, dsu_find(a) == dsu_find(b)) for a, b in checks]
    d.append(data("tree_ds_union", "Array[(Int32, Int32)]", tuples(ds_ops), ds_ops,
                  "Unions applied to a disjoint set of seven nodes."))
    d.append(data("tree_ds_count", "Int32", str(ds_count), ds_count,
                  "The number of components afterwards."))
    d.append(data("tree_ds_connected", "Array[(Int32, Int32, Bool)]",
                  "[" + ", ".join("(%d, %d, %s)" % (a, b, "true" if c else "false") for a, b, c in ds_conn) + "]",
                  [[a, b, bool(c)] for a, b, c in ds_conn], "Selected connectivity checks."))
    t.append(test("differential: disjoint set components match", [
        "let ds : @tree.DisjointSet = @tree.DisjointSet::new()",
        "for _ in 0..<7 { let _ = ds.add() }",
        "for p in tree_ds_union { let _ = ds.union(p.0, p.1) }",
        "@test.assert_eq(ds.set_count(), tree_ds_count)",
        "for c in tree_ds_connected { @test.assert_eq(ds.connected(c.0, c.1), c.2) }",
        "let mut total = 0",
        "for s in ds.to_sets() { total = total + s.length() }",
        "@test.assert_eq(total, 7)",
    ]))

    treap = [50, 30, 70, 20, 40, 60, 80, 10, 25, 35]
    d.append(data("tree_treap_keys", "Array[Int32]", ints(treap), treap, "Keys inserted into a treap."))
    d.append(data("tree_treap_inorder", "Array[Int32]", ints(sorted(treap)), sorted(treap),
                  "In-order traversal yields the keys sorted."))
    t.append(test("differential: treap in-order traversal is sorted", [
        "let m : @tree.Treap[Int32, Int32] = @tree.Treap::new()",
        "for k in tree_treap_keys { let _ = m.set(k, k * 2) }",
        "let keys = m.to_array().map(e => e.0)",
        "@test.assert_eq(keys, tree_treap_inorder)",
    ]))

    return vf.write("tree", d, t, src_root, vec_root)


def gen_cache(src_root, vec_root):
    d, t = [], []
    ops = [
        (0, "set", 1), (1, "set", 2), (2, "set", 3), (0, "get", 0),
        (3, "set", 4), (2, "get", 0), (4, "set", 5), (1, "set", 6),
    ]
    lru, evicted, survivors = [], [], []
    for key, verb, value in ops:
        ev = -1
        if verb == "set":
            if key in lru:
                lru.remove(key)
            else:
                if len(lru) >= 3:
                    ev = lru.pop(0)
            lru.append(key)
        else:
            if key in lru:
                lru.remove(key)
                lru.append(key)
        evicted.append(ev)
        survivors.append(sorted(lru))
    d.append(data("cache_lru_evicted", "Array[Int32]", ints(evicted), evicted,
                  "The key index evicted at each LRU step (-1 when none)."))
    d.append(data("cache_lru_survivors", "Array[Array[Int32]]", arr_of_arr(survivors), survivors,
                  "Surviving key indices after each step, sorted."))
    t.append(test("differential: lru eviction order matches", [
        "let cache : @cache.LruCache[Int32, Int32] = @cache.LruCache::new(capacity=3)",
        "let log : Array[(Int32, String, Int32)] = [",
        "  (0, \"set\", 1), (1, \"set\", 2), (2, \"set\", 3), (0, \"get\", 0),",
        "  (3, \"set\", 4), (2, \"get\", 0), (4, \"set\", 5), (1, \"set\", 6),",
        "]",
        "for step in 0..<log.length() {",
        "  let (key, verb, value) = log[step]",
        "  if verb == \"set\" {",
        "    let displaced = cache.set(key, value)",
        "    if cache_lru_evicted[step] < 0 {",
        "      @test.assert_eq(displaced, None)",
        "    } else {",
        "      match displaced {",
        "        Some(pair) => @test.assert_eq(pair.0, cache_lru_evicted[step])",
        "        None => @test.assert_eq(false, true)",
        "      }",
        "    }",
        "  } else { let _ = cache.get(key) }",
        "  @test.assert_eq(cache.length(), cache_lru_survivors[step].length())",
        "  for k in cache_lru_survivors[step] { @test.assert_eq(cache.contains(k), true) }",
        "}",
    ]))

    lfu_ops = [(0, "set"), (1, "set"), (2, "set"), (0, "get"), (0, "get"), (1, "get"), (3, "set")]
    freq, order = {}, []
    evicted = -1
    for key, verb in lfu_ops:
        if verb == "set":
            if key in freq:
                freq[key] += 1
            else:
                if len(freq) >= 3:
                    evicted = min(order, key=lambda k: (freq[k], order.index(k)))
                    del freq[evicted]
                    order.remove(evicted)
                freq[key] = 1
                order.append(key)
        else:
            if key in freq:
                freq[key] += 1
                order.remove(key)
                order.append(key)
    d.append(data("cache_lfu_evicted", "Int32", str(evicted), evicted,
                  "The key the LFU cache evicts when the seventh insert arrives."))
    t.append(test("differential: lfu keeps the most frequent", [
        "let cache : @cache.LfuCache[Int32, Int32] = @cache.LfuCache::new(capacity=3)",
        "let _ = cache.set(0, 1)",
        "let _ = cache.set(1, 1)",
        "let _ = cache.set(2, 1)",
        "let _ = cache.get(0)",
        "let _ = cache.get(0)",
        "let _ = cache.get(1)",
        "let displaced = cache.set(3, 1)",
        "match displaced {",
        "  Some(pair) => @test.assert_eq(pair.0, cache_lfu_evicted)",
        "  None => @test.assert_eq(false, true)",
        "}",
        "@test.assert_eq(cache.frequency(0), Some(3))",
        "@test.assert_eq(cache.frequency(1), Some(2))",
        "@test.assert_eq(cache.frequency(2), None)",
    ]))

    # All three keys are inserted at time 0; an entry is dropped when read at or
    # after its deadline (now >= expire), so the alive count at each queried
    # time is the number of deadlines still ahead.
    deadlines = [10, 10, 108]  # key 0 -> 10, key 1 -> 10, key 2 -> 108
    times = [0, 5, 8, 10, 108]
    alive_count = [sum(1 for d in deadlines if t < d) for t in times]
    d.append(data("cache_exp_times", "Array[Int64]",
                  "[" + ", ".join(str(x) + "L" for x in times) + "]", times, "The queried times."))
    d.append(data("cache_exp_alive_count", "Array[Int32]", ints(alive_count), alive_count,
                  "The number of keys still alive when read at each time."))
    t.append(test("differential: expiring cache drops at the deadline", [
        "let mut now = 0L",
        "let cache : @cache.ExpiringCache[Int32, Int32] = @cache.ExpiringCache::new("
        "ttl=100, capacity=8, now=() => now)",
        "let _ = cache.set(0, 1, ttl=10)",
        "let _ = cache.set(1, 1, ttl=10)",
        "let _ = cache.set(2, 1, ttl=108)",
        "for i in 0..<cache_exp_times.length() {",
        "  now = cache_exp_times[i]",
        "  let mut alive = 0",
        "  if cache.get(0) is Some(_) { alive = alive + 1 }",
        "  if cache.get(1) is Some(_) { alive = alive + 1 }",
        "  if cache.get(2) is Some(_) { alive = alive + 1 }",
        "  @test.assert_eq(alive, cache_exp_alive_count[i])",
        "}",
    ]))

    return vf.write("cache", d, t, src_root, vec_root)


def gen_seq(src_root, vec_root):
    d, t = [], []
    d.append(data("seq_ring_pushes", "Array[Int32]", ints([1, 2, 3, 4, 5]), [1, 2, 3, 4, 5],
                  "Values pushed onto a fixed-capacity ring buffer."))
    d.append(data("seq_ring_final", "Array[Int32]", ints([3, 4, 5]), [3, 4, 5],
                  "The ring contents front to back once full."))
    t.append(test("differential: ring buffer overwrite keeps the newest", [
        "let ring : @seq.RingBuffer[Int32] = @seq.RingBuffer::new("
        "capacity=3, overflow=@seq.Overflow::Overwrite)",
        "for v in seq_ring_pushes { let _ = ring.push_back(v) }",
        "@test.assert_eq(ring.to_array(), seq_ring_final)",
        "@test.assert_eq(ring.front(), Some(3))",
        "@test.assert_eq(ring.back(), Some(5))",
    ]))

    bits = [0, 1, 3, 7, 15, 33]
    total = 40
    ones = [1 if b in bits else 0 for b in range(total)]
    # rank(index) is the number of set bits in [0, index), matching the library.
    rank = [sum(ones[:i]) for i in range(total)]
    select = []
    for k in range(len(bits)):
        c = 0
        for b in range(total):
            if ones[b]:
                if c == k:
                    select.append(b)
                    break
                c += 1
        else:
            select.append(-1)
    d.append(data("seq_bits_set", "Array[Int32]", ints(bits), bits, "The indices of the set bits."))
    d.append(data("seq_bits_rank", "Array[Int32]", ints(rank), rank, "Set bits in [0, i), for each i."))
    d.append(data("seq_bits_select", "Array[Int32]", ints(select), select, "The k-th set bit, -1 when out of range."))
    t.append(test("differential: bit set rank and select match", [
        "let set : @seq.BitSet = @seq.BitSet::new(capacity=40)",
        "for b in seq_bits_set { let _ = set.insert(b) }",
        "for i in 0..<40 { @test.assert_eq(set.rank(i), seq_bits_rank[i]) }",
        "for k in 0..<seq_bits_select.length() {",
        "  let want = seq_bits_select[k]",
        "  if want < 0 { @test.assert_eq(set.select(k), None) }",
        "  else { @test.assert_eq(set.select(k), Some(want)) }",
        "}",
    ]))

    s = list("ab")
    for op, pos, val in [("insert", 0, "c"), ("insert", 3, "a"), ("remove", 1, None), ("insert", 6, "x")]:
        if op == "insert":
            s.insert(pos, val)
        else:
            del s[pos]
    d.append(data("seq_gap_final", "Array[Char]", char_arr(s), "".join(s), "The text after the edit log."))
    t.append(test("differential: gap buffer edits match a reference", [
        "let buf : @seq.GapBuffer[Char] = @seq.GapBuffer::new()",
        "let _ = buf.insert(0, 'a')",
        "let _ = buf.insert(1, 'b')",
        "let _ = buf.insert(0, 'c')",
        "let _ = buf.insert(3, 'a')",
        "let _ = buf.remove(1)",
        "let _ = buf.insert(6, 'x')",
        "@test.assert_eq(buf.to_array(), seq_gap_final)",
    ]))

    lst = []
    for op, v in [("push_back", 1), ("push_front", 0), ("push_back", 2), ("push_back", 3),
                  ("pop_front", None), ("pop_back", None)]:
        if op == "push_back":
            lst.append(v)
        elif op == "push_front":
            lst.insert(0, v)
        elif op == "pop_front":
            lst.pop(0)
        else:
            lst.pop()
    d.append(data("seq_list_final", "Array[Int32]", ints(lst), lst, "The list after the push and pop log."))
    t.append(test("differential: linked list edits match a reference", [
        "let ll : @seq.LinkedList[Int32] = @seq.LinkedList::new()",
        "ll.push_back(1)",
        "ll.push_front(0)",
        "ll.push_back(2)",
        "ll.push_back(3)",
        "let _ = ll.pop_front()",
        "let _ = ll.pop_back()",
        "@test.assert_eq(ll.to_array(), seq_list_final)",
    ]))

    return vf.write("seq", d, t, src_root, vec_root)


def gen_sketch(src_root, vec_root):
    d, t = [], []
    d.append(data("sketch_cm_items", "Array[String]", str_arr(["a", "a", "a", "b", "b", "c"]),
                  ["a", "a", "a", "b", "b", "c"], "The items fed to a wide count-min sketch."))
    d.append(data("sketch_cm_true", "Array[Int32]", ints([3, 2, 1]), [3, 2, 1], "The true counts of a, b, c."))
    total = 6
    eps = 1.0 / 100
    d.append(data("sketch_cm_upper", "Array[Int32]", ints([3 + math.ceil(eps * total), 2 + math.ceil(eps * total),
                  1 + math.ceil(eps * total)]),
                  [3 + math.ceil(eps * total), 2 + math.ceil(eps * total), 1 + math.ceil(eps * total)],
                  "The promised upper bound: true count plus the error."))
    t.append(test("differential: count-min is within the promised error", [
        "let sketch : @sketch.CountMinSketch[String] = @sketch.CountMinSketch::new("
        "epsilon=0.01, confidence=0.99)",
        "let keys : Array[String] = [\"a\", \"b\", \"c\"]",
        "for item in sketch_cm_items { let _ = sketch.insert(item) }",
        "for i in 0..<3 {",
        "  let est = sketch.estimate(keys[i])",
        "  @test.assert_eq(est >= sketch_cm_true[i], true)",
        "  @test.assert_eq(est <= sketch_cm_upper[i], true)",
        "}",
    ]))

    hll_n = 10000
    p = 12
    rel = 1.04 / math.sqrt(1 << p)
    d.append(data("sketch_hll_count", "Int32", str(hll_n), hll_n, "Distinct integers added to the HLL."))
    d.append(data("sketch_hll_rel", "Double", fscalar(rel), round(rel, 9),
                  "The relative standard error at precision 12."))
    t.append(test("differential: hyperloglog is within three standard errors", [
        "let hll : @sketch.HyperLogLog[Int32] = @sketch.HyperLogLog::new("
        "precision=12, hash_seed=0)",
        "for i in 0..<sketch_hll_count { hll.add(i) }",
        "let est = hll.estimate()",
        "let low = sketch_hll_count.to_double() * (1.0 - 3.0 * sketch_hll_rel)",
        "let high = sketch_hll_count.to_double() * (1.0 + 3.0 * sketch_hll_rel)",
        "@test.assert_eq(est >= low && est <= high, true)",
    ]))

    td = list(range(1, 1001))
    q = [td[int(0.05 * (len(td) - 1))], td[int(0.50 * (len(td) - 1))], td[int(0.95 * (len(td) - 1))]]
    d.append(data("sketch_td_true", "Array[Double]", float_arr([float(x) for x in q]),
                  [float(x) for x in q], "The true 5, 50 and 95 percentiles of 1..1000."))
    t.append(test("differential: t-digest quantiles are near the true ones", [
        "let td : @sketch.TDigest = @sketch.TDigest::new(compression=100.0)",
        "for i in 1..<1001 { td.add(i.to_double()) }",
        "let p05 = td.quantile(0.05)",
        "let p50 = td.quantile(0.5)",
        "let p95 = td.quantile(0.95)",
        "@test.assert_eq(p05 > sketch_td_true[0] - 8.0 && p05 < sketch_td_true[0] + 8.0, true)",
        "@test.assert_eq(p50 > sketch_td_true[1] - 8.0 && p50 < sketch_td_true[1] + 8.0, true)",
        "@test.assert_eq(p95 > sketch_td_true[2] - 8.0 && p95 < sketch_td_true[2] + 8.0, true)",
    ]))

    fp = 0.01
    d.append(data("sketch_bloom_fp_rate", "Double", fscalar(fp), fp,
                  "The design false-positive rate of the bloom filter."))
    t.append(test("differential: bloom has no false negatives", [
        "let bloom : @sketch.BloomFilter[String] = @sketch.BloomFilter::new("
        "expected_items=200, hash_seed=0)",
        "for i in 0..<200 { let _ = bloom.insert(\"k\" + i.to_string()) }",
        "for i in 0..<200 { @test.assert_eq(bloom.may_contain(\"k\" + i.to_string()), true) }",
        "let mut false_pos = 0",
        "for i in 0..<200 { if bloom.may_contain(\"q\" + i.to_string()) { false_pos = false_pos + 1 } }",
        "@test.assert_eq(false_pos.to_double() / 200.0 < 2.0 * sketch_bloom_fp_rate, true)",
    ]))

    return vf.write("sketch", d, t, src_root, vec_root)


def gen_text(src_root, vec_root):
    d, t = [], []
    text = "ababcababcab"
    pattern = "cabab"
    occ = [i for i in range(len(text) - len(pattern) + 1) if text[i:i + len(pattern)] == pattern]
    d.append(data("text_text", "String", '"' + text + '"', text, "The text the searchers scan."))
    d.append(data("text_kmp_pattern", "String", '"' + pattern + '"', pattern, "The KMP pattern."))
    d.append(data("text_kmp_occ", "Array[Int32]", ints(occ), occ, "Every start of the pattern."))
    t.append(test("differential: kmp finds every occurrence", [
        "let kmp : @text.Kmp = @text.Kmp::new(text_kmp_pattern)",
        "@test.assert_eq(kmp.search_all(text_text).to_array(), text_kmp_occ)",
    ]))

    ac_text = "ushers"
    ac_patterns = ["he", "she", "his", "hers"]
    # For each pattern (by insertion index), the sorted start positions where
    # it occurs. Matches at the same position are reported in an
    # implementation-defined order, so the test checks per-pattern positions
    # rather than the report order.
    per_pattern = []
    for i, p in enumerate(ac_patterns):
        s = ac_text.find(p)
        starts = []
        while s >= 0:
            starts.append(s)
            s = ac_text.find(p, s + 1)
        per_pattern.append(sorted(starts))
    d.append(data("text_ac_text", "String", '"' + ac_text + '"', ac_text, "The Aho-Corasick text."))
    d.append(data("text_ac_starts", "Array[Array[Int32]]", arr_of_arr(per_pattern), per_pattern,
                  "For each pattern, in order, the start positions where it occurs."))
    d.append(data("text_ac_total", "Int32", str(sum(len(r) for r in per_pattern)),
                  sum(len(r) for r in per_pattern), "The total number of occurrences."))
    t.append(test("differential: aho-corasick finds every hit", [
        "let ac : @text.AhoCorasick = @text.AhoCorasick::new([\"he\", \"she\", \"his\", \"hers\"])",
        "let matches = ac.search_all(text_ac_text).to_array()",
        "@test.assert_eq(matches.length(), text_ac_total)",
        "for m in matches {",
        "  let p = m.0",
        "  let s = m.1",
        "  let mut valid = false",
        "  for t in text_ac_starts[p] {",
        "    if t == s { valid = true }",
        "  }",
        "  @test.assert_eq(valid, true)",
        "}",
    ]))

    z_str = "aabxaaby"
    z = _z(z_str)
    d.append(data("text_z_str", "String", '"' + z_str + '"', z_str, "The string whose Z-function is taken."))
    d.append(data("text_z_arr", "Array[Int32]", ints(z), z, "The Z-function of the string."))
    t.append(test("differential: z function matches a reference", [
        "@test.assert_eq(@text.z_function(text_z_str), text_z_arr)",
    ]))

    sa_str = "banana"
    sa = sorted(range(len(sa_str)), key=lambda i: sa_str[i:])
    d.append(data("text_sa_str", "String", '"' + sa_str + '"', sa_str, "The string whose suffixes are ordered."))
    d.append(data("text_sa_order", "Array[Int32]", ints(sa), sa, "Suffix starts in lexicographic order."))
    t.append(test("differential: suffix array orders the suffixes", [
        "let sa : @text.SuffixArray = @text.SuffixArray::new(text_sa_str)",
        "@test.assert_eq(sa.to_array(), text_sa_order)",
    ]))

    a, b = "abcd", "acb"
    from difflib import SequenceMatcher as _SM
    ratio = _SM(None, a, b).ratio()
    d.append(data("text_sm_a", "String", '"' + a + '"', a, "The first sequence of the matcher."))
    d.append(data("text_sm_b", "String", '"' + b + '"', b, "The second sequence of the matcher."))
    d.append(data("text_sm_ratio", "Double", fscalar(ratio), round(ratio, 9),
                  "The similarity ratio of the two sequences."))
    t.append(test("differential: sequence matcher ratio matches difflib", [
        "let m : @text.SequenceMatcher[Char] = @text.SequenceMatcher::new("
        "text_sm_a.iter().to_array(), text_sm_b.iter().to_array())",
        "@test.assert_eq(m.ratio() > text_sm_ratio - 0.0000001 && m.ratio() < text_sm_ratio + 0.0000001, true)",
    ]))

    return vf.write("text", d, t, src_root, vec_root)


def _z(s):
    n = len(s)
    z = [0] * n
    if n > 0:
        z[0] = n  # the library's convention for index 0
    l = r = 0
    for i in range(1, n):
        if i < r:
            z[i] = min(r - i, z[i - l])
        while i + z[i] < n and s[z[i]] == s[i + z[i]]:
            z[i] += 1
        if i + z[i] > r:
            l, r = i, i + z[i]
    return z


def gen_phf(src_root, vec_root):
    d, t = [], []
    keys = ["alpha", "beta", "gamma", "delta", "epsilon", "zeta", "eta", "theta"]
    values = list(range(1, len(keys) + 1))
    absent = ["iota", "kappa", "lambda", "mu", "nu"]
    d.append(data("phf_keys", "Array[String]", str_arr(keys), keys, "The keys of the perfect hash map."))
    d.append(data("phf_values", "Array[Int32]", ints(values), values, "The value of each key."))
    d.append(data("phf_absent", "Array[String]", str_arr(absent), absent, "Keys not in the map."))
    t.append(test("differential: perfect hash map answers its key set", [
        "let builder : @phf.PhfBuilder[String, Int32] = @phf.PhfBuilder::new("
        "phf_options=@phf.phf_options)",
        "for i in 0..<phf_keys.length() { let _ = builder.entry(phf_keys[i], phf_values[i]) }",
        "let map : @phf.PhfMap[String, Int32] = builder.build()",
        "for i in 0..<phf_keys.length() { @test.assert_eq(map.get(phf_keys[i]), Some(phf_values[i])) }",
        "for k in phf_absent { @test.assert_eq(map.contains(k), false) }",
        "@test.assert_eq(map.length(), phf_keys.length())",
    ]))
    d.append(data("phf_index", "Array[Int32]", ints(list(range(len(keys)))), list(range(len(keys))),
                  "The index of each key in the ordered map."))
    t.append(test("differential: ordered perfect hash map gives the index", [
        "let builder : @phf.PhfBuilder[String, Int32] = @phf.PhfBuilder::new("
        "phf_options=@phf.phf_options)",
        "for i in 0..<phf_keys.length() { let _ = builder.entry(phf_keys[i], phf_values[i]) }",
        "let om : @phf.PhfOrderedMap[String, Int32] = builder.build_ordered()",
        "for i in 0..<phf_keys.length() { @test.assert_eq(om.index(phf_keys[i]), Some(phf_index[i])) }",
    ]))

    return vf.write("phf", d, t, src_root, vec_root)


GENERATORS = {
    "algo": gen_algo, "map": gen_map, "heap": gen_heap, "tree": gen_tree,
    "cache": gen_cache, "seq": gen_seq, "sketch": gen_sketch, "text": gen_text, "phf": gen_phf,
}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--only", nargs="*", default=vf.PKGS, choices=vf.PKGS)
    ap.add_argument("--src", default=str(Path(__file__).resolve().parent.parent / "src"))
    ap.add_argument("--vec", default=str(Path(__file__).resolve().parent.parent / "scripts" / "vectors"))
    args = ap.parse_args()
    for pkg in args.only:
        GENERATORS[pkg](args.src, args.vec)
        print("wrote", pkg)
    return 0


if __name__ == "__main__":
    sys.exit(main())
