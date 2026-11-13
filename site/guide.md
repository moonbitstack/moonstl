# The Guide

The atlas read in order: install it, hold entries in order, bound a cache, answer
from both ends of a heap, keep ranges, sketch a stream, search text, and reach
for the algorithms that save writing a loop. Every snippet on this page is
compiled and run before it is published, and the answer under it is the one the
snippet produced.

## Install and the first map | one module, ten packages

The module is one dependency. `moon add` fetches it, and a package import names
the family you want; the module root re-exports the same types, so
`"moonbitstack/moonstl"` alone is enough when you want several at once.

```sh
moon add moonbitstack/moonstl
```

```moonbit
import {
  "moonbitstack/moonstl",
  "moonbitstack/moonstl/map",
  "moonbitstack/moonstl/algo",
}
```

An `IndexMap` is a hash map that remembers the order its entries arrived in, so
it answers by key and by position from the same structure.

```mbt check
test {
  let index : @map.IndexMap[String, Int32] = @map.IndexMap::new()
  let _ = index.set("a", 1)
  let _ = index.set("b", 2)
  @test.assert_eq(index.get("b"), Some(2))
  @test.assert_eq(index.keys().to_array(), ["a", "b"])
}
```

```text
get("b")             Some(2)
keys().to_array()    ["a", "b"]
```

## Where an entry sits | positions, sorting, removal

Positions are what the order buys you: `get_index` reads an entry by position,
`get_index_of` reads a key's position, and the entries can be reordered without
touching the table. `remove` is `swap_remove` — the last entry takes the hole in
O(1), which moves the positions after the hole. A caller that needs the
remaining positions to stay put calls `shift_remove`, which is O(n).

```mbt check
test {
  let run : @map.IndexMap[Int32, String] = @map.IndexMap::new()
  let _ = run.set(3, "three")
  let _ = run.set(1, "one")
  let _ = run.set(2, "two")
  @test.assert_eq(run.get_index(1), Some((1, "one")))
  run.sort_keys()
  @test.assert_eq(run.keys().to_array(), [1, 2, 3])
  let _ = run.swap_remove(1)
  @test.assert_eq(run.keys().to_array(), [3, 2])
  let _ = run.shift_remove(3)
  @test.assert_eq(run.keys().to_array(), [2])
}
```

```text
get_index(1)              Some((1, "one"))
after sort_keys()         [1, 2, 3]
after swap_remove(1)      [3, 2]
after shift_remove(3)     [2]
```

`IndexSet` is the same container with no values: it keeps insertion order, hands
out positions, and answers `intersection`, `is_subset` and `is_disjoint`.
`FlatMap` keeps its entries in one sorted run instead, which trades O(n) inserts
for a cache-friendly walk in key order.

## Counts and layers | Counter, ChainMap

`Counter` drops a key when its count reaches zero, so the map holds what was
seen rather than what was mentioned. `most_common` breaks a tie by the order the
keys arrived in.

```mbt check
test {
  let counts : @map.Counter[String] = @map.Counter::new()
  for word in ["to", "be", "to", "do"] {
    let _ = counts.incr(word)
  }
  @test.assert_eq(counts.get("to"), 2)
  @test.assert_eq(counts.total(), 4L)
  @test.assert_eq(counts.most_common(n=1), [("to", 2)])
  let _ = counts.decr("do")
  @test.assert_eq(counts.length(), 2)
}
```

```text
get("to")            2
total()              4
most_common(n=1)     [("to", 2)]
after decr("do")     2 keys
```

A `ChainMap` is a stack of maps read as one: a lookup falls through from the
front, and a write always lands in the front map. A child scope sees its
parent's settings and shadows them without touching them.

```mbt check
test {
  let base : Map[String, Int32] = Map([])
  base.set("port", 8080)
  let chain : @map.ChainMap[String, Int32] = @map.ChainMap::new([base])
  let child = chain.new_child()
  child.set("port", 9090)
  @test.assert_eq(child.get("port"), Some(9090))
  @test.assert_eq(chain.get("port"), Some(8080))
}
```

