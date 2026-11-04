# Interface: packages, types, signatures, costs

The surface the implementation is written against. A signature found not to compile is changed here
in the same commit, so this file never drifts from the code.

`Rope`, `RopeView` and `RopeBuilder` live in `text`, not in `seq`. A type belongs to the package of the domain it is specific to. A rope's chunks are
`String`s, its indices are `Char` positions, and a third of its surface (`lines`,
`byte_to_line`, `line_of_char`) only makes sense for text; it is also the only type in
the brief's `seq` table that carries no element parameter, so `seq` becomes uniform
("containers over any `T`") once it leaves. The move also removes a dependency edge
before it exists: `Kmp`, `AhoCorasick` and `SuffixArray` take `StringView` today, and
with `RopeView` in the same package they can accept a rope window without `text`
reaching into `seq`. `GapBuffer`
stays in `seq` — it is `GapBuffer[T]`, generic over the element, and a text editor's use
of it is one caller among others.

`map` and `tree` stay apart. `tree` holds structures whose identity is a shape
  (segments, intervals, prefixes, nodes), while `map` holds associative containers with
  one ordering. Merging them would put `SegmentTree` next to `FlatMap` for no gain, and
  would make the package dependency graph worse: `RangeMap` needs the interval tree.

`seq::LinkedList` is here for the O(1) splice and split that core's persistent singly linked
`List` cannot do.

## Conventions that apply to every package

**Method names.** Core's names, always: `new`, `from_array`, `from_iter`, `length`,
`is_empty`, `clear`, `copy`, `iter`, `rev_iter`, `to_array`, `get` (returns `T?`),
`at` (aborts), `set`, `remove`, `contains`, `push`, `pop`, `push_front`, `push_back`,
`pop_front`, `pop_back`, `front`, `back`, `retain`, `truncate`. Where core has no
equivalent, the name comes from the reference the type was read from, adapted to
MoonBit style (`appendleft` → `push_front`, `swap_remove` stays `swap_remove`).

**Traits.** Every container implements `Eq` where the element does, `Hash` where the
element does, `Show` and `Debug`, and `Default` when a default instance makes sense.
`ToJson` and `FromJson` are implemented where the element is convertible and the
container has an unambiguous JSON shape (a map becomes an object only when the key is
a string; otherwise an array of pairs). Hashed containers require `K : Hash + Eq` and
take a `hash_seed`.

A MoonBit trait takes no type parameter, so there is no `Heap[T]` or `Generator[T]`: what shares
a shape shares its method names, and generic code takes the concrete type or a closure.

Ordered containers require `T : Compare`, and every one of them also has a
`new_by(cmp~ : (T, T) -> Int32)` constructor plus `_by` forms of the methods that
compare, so a caller with an ordering the trait cannot express (a case-insensitive
key, a descending priority) does not have to wrap the element. Those forms are stated
once here and not repeated in every table below.

**The hash seed.** Hashed containers take `hash_seed~ : Int32 = @spec.hash_seed()`. The first call
in a process draws 32 bytes from `@moonseed.bytes(32, @moonseed.system.source)` and remembers the
result, so every process lays its tables out differently, which is what stops a key set chosen to
collide from colliding, and a program that makes no hash table draws nothing. Rust's `RandomState`
and Python's hash randomisation are the precedent; core's `Map` uses a fixed seed.

```mbt
pub fn hash_seed() -> Int32
pub fn hash_seed_is_random() -> Bool
pub fn hash_seed_from(bytes : BytesView) -> Int32
```

`hash_seed_is_random` is `false` only where the platform offers no entropy
(`@moonseed.Unavailable::Platform`, a wasm host without WASI); the seed is then zero and every
container still works. `hash_seed_from` derives a seed from bytes the caller already holds, which is
how a service reproduces its tables across restarts. Pass `hash_seed=0`, or any fixed value, and
iteration order, bucket layout and serialised output stay identical across runs; generated vectors
and fixtures always do.

**Dependencies.** Core, `moonbitstack/moonrand` for the seeded generator, `moonbitstack/moonseed` and
its `system` package for the entropy, and nothing else. Every package imports `spec`, which holds
`Refused` and the seed and nothing else.

**Errors.** Invalid input is `@spec.Refused` and nothing else:

```mbt
pub(all) suberror Refused {
  Capacity(got~ : Int32)                  // a capacity of zero or less, or below what the input needs
  Probability(got~ : Double)              // a rate outside (0, 1)
  Arity(got~ : Int32)                     // a branching factor below 2
  Precision(got~ : Int32)                 // a sketch precision outside its documented range
  DuplicateValue                          // a bijection given a value that is already mapped
  NonMonotone(got~ : UInt64, limit~ : UInt64)  // a radix heap given a key below the last popped one
  TooMany(limit~ : Int32)                 // a fixed capacity given more elements than it holds
  Incompatible                            // two sketches of different shape asked to combine
}
```

Reading an index that is out of range returns `Option`, never `Refused`: `get` returns `T?`, `at`
aborts as core's `op_get` does. A method that takes a capacity and can fail says so with
`raise Refused`; one that cannot, does not.

**Parameters.** A single knob stays flat and takes its type's name: `overflow~ : Overflow = Overwrite`,
`arity~ : Int32 = 4`. Two or more knobs on one type are a record named after the type, with a preset
of the same name, and the parameter takes that name too:

```mbt
pub(all) struct BloomOptions {
  false_positive_rate : Double
  growth : Growth
}
pub let bloom_options : BloomOptions = { false_positive_rate: 0.01, growth: Fixed }
```

Call sites read `BloomFilter::new(expected_items=1000, bloom_options={ ..bloom_options, growth: Scalable })`.
Every policy number names where it comes from in its doc comment.

**Complexity.** `O(1)` is worst case, `O(1)*` amortised, `O(n)` means the number of
elements in the container, `O(k)` a key length or a count the caller asked for.

