---
name: moonstl
description: Containers the MoonBit core library leaves out - an insertion-ordered map and set, a bijection, a counter, a range map, a trie, four cache eviction policies, and the sequence algorithms and combinatoric generators that go with them. Use it when a program needs order plus hashing, a position for an entry, an LRU or expiry policy, or a bisect/partition/permutation helper instead of writing one.
---

# moonstl

## Install

```
moon add moonbitstack/moonstl
```

```moonbit
import {
  "moonbitstack/moonstl/map",
  "moonbitstack/moonstl/cache",
  "moonbitstack/moonstl/tree",
  "moonbitstack/moonstl/algo",
}
```

The module root re-exports the same types, so `import { "moonbitstack/moonstl" }`
is enough when you want several packages at once.

## Keep insertion order and still look up by key

`IndexMap` hashes the key and keeps the entries in a dense array, so a position
is an index and a lookup is a hash lookup.

```moonbit
fn recent(map : @map.IndexMap[String, Int32]) -> Array[String] {
  let _ = map.set("a", 1)
  let _ = map.set("b", 2)
  map.keys().to_array()
}
```

`remove` is `swap_remove`: the last entry takes the hole, in O(1). Use
`shift_remove` when the remaining positions must not move. `get_index(n)` reads
by position, `get_index_of(key)` reads a key's position.

For a ring of settings that a scope shadows, `ChainMap` reads through a stack and
writes only its first map; for counts, `Counter` drops a key when its count
reaches zero; for spans, `RangeMap` merges touching ranges that hold the same
value.

## Bound a cache

```moonbit
fn fill(cache : @cache.LruCache[String, Int32]) -> Unit {
  let _ = cache.set("a", 1)
  let _ = cache.set("b", 2)
  let dropped = cache.set("c", 3)
  ignore(dropped)
}
```

`set` returns what the insert displaced: the pair it replaced when the key was
already there, the pair the policy dropped otherwise. `LfuCache` drops by access
count, `ArcCache` balances recency against frequency, `ExpiringCache` drops by
deadline and takes its clock from you:

```moonbit
fn with_clock(now : () -> Int64) -> Unit raise {
  let cache : @cache.ExpiringCache[String, Int32] = @cache.ExpiringCache::new(
    ttl=60_000L, capacity=16, now~,
  )
  let _ = cache.set("token", 1)
  ignore(cache.get("token"))
}
```

## Search a sorted run without writing the loop

```moonbit
fn rank(scores : ArrayView[Int32]) -> Int32 {
  @algo.bisect_left(scores, 50)
}
```

`bisect_right` gives the other boundary and `equal_range` gives both. Runs that
have to change in place take an `Array` and say `_in_place`:
`nth_element_in_place`, `partial_sort_in_place`, `stable_partition_in_place`,
`next_permutation_in_place`. The generators (`Permutations`, `Combinations`,
`Powerset`, `Product`, `GrayCode`) are structs with `next()` and `iter()`.

## Merge sets and keep a snapshot

`DisjointSet` numbers its elements, `DisjointSetMap` takes keys and interns them;
both `copy` into a structure that owns its arrays, so a copy merges on its own.

```moonbit
fn merge_pairs(count : Int32) -> (Int32, Int32) {
  let sets : @tree.DisjointSet = @tree.DisjointSet::new()
  for _ in 0..<count {
    let _ = sets.add()
  }
  let twin = sets.copy()
  for start in 0..<(count / 2) {
    let _ = twin.union(2 * start, 2 * start + 1)
  }
  (sets.set_count(), twin.set_count())
}
```

## Everything else in one line each

- `seq`: `RingBuffer` (ceiling, overwrite-or-refuse), `SlotMap`/`DenseSlotMap`
  with generation-checked `SlotKey`s, `Slab` with plain indices, `SecondaryMap`,
  `GapBuffer`, `BitVec`/`BitSet` with rank and select, `SparseSet`, `LinkedList`
  with O(1) splice and split.
- `heap`: `DaryHeap`, `IndexHeap` (handles, `update`/`remove_at`), `PairingHeap`,
  `FibonacciHeap` (`decrease_key`), `MinMaxHeap`, `RadixHeap` (monotone keys).
- `tree`: `DisjointSet` and `DisjointSetMap` (union-find; `copy` is independent
  of its origin), `SegmentTree`, `LazySegmentTree`, `Fenwick`, `IntervalTree`,
  `OrderStatisticTree`, `SkipList`, `Treap`, `ArenaTree`.
- `sketch`: `BloomFilter`, `CuckooFilter`, `CountMinSketch`, `HyperLogLog`,
  `ThetaSketch`, `TDigest`, each with `encode`/`decode`.
- `text`: `Kmp`, `BoyerMoore`, `AhoCorasick`, `SuffixArray`, `SuffixAutomaton`,
  `SequenceMatcher` and the diff formats, `Rope`.
- `phf`: `PhfBuilder` and the four tables whose hash is computed at build time.
  `#phf.map`, `#phf.ordered_map`, `#phf.set` and `#phf.ordered_set` on a
  top-level `let` with a literal list generate `<name>_phf` through
  `moonx moonbitstack/moonstl/cmd/phfgen` as a dev_build rule; keys are literal
  `String`, `Int`, `Int64` or `UInt64`, values any expression.

## Rules worth knowing

- Bad input raises `@spec.Refused`: a capacity of zero, a rate outside `(0, 1)`,
  an overlapping range under `Overlap::Refuse`. A lookup that finds nothing
  returns `None`; an index out of range aborts as `Array` does.
- Hashed containers take `hash_seed`; leave it alone unless a run has to be
  reproducible, then pass a fixed value.
- Ordered containers take `Compare`, and most also a `_by` form that takes a
  comparator instead.
