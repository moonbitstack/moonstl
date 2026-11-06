///|
/// The one error type, so a caller can catch it without naming the package.
pub using @spec {type Refused}

///|
pub using @seq {
  type RingBuffer,
  type Overflow,
  type Slab,
  type SlotKey,
  type SlotMap,
  type DenseSlotMap,
  type SecondaryMap,
  type GapBuffer,
  type BitVec,
  type BitSet,
  type SparseSet,
  type LinkedList,
}

///|
pub using @heap {
  type Order,
  type HeapKey,
  type DaryHeap,
  type IndexHeap,
  type PairingHeap,
  type FibonacciHeap,
  type MinMaxHeap,
  type RadixHeap,
}

///|
pub using @tree {
  type DisjointSet,
  type DisjointSetMap,
  type SegmentTree,
  type LazySegmentTree,
  type Fenwick,
  type IntervalTree,
  type IntervalKey,
  type OrderStatisticTree,
  type SkipList,
  type SkipListOptions,
  type Treap,
  type ArenaTree,
  type TreeId,
}

///|
pub using @sketch {
  type BloomFilter,
  type BloomOptions,
  type Growth,
  type CuckooFilter,
  type CuckooOptions,
  type CountMinSketch,
  type HyperLogLog,
  type ThetaSketch,
  type TDigest,
}

///|
pub using @phf {
  type PhfMap,
  type PhfSet,
  type PhfOrderedMap,
  type PhfOrderedSet,
  type PhfBuilder,
  type PhfBuild,
  type PhfOptions,
  type PhfLayout,
}

///|
pub using @map {
  type IndexMap,
  type IndexSet,
  type MultiMap,
  type MultiSet,
  type SortedMultiMap,
  type SortedMultiSet,
  type BiMap,
  type Counter,
  type DefaultMap,
  type ChainMap,
  type FlatMap,
  type FlatSet,
  type FlatMultiMap,
  type FlatMultiSet,
  type RangeMap,
  type RangeSet,
  type Trie,
  type RadixTree,
  type Overlap,
}

///|
pub using @cache {
  type CacheStats,
  type LruCache,
  type LfuCache,
  type ArcCache,
  type ExpiringCache,
}

///|
pub using @algo {
  type Permutations,
  type Combinations,
  type CombinationsWithReplacement,
  type Product,
  type Powerset,
  type GrayCode,
  type Position,
  type JoinEntry,
}