**Conversions with core.** Every container has `from_array(ArrayView[T])`,
`from_iter(Iter[T])` and `to_array() -> Array[T]`; `to_array` returns the elements in
the container's own order. Views into a container are `ArrayView[T]` or a dedicated
read-only view type (`RopeView`, `FlatMap`'s key and value views). Core's `Deque`,
`Array`, `HashMap`, `Map`, `SortedMap` all convert: `from_deque`, `to_deque`,
`to_hash_map` and so on, added only where the conversion is lossless.

## `seq`

Sequence containers, every one of them parameterised over the element type: a
fixed-capacity ring, two address-by-handle stores, a gap buffer, the bit containers, a
sparse set, and a doubly linked list. Text storage is in `text`, because a rope is not
generic over its contents.

| Type | Backing structure | Invariant |
|:--|:--|:--|
| `RingBuffer[T]` | `Array[T]` plus head and length | `length <= capacity`; when full, the oldest element is dropped or the push is refused |
| `Slab[T]` | value array plus free index list | a removed index is reused, and nothing checks that a stale index is stale |
| `SlotMap[T]` | value array plus generation array plus free list | a key's generation must match the slot's or `get` returns `None` |
| `DenseSlotMap[T]` | slot map plus a dense order array | iteration follows insertion order; removal swaps the last element in |
| `SecondaryMap[T]` | value array indexed by slot | holds values for keys owned by a `SlotMap`; does not create or free slots |
| `GapBuffer[T]` | array with a hole | text before the hole, text after it; moving the hole is the only O(n) operation |
| `BitVec` | `Array[UInt64]` plus bit length | bit `i` lives in word `i / 64` at bit `i % 64` |
| `BitSet` | `Array[UInt64]` | the highest set bit determines the word count |
| `SparseSet[T]` | dense array plus sparse index | membership is O(1) and iteration is dense |
| `LinkedList[T]` | doubly linked nodes | splice and split are O(1); indexing is O(n) |

### `RingBuffer[T]`

| Method | Signature | Cost |
|:--|:--|:--|
| `new` | `fn[T] RingBuffer::new(capacity~ : Int32, overflow~ : Overflow = Overwrite) -> RingBuffer[T] raise Refused` | O(capacity) |
| `from_array` | `fn[T] RingBuffer::from_array(capacity~ : Int32, ArrayView[T], overflow~ : Overflow = Overwrite) -> RingBuffer[T] raise Refused` | O(n) |
| `from_iter` | `fn[T] RingBuffer::from_iter(capacity~ : Int32, Iter[T], overflow~ : Overflow = Overwrite) -> RingBuffer[T] raise Refused` | O(n) |
| `push_back` | `fn[T] RingBuffer::push_back(RingBuffer[T], T) -> T?` | O(1) |
| `push_front` | `fn[T] RingBuffer::push_front(RingBuffer[T], T) -> T?` | O(1) |
| `pop_front` | `fn[T] RingBuffer::pop_front(RingBuffer[T]) -> T?` | O(1) |
| `pop_back` | `fn[T] RingBuffer::pop_back(RingBuffer[T]) -> T?` | O(1) |
| `front`, `back` | `fn[T] RingBuffer::front(RingBuffer[T]) -> T?` | O(1) |
| `get`, `at`, `set` | `get -> T?`, `at -> T` (aborts), `set(Int32, T)` | O(1) |
| `length`, `capacity`, `is_empty`, `is_full` | `-> Int32` / `-> Bool` | O(1) |
| `resize_capacity` | `fn[T] RingBuffer::resize_capacity(RingBuffer[T], capacity~ : Int32) -> Unit raise Refused` | O(n) |
| `as_views` | `fn[T] RingBuffer::as_views(RingBuffer[T]) -> (ArrayView[T], ArrayView[T])` | O(1) |
| `linearize` | `fn[T] RingBuffer::linearize(RingBuffer[T]) -> Unit` | O(n) |
| `iter`, `rev_iter`, `to_array`, `copy`, `clear` | as core | O(n) |

```mbt
pub(all) enum Overflow { Overwrite; Refuse }
```

`push_back` returns the element it dropped when the buffer is full and `overflow` is `Overwrite`, and
`None` otherwise. Under `Refuse` it drops nothing and returns the new element instead, so that a push
stays a single shape and needs no `raise` on the common path; `is_full` asks first. Storage starts
empty and grows up to the capacity on demand, so a capacity is a ceiling rather than an
up-front allocation.

### `SlotMap[T]`, `DenseSlotMap[T]`, `SecondaryMap[T]`, `Slab[T]`

| Method | Signature | Cost |
|:--|:--|:--|
| `new` | `fn[T] SlotMap::new(capacity~ : Int32 = 0) -> SlotMap[T]` | O(capacity) |
| `insert` | `fn[T] SlotMap::insert(SlotMap[T], T) -> SlotKey[T]` | O(1)* |
| `get`, `at` | `get(SlotKey[T]) -> T?`, `at(SlotKey[T]) -> T` (aborts) | O(1) |
| `set` | `fn[T] SlotMap::set(SlotMap[T], SlotKey[T], T) -> Bool` | O(1) |
| `remove` | `fn[T] SlotMap::remove(SlotMap[T], SlotKey[T]) -> T?` | O(1) |
| `contains` | `fn[T] SlotMap::contains(SlotMap[T], SlotKey[T]) -> Bool` | O(1) |
| `keys` | `fn[T] SlotMap::keys(SlotMap[T]) -> Iter[SlotKey[T]]` | O(n) |
| `iter`, `iter2` | `Iter[T]`, `Iter2[SlotKey[T], T]` | O(n) |
| `retain` | `fn[T] SlotMap::retain(SlotMap[T], (SlotKey[T], T) -> Bool) -> Unit` | O(n) |
| `length`, `capacity`, `is_empty`, `clear`, `copy` | as core | O(1) / O(n) |
| `Slab::insert` | `fn[T] Slab::insert(Slab[T], T) -> Int32` | O(1)* |
| `Slab::remove` | `fn[T] Slab::remove(Slab[T], Int32) -> T?` | O(1) |
| `SecondaryMap::new` | `fn[T] SecondaryMap::new() -> SecondaryMap[T]` | O(1) |
| `SecondaryMap::get` | `fn[T] SecondaryMap::get(SecondaryMap[T], SlotKey[T]) -> T?` | O(1) |
| `SecondaryMap::set` | `fn[T] SecondaryMap::set(SecondaryMap[T], SlotKey[T], T) -> Unit raise Refused` | O(1) |
| `DenseSlotMap` | the `SlotMap` surface, with iteration in insertion order and `swap_remove` semantics on `remove` | O(1)* |

```mbt
pub(all) struct SlotKey[T] {
  index : Int32
  generation : UInt32
}
```

`SlotKey` implements `Eq`, `Hash`, `Show`, `Debug`, and `ToJson`/`FromJson` as a pair.
The type parameter exists so that a key cannot be used with the wrong map; it carries
no value.

### `GapBuffer[T]`, `LinkedList[T]`

| Method | Signature | Cost |
|:--|:--|:--|
| `GapBuffer::new` | `fn[T] GapBuffer::new(capacity~ : Int32 = 0) -> GapBuffer[T]` | O(capacity) |
| `GapBuffer::insert` | `fn[T] GapBuffer::insert(GapBuffer[T], index : Int32, T) -> Unit` | O(1)* at the gap, O(n) elsewhere |
| `GapBuffer::remove` | `fn[T] GapBuffer::remove(GapBuffer[T], index : Int32) -> T?` | O(n) move, O(1) remove |
| `GapBuffer::move_gap_to` | `fn[T] GapBuffer::move_gap_to(GapBuffer[T], index : Int32) -> Unit` | O(n) |
| `GapBuffer::get` / `at` / `set` / `length` / `iter` / `to_array` | as core | O(1) |
| `LinkedList::new` | `fn[T] LinkedList::new() -> LinkedList[T]` | O(1) |
| `LinkedList::push_front` / `push_back` / `pop_front` / `pop_back` / `front` / `back` | as core `Deque` | O(1) |
| `LinkedList::splice` | `fn[T] LinkedList::splice(LinkedList[T], other : LinkedList[T]) -> Unit` | O(1) |
| `LinkedList::append` / `split_off` | `append(LinkedList[T]) -> Unit`, `split_off(Int32) -> LinkedList[T]` | O(1) |
| `LinkedList::insert_at` / `remove_at` | `insert_at(Int32, T) -> Unit`, `remove_at(Int32) -> T?` | O(n) |
| `LinkedList::iter` / `rev_iter` / `to_array` / `length` / `is_empty` / `clear` | as core | O(n) |

### `BitVec`, `BitSet`, `SparseSet[T]`

| Method | Signature | Cost |
|:--|:--|:--|
| `BitVec::new` | `fn BitVec::new(capacity~ : Int32 = 0) -> BitVec` | O(capacity/64) |
| `BitVec::push` / `pop` | `push(Bool) -> Unit`, `pop() -> Bool?` | O(1)* |
| `BitVec::get` / `set` | `get(Int32) -> Bool?`, `set(Int32, Bool) -> Unit` | O(1) |
| `BitVec::length` / `count_ones` / `resize` / `iter` / `blocks` | `blocks() -> ArrayView[UInt64]` | O(1) / O(n/64) |
| `BitSet::new` | `fn BitSet::new(capacity~ : Int32 = 0) -> BitSet` | O(capacity/64) |
| `BitSet::insert` / `remove` / `contains` | `insert(Int32) -> Bool`, `remove(Int32) -> Bool`, `contains(Int32) -> Bool` | O(1) |
| `BitSet::rank` / `select` | `rank(Int32) -> Int32`, `select(Int32) -> Int32?` | O(n/64) |
| `BitSet::union` / `intersection` / `difference` / `symmetric_difference` | `(BitSet, BitSet) -> BitSet`, plus `_in_place` forms | O(n/64) |
| `BitSet::is_subset` / `is_superset` / `is_disjoint` | `-> Bool` | O(n/64) |
| `BitSet::length` / `is_empty` / `iter` / `to_array` / `copy` / `clear` | `length` is the count of set bits | O(1) / O(n/64) |
| `SparseSet::new` | `fn[T] SparseSet::new(capacity~ : Int32 = 0) -> SparseSet[T]` | O(capacity) |
| `SparseSet::insert` / `remove` / `contains` | `-> Bool` | O(1) |
| `SparseSet::length` / `is_empty` / `iter` / `to_array` / `clear` / `copy` | `iter` walks the dense part | O(1) / O(n) |

## `map`

Associative containers. Eight types have a distinct shape; four are aliases.

| Type | Ordering | Backing structure | Invariant |
|:--|:--|:--|:--|
| `IndexMap[K, V]` | insertion, plus position | hash table plus dense entry array | an entry's index stays valid until the container is reordered or shifted |
| `IndexSet[K]` | insertion, plus position | as `IndexMap` with `Unit` values | same |
| `MultiMap[K, V]` | insertion per key | hash table of `Array[V]` | one key appears once; its values keep insertion order |
| `SortedMultiMap[K, V]` | key, then value | B-tree of `(K, V)` | equal keys are adjacent, sorted by value |
| `BiMap[K, V]` | insertion | two hash tables, one per direction | the mapping is a bijection |
| `Counter[K]` | insertion | hash table of `Int32` | a key with count 0 is removed |
| `DefaultMap[K, V]` | insertion | hash table plus a factory | `get_or_init` inserts `factory(k)` when absent |
| `ChainMap[K, V]` | first map wins | array of maps | writes go to the first map |
| `FlatMap[K, V]`, `FlatSet[K]` | key order | sorted `Array` of keys and values, or of elements | the array is always sorted and deduplicated |
| `FlatMultiMap[K, V]`, `FlatMultiSet[K]` | key order | sorted array with repeated keys | sorted, may contain repeats |
| `RangeMap[K, V]`, `RangeSet[K]` | interval start | interval tree | intervals do not overlap unless the overlap policy allows it |
| `Trie[T]`, `RadixTree[T]` | key prefix | character trie, compressed radix tree | a node's key is a prefix of every key below it |

`MultiSet[K]` is `MultiMap[K, Unit]` and `SortedMultiSet[K]` is `SortedMultiMap[K, Unit]`
— type aliases, not separate implementations.

### `IndexMap[K, V]` and `IndexSet[K]`

| Method | Signature | Cost |
|:--|:--|:--|
| `new` | `fn[K : Hash + Eq, V] IndexMap::new(capacity~ : Int32 = 0, hash_seed~ : Int32 = @spec.hash_seed()) -> IndexMap[K, V]` | O(capacity) |
| `from_array` | `fn[K : Hash + Eq, V] IndexMap::from_array(ArrayView[(K, V)]) -> IndexMap[K, V]` | O(n) |
| `set` | `fn[K : Hash + Eq, V] IndexMap::set(IndexMap[K, V], K, V) -> V?` | O(1)* |
| `insert_full` | `fn[K : Hash + Eq, V] IndexMap::insert_full(IndexMap[K, V], K, V) -> (Int32, V?)` | O(1)* |
| `get` / `update` | `get(K) -> V?`, `update(K, (V) -> V) -> Bool` | O(1) |
| `get_index` | `fn[K, V] IndexMap::get_index(IndexMap[K, V], Int32) -> (K, V)?` | O(1) |
| `get_index_of` / `get_full` | `get_index_of(K) -> Int32?`, `get_full(K) -> (Int32, K, V)?` | O(1) |
| `remove` / `swap_remove` / `shift_remove` | `-> V?`; `remove` is `swap_remove` | O(1) / O(n) |
| `swap_remove_index` / `shift_remove_index` | `-> (K, V)?` | O(1) / O(n) |
| `move_index` / `swap_indices` | `move_index(Int32, Int32) -> Unit`, `swap_indices(Int32, Int32) -> Unit` | O(n) / O(1) |
| `sort_keys` / `sort_by` / `sort_by_key` | sort the entries and renumber positions | O(n log n) |
| `range` | `fn[K, V] IndexMap::range(IndexMap[K, V], start~ : Int32, len~ : Int32) -> Iter[(K, V)]` | O(len) |
| `keys` / `values` / `iter` / `iter2` | `iter` yields `(K, V)`, `iter2` yields `K, V`; a position comes from `get_index_of` | O(n) |
| `length` / `capacity` / `is_empty` / `clear` / `retain` / `truncate` / `split_off` | as core plus position semantics | O(1) / O(n) |
| `IndexSet` | the same surface without values: `insert(IndexSet, K) -> (Int32, Bool)`, `remove`, `swap_remove`, `get_index`, `get_index_of`, `move_index`, `sort`, `difference`, `intersection`, `union`, `symmetric_difference`, `is_subset`, `is_superset`, `is_disjoint` | as above |

There is no `entry` type. Iterating entry handles would need a mutable borrow the
language does not have; `update(k, f)` and `insert_full` cover what `entry` is used for.

### `MultiMap[K, V]`, `SortedMultiMap[K, V]`, `BiMap[K, V]`

| Method | Signature | Cost |
|:--|:--|:--|
| `MultiMap::new` | `fn[K : Hash + Eq, V] MultiMap::new(capacity~ : Int32 = 0, hash_seed~ : Int32 = @spec.hash_seed()) -> MultiMap[K, V]` | O(capacity) |
| `MultiMap::insert` | `fn[K : Hash + Eq, V] MultiMap::insert(MultiMap[K, V], K, V) -> Unit` | O(1)* |
| `MultiMap::get` | `fn[K, V] MultiMap::get(MultiMap[K, V], K) -> Array[V]` — in insertion order, empty when absent | O(k) |
| `MultiMap::iter_values` | `fn[K, V] MultiMap::iter_values(MultiMap[K, V], K) -> Iter[V]` | O(1) create |
| `MultiMap::contains` / `contains_entry` | `contains(K) -> Bool`, `contains_entry(K, V) -> Bool` | O(1) / O(k) |
| `MultiMap::remove` / `remove_entry` | `remove(K) -> Array[V]`, `remove_entry(K, V) -> Bool` | O(k) |
| `MultiMap::length` / `key_count` | total values / distinct keys | O(1) |
| `MultiMap::iter` / `iter2` | `Iter[(K, V)]`, `Iter2[K, V]` | O(n) |
| `SortedMultiMap::new` | `fn[K : Compare, V : Compare] SortedMultiMap::new() -> SortedMultiMap[K, V]` | O(1) |
| `SortedMultiMap::insert` / `get` / `remove` | `insert(K, V) -> Unit`, `get(K) -> Array[V]`, `remove(K) -> Array[V]` | O(log n) / O(k) |
| `SortedMultiMap::range` | `fn[K : Compare, V] SortedMultiMap::range(SortedMultiMap[K, V], start~ : K, end~ : K) -> Iter[(K, V)]` | O(log n + k) |
| `SortedMultiMap::first` / `last` / `pop_first` / `pop_last` | `-> (K, V)?` | O(log n) |
| `BiMap::new` | `fn[K : Hash + Eq, V : Hash + Eq] BiMap::new(capacity~ : Int32 = 0, hash_seed~ : Int32 = @spec.hash_seed()) -> BiMap[K, V]` | O(capacity) |
| `BiMap::set` | `fn[K : Hash + Eq, V : Hash + Eq] BiMap::set(BiMap[K, V], K, V) -> (K, V)? raise Refused` | O(1)* |
| `BiMap::get` / `get_key` | `get(K) -> V?`, `get_key(V) -> K?` | O(1) |
| `BiMap::remove_key` / `remove_value` | `-> (K, V)?` | O(1) |
| `BiMap::length` / `is_empty` / `iter` / `keys` / `values` / `clear` / `copy` | as core | O(n) |

`BiMap::set` replaces the pair that the key or the value already belongs to and returns
it; it raises `Refused::DuplicateValue` only when the caller asked for `set_new`.

### `Counter[K]`, `DefaultMap[K, V]`, `ChainMap[K, V]`

| Method | Signature | Cost |
|:--|:--|:--|
| `Counter::new` | `fn[K : Hash + Eq] Counter::new(capacity~ : Int32 = 0, hash_seed~ : Int32 = @spec.hash_seed()) -> Counter[K]` | O(capacity) |
| `Counter::incr` / `incr_by` | `incr(K) -> Int32`, `incr_by(K, Int32) -> Int32` (the new count) | O(1)* |
| `Counter::decr` / `decr_by` | `-> Int32`; a count that reaches zero removes the key | O(1) |
| `Counter::get` | `-> Int32` (0 when absent) | O(1) |
| `Counter::total` | `-> Int64` | O(1) |
| `Counter::most_common` | `fn[K : Hash + Eq] Counter::most_common(Counter[K], n~ : Int32) -> Array[(K, Int32)]` | O(n log n) |
| `Counter::elements` | `-> Iter[K]`, repeating each key by its count | O(total) |
| `Counter::add` / `subtract` | `Counter::add(Counter[K], Counter[K]) -> Counter[K]`, `subtract_in_place` | O(n) |
| `Counter::iter` / `length` / `is_empty` / `retain` / `clear` / `copy` | as core | O(n) |
| `DefaultMap::new` | `fn[K : Hash + Eq, V] DefaultMap::new(factory~ : (K) -> V, capacity~ : Int32 = 0, hash_seed~ : Int32 = @spec.hash_seed()) -> DefaultMap[K, V]` | O(capacity) |
| `DefaultMap::get_or_init` | `fn[K, V] DefaultMap::get_or_init(DefaultMap[K, V], K) -> V`, core's name; inserts `factory(k)` when absent | O(1)* |
| `DefaultMap::get` / `set` / `remove` / `contains` | as core `HashMap` | O(1) |
| `ChainMap::new` | `fn[K : Hash + Eq, V] ChainMap::new(maps : Array[Map[K, V]]) -> ChainMap[K, V]` | O(1) |
| `ChainMap::new_child` / `parent` | `new_child(ChainMap[K, V]) -> ChainMap[K, V]`, `parent(ChainMap[K, V]) -> ChainMap[K, V]?` | O(1) |
| `ChainMap::get` / `set` / `remove` / `contains` | `get` searches the chain; `set` writes the first map | O(depth) / O(1) |
| `ChainMap::maps` / `length` / `iter` / `flatten` | `length` is the count of distinct keys; `flatten` copies the chain into one `Map` | O(depth·n) length, O(n) flatten |

### `FlatMap[K, V]`, `FlatSet[K]`, `FlatMultiMap`, `FlatMultiSet`

| Method | Signature | Cost |
|:--|:--|:--|
| `FlatMap::new` | `fn[K : Compare, V] FlatMap::new(capacity~ : Int32 = 0) -> FlatMap[K, V]` | O(capacity) |
| `FlatMap::from_array` | `from_array(ArrayView[(K, V)]) -> FlatMap[K, V]` — sorts, last duplicate wins | O(n log n) |
| `FlatMap::set` | `-> V?` | O(log n) find, O(n) shift |
| `FlatMap::get` / `contains` / `index_of` | `get(K) -> V?`, `index_of(K) -> Result[Int32, Int32]` | O(log n) |
| `FlatMap::get_index` | `-> (K, V)?` | O(1) |
| `FlatMap::remove` | `-> V?` | O(n) |
| `FlatMap::range` | `range(start~ : K, end~ : K) -> Iter[(K, V)]` | O(log n + k) |
| `FlatMap::first` / `last` / `pop_first` / `pop_last` | `-> (K, V)?` | O(1) / O(n) |
| `FlatMap::keys` / `values` / `iter` / `length` / `capacity` / `reserve_capacity` / `shrink_to_fit` / `clear` / `copy` | as core | O(n) |
| `FlatSet` | the same surface without values: `insert(K) -> Bool`, `remove`, `get_index`, `range`, `first`, `last` | as above |
| `FlatMultiMap` / `FlatMultiSet` | same surface, `set` becomes `insert` and duplicates are kept | as above |

### `RangeMap[K, V]`, `RangeSet[K]`

```mbt
pub(all) enum Overlap { Overwrite; Refuse; KeepFirst }
```

| Method | Signature | Cost |
|:--|:--|:--|
| `RangeMap::new` | `fn[K : Compare, V] RangeMap::new(overlap~ : Overlap = Overwrite) -> RangeMap[K, V]` | O(1) |
| `RangeMap::insert` | `fn[K : Compare, V] RangeMap::insert(RangeMap[K, V], start~ : K, end~ : K, V) -> Unit raise Refused` | O(log n) |
| `RangeMap::get` | `fn[K : Compare, V] RangeMap::get(RangeMap[K, V], K) -> V?` | O(log n) |
| `RangeMap::get_range` | `fn[K : Compare, V] RangeMap::get_range(RangeMap[K, V], K) -> (K, K, V)?` | O(log n) |
| `RangeMap::overlapping` | `fn[K : Compare, V] RangeMap::overlapping(RangeMap[K, V], start~ : K, end~ : K) -> Array[(K, K, V)]` | O(log n + k) |
| `RangeMap::remove` | `fn[K : Compare, V] RangeMap::remove(RangeMap[K, V], start~ : K, end~ : K) -> Unit` | O(log n + k) |
| `RangeMap::ranges` / `gaps` / `length` / `is_empty` / `clear` / `copy` | `ranges` yields `(K, K, V)` in start order | O(n) |
| `RangeSet` | `insert(start~, end~)`, `contains(K)`, `overlapping`, `remove`, `ranges`, `gaps` | as above |

`RangeMap` merges adjacent ranges with equal values and splits a range on insert when
`overlap` is `Overwrite`; `Refuse` raises `Refused` on any overlap; `KeepFirst` keeps
the existing range and ignores the new one.

### `Trie[T]`, `RadixTree[T]`

| Method | Signature | Cost |
|:--|:--|:--|
| `Trie::new` | `fn[T] Trie::new() -> Trie[T]` | O(1) |
| `Trie::insert` / `get` / `remove` | `insert(String, T) -> T?`, `get(String) -> T?`, `remove(String) -> T?` | O(k) |
| `Trie::contains_prefix` | `fn[T] Trie::contains_prefix(Trie[T], String) -> Bool` | O(k) |
| `Trie::longest_prefix` | `fn[T] Trie::longest_prefix(Trie[T], String) -> (String, T)?` | O(k) |
| `Trie::keys_with_prefix` | `-> Array[String]` | O(k + m) |
| `Trie::length` / `iter` / `clear` / `copy` | `iter` yields `(String, T)` in key order | O(n·k) |
| `RadixTree` | the `Trie` surface over compressed edges, plus `get_ancestor_keys`, `prefix_count`, `iter_prefix(String)` | O(k) per operation, O(k + m) for a prefix scan |

## `heap`

| Type | Shape | Push | Pop | Decrease-key | Meld |
|:--|:--|:--|:--|:--|:--|
| `DaryHeap[T]` | d-ary array heap | O(log_d n) | O(log_d n) | — | — |
| `IndexHeap[T]` | binary array heap plus position map | O(log n) | O(log n) | O(log n) | — |
| `PairingHeap[T]` | pairing heap | O(1)* | O(log n)* | O(log n)* | O(1) |
| `FibonacciHeap[T]` | Fibonacci heap | O(1)* | O(log n)* | O(1)* | O(1) |
| `MinMaxHeap[T]` | min-max heap | O(log n) | O(log n) | — | — |
| `RadixHeap[T]` | monotone bucket heap | O(1)* | O(log C)* | — | — |

`DaryHeap`, `PairingHeap` and `FibonacciHeap` share `push`, `peek`, `pop`, `length`, `is_empty`. The
ones that address an entry take a `HeapKey[T]`, a slot and a generation, so a stale key returns `None`:

```mbt
pub(all) struct HeapKey[T] {
  index : Int32
  generation : UInt32
}
```

| Method | Signature | Cost |
|:--|:--|:--|
| `DaryHeap::new` | `fn[T : Compare] DaryHeap::new(arity~ : Int32 = 4, order~ : Order = Min) -> DaryHeap[T] raise Refused` | O(1) |
| `DaryHeap::push` / `peek` / `pop` | `pop() -> T?` | O(log_d n) |
| `DaryHeap::replace` / `push_pop` | `replace(T) -> T?`, `push_pop(T) -> T?` | O(log_d n) |
| `DaryHeap::from_array` / `into_sorted_array` / `iter` / `length` / `is_empty` / `clear` / `copy` | `into_sorted_array` drains in order | O(n) / O(n log n) |
| `IndexHeap::insert` | `-> HeapKey[T]` | O(log n) |
| `IndexHeap::peek_entry` | `-> (HeapKey[T], T)?` | O(1) |
| `IndexHeap::update` / `remove_at` | `update(HeapKey[T], T) -> Bool`, `remove_at(HeapKey[T]) -> T?` | O(log n) |
| `PairingHeap::insert` / `meld` / `update` / `remove_at` | `insert(T) -> HeapKey[T]`, `meld(Self) -> Unit`, `update(HeapKey[T], T) -> Bool`, `remove_at(HeapKey[T]) -> T?` | O(1)* / O(1) / O(log n)* |
| `PairingHeap::from_array` / `into_sorted_array` / `iter` | as `DaryHeap` | O(n) / O(n log n) |
| `FibonacciHeap` | the `PairingHeap` surface, `decrease_key` amortised O(1) | O(1)* decrease |
| `MinMaxHeap::push` / `pop_min` / `pop_max` / `peek_min` / `peek_max` | `-> T?` | O(log n) / O(1) |
| `RadixHeap::push` / `pop_min` / `peek_min` | `push(UInt64, T) -> Unit raise Refused`, `pop_min() -> (UInt64, T)?` | O(1)* / O(log C)* |

```mbt
pub(all) enum Order { Min; Max }
```

`arity: 4` is Boost.Heap's default. `Min` is Python `heapq`'s and Java's orientation, and C++ and
core's `PriorityQueue` take the other; `Max` reverses the comparator without a new type.

## `tree`

| Type | Shape | Query | Update |
|:--|:--|:--|:--|
| `DisjointSet` | index arrays with union by size and path halving | O(α(n)) | O(α(n)) |
| `DisjointSetMap[K]` | `DisjointSet` plus a `HashMap[K, Int32]` | O(α(n)) | O(α(n)) |
| `SegmentTree[T]` | complete binary tree over an associative operation | O(log n) | O(log n) |
| `LazySegmentTree[T, F]` | as `SegmentTree`, with range updates by deferred tags | O(log n) | O(log n) |
| `Fenwick[T]` | binary indexed tree over any `T : Add + Sub` | O(log n) | O(log n) |
| `IntervalTree[K, V]` | balanced tree ordered by interval start, with max-end augmentation | O(log n + k) | O(log n) |
| `OrderStatisticTree[T]` | balanced tree with subtree counts | O(log n) | O(log n) |
| `SkipList[T]` | probabilistic level lists | O(log n) expected | O(log n) expected |
| `Treap[K, V]` | randomized balanced tree, split and merge | O(log n) expected | O(log n) expected |
| `ArenaTree[T]` | nodes in a `SlotMap`, links by id | O(1) per step | O(1) link |

### `DisjointSet`, `DisjointSetMap[K]`

| Method | Signature | Cost |
|:--|:--|:--|
| `DisjointSet::new` | `fn DisjointSet::new(capacity~ : Int32 = 0) -> DisjointSet` | O(capacity) |
| `DisjointSet::add` | `fn DisjointSet::add(DisjointSet) -> Int32` | O(1)* |
| `DisjointSet::find` | `fn DisjointSet::find(DisjointSet, Int32) -> Int32` | O(α(n)) |
| `DisjointSet::union` | `fn DisjointSet::union(DisjointSet, Int32, Int32) -> Bool` | O(α(n)) |
| `DisjointSet::connected` | `fn DisjointSet::connected(DisjointSet, Int32, Int32) -> Bool` | O(α(n)) |
| `DisjointSet::set_size` / `set_count` / `component_size` | `set_size(Int32) -> Int32`, `set_count() -> Int32` | O(α(n)) / O(1) |
| `DisjointSet::to_sets` | `fn DisjointSet::to_sets(DisjointSet) -> Array[Array[Int32]]` | O(n) |
| `DisjointSetMap::new` / `make_set` / `find` / `union` / `connected` / `to_sets` | same, keyed by `K : Hash + Eq`, `find(K) -> K?` | O(α(n)) |

### `SegmentTree[T]`, `Fenwick`

| Method | Signature | Cost |
|:--|:--|:--|
| `SegmentTree::new` | `fn[T] SegmentTree::new(values : ArrayView[T], op~ : (T, T) -> T, identity~ : T) -> SegmentTree[T]` | O(n) |
| `SegmentTree::query` | `fn[T] SegmentTree::query(SegmentTree[T], start~ : Int32, end~ : Int32) -> T` — half-open, `identity` when empty | O(log n) |
| `SegmentTree::query_all` | `-> T` | O(1) |
| `SegmentTree::set` | `fn[T] SegmentTree::set(SegmentTree[T], Int32, T) -> Unit` | O(log n) |
| `SegmentTree::get` / `length` / `clear` / `copy` | as core | O(1) / O(n) |
| `SegmentTree::first_where` | `fn[T] SegmentTree::first_where(SegmentTree[T], (T) -> Bool) -> Int32?` | O(log n) |
| `LazySegmentTree::new` | `fn[T, F] LazySegmentTree::new(values : ArrayView[T], op~ : (T, T) -> T, identity~ : T, apply~ : (F, T) -> T, compose~ : (F, F) -> F, none~ : F) -> LazySegmentTree[T, F]` | O(n) |
| `LazySegmentTree::update` / `query` | `update(start~ : Int32, end~ : Int32, F) -> Unit`, `query(start~, end~) -> T` | O(log n) |
| `Fenwick::new` | `fn[T : Add + Sub] Fenwick::new(length~ : Int32, zero~ : T) -> Fenwick[T] raise Refused` | O(length) |
| `Fenwick::add` | `fn[T : Add + Sub] Fenwick::add(Fenwick[T], Int32, T) -> Unit` | O(log n) |
| `Fenwick::prefix_sum` | `fn[T : Add + Sub] Fenwick::prefix_sum(Fenwick[T], Int32) -> T` — sum of `[0, end)` | O(log n) |
| `Fenwick::range_sum` | `fn[T : Add + Sub] Fenwick::range_sum(Fenwick[T], start~ : Int32, end~ : Int32) -> T` | O(log n) |
| `Fenwick::get` / `set` | `get(Int32) -> T`, `set(Int32, T)` | O(log n) |
| `Fenwick::lower_bound` | `fn[T : Add + Sub + Compare] Fenwick::lower_bound(Fenwick[T], T) -> Int32?` — first prefix reaching the target, non-negative values only | O(log n) |
| `Fenwick::length` / `clear` | as core | O(1) / O(n) |

### `IntervalTree[K, V]`

| Method | Signature | Cost |
|:--|:--|:--|
| `IntervalTree::new` | `fn[K : Compare, V] IntervalTree::new() -> IntervalTree[K, V]` | O(1) |
| `IntervalTree::insert` | `insert(start~ : K, end~ : K, V) -> IntervalKey` | O(log n) |
| `IntervalTree::get` / `remove` | `get(IntervalKey) -> (K, K, V)?`, `remove(IntervalKey) -> (K, K, V)?` | O(1) / O(log n) |
| `IntervalTree::query_point` / `query_overlap` | `query_point(K) -> Array[(K, K, V)]`, `query_overlap(start~ : K, end~ : K) -> Array[(K, K, V)]` | O(log n + k) |
| `IntervalTree::iter` / `length` / `is_empty` / `clear` / `copy` | `iter` in start order | O(n) |

### `OrderStatisticTree[T]`, `SkipList[T]`, `Treap[K, V]`

| Method | Signature | Cost |
|:--|:--|:--|
| `OrderStatisticTree::new` | `fn[T : Compare] OrderStatisticTree::new() -> OrderStatisticTree[T]` | O(1) |
| `OrderStatisticTree::insert` / `remove` / `contains` | `insert(T) -> Bool`, `remove(T) -> Bool`, `contains(T) -> Bool` | O(log n) |
| `OrderStatisticTree::select` | `fn[T] OrderStatisticTree::select(OrderStatisticTree[T], Int32) -> T?` | O(log n) |
| `OrderStatisticTree::rank` | `fn[T] OrderStatisticTree::rank(OrderStatisticTree[T], T) -> Int32` — number of elements below | O(log n) |
| `OrderStatisticTree::count_less` / `count_range` | `-> Int32` | O(log n) |
| `OrderStatisticTree::first` / `last` / `range` / `iter` / `length` / `clear` | as core `SortedSet` | O(log n) / O(n) |
| `SkipList::new` | `fn[T : Compare] SkipList::new(skip_list_options~ : SkipListOptions = skip_list_options) -> SkipList[T]` | O(1) |
| `SkipList::insert` / `remove` / `contains` / `rank` / `select` / `range` / `first` / `last` / `iter` / `length` | as `OrderStatisticTree` | O(log n) expected |
| `Treap::new` | `fn[K : Compare, V] Treap::new(seed~ : Int32 = @spec.hash_seed()) -> Treap[K, V]` | O(1) |
| `Treap::set` / `get` / `remove` | `set(K, V) -> V?`, `get(K) -> V?` | O(log n) expected |
| `Treap::split` / `merge` | `split(K) -> (Treap[K, V], Treap[K, V])`, `merge(Treap[K, V], Treap[K, V]) -> Treap[K, V]` | O(log n) expected |
| `Treap::range` / `first` / `last` / `iter` / `length` / `clear` / `copy` | as `SortedMap` | O(log n + k) / O(n) |

```mbt
pub(all) struct SkipListOptions {
  probability : Double
  max_level : Int32
  seed : Int32
}
pub let skip_list_options : SkipListOptions = { probability: 0.25, max_level: 32, seed: @spec.hash_seed() }
```

`probability: 0.25` and `max_level: 32` are Redis's skip-list parameters, which give
O(log n) with a smaller expected level than the classic 1/2. `seed` defaults to the
per-process seed the hash tables use and drives a `@moonrand.seeded` generator, so a
skip list's levels and a treap's priorities cannot be predicted from the input; passing
a fixed seed makes the shape reproducible for a test.

### `ArenaTree[T]`

| Method | Signature | Cost |
|:--|:--|:--|
| `ArenaTree::new` | `fn[T] ArenaTree::new() -> ArenaTree[T]` | O(1) |
| `ArenaTree::add` | `fn[T] ArenaTree::add(ArenaTree[T], T) -> TreeId` — a detached node | O(1)* |
| `ArenaTree::add_child` | `fn[T] ArenaTree::add_child(ArenaTree[T], TreeId, T) -> TreeId` | O(1)* |
| `ArenaTree::prepend_child` | `fn[T] ArenaTree::prepend_child(ArenaTree[T], TreeId, T) -> TreeId` | O(1)* |
| `ArenaTree::insert_after` / `insert_before` | `-> TreeId` | O(1)* |
| `ArenaTree::detach` | `fn[T] ArenaTree::detach(ArenaTree[T], TreeId) -> ArenaTree[T]?` — the subtree becomes its own tree | O(1) |
| `ArenaTree::remove` | `fn[T] ArenaTree::remove(ArenaTree[T], TreeId) -> T?` — removes the subtree | O(k) |
| `ArenaTree::get` / `set` / `contains` | `get(TreeId) -> T?`, `set(TreeId, T) -> Bool` | O(1) |
| `ArenaTree::parent` / `children` / `siblings` | `parent(TreeId) -> TreeId?`, `children(TreeId) -> Array[TreeId]` | O(1) / O(k) |
| `ArenaTree::first_child` / `next_sibling` / `previous_sibling` | `-> TreeId?` | O(1) |
| `ArenaTree::ancestors` / `descendants` / `preorder` / `postorder` | `Iter[TreeId]` | O(1)* step |
| `ArenaTree::sort_children` | `fn[T] ArenaTree::sort_children(ArenaTree[T], TreeId, (T, T) -> Int32) -> Unit` | O(k log k) |
| `ArenaTree::length` / `is_empty` / `clear` / `copy` | as core | O(1) / O(n) |

```mbt
pub(all) struct TreeId {
  index : Int32
  generation : UInt32
}
```

`TreeId` is a `SlotKey` without a type parameter: a tree's nodes all hold the same `T`,
so the parameter would only get in the way of storing ids in other containers.

## `cache`

| Type | Policy | Backing structure | Eviction |
|:--|:--|:--|:--|
| `LruCache[K, V]` | least recently used | `IndexMap` plus an intrusive order list | on insert past the capacity |
| `LfuCache[K, V]` | least frequently used, ties by recency | hash table plus frequency buckets | on insert past the capacity |
| `ArcCache[K, V]` | adaptive, recency vs frequency | four lists `T1`, `T2`, `B1`, `B2` | by the ARC replacement rule |
| `ExpiringCache[K, V]` | time to live over any policy | a cache plus an expiry index | on read, on insert, and on `purge` |

All four take a capacity, because no bound suits everyone and every cache in the references requires
one. `ExpiringCache` also takes a clock, `now~ : () -> Int64`, with no default: this library reads no
clock, and a test moves time by passing its own. `ttl` is in the units of that clock.

`set` returns the entry it displaced, which is `(k, old)` when the key was present and the evicted
entry otherwise, so a caller compares keys to tell them apart. `on_evict?` is called for every entry
the policy drops, and not for a `remove` or a replacement.

| Method | Signature | Cost |
|:--|:--|:--|
| `LruCache::new` | `fn[K : Hash + Eq, V] LruCache::new(capacity~ : Int32, on_evict? : (K, V) -> Unit, hash_seed~ : Int32 = @spec.hash_seed()) -> LruCache[K, V] raise Refused` | O(capacity) |
| `LruCache::get` | `fn[K, V] LruCache::get(LruCache[K, V], K) -> V?` — marks the entry as most recent | O(1) |
| `LruCache::peek` | `-> V?` — does not change the order | O(1) |
| `LruCache::set` | `-> (K, V)?` — the entry it displaced | O(1)* |
| `LruCache::remove` / `contains` | `remove(K) -> V?`, `contains(K) -> Bool` | O(1) |
| `LruCache::resize_capacity` | `fn[K, V] LruCache::resize_capacity(LruCache[K, V], capacity~ : Int32) -> Unit raise Refused` | O(k) evictions |
| `LruCache::keys` / `values` / `iter` / `length` / `capacity` / `is_empty` / `clear` | `iter` runs from least to most recently used | O(n) |
| `LruCache::stats` | `fn[K, V] LruCache::stats(LruCache[K, V]) -> CacheStats` — hits, misses, evictions | O(1) |
| `LfuCache::new` | `fn[K : Hash + Eq, V] LfuCache::new(capacity~ : Int32, on_evict? : (K, V) -> Unit, hash_seed~ : Int32 = @spec.hash_seed()) -> LfuCache[K, V] raise Refused` | O(capacity) |
| `LfuCache::get` / `peek` / `set` / `remove` / `contains` | as `LruCache`, with frequency counting on every `get` | O(1) |
| `LfuCache::take` | `fn[K, V] LfuCache::take(LfuCache[K, V], K) -> V?` — removes and returns | O(1) |
| `LfuCache::frequency` | `fn[K, V] LfuCache::frequency(LfuCache[K, V], K) -> Int32?` | O(1) |
| `ArcCache::new` | `fn[K : Hash + Eq, V] ArcCache::new(capacity~ : Int32, on_evict? : (K, V) -> Unit, hash_seed~ : Int32 = @spec.hash_seed()) -> ArcCache[K, V] raise Refused` | O(capacity) |
| `ArcCache::get` / `set` / `remove` / `contains` / `length` / `capacity` / `clear` | as `LruCache`, with the ARC rule | O(1)* |
| `ArcCache::lists` | `fn[K, V] ArcCache::lists(ArcCache[K, V]) -> (Int32, Int32, Int32, Int32)` — sizes of `T1`, `T2`, `B1`, `B2` | O(1) |
| `ExpiringCache::new` | `fn[K : Hash + Eq, V] ExpiringCache::new(ttl~ : Int64, capacity~ : Int32, now~ : () -> Int64, hash_seed~ : Int32 = @spec.hash_seed()) -> ExpiringCache[K, V] raise Refused` | O(capacity) |
| `ExpiringCache::set` | `fn[K, V] ExpiringCache::set(ExpiringCache[K, V], K, V, ttl? : Int64) -> (K, V)?` | O(1)* |
| `ExpiringCache::get` | `-> V?` — returns `None` and drops the entry when expired | O(1) |
| `ExpiringCache::purge` | `fn[K, V] ExpiringCache::purge(ExpiringCache[K, V]) -> Int32` — drops expired entries, returns how many | O(k) |
| `ExpiringCache::set_expire` | `fn[K, V] ExpiringCache::set_expire(ExpiringCache[K, V], K, Int64) -> Bool` | O(1) |
| `ExpiringCache::length` / `is_empty` / `clear` / `keys` / `iter` | as `LruCache` | O(n) |

Memoising a function is one call, as `functools.lru_cache` makes it:

```mbt
pub fn[K : Hash + Eq, V] memoize(f : (K) -> V, capacity~ : Int32) -> (K) -> V raise Refused

pub(all) struct CacheStats {
  hits : Int64
  misses : Int64
  evictions : Int64
}
```

## `sketch`

Probabilistic structures. Every one of them takes its accuracy as a parameter and
derives its size from it, so a caller never picks a bit count by hand.

| Type | Answers | Parameters | Error |
|:--|:--|:--|:--|
| `BloomFilter[T]` | membership | expected items, false-positive rate | one-sided: no false negatives |
| `CuckooFilter[T]` | membership with deletion | capacity, fingerprint bits, bucket size | one-sided, and it can fail to insert |
| `CountMinSketch[T]` | frequency of an item | epsilon, confidence | over-estimate only |
| `HyperLogLog[T]` | distinct count | precision | relative standard error ≈ 1.04 / √m |
| `ThetaSketch[T]` | distinct count with set algebra | nominal entries | ≈ 1 / √k |
| `TDigest` | quantiles of a distribution | compression | rank error, tighter at the tails |

| Method | Signature | Cost |
|:--|:--|:--|
| `BloomFilter::new` | `fn[T : Hash] BloomFilter::new(expected_items~ : Int32, bloom_options~ : BloomOptions = bloom_options, hash_seed~ : Int32 = @spec.hash_seed()) -> BloomFilter[T] raise Refused` | O(m/64) |
| `BloomFilter::insert` | `fn[T] BloomFilter::insert(BloomFilter[T], T) -> Bool` — `true` when a bit changed, so the item was certainly new | O(k) |
| `BloomFilter::may_contain` | `fn[T] BloomFilter::may_contain(BloomFilter[T], T) -> Bool` | O(k) |
| `BloomFilter::estimated_false_positive_rate` | `-> Double` | O(1) |
| `BloomFilter::union` / `intersection` | `-> BloomFilter[T] raise Refused` — same capacity and rate required | O(m/64) |
| `BloomFilter::length` / `capacity` / `bit_count` / `is_empty` / `clear` / `copy` | `length` is the number of inserts | O(1) |
| `CuckooFilter::new` | `fn[T : Hash] CuckooFilter::new(capacity~ : Int32, cuckoo_options~ : CuckooOptions = cuckoo_options, hash_seed~ : Int32 = @spec.hash_seed()) -> CuckooFilter[T] raise Refused` | O(capacity) |
| `CuckooFilter::insert` | `-> Bool` — `false` when the table is too full, after a bounded number of kicks | O(1)* |
| `CuckooFilter::may_contain` / `remove` | `-> Bool` | O(1) |
| `CuckooFilter::length` / `load_factor` / `is_empty` / `clear` / `copy` | `load_factor` is `length / capacity` | O(1) |
| `CountMinSketch::new` | `fn[T : Hash] CountMinSketch::new(epsilon~ : Double = 0.001, confidence~ : Double = 0.99, hash_seed~ : Int32 = @spec.hash_seed()) -> CountMinSketch[T] raise Refused` | O(width·depth) |
| `CountMinSketch::incr` / `incr_by` | `-> Unit` | O(depth) |
| `CountMinSketch::estimate` | `-> Int64` — never below the true count | O(depth) |
| `CountMinSketch::merge` | `-> Unit raise Refused` — same width and depth | O(width·depth) |
| `CountMinSketch::width` / `depth` / `total` / `clear` / `copy` | as the reference | O(1) |
| `HyperLogLog::new` | `fn[T : Hash] HyperLogLog::new(precision~ : Int32 = 14, hash_seed~ : Int32 = @spec.hash_seed()) -> HyperLogLog[T] raise Refused` | O(m) |
| `HyperLogLog::add` | `fn[T] HyperLogLog::add(HyperLogLog[T], T) -> Bool` — `false` when the register did not change | O(1) |
| `HyperLogLog::count` | `-> Int64` — the estimate, with the small-range correction | O(m) |
| `HyperLogLog::merge` | `-> Unit raise Refused` — same precision | O(m) |
| `HyperLogLog::precision` / `clear` / `copy` | as the reference | O(1) / O(m) |
| `ThetaSketch::new` | `fn[T : Hash] ThetaSketch::new(nominal_entries~ : Int32 = 4096, hash_seed~ : Int32 = @spec.hash_seed()) -> ThetaSketch[T] raise Refused` | O(k) |
| `ThetaSketch::add` / `estimate` / `is_empty` | as the reference | O(1) / O(k) |
| `ThetaSketch::union` / `intersection` / `a_not_b` | `(ThetaSketch[T], ThetaSketch[T]) -> ThetaSketch[T]` | O(k log k) |
| `TDigest::new` | `fn TDigest::new(compression~ : Double = 100.0) -> TDigest raise Refused` | O(1) |
| `TDigest::add` / `add_weighted` | `add(Double)`, `add_weighted(Double, Double)` | O(log n)* |
| `TDigest::quantile` | `fn TDigest::quantile(TDigest, Double) -> Double` | O(log n) |
| `TDigest::cdf` | `fn TDigest::cdf(TDigest, Double) -> Double` | O(log n) |
| `TDigest::merge` / `compress` / `count` / `min` / `max` | `compress()` folds the buffer into centroids | O(n) |
| `encode` / `decode` on all six | `encode() -> Bytes`, `T::decode(BytesView) -> T raise Refused`: a sketch's point is to be merged across machines, and the format is this library's own | O(size) |

```mbt
pub(all) struct BloomOptions {
  false_positive_rate : Double
  growth : Growth
}
pub let bloom_options : BloomOptions = { false_positive_rate: 0.01, growth: Fixed }
pub(all) enum Growth { Fixed; Scalable }

pub(all) struct CuckooOptions {
  fingerprint_bits : Int32
  bucket_size : Int32
}
pub let cuckoo_options : CuckooOptions = { fingerprint_bits: 8, bucket_size: 4 }
```

The false-positive rate defaults to 1%, Redis's default, where Guava's is 3%. `Scalable` is the
layered scheme Redis uses; `Fixed` keeps accepting past the expected count at a worse rate, as Guava
does, and `estimated_false_positive_rate` says what the rate has become.
`fingerprint_bits: 8` and `bucket_size: 4` are the values the cuckoo filter paper and
its reference implementation use.

## `text`

| Type or function | Answers | Build | Query |
|:--|:--|:--|:--|
| `Kmp` | one pattern, worst-case guarantee | O(m) | O(n) |
| `BoyerMoore` | one pattern, fastest in practice | O(m + σ) | O(n/m) best |
| `AhoCorasick` | many patterns at once | O(total pattern length) | O(n + matches) |
| `SuffixArray` | every occurrence of a pattern | O(n log n) | O(m log n) |
| `SuffixAutomaton` | substring queries, longest common substring | O(n) | O(m) |
| `SequenceMatcher` | what changed between two runs | O(n·m) worst | per block |
| `Rope`, `RopeView` | text a matcher can read without flattening it | O(n) | O(log n) index and edit |

| Method | Signature | Cost |
|:--|:--|:--|
| `Kmp::new` | `fn Kmp::new(pattern : StringView) -> Kmp` | O(m) |
| `Kmp::search` | `fn Kmp::search(Kmp, text : StringView) -> Int32?` — the first offset, in UTF-16 code units as `String` indexes | O(n) |
| `Kmp::search_all` | `-> Iter[Int32]` — every occurrence, overlapping included | O(n + matches) |
| `BoyerMoore::new` / `search` / `search_all` | as `Kmp` | O(m + σ) build |
| `AhoCorasick::new` | `fn AhoCorasick::new(patterns : Array[StringView]) -> AhoCorasick` | O(total) |
| `AhoCorasick::add` | `fn AhoCorasick::add(AhoCorasick, StringView) -> Int32` — the pattern's index | O(m) |
| `AhoCorasick::build` | `fn AhoCorasick::build(AhoCorasick) -> Unit` — builds the failure links after the last `add` | O(total) |
| `AhoCorasick::search_all` | `-> Iter[(Int32, Int32)]` — `(pattern index, offset)` | O(1)* step |
| `AhoCorasick::is_match` | `-> Bool` | O(n) |
| `z_function` | `fn z_function(StringView) -> Array[Int32]` | O(n) |
| `longest_palindrome` | `fn longest_palindrome(StringView) -> (Int32, Int32)` — Manacher, half-open | O(n) |
| `SuffixArray::new` | `fn SuffixArray::new(StringView) -> SuffixArray` | O(n log n) |
| `SuffixArray::search` | `fn SuffixArray::search(SuffixArray, StringView) -> Array[Int32]` | O(m log n + k) |
| `SuffixArray::lcp_array` | `fn SuffixArray::lcp_array(SuffixArray) -> Array[Int32]` — Kasai | O(n) |
| `SuffixArray::length` / `text` | as the reference | O(1) |
| `SuffixAutomaton::new` | `fn SuffixAutomaton::new(StringView) -> SuffixAutomaton` | O(n) |
| `SuffixAutomaton::contains` | `-> Bool` | O(m) |
| `SuffixAutomaton::count_occurrences` | `-> Int32` | O(m) |
| `SuffixAutomaton::longest_common_substring` | `fn SuffixAutomaton::longest_common_substring(SuffixAutomaton, StringView) -> (Int32, Int32)` | O(n + m) |
| `SequenceMatcher::new` | `fn[T : Hash + Eq] SequenceMatcher::new(a : ArrayView[T], b : ArrayView[T], sequence_matcher_options~ : SequenceMatcherOptions[T] = sequence_matcher_options()) -> SequenceMatcher[T]` — over any run: lines for a file diff, `chars(text)` for a line diff, as `difflib` | O(n + m) |
| `SequenceMatcher::find_longest_match` | `-> Match` — `{ a_start, b_start, size }` | O(n·m) worst |
| `SequenceMatcher::get_matching_blocks` | `-> Array[Match]` | O(n·m) worst |
| `SequenceMatcher::get_opcodes` | `-> Array[Opcode]` — `Equal`, `Replace`, `Delete`, `Insert` with ranges | O(n·m) worst |
| `SequenceMatcher::ratio` / `quick_ratio` / `real_quick_ratio` | `-> Double` | O(n·m) / O(n) / O(1) |
| `ndiff`, `unified_diff`, `context_diff` | `fn ndiff(StringView, StringView, ...) -> String`; `restore(diff, Opcode) -> String` | O(n·m) |
| `get_close_matches` | `fn get_close_matches(word : StringView, possibilities : ArrayView[StringView], n~ : Int32 = 3, cutoff~ : Double = 0.6) -> Array[StringView]` | O(n·m) |
| `is_line_junk` / `is_character_junk` | `fn(StringView) -> Bool` | O(1) |

```mbt
pub(all) struct SequenceMatcherOptions[T] {
  autojunk : Bool
  junk : (T) -> Bool
}
pub fn[T] sequence_matcher_options() -> SequenceMatcherOptions[T]  // { autojunk: true, junk: _ => false }

pub(all) struct Match {
  a_start : Int32
  b_start : Int32
  size : Int32
}
```

`autojunk: true` reproduces `difflib`'s default: in sequences of 200 elements or more,
an element that appears in more than 1% of the sequence is treated as junk. Turning it
off gives the textbook diff, which is slower on repetitive input and usually looks
better.

### Text storage: `Rope`, `RopeView`, `RopeBuilder`

The matchers above read a `StringView`. A document that changes between reads is kept in
a rope and handed over as a `RopeView`, which is why the storage types sit here: the two
are used together, and neither is generic over its contents. `Rope` is what `seq` was
not: a sequence whose chunk type and indices are fixed by the text domain.

| Method | Signature | Cost |
|:--|:--|:--|
| `Rope::new` | `fn Rope::new() -> Rope` | O(1) |
| `Rope::from_string` | `fn Rope::from_string(StringView) -> Rope` | O(n) |
| `Rope::slice` | `fn Rope::slice(Rope, start~ : Int32, end~ : Int32) -> RopeView` | O(log n) |
| `Rope::insert` | `fn Rope::insert(Rope, Int32, StringView) -> Unit` | O(log n) |
| `Rope::remove` | `fn Rope::remove(Rope, start~ : Int32, end~ : Int32) -> Unit` | O(log n + k) |
| `Rope::append` | `fn Rope::append(Rope, StringView) -> Unit` | O(log n) |
| `Rope::edit` | `fn Rope::edit(Rope, start~ : Int32, end~ : Int32, StringView) -> Unit` | O(log n + k) |
| `Rope::char_at` | `-> Char?` | O(log n) |
| `Rope::length` / `char_length` / `line_count` | `-> Int32`; `length` counts UTF-16 code units, as `String::length` does | O(1) |
| `Rope::line_at` / `line_start` / `char_to_offset` / `offset_to_char` | `line_at(Int32) -> Int32`, `line_start(Int32) -> Int32` | O(log n) |
| `Rope::chars` / `lines` / `chunks` | `Iter[Char]`, `Iter[StringView]`, `Iter[StringView]` | O(1)* step |
| `Rope::to_string` / `write_to` | `-> String` / `StringBuilder` append | O(n) |
| `Rope::split_off` / `copy` / `clear` | as the reference | O(log n) / O(n) |
| `RopeView::slice` / `to_string` / `chars` / `lines` / `length` / `char_length` | as `Rope` | O(1) create |
| `RopeBuilder::new` / `append` / `finish` | `finish() -> Rope` | O(n) |

Offsets are UTF-16 code units, as everywhere a `String` is indexed, which is also what an LSP position
counts; an edit that would split a surrogate pair aborts, as slicing a `String` there refuses.

## `phf`

A perfect hash table is built from a fixed key set and never changes.

| Type | Shape | Lookup | Build |
|:--|:--|:--|:--|
| `PhfMap[K, V]` | displacement table plus entry array | O(1), one probe | `PhfBuilder` |
| `PhfSet[K]` | as `PhfMap` with `Unit` values | O(1) | `PhfBuilder` |
| `PhfOrderedMap[K, V]` | `PhfMap` plus the key order | O(1) | `PhfBuilder` |
| `PhfOrderedSet[K]` | as `PhfOrderedMap` | O(1) | `PhfBuilder` |

| Method | Signature | Cost |
|:--|:--|:--|
| `PhfMap::get` | `fn[K : PhfKey, V] PhfMap::get(PhfMap[K, V], K) -> V?` | O(1) |
| `PhfMap::contains` | `-> Bool` | O(1) |
| `PhfMap::get_key` | `fn[K : PhfKey, V] PhfMap::get_key(PhfMap[K, V], K) -> K?` — the stored key equal to the argument | O(1) |
| `PhfMap::keys` / `values` / `iter` | `iter` yields `(K, V)` | O(n) |
| `PhfMap::length` / `is_empty` | as core | O(1) |
| `PhfOrderedMap::index` | `-> Int32?` — the key's position in the declaration order | O(1) |
| `PhfOrderedMap::get_index` | `-> (K, V)?` | O(1) |
| `PhfSet` | `contains`, `length`, `iter` | O(1) / O(n) |
| `PhfBuilder::new` | `fn[K : PhfKey, V] PhfBuilder::new(phf_options~ : PhfOptions = phf_options) -> PhfBuilder[K, V]` | O(1) |
| `PhfBuilder::entry` | `fn[K, V] PhfBuilder::entry(PhfBuilder[K, V], K, V) -> Unit raise Refused` — a duplicate key is refused | O(1)* |
| `PhfBuilder::build` | `fn[K, V] PhfBuilder::build(PhfBuilder[K, V]) -> PhfMap[K, V] raise Refused` | O(n) expected |
| `PhfBuilder::build_source` | `fn[K, V] PhfBuilder::build_source(PhfBuilder[K, V], name~ : String) -> String` — the MoonBit source of a table literal, for the generated module | O(n) |

```mbt
pub(all) struct PhfOptions {
  build : PhfBuild
  seed : Int32
}
pub let phf_options : PhfOptions = { build: Search, seed: 0 }
pub(all) enum PhfBuild { Search; Quick; Minimal }

pub(open) trait PhfKey {
  to_bytes(Self) -> Bytes
}
```

`PhfBuild` selects the same trade the four crates make: `Search` finds a good hash and
stores the displacement table (the `phf` crate's default), `Quick` accepts a slightly
larger table to avoid the search (`quickphf`), `Minimal` stores the smallest possible
index and a rank structure instead of a displacement table (`entropy-map`). `seed: 0`
is deliberately fixed here, unlike the hash containers: the generated source is checked
in, and CI compares it byte for byte, so the search has to start from the same place on
every machine.

## `algo`

Two function families and one generator type.

- A function over a run that does not change it takes `ArrayView[T]` and returns a new
  `Array[T]`: `sorted`, `k_smallest`, `rotate`.
- A function that changes the run in place takes `Array[T]`, says so in its name with
  `_in_place`, and returns nothing or the number of elements that survived:
  `nth_element_in_place`, `dedup_in_place`.
- Everything lazy takes an `Iter[T]` and returns an `Iter[...]`: `chunks`, `interleave`,
  `chunk_by`.

Core's `Array` and `Iter` methods are not repeated here: `sort`, `dedup`, `rev`, `filter`, `search`,
`windows`, `chunks`, `take_while`, `concat`, `flatten`, `nth`, and moonrand's `shuffle` and `sample`.
Fixed-size combinatorics carry a tuple between steps, so they are structs.

### Searching and order

| Function | Signature | Cost |
|:--|:--|:--|
| `bisect_left` | `fn[T : Compare] bisect_left(ArrayView[T], T) -> Int32` | O(log n) |
| `bisect_right` | `fn[T : Compare] bisect_right(ArrayView[T], T) -> Int32` | O(log n) |
| `bisect_left_by` / `bisect_right_by` | `fn[T] (ArrayView[T], T, cmp~ : (T, T) -> Int32) -> Int32` | O(log n) |
| `equal_range` | `fn[T : Compare] equal_range(ArrayView[T], T) -> (Int32, Int32)` | O(log n) |
| `partition_point` | `fn[T] partition_point(ArrayView[T], (T) -> Bool) -> Int32` | O(log n) |
| `insort_left_in_place` / `insort_right_in_place` | `fn[T : Compare] (Array[T], T) -> Unit` | O(n) |
| `mismatch` | `fn[T : Eq] (ArrayView[T], ArrayView[T]) -> (Int32, Int32)?` — the first difference | O(n) |
| `find_run` | `fn[T : Eq] (ArrayView[T], ArrayView[T]) -> Int32?` — the first occurrence of the second run | O(n·m) |
| `is_partitioned` / `is_partitioned_until` | `fn[T] (ArrayView[T], (T) -> Bool) -> Bool` / `-> Int32?` | O(n) |
| `is_palindrome` | `fn[T : Eq] (ArrayView[T]) -> Bool` | O(n) |
| `all_equal` / `all_unique` | `fn[T : Eq] (ArrayView[T]) -> Bool`; `all_unique` needs `Hash` | O(n) |
| `exactly_one` / `at_most_one` | `fn[T] (ArrayView[T], (T) -> Bool) -> Bool` | O(n) |
| `clamp` | `fn[T : Compare] (T, min~ : T, max~ : T) -> T`, for what core's numeric `clamp` does not cover | O(1) |

### Ordering and selection

| Function | Signature | Cost |
|:--|:--|:--|
| `sorted` / `sorted_by_key` | `fn[T : Compare] (ArrayView[T]) -> Array[T]` | O(n log n) |
| `nth_element_in_place` | `fn[T : Compare] (Array[T], Int32) -> Unit` — the k-th smallest ends at k | O(n) expected |
| `partial_sort_in_place` | `fn[T : Compare] (Array[T], Int32) -> Unit` — the first k are sorted and smallest | O(n log k) |
| `sort_subrange_in_place` | `fn[T : Compare] (Array[T], start~ : Int32, end~ : Int32) -> Unit` | O(n log n) |
| `k_smallest` / `k_largest` | `fn[T : Compare] (Int32, ArrayView[T]) -> Array[T]` | O(n log k) |
| `min_max_element` | `fn[T : Compare] (ArrayView[T]) -> (Int32, Int32)?` | O(n) |
| `min_set` / `max_set` | `fn[T : Compare] (ArrayView[T]) -> Array[T]` — every element equal to the extremum | O(n) |
| `min_max` | `fn[T : Compare] (Iter[T]) -> (T, T)?` | O(n) |
| `position_min` / `position_max` / `position_min_max` | `fn[T : Compare] (ArrayView[T]) -> Int32?` / `-> (Int32, Int32)?` | O(n) |
| `next_permutation_in_place` / `prev_permutation_in_place` | `fn[T : Compare] (Array[T]) -> Bool` | O(n) |
| `apply_permutation_in_place` | `fn[T] (Array[T], ArrayView[Int32]) -> Unit` — moves element `i` to position `order[i]` | O(n) |

### Partition, run editing, merging

| Function | Signature | Cost |
|:--|:--|:--|
| `partition_in_place` | `fn[T] (Array[T], (T) -> Bool) -> Int32` — returns the boundary | O(n) |
| `stable_partition_in_place` | `fn[T] (Array[T], (T) -> Bool) -> Int32` | O(n log n) |
| `partition_copy` | `fn[T] (ArrayView[T], (T) -> Bool) -> (Array[T], Array[T])` | O(n) |
| `partition_pair` | `fn[A, B] (ArrayView[A], (A) -> B?) -> (Array[B], Array[A])` — the mapped elements and the rest | O(n) |
| `rotate_in_place` / `rotate` | `fn[T] (Array[T], mid~ : Int32) -> Unit` / `-> Array[T]` | O(n) |
| `shift_left_in_place` / `shift_right_in_place` | `fn[T] (Array[T], n~ : Int32) -> Unit` | O(n) |
| `replace_in_place` | `fn[T : Eq] (Array[T], T, T) -> Int32` — returns how many were replaced | O(n) |
| `gather_in_place` | `fn[T] (Array[T], mid~ : Int32, (T) -> Bool) -> Int32` | O(n) |
| `unique` / `duplicates` | `fn[T : Hash + Eq] (ArrayView[T]) -> Array[T]` | O(n) |
| `merge` | `fn[T : Compare] (ArrayView[T], ArrayView[T]) -> Array[T]` | O(n+m) |
| `merge_join_by` | `fn[A, B] (ArrayView[A], ArrayView[B], cmp~ : (A, B) -> Int32) -> Iter[JoinEntry[A, B]]` | O(n+m) |
| `k_way_merge` | `fn[T : Compare] (ArrayView[ArrayView[T]]) -> Array[T]` | O(n log k) |
| `merge_in_place` | `fn[T : Compare] (Array[T], Array[T]) -> Unit` | O(n+m) |
| `prefix_sum` | `fn[T] (ArrayView[T], op~ : (T, T) -> T) -> Array[T]` | O(n) |
| `scan_in_place` | `fn[T] (Array[T], op~ : (T, T) -> T) -> Unit` | O(n) |
| `adjacent_difference` | `fn[T] (ArrayView[T], op~ : (T, T) -> T) -> Array[T]` | O(n) |

### Lazy adaptors over `Iter`

| Function | Signature | Cost |
|:--|:--|:--|
| `chunks` | `fn[T] (Iter[T], Int32) -> Iter[Array[T]]` | O(1)* per chunk |
| `chunk_by` | `fn[T] (Iter[T], (T, T) -> Bool) -> Iter[Array[T]]` | O(1)* per chunk |
| `windows_circular` | `fn[T] (ArrayView[T], Int32) -> Iter[Array[T]]` | O(1) per window |
| `interleave` / `interleave_shortest` | `fn[T] (Iter[T], Iter[T]) -> Iter[T]` | O(1) per item |
| `zip_longest` | `fn[A, B] (Iter[A], Iter[B], fill~ : A, fill_b~ : B) -> Iter[(A, B)]` | O(1) per item |
| `zip_eq` | `fn[A, B] (Iter[A], Iter[B]) -> Iter[(A, B)] raise` — raises when the lengths differ | O(1) per item |
| `take_while_inclusive` | `fn[T] (Iter[T], (T) -> Bool) -> Iter[T]` — keeps the first failing item | O(1) per item |
| `group_by` | `fn[T, K : Eq] (Iter[T], key~ : (T) -> K) -> Iter[(K, Array[T])]` | O(n) buffered |
| `peek_nth` | `fn[T] (Iter[T], Int32) -> Iter[T]` | O(1)* per item |
| `tee` | `fn[T] (Iter[T]) -> (Iter[T], Iter[T])` | O(n) buffered |
| `cycle` | `fn[T] (Iter[T]) -> Iter[T]` — unbounded | O(n) buffered |
| `count` | `fn (Int32) -> Iter[Int32]` | O(1) per item |
| `pad_using` | `fn[T] (Iter[T], Int32, (Int32) -> T) -> Iter[T]` | O(1) per item |
| `scan` | `fn[A, B] (Iter[A], init~ : B, (B, A) -> B) -> Iter[B]` | O(1) per item |
| `fold_first` | `fn[T] (Iter[T], (T, T) -> T) -> T?` | O(n) |
| `fold_while` | `fn[A, B] (Iter[A], init~ : B, (B, A) -> Result[B, B]) -> B` | O(n) |
| `tree_reduce` | `fn[T] (Iter[T], (T, T) -> T) -> T?` — pairwise, keeps the tree shape | O(n) |
| `with_position` | `fn[T] (Iter[T]) -> Iter[(Position, T)]` | O(1)* per item |

### Combinatoric generators

Each is a struct with `next() -> Array[T]?` and `iter() -> Iter[Array[T]]`. They share those names and
no trait.

| Type | Constructor | Yields | Cost per item |
|:--|:--|:--|:--|
| `Permutations[T]` | `fn[T] Permutations::new(ArrayView[T], length? : Int32)` | `Array[T]` | O(k) |
| `Combinations[T]` | `fn[T] Combinations::new(ArrayView[T], k~ : Int32)` | `Array[T]` | O(k) |
| `CombinationsWithReplacement[T]` | `fn[T] CombinationsWithReplacement::new(ArrayView[T], k~ : Int32)` | `Array[T]` | O(k) |
| `Product[T]` | `fn[T] Product::new(ArrayView[ArrayView[T]])` | `Array[T]` | O(k) |
| `Powerset[T]` | `fn[T] Powerset::new(ArrayView[T])` | `Array[T]` | O(k) |
| `GrayCode` | `fn GrayCode::new(Int32)` | `Array[Bool]` | O(1) |

```mbt
pub(all) enum Position {
  Only
  First
  Middle
  Last
}
```

`Permutations` with a `length` shorter than the input yields k-permutations, which is
what `itertools::permutations` does; without it, all n! arrangements.

## Root package

The root package only re-exports; it carries no implementation.

```mbt
pub using @seq {type RingBuffer, type SlotMap, type SlotKey, type Slab, type GapBuffer, type BitVec, type BitSet, type SparseSet, type LinkedList}
pub using @map {type IndexMap, type IndexSet, type MultiMap, type MultiSet, type SortedMultiMap, type SortedMultiSet, type BiMap, type Counter, type DefaultMap, type ChainMap, type FlatMap, type FlatSet, type RangeMap, type RangeSet, type Trie, type RadixTree}
pub using @heap {type DaryHeap, type IndexHeap, type PairingHeap, type FibonacciHeap, type MinMaxHeap, type RadixHeap}
pub using @tree {type DisjointSet, type DisjointSetMap, type SegmentTree, type Fenwick, type IntervalTree, type OrderStatisticTree, type SkipList, type Treap, type ArenaTree, type TreeId}
pub using @cache {type LruCache, type LfuCache, type ArcCache, type ExpiringCache}
pub using @sketch {type BloomFilter, type CuckooFilter, type CountMinSketch, type HyperLogLog, type ThetaSketch, type TDigest}
pub using @text {type Kmp, type BoyerMoore, type AhoCorasick, type SuffixArray, type SuffixAutomaton, type SequenceMatcher, type Rope, type RopeView, type RopeBuilder}
pub using @phf {type PhfMap, type PhfSet, type PhfBuilder}
```

A re-exported type does not carry its constructors or its methods, so a program that
wants them imports the package: `@seq.RingBuffer::new(...)`, or
`import { "moonbitstack/moonstl/seq" as seq }`. The root saves the import for the
common case of naming a type in a signature.

`algo` is not re-exported: it is a package of free functions with names like `sorted`
and `chunks`, and pulling those into every program that imports the root would shadow
core's iterator methods.

## Left to the implementation

- **The JSON field names of the containers.** A map becomes an object only with string keys, and an
  array of pairs otherwise; the rest belongs where `moon test` can check it.
- **Internal capacity growth.** Zero means "grow from nothing".