```text
child.get("port")   Some(9090)
chain.get("port")   Some(8080)
```

## Bounded memory | caches with a policy

A cache owns a policy, not a data structure: the entries live in one slab of
slots and the policy decides which slot is handed back when the capacity is
reached. `set` returns what the insert displaced — the pair it replaced when the
key was already there, the pair the policy dropped otherwise.

```mbt check
test {
  let cache : @cache.LruCache[String, Int32] = @cache.LruCache::new(capacity=2)
  let _ = cache.set("a", 1)
  let _ = cache.set("b", 2)
  let _ = cache.get("a")
  @test.assert_eq(cache.set("c", 3), Some(("b", 2)))
  @test.assert_eq(cache.keys().to_array(), ["a", "c"])
  @test.assert_eq(cache.stats().hit_rate(), 1.0)
}
```

```text
set("c", 3)          Some(("b", 2))
keys()               ["a", "c"]
stats().hit_rate()   1.0
```

`LfuCache` drops by access count and breaks a tie by recency; `ArcCache` moves
the share of the cache given to frequent entries as it sees repeats and reports
the four list sizes through `lists()`; `ExpiringCache` reads no clock of its own
— it takes `now`, and every deadline is in that clock's units. That is what lets
a test move time without waiting.

```mbt check
test {
  let mut clock = 0L
  let cache : @cache.ExpiringCache[String, Int32] = @cache.ExpiringCache::new(
    ttl=1_000L, capacity=4, now=fn() { clock },
  )
  let _ = cache.set("token", 7)
  @test.assert_eq(cache.get("token"), Some(7))
  clock = 1_500L
  @test.assert_eq(cache.get("token"), None)
  @test.assert_eq(cache.is_empty(), true)
}
```

```text
get("token") at clock 0       Some(7)
get("token") at clock 1500    None
```

## Priority queues | heaps with handles

A heap that hands out handles lets an entry be found and moved later. `IndexHeap`
keeps a position for every key it holds, so `update` and `remove_at` cost
O(log n) rather than a search.

```mbt check
test {
  let heap : @heap.IndexHeap[Int32] = @heap.IndexHeap::new()
  let slow = heap.insert(9)
  let _ = heap.insert(4)
  let _ = heap.insert(7)
  @test.assert_eq(heap.peek(), Some(4))
  let _ = heap.update(slow, 1)
  @test.assert_eq(heap.pop(), Some(1))
  @test.assert_eq(heap.contains(slow), false)
}
```

```text
peek()                 Some(4)
pop() after update     Some(1)
contains(slow)         false
```

The rest of the family: `DaryHeap` for a plain array heap, `PairingHeap` and
`FibonacciHeap` for node-based heaps whose `decrease_key` costs nothing to undo,
`MinMaxHeap` when both ends are wanted, and `RadixHeap` for monotone integer
keys, which refuses a key below the last one it popped instead of reordering.

## Ranges and ranks | segment trees, Fenwick, interval trees

A segment tree combines an associative operation over a range; a lazy one takes
a range update. Both answer in O(log n).

```mbt check
test {
  let tree : @tree.SegmentTree[Int32] = @tree.SegmentTree::from_array(
    [3, 1, 4, 1, 5], op=(a : Int32, b : Int32) => a + b, identity=0,
  )
  @test.assert_eq(tree.query(1, 4), 6)
  @test.assert_eq(tree.query_all(), 14)
  let _ = tree.set(1, 10)
  @test.assert_eq(tree.query(0, 2), 13)
  let sums : @tree.Fenwick[Int32] = @tree.Fenwick::from_array([5, 2, 7])
  @test.assert_eq(sums.prefix_sum(2), 7)
  sums.add(0, 1)
  @test.assert_eq(sums.prefix_sum(3), 15)
}
```

