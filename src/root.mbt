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
