# moonstl

Data structures and algorithms for MoonBit: the containers, trees, heaps, caches,
sketch structures and sequence algorithms that the core library does not carry, in
one module with one package per family.

## Status

The interface is drafted and under review. No implementation has landed yet.

- `docs/design/inventory.md` — every capability the module covers, one row each, with
  where it lives and what it costs.
- `docs/design/interface.md` — the types, constructors, signatures and complexities
  the implementation will be written against.

## Packages

| Package | Carries |
|:--|:--|
| `seq` | `RingBuffer`, `Slab`, `SlotMap`, `DenseSlotMap`, `SecondaryMap`, `GapBuffer`, `Rope`, `BitVec`, `BitSet`, `SparseSet`, `LinkedList` |
| `map` | `IndexMap`, `IndexSet`, `MultiMap`, `SortedMultiMap`, `BiMap`, `Counter`, `DefaultMap`, `ChainMap`, `FlatMap`, `FlatSet`, `RangeMap`, `RangeSet`, `Trie`, `RadixTree` |
| `heap` | `DaryHeap`, `IndexHeap`, `PairingHeap`, `FibonacciHeap`, `MinMaxHeap`, `RadixHeap` |
| `tree` | `DisjointSet`, `SegmentTree`, `Fenwick`, `IntervalTree`, `OrderStatisticTree`, `SkipList`, `Treap`, `ArenaTree` |
| `cache` | `LruCache`, `LfuCache`, `ArcCache`, `ExpiringCache` |
| `sketch` | `BloomFilter`, `CuckooFilter`, `CountMinSketch`, `HyperLogLog`, `ThetaSketch`, `TDigest` |
| `algo` | searching, ordering, partitioning, merging, and lazy combinatorics over `ArrayView` and `Iter` |
| `text` | `Kmp`, `BoyerMoore`, `AhoCorasick`, `SuffixArray`, `SuffixAutomaton`, `SequenceMatcher` |
| `phf` | `PhfMap`, `PhfSet`, `PhfBuilder` — tables whose hash is computed once for a fixed key set |

The root package re-exports the types, so naming one costs a single import. It carries
no implementation of its own.

## Working with it

Each package is a directory under `src/`. A package depends on core and on the sibling
packages it needs, never on the module as a whole; a program that wants only the caches
pulls in only the caches.

Method names follow the core library: `new`, `from_array`, `from_iter`, `length`,
`is_empty`, `clear`, `copy`, `iter`, `get` returning `Option`, `at` aborting. Ordered
containers take `Compare`; hashed containers take `Hash + Eq` and a seed that is drawn
per process, so a table cannot be laid out for a key set an attacker chose — pin the
seed and iteration order becomes reproducible. Bad input — a capacity of zero, a rate
outside (0, 1) — is refused with one error type rather than per-type errors.

## Checks

```
moon fmt
moon check --target all --deny-warn
moon build --target all
moon test --target all
```

## Licence

Apache-2.0.