```text
query(1, 4)                 6
query_all()                 14
query(0, 2) after set       13
prefix_sum(2)               7
prefix_sum(3) after add     15
```

An interval tree answers which spans cover a point, and an order-statistic tree
answers by rank as well as by key.

```mbt check
test {
  let spans : @tree.IntervalTree[Int32, String] = @tree.IntervalTree::new()
  let _ = spans.insert(start=1, end=4, "a")
  let _ = spans.insert(start=3, end=8, "b")
  @test.assert_eq(spans.query_point(2), [(1, 4, "a")])
  @test.assert_eq(spans.query_point(3).length(), 2)
  let ranks : @tree.OrderStatisticTree[Int32] = @tree.OrderStatisticTree::new()
  for key in [5, 3, 8, 1] {
    let _ = ranks.insert(key)
  }
  @test.assert_eq(ranks.count_less(5), 2)
  @test.assert_eq(ranks.select(0), Some(1))
  @test.assert_eq(ranks.select(2), Some(5))
}
```

```text
query_point(2)          [(1, 4, "a")]
query_point(3)          2 spans
count_less(5)           2
select(0), select(2)    Some(1), Some(5)
```

## Sets that merge | union-find

`DisjointSet` starts with every element alone. `union` joins two sets and
`connected` answers whether two elements are already in one. `copy` takes the
whole structure with it, so a copy merges further while the original stays where
it was.

```mbt check
test {
  let sets : @tree.DisjointSet = @tree.DisjointSet::new()
  for _ in 0..<6 {
    let _ = sets.add()
  }
  let _ = sets.union(0, 1)
  let _ = sets.union(1, 2)
  let _ = sets.union(4, 5)
  @test.assert_eq(sets.set_count(), 3)
  @test.assert_eq(sets.connected(0, 2), true)
  @test.assert_eq(sets.component_size(0), 3)
  let twin = sets.copy()
  let _ = twin.union(2, 4)
  let _ = twin.union(3, 5)
  @test.assert_eq(twin.set_count(), 1)
  @test.assert_eq(sets.set_count(), 3)
}
```

```text
set_count()          3
connected(0, 2)      true
component_size(0)    3
twin.set_count()     1
sets.set_count()     3
```

`DisjointSetMap` does the same for keys of any type: a key is interned to an
index the first time it is seen, so `union`, `connected` and `find` take the
keys themselves.

## When an exact answer costs too much | sketches

A sketch trades accuracy for a fixed amount of memory. A Bloom filter has no
false negatives; a Count-Min sketch never under-estimates; a HyperLogLog counts
distinct items; a t-digest answers quantiles. Each round-trips through its own
byte format, so a sketch can be written beside the data it summarises.

```mbt check
test {
  let seen : @sketch.BloomFilter[String] = @sketch.BloomFilter::new(
    expected_items=1000,
  )
  for i in 0..<100 {
    let _ = seen.insert("key-\{i}")
  }
  @test.assert_eq(seen.may_contain("key-42"), true)
  @test.assert_eq(seen.may_contain("never-added"), false)
  let bytes = seen.encode()
  let back = @sketch.BloomFilter::decode(bytes[:])
  @test.assert_eq(back.may_contain("key-42"), true)

  let counts : @sketch.CountMinSketch[String] = @sketch.CountMinSketch::new()
  for _ in 0..<5 {
    counts.insert("a")
  }
  @test.assert_eq(counts.estimate("a") >= 5, true)
  @test.assert_eq(counts.estimate("b"), 0)

  let log : @sketch.HyperLogLog[Int32] = @sketch.HyperLogLog::new(precision=12)
  for i in 0..<10000 {
    log.add(i)
  }
  let estimate = log.estimate()
  @test.assert_eq(estimate > 9500.0 && estimate < 10500.0, true)
}
```

