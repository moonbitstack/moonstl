# moonstl

Data structures and algorithms for MoonBit: the containers, caches and sequence
algorithms that the core library leaves out, in one module with one package per
family.

```moonbit
///|
test {
  let map : @map.IndexMap[String, Int32] = @map.IndexMap::new()
  let _ = map.set("a", 1)
  let _ = map.set("b", 2)
  @test.assert_eq(map.get_index(1), Some(("b", 2)))
  @test.assert_eq(map.get_index_of("a"), Some(0))
}
```

## Packages

| Package | Carries |
|:--|:--|
| `spec` | `Refused`, the one error type; `hash_seed`, the per-process seed |
| `map` | `IndexMap`, `IndexSet`, `MultiMap`, `SortedMultiMap`, `BiMap`, `Counter`, `DefaultMap`, `ChainMap`, `FlatMap`, `FlatSet`, `FlatMultiMap`, `FlatMultiSet`, `RangeMap`, `RangeSet`, `Trie`, `RadixTree` |
| `cache` | `LruCache`, `LfuCache`, `ArcCache`, `ExpiringCache`, `memoize`, `CacheStats` |
| `algo` | searching, selection, partitioning, merging and lazy adaptors over `ArrayView` and `Iter`, plus the combinatoric generators |

The module root re-exports the types of these packages, so one import is enough
to name them.

## Index maps: order and position

`IndexMap` keeps insertion order and gives every entry a position. A lookup is a
hash lookup; a position lookup is an array index.

```moonbit
///|
test {
  let map : @map.IndexMap[Int32, String] = @map.IndexMap::new()
  let _ = map.set(3, "three")
  let _ = map.set(1, "one")
  @test.assert_eq(map.keys().to_array(), [3, 1])
  map.sort_keys()
  @test.assert_eq(map.keys().to_array(), [1, 3])
  let _ = map.swap_remove(1)
  @test.assert_eq(map.to_array(), [(3, "three")])
}
```

`remove` is `swap_remove`: the last entry moves into the hole and the container
stays dense in O(1). A caller that needs the remaining positions to stay
contiguous calls `shift_remove`, which is O(n).

## Caches

A cache owns a policy, not a data structure: the entries live in one slab of
slots and the policy decides which slot is handed back when the capacity is
reached.

```moonbit
///|
test {
  let cache : @cache.LruCache[String, Int32] = @cache.LruCache::new(capacity=2)
  let _ = cache.set("a", 1)
  let _ = cache.set("b", 2)
  let _ = cache.get("a")
  @test.assert_eq(cache.set("c", 3), Some(("b", 2)))
  @test.assert_eq(cache.stats().hit_rate(), 1.0)
}
```

`set` returns what the insert displaced — the pair it replaced when the key was
already there, the pair the policy dropped otherwise. `on_evict` sees evictions
only: a `remove` is the caller's own doing and is not reported.

`ArcCache` moves the share of the cache given to frequent entries as it sees
repeats, and `lists` reports the four list sizes so the adaptation can be
watched. `ExpiringCache` reads no clock of its own: it takes `now`, and every
deadline is in that clock's units, which is what lets a test move time without
waiting.

## Algorithms

Functions that leave the run alone take `ArrayView[T]`; functions that change it
take `Array[T]` and say so with `_in_place`; everything lazy takes and returns an
`Iter[T]`.

```moonbit
///|
test {
  let run : Array[Int32] = [5, 1, 4, 2]
  @test.assert_eq(@algo.bisect_left(@algo.sorted(run[:]), 4), 2)
  @algo.nth_element_in_place(run, 1)
  @test.assert_eq(run[1], 2)
  @test.assert_eq(@algo.chunks(run.iter(), 2).to_array().length(), 2)
}
```

The combinatoric generators are structs with `next()` and `iter()`, and they
enumerate in the order Python's `itertools` produces, so a reader can check one
against the other.

```moonbit
///|
test {
  let pairs : @algo.Permutations[Int32] = @algo.Permutations::new([1, 2, 3], length=2)
  @test.assert_eq(pairs.iter().to_array(), [
    [1, 2], [1, 3], [2, 1], [2, 3], [3, 1], [3, 2],
  ])
}
```

## Names, order and failure

Method names follow the core library: `new`, `from_array`, `from_iter`, `length`,
`is_empty`, `clear`, `copy`, `iter`, `get` returning `Option`, `at` aborting.

Ordered containers take `Compare` and also a `_by` form that takes a comparator;
hashed containers take `Hash + Eq` and a `hash_seed`. The seed is drawn once per
process from the platform's entropy, so a table cannot be laid out for a key set
an attacker chose; pin it with `hash_seed=0` when a run has to be reproducible.

Input that cannot be used is refused with one type, `Refused`: a capacity of
zero, a rate outside `(0, 1)`, a branching factor below 2, two sketches of
different shape asked to combine, a range inserted where the overlap policy
forbids it. A lookup that finds nothing returns `None` instead, and an
out-of-range index aborts as `Array` does.

```moonbit
///|
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

## Checks

```
moon check --target all --deny-warn
moon build --target all
moon test --target all
```

## Licence

Apache-2.0.