```text
may_contain("key-42")        true
may_contain("never-added")   false
decoded.may_contain(42)      true
estimate("a")                at least 5
estimate("b")                0
hyperloglog of 10000         within 5% of 10000
```

## Strings and their questions | matchers, rope, diffs

One pattern, many patterns, every occurrence, the longest repeated substring:
`text` answers each from a structure built once.

```mbt check
test {
  let kmp = @text.Kmp::new("aba")
  @test.assert_eq(kmp.search_all("ababa").to_array(), [0, 2])
  let ac = @text.AhoCorasick::new(["he", "she", "hers"])
  @test.assert_eq(ac.search_all("ushers").to_array(), [
    (1, 1), (0, 2), (2, 2),
  ])
  let automaton = @text.SuffixAutomaton::new("banana")
  @test.assert_eq(automaton.count_occurrences("ana"), 2)
  let array = @text.SuffixArray::new("banana")
  @test.assert_eq(array.to_array(), [5, 3, 1, 0, 4, 2])
}
```

```text
Kmp("aba").search_all("ababa")    [0, 2]
AhoCorasick(three patterns)       (1, 1) (0, 2) (2, 2)
count_occurrences("ana")          2
suffix order of "banana"          [5, 3, 1, 0, 4, 2]
```

A `Rope` holds a document in chunks and remembers where each chunk starts, so an
edit near the front does not copy the whole text. Offsets are UTF-16 code units,
the unit `String` counts, and an edit that would split a surrogate pair is
refused.

```mbt check
test {
  let rope : @text.Rope = @text.Rope::from_string("the quick brown fox")
  rope.insert(3, ", ")
  @test.assert_eq(rope.to_string(), "the,  quick brown fox")
  @test.assert_eq(rope.length(), 21)
  rope.edit(start=5, end=11, "slow")
  @test.assert_eq(rope.to_string(), "the, slow brown fox")
  @test.assert_eq(rope.line_count(), 1)
}
```

```text
insert(3, ", ")     "the,  quick brown fox"
edit(5..11)         "the, slow brown fox"
line_count()        1
```

`SequenceMatcher` follows the algorithm `difflib` uses, and the diff formats are
written from it, so the output lines up with what Python prints.

```mbt check
test {
  let patch = @text.unified_diff("a\nb\n", "a\nc\n", fromfile="old", tofile="new")
  @test.assert_eq(patch.contains("--- old"), true)
  @test.assert_eq(patch.contains("+++ new"), true)
  @test.assert_eq(patch.contains("-b"), true)
  @test.assert_eq(patch.contains("+c"), true)
}
```

```diff
--- old
+++ new
@@ -1,2 +1,2 @@
 a
-b
+c
```

## Loops you do not have to write | algorithms over runs

Functions that leave the run alone take an `ArrayView[T]`; functions that change
it take `Array[T]` and say so with `_in_place`; everything lazy takes and returns
an `Iter[T]`.

```mbt check
test {
  let run : Array[Int32] = [5, 1, 4, 2]
  @test.assert_eq(@algo.bisect_left(@algo.sorted(run[:]), 4), 2)
  @algo.nth_element_in_place(run, 1)
  @test.assert_eq(run[1], 2)
  @test.assert_eq(@algo.chunks(run.iter(), 2).to_array().length(), 2)
  let pairs : @algo.Permutations[Int32] = @algo.Permutations::new(
    [1, 2, 3], length=2,
  )
  @test.assert_eq(pairs.iter().to_array(), [
    [1, 2], [1, 3], [2, 1], [2, 3], [3, 1], [3, 2],
  ])
}
```

```text
bisect_left(sorted, 4)         2
nth_element_in_place(run, 1)   run[1] == 2
chunks(run, 2)                 2 chunks
Permutations([1,2,3], len=2)   itertools order
```

`windows` walks a run in overlapping slices and `chunks` in disjoint ones; both
are lazy, so a long run is read one window at a time. `reservoir_sample` draws
`k` elements from a stream whose length is not known in advance, in one pass,
with every element equally likely — pass a `seed` when the draw has to repeat.

```mbt check
test {
  let run : Array[Int32] = [1, 2, 3, 4, 5]
  @test.assert_eq(@algo.windows(run[:], 3).to_array(), [
    [1, 2, 3], [2, 3, 4], [3, 4, 5],
  ])
  let drawn = @algo.reservoir_sample(run[:].iter(), k=2, seed=7UL)
  @test.assert_eq(drawn.length(), 2)
  @test.assert_eq(drawn, @algo.reservoir_sample(run[:].iter(), k=2, seed=7UL))
  @test.assert_eq(@algo.reservoir_sample(run[:].iter(), k=9, seed=7UL), run)
}
```

```text
windows(run, 3)          [[1, 2, 3], [2, 3, 4], [3, 4, 5]]
reservoir_sample(k=2)    two elements, the same two on every run
reservoir_sample(k=9)    [1, 2, 3, 4, 5]
```

## Perfect hashes at build time | the #phf annotations

A `phf` table hashes its keys once, while it is built, so a lookup is a single
comparison. The annotation puts that build in the compiler: the list stays as it
is written and the generated table reads it.

<!-- nocheck -->
```moonbit
#phf.ordered_map
let keywords : Array[(String, Token)] = [("fn", Fn), ("let", Let), ("match", Match)]

fn token(word : String) -> Token? {
  keywords_phf.get(word)
}
```

The keys are literal `String`, `Int`, `Int64` or `UInt64` values; the values are
any expression. The table is `keywords_phf`, public when the list is;
`name="..."` renames it, and `build="search"`, `"quick"` or `"minimal"` with
`seed="N"` set the layout. A list changed without running the generator again
either still fits its layout or stops the program at start-up with the reason.

## Failure, and the seed | one error, one seed

Input that cannot be used is refused with one type, `Refused`: a capacity of
zero, a rate outside `(0, 1)`, a branching factor below 2, two sketches of
different shape asked to combine. A lookup that finds nothing returns `None`
instead, and an out-of-range index aborts as `Array` does.

```mbt check
test {
  let built : Result[Unit, Int32] = try {
    let cache : @cache.LruCache[String, Int32] = @cache.LruCache::new(capacity=0)
    let _ = cache
    Ok(())
  } catch {
    @spec.Refused::Capacity(got~) => Err(got)
    _ => Err(-1)
  }
  @test.assert_eq(built, Err(0))
}
```

```text
LruCache::new(capacity=0)    Refused::Capacity(got=0)
```

Hashed containers take a `hash_seed`, drawn once per process from the platform's
entropy, so a key set chosen to collide in one run does not collide in the next.
Pass `hash_seed=0`, or any fixed value, when a run has to be reproducible. The
order of an `IndexMap` never depends on it.

```mbt check
test {
  let a : @map.IndexMap[String, Int32] = @map.IndexMap::new(hash_seed=0)
  let b : @map.IndexMap[String, Int32] = @map.IndexMap::new(hash_seed=0)
  let _ = a.set("x", 1)
  let _ = b.set("x", 1)
  @test.assert_eq(a.keys().to_array(), b.keys().to_array())
  @test.assert_eq(@spec.hash_seed_from(b"moonstl"), @spec.hash_seed_from(b"moonstl"))
}
```

```text
two maps at hash_seed=0      the same layout, the same order
hash_seed_from(b"moonstl")   the same number on every run
```

## Where to go next

The [reference](index.html#reference) lists every public type, method and
function with the description it carries in the source. The
[workbench](index.html#workbench) runs the library compiled to WebAssembly, one
specimen at a time. The [packages](index.html#families) page says which family
holds what. Everything here is also in the
[repository](https://github.com/moonbitstack/moonstl).
