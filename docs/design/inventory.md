# API inventory: what the reference libraries have, and where each thing goes

Every container, algorithm and adaptor of the libraries named in the task is listed
here once. Rows are grouped by the library they were read from; a capability that
several libraries have appears once with all of their names in the `Name` cell.

The list was read from source, not from memory. Versions checked out while writing
it:

| Library | Version or commit | Licence | Read from |
|:--|:--|:--|:--|
| C++ standard library | C++26 draft, `en.cppreference.com` | libstdc++ GPL-3.0 with runtime exception | interface only |
| Boost | 1.92.0, submodules `container`, `circular_buffer`, `heap`, `bimap`, `multi_index`, `intrusive`, `unordered`, `algorithm` | BSL-1.0 | headers |
| EASTL | 3.27.01 | BSD-3-Clause | `include/EASTL` |
| ETL | 20.49.0 | MIT | `include/etl` |
| Abseil | 20260817.0 | Apache-2.0 | `absl/container`, `absl/algorithm` |
| Folly | v2026.10.26.00 | Apache-2.0 | `folly/container` |
| GTL | v1.2.0 | Apache-2.0 | `include/gtl` |
| STXXL | master, 2026-10 | BSL-1.0 | headers |
| CGAL | 6.x package list | GPL-3.0-or-later, LGPL-3.0, commercial | interface only |
| CPython | v3.14.10 | PSF-2.0 | `Lib/`, `Modules/` |
| Rust | 1.99.1 | MIT OR Apache-2.0 | `library/alloc/src/collections`, `library/core/src/slice`, `library/std/src/collections` |
| itertools | v0.15.0 | MIT OR Apache-2.0 | `src/` |
| indexmap | 2.14.2 | MIT OR Apache-2.0 | `src/` |
| rust-phf | v0.14.0 | MIT | `phf/`, `phf_codegen/`, `phf_macros/`, `phf_shared/` |
| bit-set | v0.5.3 | MIT OR Apache-2.0 | `src/lib.rs` |
| ego-tree | v0.11.1 | MIT OR Apache-2.0 | `src/` |
| slotmap | v1.1.1 | Zlib | `src/` |
| ropey | v1.6.1 | MIT | `src/` |
| rheaps | 0.16.3 | Apache-2.0 | crate source |
| pickmap | 0.3.0 | MIT OR Apache-2.0 | crate source |
| cphf | 1.0.0 | MIT | crate source |
| quickphf | 0.1.0 | Zlib OR Apache-2.0 OR MIT | crate source |
| entropy-map | 1.2.0 | Apache-2.0 | crate source |
| dashmap | 7.0.0-rc2 | MIT | docs |
| crossbeam | 0.8.5 | MIT OR Apache-2.0 | docs |
| rustc-hash (`FxHashMap`) | 2.1.3 | Apache-2.0 OR MIT | docs |
| NetworkX | 3.7 | BSD-3-Clause | interface only |
| igraph | 1.0.1 | GPL-2.0-or-later | interface only |
| graph-tool | 2.9x | GPL-3.0-or-later | interface only |
| scikit-network | 0.33.5 | BSD-3-Clause | interface only |
| EasyGraph | 1.x | Apache-2.0 | interface only |
| JGraphT | 1.5.2 | LGPL-2.1-or-later | interface only |
| petgraph | 0.8.3 | MIT OR Apache-2.0 | interface only |

`MoonBit core` 0.10.19 (`~/.moon/lib/core`) is the judge of what already exists; every
`core:` cell names the type or function that covers the row.

## Reading the tables

`Home` is one of exactly four things:

- `core: X` — the MoonBit core library already has it, under that name.
- a package of this library — `seq`, `map`, `heap`, `tree`, `cache`, `sketch`,
  `algo`, `text`, `phf`.
- another library of the organisation — `moongraph` (graphs, `graphlib`,
  NetworkX and friends), `moonmath` (geometry, `CGAL`).
- `drop: <reason>` — not built, with the reason in one clause.

`Cost` is the cost of the operation the row is about, in the usual notation;
`O(1)*` is amortised. Rows that bundle a family of names state the cost of the
operation the family is used for.

Licences are the licences of the reference implementation. Only BSD, MIT, Apache,
BSL and PSF sources are candidates for transcription; GPL sources (libstdc++, CGAL,
igraph, graph-tool, JGraphT) were read for their interface only.

## C++ standard library

### Containers and views

| Ref | Name | What it does | Cost | Licence | Home |
|:--|:--|:--|:--|:--|:--|
| C++ | `vector` | growable contiguous array | O(1)* push, O(1) index | GPL-3.0+exception | core: `Array` |
| C++ | `vector<bool>` | bit-packed booleans | O(1) index | GPL-3.0+exception | seq: `BitVec` |
| C++ | `deque` | queue with growth at both ends | O(1) both ends | GPL-3.0+exception | core: `Deque` |
| C++ | `list` | doubly linked list, splice, O(1) move | O(1) splice | GPL-3.0+exception | seq: `LinkedList` |
| C++ | `forward_list` | singly linked list | O(1) push_front | GPL-3.0+exception | core: `List` |
| C++ | `array` | fixed-size array | O(1) index | GPL-3.0+exception | core: `FixedArray` |
| C++ | `span` | non-owning view of a run | O(1) | GPL-3.0+exception | core: `ArrayView` |
| C++ | `mdspan` | view with strides over N dimensions | O(1) index | GPL-3.0+exception | moonmath |
| C++ | `basic_string` | owning string | O(1)* append | GPL-3.0+exception | core: `String` |
| C++ | `basic_string_view` | non-owning string view | O(1) | GPL-3.0+exception | core: `StringView` |
| C++ | `bitset` | fixed-width bit set with bitwise operators | O(n/64) whole-set ops | GPL-3.0+exception | seq: `BitSet` |
| C++ | `valarray` | elementwise arithmetic over a run | O(n) elementwise | GPL-3.0+exception | moonmath |
| C++ | `stack` | LIFO adaptor over a container | O(1) | GPL-3.0+exception | core: `Array` (`push`/`pop`) |
| C++ | `queue` | FIFO adaptor over a container | O(1) | GPL-3.0+exception | core: `Queue` |
| C++ | `priority_queue` | binary heap adaptor | O(log n) push/pop | GPL-3.0+exception | core: `PriorityQueue` |
| C++ | `map`, `set` | ordered associative containers | O(log n) | GPL-3.0+exception | core: `SortedMap`, `SortedSet` |
| C++ | `multimap`, `multiset` | ordered containers with repeated keys | O(log n) | GPL-3.0+exception | map: `SortedMultiMap`, `SortedMultiSet` |
| C++ | `unordered_map`, `unordered_set` | hashed associative containers | O(1)* | GPL-3.0+exception | core: `HashMap`, `HashSet` |
| C++ | `unordered_multimap`, `unordered_multiset` | hashed containers with repeated keys | O(1)* | GPL-3.0+exception | map: `MultiMap`, `MultiSet` |
| C++ | `flat_map`, `flat_multimap` (C++23) | sorted contiguous map | O(log n) lookup, O(n) insert | GPL-3.0+exception | map: `FlatMap`, `FlatMultiMap` |
| C++ | `flat_set`, `flat_multiset` (C++23) | sorted contiguous set | O(log n) lookup, O(n) insert | GPL-3.0+exception | map: `FlatSet`, `FlatMultiSet` |
| C++ | `allocator`, `pmr::*` | manual memory control | — | GPL-3.0+exception | drop: the runtime owns allocation; capacities are knobs, allocators are not |
| C++ | `basic_istream_iterator`, `back_insert_iterator`, `front_insert_iterator`, `insert_iterator`, `ostream_iterator`, `move_iterator`, `common_iterator`, `counted_iterator` | iterator glue | — | GPL-3.0+exception | drop: `Iter` plus closures replace insert iterators; the rest are view plumbing |
| C++ | `initializer_list`, `span` deduction guides | language plumbing | — | GPL-3.0+exception | drop: array literals already convert |
| C++ | `std::function`, `std::bind` | type-erased callables | — | GPL-3.0+exception | core: function values |
| C++ | `optional`, `variant`, `any`, `tuple`, `pair` | sum and product types | — | GPL-3.0+exception | core: `Option`, enums, tuples |
| C++ | `std::hash`, `std::equal_to`, `std::less` | function objects for hashing and ordering | — | GPL-3.0+exception | core: `Hash`, `Eq`, `Compare` |

### Algorithms

| Ref | Name | What it does | Cost | Licence | Home |
|:--|:--|:--|:--|:--|:--|
| C++ | `all_of`, `any_of`, `none_of` | predicate over a run | O(n) | GPL-3.0+exception | core: `Iter::all`, `Iter::any` |
| C++ | `for_each`, `for_each_n` | visit every element | O(n) | GPL-3.0+exception | core: `Array::each`, `Iter::each` |
| C++ | `count`, `count_if` | count matches (also algo: `count_if`) | O(n) | GPL-3.0+exception | core: `Array::count` |
| C++ | `mismatch` | first differing position | O(n) | GPL-3.0+exception | algo: `mismatch` |
| C++ | `find`, `find_if`, `find_if_not`, `find_last`, `find_last_if`, `find_last_if_not` | linear search | O(n) | GPL-3.0+exception | algo: `find_*` |
| C++ | `find_end`, `find_first_of`, `adjacent_find` | subsequence and neighbour search | O(n·m) | GPL-3.0+exception | algo: `find_*` |
| C++ | `search`, `search_n`, `contains`, `contains_subrange`, `starts_with`, `ends_with` | subsequence tests | O(n·m) | GPL-3.0+exception | algo: `search`, `contains_subrange` |
| C++ | `copy`, `copy_if`, `copy_n`, `copy_backward` | copy runs | O(n) | GPL-3.0+exception | core: `Array::copy`, `Array::blit_to` |
| C++ | `move`, `move_backward` | move runs | O(n) | GPL-3.0+exception | drop: references are shared; a move is a copy the runtime already does |
| C++ | `fill`, `fill_n` | fill with a value | O(n) | GPL-3.0+exception | core: `Array::fill` |
| C++ | `transform` | map a run | O(n) | GPL-3.0+exception | core: `Array::map`, `Iter::map` |
| C++ | `generate`, `generate_n` | fill from a producer | O(n) | GPL-3.0+exception | algo: `generate` |
| C++ | `remove`, `remove_if`, `remove_copy`, `remove_copy_if` | remove by value or predicate | O(n) | GPL-3.0+exception | core: `Deque::retain`, `Array::retain` |
| C++ | `replace`, `replace_if`, `replace_copy`, `replace_copy_if` | replace by value or predicate | O(n) | GPL-3.0+exception | algo: `replace_in_place` |
| C++ | `swap`, `swap_ranges`, `iter_swap` | exchange elements or runs | O(1), O(n) | GPL-3.0+exception | core: `Array::swap` |
| C++ | `reverse`, `reverse_copy` | reverse a run | O(n) | GPL-3.0+exception | core: `Array::rev`, `Deque::rev` |
| C++ | `rotate`, `rotate_copy` | rotate a run about a pivot | O(n) | GPL-3.0+exception | algo: `rotate_in_place`, `rotate` |
| C++ | `shift_left`, `shift_right` | shift a run within its bounds | O(n) | GPL-3.0+exception | algo: `shift_left_in_place`, `shift_right_in_place` |
| C++ | `shuffle`, `sample`, `random_shuffle` | random reorder and reservoir sample | O(n) | GPL-3.0+exception | algo: `shuffle_in_place`, `sample` |
| C++ | `unique`, `unique_copy` | collapse equal neighbours | O(n) | GPL-3.0+exception | algo: `dedup_in_place` |
| C++ | `is_partitioned`, `partition`, `partition_copy`, `stable_partition`, `partition_point` | partition a run | O(n), O(n log n) stable | GPL-3.0+exception | algo: `partition_*`, `stable_partition_in_place` |
| C++ | `sort`, `stable_sort` | comparison sort | O(n log n) | GPL-3.0+exception | core: `Array::sort`, `Array::sort_by` |
| C++ | `partial_sort`, `partial_sort_copy` | sort the first k | O(n log k) | GPL-3.0+exception | algo: `partial_sort_in_place` |
| C++ | `nth_element` | k-th element in place | O(n) expected | GPL-3.0+exception | algo: `nth_element_in_place` |
| C++ | `is_sorted`, `is_sorted_until` | order check | O(n) | GPL-3.0+exception | algo: `is_sorted`, `is_sorted_until` |
| C++ | `lower_bound`, `upper_bound`, `equal_range`, `binary_search` | binary search on a sorted run (also core: `Array::binary_search`) | O(log n) | GPL-3.0+exception | algo: `bisect_left`, `bisect_right`, `equal_range` |
| C++ | `merge`, `inplace_merge` | merge sorted runs | O(n+m) | GPL-3.0+exception | algo: `merge`, `merge_in_place` |
| C++ | `includes`, `set_difference`, `set_intersection`, `set_symmetric_difference`, `set_union` | sorted set algebra | O(n+m) | GPL-3.0+exception | algo: `set_*` over sorted views |
| C++ | `make_heap`, `push_heap`, `pop_heap`, `sort_heap`, `is_heap`, `is_heap_until` | heap over a run (the d-ary form lives in `heap`) | O(log n), O(n) make_heap | GPL-3.0+exception | core: `PriorityQueue` |
| C++ | `min`, `max`, `minmax`, `clamp` | extrema of values (also algo: `clamp`) | O(1) | GPL-3.0+exception | core: `@cmp.minimum`, `@cmp.maximum`, `@cmp.minmax` |
| C++ | `min_element`, `max_element`, `minmax_element` | extrema of a run (also algo: `min_max_element`) | O(n) | GPL-3.0+exception | core: `Array::iter` fold |
| C++ | `equal`, `lexicographical_compare`, `lexicographical_compare_three_way` | run comparison | O(n) | GPL-3.0+exception | algo: `equal`, `lexicographical_compare` |
| C++ | `next_permutation`, `prev_permutation` | next or previous arrangement | O(n) | GPL-3.0+exception | algo: `next_permutation_in_place`, `prev_permutation_in_place` |
| C++ | `ranges::*` (C++20) | the same algorithms over ranges | as above | GPL-3.0+exception | drop: `ArrayView` plus the plain functions already accept a run; a ranges layer would duplicate every signature |
| C++ | `ranges::views::*` (`filter`, `transform`, `take`, `drop`, `reverse`, `join`, `split`, `chunk`, `slide`, `zip`, `enumerate`, `stride`, `common`, `counted`, `iota`, `repeat`, `single`, `take_while`, `drop_while`, `elements`, `keys`, `values`) | lazy views | lazy | GPL-3.0+exception | algo: adaptors with the same names |

### Numeric

| Ref | Name | What it does | Cost | Licence | Home |
|:--|:--|:--|:--|:--|:--|
| C++ | `iota` | fill an increasing run | O(n) | GPL-3.0+exception | core: `@range.from` + `Array::from_iter` |
| C++ | `accumulate`, `reduce`, `fold_left`, `fold_right` | fold a run | O(n) | GPL-3.0+exception | core: `Array::fold`, `Iter::fold` |
| C++ | `inner_product` | dot product | O(n) | GPL-3.0+exception | moonmath |
| C++ | `adjacent_difference` | differences of neighbours | O(n) | GPL-3.0+exception | algo: `adjacent_difference` |
| C++ | `partial_sum`, `inclusive_scan`, `exclusive_scan` | prefix sums (also algo: `prefix_sum`) | O(n) | GPL-3.0+exception | tree: `Fenwick` for repeated queries |
| C++ | `transform_reduce`, `transform_inclusive_scan`, `transform_exclusive_scan` | fold with a mapping | O(n) | GPL-3.0+exception | algo: `map_reduce` |
| C++ | `gcd`, `lcm` | integer arithmetic | O(log min) | GPL-3.0+exception | moonmath |
| C++ | `midpoint` | overflow-safe middle | O(1) | GPL-3.0+exception | moonmath |
| C++ | `add_sat`, `sub_sat`, `mul_sat`, `div_sat`, `saturate_cast` | saturating arithmetic | O(1) | GPL-3.0+exception | moonmath |

## Boost

### Boost.Container

| Ref | Name | What it does | Cost | Licence | Home |
|:--|:--|:--|:--|:--|:--|
| Boost.Container | `vector`, `deque`, `list`, `slist`, `map`, `set` | the std containers with extra options | as std | BSL-1.0 | core: `Array`, `Deque`, `List`, `SortedMap`, `SortedSet` (plus seq: `LinkedList`) |
| Boost.Container | `stable_vector` | vector whose element addresses never move | O(1) index, O(n) insert | BSL-1.0 | drop: no element addresses to keep stable; handles cover the use case |
| Boost.Container | `static_vector` | fixed-capacity vector with a length | O(1) push | BSL-1.0 | seq: `RingBuffer` with `overflow = refuse` |
| Boost.Container | `small_vector` | vector with inline storage for n elements | O(1) index | BSL-1.0 | drop: no inline storage in a GC language; `RingBuffer`/`Array` without a capacity hint is equivalent in cost |
| Boost.Container | `devector` | growth at both ends without a ring | O(1) both ends | BSL-1.0 | core: `Deque` |
| Boost.Container | `flat_map`, `flat_set`, `flat_multimap`, `flat_multiset` | sorted contiguous maps and sets | O(log n) lookup | BSL-1.0 | map: `FlatMap`, `FlatSet`, `FlatMultiMap`, `FlatMultiSet` |
| Boost.Container | `segtor` | vector addressed through a segment table | O(1) index | BSL-1.0 | drop: keeps addresses stable across growth, which the runtime already guarantees |
| Boost.Container | `string` | owning string with SSO knobs | O(1)* append | BSL-1.0 | core: `String` |
| Boost.Container | `node_handle`, `insert_return_type` | detach and reattach a node | O(1) | BSL-1.0 | drop: nodes are ordinary references; moving a value between containers needs no handle |
| Boost.Container | `vec_options`, `tree_assoc_options`, `small_vector_options`, `static_vector_options`, `stable_vector_options`, `devector_options` | growth and storage policies | — | BSL-1.0 | drop: no allocator or growth policy to configure |
| Boost.Container | `adaptive_pool`, `node_allocator`, `scoped_allocator_adaptor`, `pmr::*`, `allocator_traits`, `uses_allocator` | allocation plumbing | — | BSL-1.0 | drop: allocation is the runtime's |
| Boost.Container | `container::pmr::monotonic_buffer_resource` | arena allocation | O(1)* | BSL-1.0 | drop: same reason |
| Boost.Container | `hub` (`hub_options`) | shared structure for copying containers cheaply | copy O(1) on first copy | BSL-1.0 | drop: no copy-on-write containers in this library; `core immut` covers cheap sharing |
| Boost.Container | `erase_if`, `container::copy`, `container::equal` | helpers over containers (also algo: `equal`) | O(n) | BSL-1.0 | core: `retain` |
| Boost.Container | `segmented_iterator` | iterator over segmented storage | O(1) | BSL-1.0 | drop: iterator machinery, not a container |
| Boost.Container | `scoped_allocator_adaptor` | propagate allocators to elements | — | BSL-1.0 | drop: allocation is the runtime's |

### Boost.CircularBuffer

| Ref | Name | What it does | Cost | Licence | Home |
|:--|:--|:--|:--|:--|:--|
| Boost.CircularBuffer | `circular_buffer` | fixed-capacity ring buffer that overwrites the oldest element | O(1) push, pop, index | BSL-1.0 | seq: `RingBuffer` |
| Boost.CircularBuffer | `circular_buffer_space_optimized` | ring buffer that grows its storage on demand up to the capacity | O(1)* push | BSL-1.0 | seq: `RingBuffer` (storage grows to the capacity on demand, then overwrites) |
| Boost.CircularBuffer | `circular_buffer::array_one`, `array_two`, `linearize`, `is_linearized`, `rotate`, `rerase`, `rresize` | two-run view of ring storage | O(1) view, O(n) linearise | BSL-1.0 | seq: `RingBuffer::as_views`, `RingBuffer::linearize` |
| Boost.CircularBuffer | `circular_buffer::capacity`, `resize`, `set_capacity` | size control | O(1), O(n) | BSL-1.0 | seq: `RingBuffer::capacity`, `RingBuffer::resize_capacity` |

### Boost.Heap

| Ref | Name | What it does | Cost | Licence | Home |
|:--|:--|:--|:--|:--|:--|
| Boost.Heap | `priority_queue` | binary heap with policy knobs | O(log n) push/pop | BSL-1.0 | core: `PriorityQueue` |
| Boost.Heap | `d_ary_heap` | d-ary heap, better cache behaviour | O(log_d n) | BSL-1.0 | heap: `DaryHeap` |
| Boost.Heap | `binomial_heap` | meldable heap of binomial trees | O(log n) push, O(log n) meld | BSL-1.0 | heap: `BinomialHeap` |
| Boost.Heap | `fibonacci_heap` | meldable heap with amortised O(1) decrease-key | O(1)* push, O(1)* decrease-key | BSL-1.0 | heap: `FibonacciHeap` |
| Boost.Heap | `pairing_heap` | meldable heap, decrease-key without cuts | O(1)* push, O(log n)* meld | BSL-1.0 | heap: `PairingHeap` |
| Boost.Heap | `skew_heap` | self-adjusting meldable heap | O(log n)* meld | BSL-1.0 | drop: same asymptotics as the pairing heap with a simpler implementation to get wrong; one meldable heap without handles is enough |
| Boost.Heap | `mutable_` (interface of `d_ary_heap`, `pairing_heap`, `fibonacci_heap`) | handle-based key update and erase | O(log n), O(1)* decrease-key | BSL-1.0 | heap: `IndexHeap`, `PairingHeap`, `FibonacciHeap` (`insert` returns a handle) |
| Boost.Heap | `heap_merge`, `heap_algorithms` (`heap_merge`, `heap_union`, `heap_contains`, `heap_is_permutation`, `heap_is_heap`, `heap_erase_and_update`) | merge and inspect heaps | O(n) | BSL-1.0 | heap: methods on the meldable heaps |
| Boost.Heap | `compare`, `stability`, `arity`, `allocator`, `mutable` policies | heap tuning (of the policy knobs, only arity has a counterpart here) | — | BSL-1.0 | heap: `DaryHeap` arity parameter |

### Boost.Bimap

| Ref | Name | What it does | Cost | Licence | Home |
|:--|:--|:--|:--|:--|:--|
| Boost.Bimap | `bimap` | two-way map, lookup by either side | O(log n) or O(1) per side | BSL-1.0 | map: `BiMap` |
| Boost.Bimap | `set_of`, `multiset_of`, `unordered_set_of`, `unordered_multiset_of`, `list_of`, `vector_of`, `unconstrained_set_of` | storage and ordering choice per side | as the side | BSL-1.0 | map: `BiMap` (hashed sides) and `SortedBiMap` (ordered sides) |
| Boost.Bimap | `bimap_of` | shorthand for a set/unordered-set bimap | — | BSL-1.0 | map: `BiMap::new` |
| Boost.Bimap | `member_at`, `value_type_of`, `left_map`, `right_map`, `relation`, `project` | navigate and relate the two sides | O(1) | BSL-1.0 | map: `BiMap::get_by_value`, `BiMap::get_key` |
| Boost.Bimap | `bimap::insert`, `replace`, `modify`, `erase`, `find`, `at` | element operations | O(1) or O(log n) | BSL-1.0 | map: `BiMap::set`, `BiMap::remove` |

### Boost.MultiIndex

| Ref | Name | What it does | Cost | Licence | Home |
|:--|:--|:--|:--|:--|:--|
| Boost.MultiIndex | `multi_index_container` | one set of elements, several independent orderings | O(log n) per index | BSL-1.0 | drop: MoonBit cannot parameterise a type over a list of index types; `IndexMap`, `SortedMap` and `MultiMap` cover the cases that need one or two orderings |
| Boost.MultiIndex | `ordered_index`, `hashed_index`, `sequenced_index`, `random_access_index`, `ranked_index` | the five index kinds | O(log n), O(1)*, O(1), O(1), O(log n) | BSL-1.0 | drop: same reason; `tree: OrderStatisticTree` covers the ranked index |
| Boost.MultiIndex | `identity`, `member`, `mem_fun`, `global_fun`, `composite_key`, `composite_key_compare`, `composite_key_equal_to`, `composite_key_hash` | key extraction from a whole element | O(1) | BSL-1.0 | drop: keys are values in MoonBit; a composite key is a tuple, which already has `Compare` and `Hash` |
| Boost.MultiIndex | `tag`, `indexed_by`, `nth_index`, `get` | address an index by type or tag | O(1) | BSL-1.0 | drop: same reason |

### Boost.Intrusive

| Ref | Name | What it does | Cost | Licence | Home |
|:--|:--|:--|:--|:--|:--|
| Boost.Intrusive | `list`, `slist`, `circular_list_algorithms`, `circular_slist_algorithms` | list nodes embedded in the element type | O(1) | BSL-1.0 | drop: embedding link fields into a user type needs layout control the language does not give; `seq: LinkedList` and `seq: SlotMap` cover the uses |
| Boost.Intrusive | `set`, `multiset`, `rbtree`, `avltree`, `splaytree`, `treap`, `bs_set`, `sg_set`, `sgtree`, `treap_set` | trees over embedded hooks | O(log n) | BSL-1.0 | drop: same reason; tree: `Treap`, `SkipList`, `OrderStatisticTree` cover the ordered structures |
| Boost.Intrusive | `unordered_set`, `hashtable` | hash table over embedded hooks | O(1)* | BSL-1.0 | drop: same reason |
| Boost.Intrusive | `list_hook`, `set_hook`, `any_hook`, `bs_set_hook`, `avl_set_hook`, `splay_set_hook`, `treap_set_hook`, `unordered_set_hook` | the embedded link fields | — | BSL-1.0 | drop: same reason |
| Boost.Intrusive | `auto_unlink`, `safe_link`, `normal_link`, `link_mode`, `constant_time_size`, `size_type`, `store_hash`, `optimize_size`, `cache_last`, `compare_hash`, `power_2_buckets` | hook and container options | — | BSL-1.0 | drop: same reason |
| Boost.Intrusive | `pointer_traits`, `pointer_plus_bits`, `pointer_rebind`, `derivation_value_traits`, `member_value_traits`, `trivial_value_traits` | hook-to-element mapping | — | BSL-1.0 | drop: same reason |
| Boost.Intrusive | `bucket_traits`, `hashtable_bucket_traits` | external bucket storage | — | BSL-1.0 | drop: same reason |
| Boost.Intrusive | `priority_compare`, `value_traits` | ordering and value adaptors | — | BSL-1.0 | drop: same reason |

### Boost.Unordered

| Ref | Name | What it does | Cost | Licence | Home |
|:--|:--|:--|:--|:--|:--|
| Boost.Unordered | `unordered_map`, `unordered_set`, `unordered_multimap`, `unordered_multiset` | hashed containers (also map: `MultiMap`, `MultiSet`) | O(1)* | BSL-1.0 | core: `HashMap`, `HashSet` |
| Boost.Unordered | `unordered_flat_map`, `unordered_flat_set`, `unordered_node_map`, `unordered_node_set`, `unordered_map` (flat default) | open-addressing and node-based variants | O(1)* | BSL-1.0 | drop: core's `HashMap` is already an open-addressing table; a second table with the same interface would only add a tuning surface |
| Boost.Unordered | `concurrent_flat_map`, `concurrent_flat_set`, `concurrent_node_map`, `concurrent_node_set` | containers safe across threads | O(1)* | BSL-1.0 | drop: no shared-memory threads |
| Boost.Unordered | `dense_map`, `dense_set` (Boost 1.81) | index table plus dense value array | O(1)* | BSL-1.0 | drop: same reason as the flat variants |
| Boost.Unordered | `hash_traits`, `hash_is_avalanching`, `is_transparent`, `heterogeneous lookup` (`find`, `contains`, `erase` with a different key type) | hashing policy and heterogeneous lookup | O(1)* | BSL-1.0 | drop: `Hash + Eq` on one key type only; heterogeneous lookup would need a second trait on core's `Hash` |
| Boost.Unordered | `bucket_count`, `load_factor`, `rehash`, `reserve` | table control (also `reserve_capacity` on this library's tables) | O(n) | BSL-1.0 | core: `HashMap::capacity` |

### Boost.Algorithm

| Ref | Name | What it does | Cost | Licence | Home |
|:--|:--|:--|:--|:--|:--|
| Boost.Algorithm | `all_of`, `any_of`, `none_of`, `one_of` | predicate over a run (also algo: `one_of`) | O(n) | BSL-1.0 | core: `Iter::all`, `Iter::any` |
| Boost.Algorithm | `clamp`, `is_clamped` | bound a value | O(1) | BSL-1.0 | algo: `clamp`, `is_clamped` |
| Boost.Algorithm | `copy_if`, `copy_until`, `copy_n`, `copy_while` | conditional copy (also algo: `copy_if`) | O(n) | BSL-1.0 | core: `Array::blit_to` |
| Boost.Algorithm | `find_not`, `find_backward`, `find_if_not` | search from the ends | O(n) | BSL-1.0 | algo: `find_*` |
| Boost.Algorithm | `gather` | move matching elements into one place | O(n) | BSL-1.0 | algo: `gather_in_place` |
| Boost.Algorithm | `hex`, `unhex` | hex encode and decode a run | O(n) | BSL-1.0 | drop: belongs with the encoding library, and that library has it |
| Boost.Algorithm | `is_palindrome`, `is_partitioned_until` | run predicates | O(n) | BSL-1.0 | algo: `is_palindrome`, `is_partitioned_until` |
| Boost.Algorithm | `minmax`, `minmax_element` | both extrema in one pass | O(1), O(n) | BSL-1.0 | algo: `min_max_element` |
| Boost.Algorithm | `apply_permutation`, `apply_reverse_permutation`, `sort_subrange` | apply an index permutation, sort a subrange | O(n), O(n log n) | BSL-1.0 | algo: `apply_permutation_in_place`, `sort_subrange_in_place` |
| Boost.Algorithm | `partition_point`, `partition_copy` | partition helpers | O(log n), O(n) | BSL-1.0 | algo: `partition_point`, `partition_copy` |
| Boost.Algorithm | `search`, `find_first_of` | subsequence search | O(n·m) | BSL-1.0 | algo: `search` |
| Boost.Algorithm | `trim`, `trim_copy`, `trim_if`, `trim_copy_if`, `trim_left`, `trim_right` | trim a string view | O(n) | BSL-1.0 | drop: the string library owns string trimming |
| Boost.Algorithm | `boyer_moore_search`, `boyer_moore_horspool_search`, `knuth_morris_pratt_search` | substring search with a precomputed skip table | O(n+m) search, O(m) table | BSL-1.0 | text: `Kmp`, `BoyerMoore` |
| Boost.Algorithm | `boyer_moore`, `boyer_moore_horspool`, `knuth_morris_pratt` | the searcher objects behind the above | — | BSL-1.0 | text: `Kmp`, `BoyerMoore` (types that hold the table) |
| Boost.Algorithm | `order`, `identity_ord` | comparison from a key function | O(1) | BSL-1.0 | drop: pass a closure; a comparator wrapper adds nothing |
| Boost.Algorithm | `lexicographical_compare_three_way` | three-way run comparison | O(n) | BSL-1.0 | algo: `lexicographical_compare` |
| Boost.Algorithm | `string_regex`, `regex_search`, `regex_replace` (Boost.Algorithm's regex helpers) | regex over strings | — | BSL-1.0 | drop: a regex engine is its own library, not a container or algorithm of this one |

## EASTL

| Ref | Name | What it does | Cost | Licence | Home |
|:--|:--|:--|:--|:--|:--|
| EASTL | `vector`, `deque`, `list`, `slist`, `map`, `multimap`, `set`, `multiset`, `basic_string`, `span`, `array`, `bitset`, `bitvector` | the std containers without exceptions (also seq: `BitVec`, `BitSet`; map: `SortedMultiMap`, `SortedMultiSet`) | as std | BSD-3-Clause | core: `Array`, `Deque`, `List`, `SortedMap`, `SortedSet`, `String`, `ArrayView`, `FixedArray` |
| EASTL | `hash_map`, `hash_set`, `hash_multimap`, `hash_multiset` | hashed containers (also map: `MultiMap`, `MultiSet`) | O(1)* | BSD-3-Clause | core: `HashMap`, `HashSet` |
| EASTL | `fixed_vector`, `fixed_list`, `fixed_slist`, `fixed_map`, `fixed_multimap`, `fixed_set`, `fixed_multiset`, `fixed_hash_map`, `fixed_hash_set`, `fixed_hash_multimap`, `fixed_hash_multiset`, `fixed_string`, `fixed_substring` | containers with a compile-time capacity (also drop for the rest: a fixed capacity is a constructor argument here, not a type) | O(1) push | BSD-3-Clause | seq: `RingBuffer` with `overflow = refuse` for the sequence ones |
| EASTL | `vector_map`, `vector_multimap`, `vector_set`, `vector_multiset` | sorted contiguous containers | O(log n) lookup | BSD-3-Clause | map: `FlatMap`, `FlatMultiMap`, `FlatSet`, `FlatMultiSet` |
| EASTL | `segmented_vector` | vector over segments | O(1) index | BSD-3-Clause | drop: like `segtor`; stable addresses are not a problem here |
| EASTL | `intrusive_list`, `intrusive_slist`, `intrusive_hash_map`, `intrusive_hash_set`, `intrusive_ptr`, `linked_ptr`, `safe_ptr`, `scoped_ptr`, `shared_ptr`, `unique_ptr`, `weak_ptr`, `scoped_array`, `shared_array`, `linked_array` | smart pointers and intrusive containers | — | BSD-3-Clause | drop: garbage collected; intrusive containers need layout control |
| EASTL | `priority_queue`, `queue`, `stack` | adaptors | O(log n), O(1), O(1) | BSD-3-Clause | core: `PriorityQueue`, `Queue`, `Array` |
| EASTL | `intrusive_heap` | heap over nodes linked by the element | O(log n) | BSD-3-Clause | drop: intrusive |
| EASTL | `fixed_function`, `function`, `functional` | callable wrappers | — | BSD-3-Clause | core: function values |
| EASTL | `optional`, `expected`, `variant`, `any`, `tuple`, `utility`, `initializer_list` | vocabulary types | — | BSD-3-Clause | core: `Option`, `Result`, enums, tuples |
| EASTL | `algorithm`, `sort`, `heap`, `numeric` | the std algorithms | as std | BSD-3-Clause | algo |
| EASTL | `allocator`, `fixed_allocator`, `core_allocator`, `core_allocator_adapter`, `allocator_malloc` | allocation | — | BSD-3-Clause | drop: allocation is the runtime's |
| EASTL | `string_view`, `string_hash_map`, `string_map` | string keys with precomputed hashes | O(1)* | BSD-3-Clause | drop: `String` hashing is already cheap; a separate container for string keys duplicates `HashMap` |
| EASTL | `finally`, `scope_guard`, `atomic`, `chrono`, `ratio`, `type_traits`, `meta`, `memory`, `iterator`, `random`, `compare`, `utility`, `core_allocator` | language backfills | — | BSD-3-Clause | drop: backfills for a language without these features |

## ETL

ETL is the embedded subset of the STL: fixed capacity everywhere, no exceptions, no
allocation. Its containers are one row each; the fixed capacity is a constructor
parameter here, as with EASTL.

| Ref | Name | What it does | Cost | Licence | Home |
|:--|:--|:--|:--|:--|:--|
| ETL | `vector`, `deque`, `list`, `forward_list`, `array`, `basic_string`, `string_view`, `span`, `bitset` | the std containers with a capacity bound (also seq: `BitSet`) | as std | MIT | core: `Array`, `Deque`, `List`, `String`, `StringView`, `ArrayView`, `FixedArray` |
| ETL | `map`, `multimap`, `set`, `multiset`, `flat_map`, `flat_multimap`, `flat_set`, `flat_multiset` | ordered containers (also map: `SortedMultiMap`, `SortedMultiSet`, `FlatMap`, `FlatSet`) | O(log n) | MIT | core: `SortedMap`, `SortedSet` |
| ETL | `unordered_map`, `unordered_multimap`, `unordered_set`, `unordered_multiset`, `unordered_map` bucket storage | hashed containers (also map: `MultiMap`, `MultiSet`) | O(1)* | MIT | core: `HashMap`, `HashSet` |
| ETL | `circular_buffer` | fixed-capacity ring buffer | O(1) | MIT | seq: `RingBuffer` |
| ETL | `priority_queue`, `queue`, `stack` | adaptors with a capacity | O(log n), O(1), O(1) | MIT | core: `PriorityQueue`, `Queue`, `Array` |
| ETL | `intrusive_list`, `intrusive_links`, `intrusive_queue`, `intrusive_stack` | intrusive containers | O(1) | MIT | drop: intrusive needs layout control |
| ETL | `reference_flat_map`, `reference_flat_set`, `reference_flat_multimap`, `reference_flat_multiset` | sorted tables of references | O(log n) | MIT | map: `FlatMap` (elements are references in MoonBit) |
| ETL | `pool`, `memory`, `unaligned_type`, `alignment` | fixed pools and alignment helpers | O(1)* | MIT | drop: allocation is the runtime's |
| ETL | `binary`, `bsearch`, `lower_bound`, `upper_bound`, `equal_range` | binary search on a run | O(log n) | MIT | algo: `bisect_*`, `equal_range` |
| ETL | `algorithm`, `numeric`, `functional`, `iterator`, `utility`, `type_traits`, `limits`, `chrono`, `ratio`, `random`, `atomic`, `expected`, `optional`, `variant`, `tuple`, `delegate`, `function`, `initializer_list`, `message_packet`, `message_router`, `state_chart`, `callback`, `observer`, `fsm`, `scheduler`, `task` | std backfills and embedded infrastructure | — | MIT | drop: backfills, or infrastructure that belongs to another library (a scheduler, an FSM, a router) |
| ETL | `hash`, `fnv_1_hash`, `crc`, `checksum` | hashing and checksums | O(n) | MIT | drop: hashing lives in core; checksums in the encoding library |
| ETL | `bit_stream`, `byte_stream`, `endianness` | bit-level I/O | O(1) | MIT | drop: belongs to a wire-format library |
| ETL | `error_handler`, `exception`, `assert` | error plumbing | — | MIT | core: `Error`, `abort` |
| ETL | `container` (`etl::container`) helpers: `assign`, `insert`, `erase`, `push`, `pop` | generic element access | O(1) | MIT | drop: methods already exist per container |
| ETL | `iterator` adaptors: `insert_iterator`, `back_insert_iterator`, `front_insert_iterator`, `move_iterator`, `reverse_iterator`, `counting_iterator`, `transform_iterator`, `filter_iterator`, `zip_iterator` | iterator glue (also drop for the insert iterators) | — | MIT | algo: the lazy adaptors that have a MoonBit equivalent (`transform`, `filter`, `zip`, `rev`, `enumerate`) |

## Abseil

Abseil matters here twice: for the containers themselves, and for `c_*` — the
container-flavoured versions of the standard algorithms. The `c_*` family are the
same algorithms as the C++ rows above, so they are listed once, in one row.

| Ref | Name | What it does | Cost | Licence | Home |
|:--|:--|:--|:--|:--|:--|
| Abseil | `flat_hash_map`, `flat_hash_set` | open-addressing hash table storing keys inline | O(1)* | Apache-2.0 | drop: core's `HashMap` is the same shape; a second table would only add a probing-policy surface |
| Abseil | `node_hash_map`, `node_hash_set`, `node_hash_map_pointer` | open-addressing index over separately stored nodes | O(1)* | Apache-2.0 | drop: references are already stable in a garbage-collected runtime |
| Abseil | `btree_map`, `btree_set`, `btree_multimap`, `btree_multiset` | B-tree with configurable node size | O(log n) | Apache-2.0 | drop: core's `SortedMap` is a B-tree already |
| Abseil | `linked_hash_map`, `linked_hash_set` | insertion-ordered hash table | O(1)* | Apache-2.0 | core: `Map`, `Set` (insertion order) |
| Abseil | `inlined_vector` | vector with inline storage | O(1)* | Apache-2.0 | drop: no inline storage in a garbage-collected runtime |
| Abseil | `fixed_array` | fixed-size array with bounds checking | O(1) | Apache-2.0 | core: `FixedArray` |
| Abseil | `chunked_queue` | unbounded FIFO in fixed-size chunks | O(1)* | Apache-2.0 | core: `Queue` |
| Abseil | `hash_container_defaults`, `container_internal::hash_default_hash`, `hash_default_eq` | default hash and equality for the tables | — | Apache-2.0 | core: `Hash`, `Eq` |
| Abseil | `c_*` (`c_accumulate`, `c_adjacent_find`, `c_all_of`, `c_any_of`, `c_binary_search`, `c_contains`, `c_contains_subrange`, `c_copy*`, `c_count*`, `c_equal`, `c_equal_range`, `c_fill*`, `c_find*`, `c_for_each`, `c_generate*`, `c_includes`, `c_inner_product`, `c_inplace_merge`, `c_iota`, `c_is_heap*`, `c_is_partitioned`, `c_is_permutation`, `c_is_sorted*`, `c_lower_bound`, `c_make_heap`, `c_max_element`, `c_merge`, `c_min_element`, `c_minmax_element`, `c_mismatch`, `c_next_permutation`, `c_none_of`, `c_nth_element`, `c_partial_sort*`, `c_partial_sum`, `c_partition*`, `c_pop_heap`, `c_prev_permutation`, `c_push_heap`, `c_remove_copy*`, `c_replace*`, `c_reverse*`, `c_rotate*`, `c_sample`, `c_search`, `c_search_n`, `c_set_*`, `c_shuffle`, `c_sort*`, `c_stable_partition`, `c_swap_ranges`, `c_transform`, `c_unique_copy`, `c_upper_bound`) | the standard algorithms taking a container | as std | Apache-2.0 | algo |
| Abseil | `absl::algorithm::equal`, `absl::algorithm::rotate` | overloads for different iterator categories | O(n) | Apache-2.0 | algo: `equal`, `rotate` |

## Folly

| Ref | Name | What it does | Cost | Licence | Home |
|:--|:--|:--|:--|:--|:--|
| Folly | `F14Map`, `F14Set`, `F14ValueMap`, `F14NodeMap`, `F14FastMap`, `F14VectorMap` and the set forms | SIMD-probed hash table with swappable storage | O(1)* | Apache-2.0 | drop: the probe design depends on vector width and word-level tricks the language does not expose; core's `HashMap` is the table here |
| Folly | `F14BasicMap::heterogeneousLookup`, `F14Table` control bytes, `reserve`, `rehash`, `prefetch` | lookup and table control | O(1)* | Apache-2.0 | drop: heterogeneous lookup needs a second key trait on core's `Hash` |
| Folly | `fbvector` | vector with growth policies and eager reallocation | O(1)* | Apache-2.0 | core: `Array` |
| Folly | `small_vector` | vector with inline storage | O(1) index | Apache-2.0 | drop: no inline storage |
| Folly | `sorted_vector_map`, `sorted_vector_set`, `sorted_vector_multimap`, `sorted_vector_multiset` | sorted contiguous containers | O(log n) lookup | Apache-2.0 | map: `FlatMap`, `FlatSet`, `FlatMultiMap`, `FlatMultiSet` |
| Folly | `dynamic` (`dynamic_map`, `dynamic_set`, `dynamic::array`, `dynamic::object`) | self-describing JSON-like container | O(1)* | Apache-2.0 | drop: `Json` in core already is that container |
| Folly | `EvictingCacheMap` | LRU eviction over a hash table | O(1)* | Apache-2.0 | cache: `LruCache` |
| Folly | `WeightedEvictingCacheMap` | eviction by accumulated weight | O(1)* | Apache-2.0 | cache: `LruCache` with a weight function |
| Folly | `GenerationalCacheMap` | generational bucket cache | O(1) | Apache-2.0 | drop: a fixed policy for a specific workload; no second consumer |
| Folly | `FixedCapacityRingQueue` | bounded FIFO in a ring | O(1) | Apache-2.0 | seq: `RingBuffer` |
| Folly | `DynamicRingQueue` | unbounded FIFO in a ring | O(1)* | Apache-2.0 | core: `Queue` |
| Folly | `SparseByteSet` | set of bytes as a 256-bit mask | O(1) | Apache-2.0 | seq: `BitSet` (`BitSet::of_bytes`) |
| Folly | `tape` | dense array addressed by sparse keys | O(1) | Apache-2.0 | seq: `SparseSet` |
| Folly | `vector_bool`, `std::bitset` helpers | bit-packed containers | O(1) index | Apache-2.0 | seq: `BitVec`, `BitSet` |
| Folly | `IntrusiveList`, `IntrusiveHeap` | intrusive containers | O(1), O(log n) | Apache-2.0 | drop: intrusive needs layout control |
| Folly | `AtomicHashMap`, `ConcurrentHashMap`, `ConcurrentSkipList`, `ConcurrentSkipListMap`, `ConcurrentSkipListSet` | lock-free and concurrent tables | O(1)*, O(log n) | Apache-2.0 | drop: no shared-memory threads |
| Folly | `merge`, `map_util` (`get_ref_default`, `get_ptr`, `get_default`, `try_get`), `reserve`, `CollectionUtil` (`contains`, `get_ptr`, `get_ref_default`, `get_default`), `Enumerate`, `irange`, `Foreach`, `MapUtil`, `Reserve`, `StringKeyedMap`, `StringKeyedUnorderedMap` | map utilities and iteration helpers (the macro and view helpers are not built) | O(1) | Apache-2.0 | core: `HashMap::get_or_default`, `HashMap::get` |
| Folly | `Access`, `Array`, `BitIterator`, `HeterogeneousAccess`, `RangeTraits`, `View`, `WeightedEvictingCacheMap::WeightFn` | adaptors and access helpers | — | Apache-2.0 | drop: helper plumbing for the C++ containers above |

## GTL

| Ref | Name | What it does | Cost | Licence | Home |
|:--|:--|:--|:--|:--|:--|
| GTL | `flat_hash_map`, `flat_hash_set`, `node_hash_map`, `node_hash_set` | the parallel-friendly hash table family | O(1)* | Apache-2.0 | drop: core's `HashMap` covers the table; the value here is the parallel variant |
| GTL | `parallel_flat_hash_map`, `parallel_flat_hash_set`, `parallel_node_hash_map`, `parallel_node_hash_set` | sharded hash table, one lock per shard | O(1)* | Apache-2.0 | drop: no shared-memory threads |
| GTL | `btree`, `btree_map`, `btree_set`, `btree_multimap`, `btree_multiset` | B-tree with a configurable node size | O(log n) | Apache-2.0 | drop: core's `SortedMap` is a B-tree already |
| GTL | `lru_cache` | fixed-capacity LRU over a hash table | O(1)* | Apache-2.0 | cache: `LruCache` |
| GTL | `small_vector` | vector with inline storage | O(1) index | Apache-2.0 | drop: no inline storage |
| GTL | `vector`, `soa` (structure of arrays), `bit_vector`, `bits` | contiguous containers and bit helpers (also seq: `BitVec`) | O(1) index | Apache-2.0 | core: `Array` |
| GTL | `memoize`, `combinators`, `utils`, `vec_utils`, `stopwatch`, `meminfo`, `intrusive` | function memoisation, combinator plumbing | O(1)* | Apache-2.0 | drop: a memoising wrapper is a `HashMap` plus a closure the caller writes |
| GTL | `phmap_dump`, `phmap_utils`, `gtl_base`, `gtl_config`, `phmap_fwd_decl` | serialisation and configuration plumbing | — | Apache-2.0 | drop: plumbing |

## STXXL

| Ref | Name | What it does | Cost | Licence | Home |
|:--|:--|:--|:--|:--|:--|
| STXXL | `stxxl::vector`, `stxxl::deque`, `stxxl::map`, `stxxl::set`, `stxxl::unordered_map`, `stxxl::queue`, `stxxl::stack`, `stxxl::priority_queue` | containers that page to disk | I/O bound | BSL-1.0 | drop: external memory needs a file-backed pager and block manager; the task defers it until another library needs it |
| STXXL | `stxxl::sort`, `stxxl::stable_sort`, `stxxl::ksort`, `stxxl::stable_ksort`, `stxxl::sorter` | external merge sort | I/O bound | BSL-1.0 | drop: same reason |
| STXXL | `stxxl::stream::*` (`stream::sort`, `stream::make_stream`, `stream::transform`, `stream::filter`, `stream::unique`, `stream::runs_creator`, `stream::runs_merger`) | streaming pipeline operators | I/O bound | BSL-1.0 | drop: same reason; the in-memory shapes are algo adaptors |
| STXXL | `stxxl::scan`, `stxxl::request`, `stxxl::mng` (block manager), `stxxl::stats`, `stxxl::timer`, `stxxl::random_shuffle`, `stxxl::random_number` | I/O scheduling and measurement | — | BSL-1.0 | drop: same reason |
| STXXL | `stxxl::matrix`, `stxxl::aligned_alloc`, `stxxl::mallocstats`, `stxxl::types` | dense numeric storage | O(1) index | BSL-1.0 | moonmath |

## CGAL

CGAL is listed here because the project asked what of it belongs where. Geometry
goes to `moonmath`; the only pieces that concern this library are the spatial
indexes, which are ordinary trees.

| Ref | Name | What it does | Cost | Licence | Home |
|:--|:--|:--|:--|:--|:--|
| CGAL | `Point_2`, `Point_3`, `Vector_2`, `Vector_3`, `Direction_2`, `Line_2`, `Segment_2`, `Ray_2`, `Triangle_2`, `Iso_rectangle_2`, `Circle_2`, `Plane_3`, `Sphere_3`, `Tetrahedron_3` | kernel types | O(1) | GPL-3.0+/LGPL-3.0/commercial | moonmath |
| CGAL | `Exact_predicates_inexact_constructions_kernel`, `Exact_predicates_exact_constructions_kernel`, `Simple_cartesian`, `Homogeneous`, `Cartesian` | kernels with exact predicates | — | GPL-3.0+/LGPL-3.0/commercial | moonmath |
| CGAL | `convex_hull_2`, `convex_hull_3`, `convex_hull_d`, `lower_hull`, `upper_hull` | convex hulls | O(n log n) | GPL-3.0+/LGPL-3.0/commercial | moonmath |
| CGAL | `Delaunay_triangulation_2`, `Delaunay_triangulation_3`, `Regular_triangulation_2/3`, `Constrained_Delaunay_triangulation_2`, `Triangulation_2`, `Triangulation_3`, `Periodic_2_triangulation_2` | triangulations | O(log n) insert | GPL-3.0+/LGPL-3.0/commercial | moonmath |
| CGAL | `Polygon_2`, `Polygon_set_2`, `General_polygon_set_2`, `Polyhedron_3`, `Surface_mesh`, `Linear_cell_complex`, `Combinatorial_map`, `Generalized_map`, `HalfedgeDS` | polygon and mesh data structures | — | GPL-3.0+/LGPL-3.0/commercial | moonmath |
| CGAL | `Arrangement_2`, `Arrangement_on_surface_2`, `Boolean_set_operations_2`, `Nef_polyhedron_2`, `Nef_polyhedron_3`, `Minkowski_sum_2`, `Minkowski_sum_3`, `Straight_skeleton_2` | arrangements and boolean geometry | O(n log n) | GPL-3.0+/LGPL-3.0/commercial | moonmath |
| CGAL | `AABB_tree`, `AABB_traits`, `Surface_mesh_shortest_path`, `Polyhedron_distance`, `point_to_triangle_distance` | axis-aligned bounding volume hierarchies (the one-dimensional case is the interval tree in `tree`) | O(log n) query | GPL-3.0+/LGPL-3.0/commercial | moonmath |
| CGAL | `Kd_tree`, `Orthogonal_k_neighbor_search`, `Incremental_neighbor_search`, `Fuzzy_sphere`, `Fuzzy_iso_box`, `Search_traits` | k-d trees and nearest-neighbour search | O(log n) query | GPL-3.0+/LGPL-3.0/commercial | moonmath |
| CGAL | `spatial_sort`, `Hilbert_sort`, `Median_cut`, `Spatial_lock_grid_3` | spatial ordering | O(n log n) | GPL-3.0+/LGPL-3.0/commercial | moonmath |
| CGAL | `Alpha_shape_2`, `Alpha_shape_3`, `Poisson_surface_reconstruction`, `advancing_front_surface_reconstruction`, `jet_smoothing`, `wlop_simplify`, `grid_simplify` | shape reconstruction | — | GPL-3.0+/LGPL-3.0/commercial | moonmath |
| CGAL | `CGAL::parameters`, `Polygon_mesh_processing::*` (`triangulate_faces`, `refine`, `isotropic_remeshing`, `smooth_mesh`, `simplify`, `corefine`, `boolean_operations`, `self_intersections`, `distance`, `sample`, `orient_polygon_soup`) | mesh processing | — | GPL-3.0+/LGPL-3.0/commercial | moonmath |
| CGAL | `mesh_3` (`make_mesh_3`), `tetrahedral_remeshing`, `polygon_mesh_slicer` | volumetric meshing | — | GPL-3.0+/LGPL-3.0/commercial | moonmath |
| CGAL | `Surface_mesh_parameterization`, `Surface_mesh_deformation`, `Surface_mesh_skeletonization`, `Surface_mesh_segmentation`, `Heat_method` | parameterisation and deformation | — | GPL-3.0+/LGPL-3.0/commercial | moonmath |
| CGAL | `snap_rounding_2`, `partition_2`, `partition_3`, `interpolation`, `Bounding_volumes`, `Optimal_bounding_box`, `Kinetic_data_structures` | geometric utilities | — | GPL-3.0+/LGPL-3.0/commercial | moonmath |
| CGAL | `Range_tree`, `Segment_tree`, `Interval_tree`, `Orthogonal_incremental_neighbor_search` (1-D forms) | interval and segment indexes | O(log n + k) | GPL-3.0+/LGPL-3.0/commercial | tree |
| CGAL | `number types`: `Gmpz`, `Gmpq`, `MP_Float`, `Lazy_exact_nt`, `Quotient`, `Sqrt_extension`, `Interval_nt`, `CORE::BigRat` | exact arithmetic (`BigInt` itself is core's) | — | GPL-3.0+/LGPL-3.0/commercial | moonmath |

## Python

### `collections`

| Ref | Name | What it does | Cost | Licence | Home |
|:--|:--|:--|:--|:--|:--|
| Python | `deque` (`appendleft`, `popleft`, `extendleft`, `rotate`, `maxlen`, `insert`, `remove`, `copy`, `index`) | double-ended queue with an optional bound (also algo: `rotate_in_place`) | O(1) both ends | PSF-2.0 | core: `Deque` |
| Python | `OrderedDict` (`move_to_end`, `popitem(last=)`, `reversed`) | map that remembers insertion order (also map: `IndexMap` (`move_index`)) | O(1)* | PSF-2.0 | core: `Map` |
| Python | `defaultdict` (`default_factory`, `__missing__`) | map that inserts a default on a missing key | O(1)* | PSF-2.0 | map: `DefaultMap` |
| Python | `Counter` (`most_common`, `elements`, `subtract`, `total`, `update`, `+`, `-`, `&`, `\|`) | multiset that counts keys | O(1)* count, O(n log n) most_common | PSF-2.0 | map: `Counter` |
| Python | `ChainMap` (`maps`, `new_child`, `parents`) | several maps read as one | O(depth) lookup | PSF-2.0 | map: `ChainMap` |
| Python | `namedtuple`, `namedtuple._fields`, `_replace`, `_asdict` | tuple with named fields | O(1) | PSF-2.0 | drop: a struct with `derive` is the same thing with types |
| Python | `UserDict`, `UserList`, `UserString` | subclassing shims over the builtins | — | PSF-2.0 | drop: no wrapper needed to extend a type |
| Python | `_collections_abc.KeysView`, `ItemsView`, `ValuesView` | views over a mapping | O(1) create, O(n) iterate | PSF-2.0 | core: `Iter` from `keys`/`values`/`iter` |
| Python | `collections.abc` (`Sequence`, `Mapping`, `MutableMapping`, `Set`, `Iterable`, `Iterator`, `Callable`, `Hashable`, `Sized`, `Container`) | interface contracts | — | PSF-2.0 | core: traits (`Eq`, `Hash`, `Compare`, `Show`) and the method names in the interface table |

### `array` and `weakref`

| Ref | Name | What it does | Cost | Licence | Home |
|:--|:--|:--|:--|:--|:--|
| Python | `array` (`typecode`, `frombytes`, `tobytes`, `append`, `extend`, `buffer_info`) | typed flat array | O(1)* append | PSF-2.0 | core: `Array` |
| Python | `weakref.ref`, `proxy`, `WeakValueDictionary`, `WeakKeyDictionary`, `WeakSet`, `finalize`, `WeakMethod` | references that do not keep an object alive | O(1) | PSF-2.0 | drop: a tracing collector hands out no weak handles; a cache that must not retain keys uses `SlotMap` keys instead |

### `heapq`

| Ref | Name | What it does | Cost | Licence | Home |
|:--|:--|:--|:--|:--|:--|
| Python | `heappush`, `heappop`, `heapify` | binary min-heap over a list | O(log n), O(n) | PSF-2.0 | core: `PriorityQueue::push`, `pop`, `from_array` |
| Python | `heapreplace`, `heappushpop` | pop then push in one sift | O(log n) | PSF-2.0 | heap: `DaryHeap::push_pop`, `DaryHeap::replace` |
| Python | `heappop_max`, `heapreplace_max`, `heappush_max`, `heappushpop_max`, `heapify_max` | max-heap forms | O(log n) | PSF-2.0 | heap: `DaryHeap` with the reversed comparator preset |
| Python | `merge` | merge already sorted runs | O(n log k) | PSF-2.0 | algo: `k_way_merge` |
| Python | `nsmallest`, `nlargest` | k extrema of a run | O(n log k) | PSF-2.0 | algo: `k_smallest`, `k_largest` |

### `bisect`

| Ref | Name | What it does | Cost | Licence | Home |
|:--|:--|:--|:--|:--|:--|
| Python | `bisect_left`, `bisect_right` (`lo`, `hi`, `key`) | insertion point in a sorted run | O(log n) | PSF-2.0 | algo: `bisect_left`, `bisect_right` |
| Python | `insort_left`, `insort_right` | insert keeping order | O(n) | PSF-2.0 | algo: `insort_left_in_place`, `insort_right_in_place` |

### `functools`

| Ref | Name | What it does | Cost | Licence | Home |
|:--|:--|:--|:--|:--|:--|
| Python | `lru_cache(maxsize, typed)`, `cache`, `cache_info`, `cache_clear` | memoise calls with LRU eviction | O(1)* | PSF-2.0 | cache: `LruCache` |
| Python | `cached_property` | memoise one attribute | O(1) | PSF-2.0 | drop: an attribute computed once is a field the caller fills |
| Python | `cmp_to_key` | adapt a three-way comparison to a key | O(1) | PSF-2.0 | drop: `Compare` is the comparison, no adapter needed |
| Python | `partial`, `partialmethod` | bind arguments | O(1) | PSF-2.0 | drop: a closure binds arguments |
| Python | `reduce` | fold a run | O(n) | PSF-2.0 | core: `Iter::fold` |
| Python | `singledispatch`, `singledispatchmethod` | dispatch on the first argument's type | O(1) | PSF-2.0 | drop: pattern matching on an enum does this with a compile-time check |
| Python | `total_ordering` | fill in comparison methods | — | PSF-2.0 | drop: `Compare` already gives the four operators |
| Python | `update_wrapper`, `wraps`, `WRAPPER_ASSIGNMENTS`, `WRAPPER_UPDATES` | copy metadata onto a wrapper | O(1) | PSF-2.0 | drop: no decorator metadata |
| Python | `_lru_cache_wrapper` internals (`__wrapped__`, `__call__`) | the wrapper object | — | PSF-2.0 | cache: `LruCache` |

### `itertools`

| Ref | Name | What it does | Cost | Licence | Home |
|:--|:--|:--|:--|:--|:--|
| Python | `chain`, `chain.from_iterable` | concatenate runs | O(1) create | PSF-2.0 | algo: `chain`, `flatten` |
| Python | `combinations`, `combinations_with_replacement`, `permutations`, `product` | combinatorial enumeration | O(k) per item | PSF-2.0 | algo: `combinations`, `combinations_with_replacement`, `permutations`, `product` |
| Python | `accumulate` (`func`, `initial`) | running fold | O(n) | PSF-2.0 | algo: `scan`, `scan_in_place` |
| Python | `batched` | fixed-size batches | O(n) | PSF-2.0 | algo: `chunks` |
| Python | `compress` | select by a mask | O(n) | PSF-2.0 | algo: `compress` |
| Python | `count`, `cycle`, `repeat` | unbounded producers | O(1) per item | PSF-2.0 | algo: `count`, `cycle`, `repeat` |
| Python | `dropwhile`, `takewhile`, `filterfalse` | conditional cut and filter | O(n) | PSF-2.0 | algo: `skip_while`, `take_while`, `filter_false` |
| Python | `groupby(key, default)` | group equal neighbours | O(n) | PSF-2.0 | algo: `group_by` |
| Python | `islice` | take a slice of an iterator | O(k) | PSF-2.0 | algo: `slice`, `take`, `skip` |
| Python | `pairwise` | adjacent pairs | O(n) | PSF-2.0 | algo: `windows` |
| Python | `starmap` | call with unpacked tuples | O(n) | PSF-2.0 | drop: a closure destructures the tuple |
| Python | `tee` | several iterators over one source | O(n) buffered | PSF-2.0 | algo: `tee` |
| Python | `zip_longest` (`fillvalue`) | zip with padding | O(n) | PSF-2.0 | algo: `zip_longest` |

### `queue`

| Ref | Name | What it does | Cost | Licence | Home |
|:--|:--|:--|:--|:--|:--|
| Python | `Queue` (`put`, `get`, `task_done`, `join`, `qsize`, `maxsize`) | bounded FIFO with blocking (also the blocking forms are `moonbitlang/async`'s queue) | O(1) | PSF-2.0 | core: `Queue` |
| Python | `LifoQueue` | bounded LIFO | O(1) | PSF-2.0 | core: `Array` (`push`/`pop`) |
| Python | `PriorityQueue` | heap-ordered queue | O(log n) | PSF-2.0 | core: `PriorityQueue` |
| Python | `SimpleQueue` | lock-free unbounded FIFO | O(1)* | PSF-2.0 | core: `Queue` |
| Python | `Full`, `ShutDown` | queue errors | — | PSF-2.0 | drop: no blocking queue in this library; the async library owns those errors |

### `graphlib`

| Ref | Name | What it does | Cost | Licence | Home |
|:--|:--|:--|:--|:--|:--|
| Python | `TopologicalSorter` (`add`, `prepare`, `get_ready`, `is_active`, `done`, `static_order`) | Kahn topological order over a DAG | O(V+E) | PSF-2.0 | moongraph |
| Python | `CycleError` | cycle in a topological order | — | PSF-2.0 | moongraph |

### `difflib`

| Ref | Name | What it does | Cost | Licence | Home |
|:--|:--|:--|:--|:--|:--|
| Python | `SequenceMatcher` (`set_seqs`, `set_seq1`, `set_seq2`, `find_longest_match`, `get_matching_blocks`, `get_opcodes`, `get_grouped_opcodes`, `ratio`, `quick_ratio`, `real_quick_ratio`) | longest-matching-block diff | O(n·m) worst | PSF-2.0 | text: `SequenceMatcher` |
| Python | `Differ` (`compare`, `compare_lines`) | line diff with intraline detail | O(n·m) | PSF-2.0 | text: `Differ` |
| Python | `ndiff`, `unified_diff`, `context_diff`, `restore` | diff text formats and their inverse | O(n·m) | PSF-2.0 | text: `ndiff`, `unified_diff`, `context_diff`, `restore` |
| Python | `HtmlDiff` (`make_file`, `make_table`) | diff rendered as HTML | — | PSF-2.0 | drop: rendering is not a data structure; callers build their own from `get_opcodes` |
| Python | `get_close_matches` | nearest strings by ratio | O(n·m) | PSF-2.0 | text: `get_close_matches` |
| Python | `IS_LINE_JUNK`, `IS_CHARACTER_JUNK` | default junk predicates | O(1) | PSF-2.0 | text: `is_line_junk`, `is_character_junk` |

### `dataclasses`, `numbers`, `operator`, `contextlib`

| Ref | Name | What it does | Cost | Licence | Home |
|:--|:--|:--|:--|:--|:--|
| Python | `dataclass` (`field`, `asdict`, `astuple`, `replace`, `make_dataclass`, `InitVar`) | record with generated methods | — | PSF-2.0 | drop: `derive` and structs |
| Python | `numbers.Number`, `Complex`, `Real`, `Rational`, `Integral` | numeric tower | — | PSF-2.0 | drop: a trait would not carry the arithmetic; core's numeric types are concrete |
| Python | `operator.itemgetter`, `attrgetter`, `methodcaller`, `add`, `sub`, `mul`, `truediv`, `lt`, `eq`, `contains`, `countOf`, `indexOf`, `concat`, `length_hint` | functions for operators | O(1) | PSF-2.0 | drop: closures and the operators themselves; the task lists it as covered by function values |
| Python | `contextlib.contextmanager`, `ExitStack`, `suppress`, `nullcontext`, `closing`, `redirect_stdout` | scoped cleanup | — | PSF-2.0 | drop: `defer` |

## Rust standard library

### `alloc::collections` and `alloc::vec`

| Ref | Name | What it does | Cost | Licence | Home |
|:--|:--|:--|:--|:--|:--|
| Rust | `Vec` | growable contiguous array | O(1)* push | MIT OR Apache-2.0 | core: `Array` |
| Rust | `VecDeque` | ring-buffer deque with `make_contiguous` | O(1) both ends | MIT OR Apache-2.0 | core: `Deque` |
| Rust | `LinkedList` (`push_front`, `push_back`, `pop_front`, `pop_back`, `append`, `split_off`, `Cursor`, `CursorMut`) | doubly linked list with cursors | O(1) splice | MIT OR Apache-2.0 | seq: `LinkedList` |
| Rust | `BTreeMap`, `BTreeSet` | ordered map and set over a B-tree | O(log n) | MIT OR Apache-2.0 | core: `SortedMap`, `SortedSet` |
| Rust | `BinaryHeap` (`push`, `pop`, `peek`, `peek_mut`, `into_sorted_vec`, `append`, `drain`, `retain`, `rebuild`, `into_vec`) | binary max-heap (also heap: `IndexHeap` for `peek_mut`) | O(log n) push/pop | MIT OR Apache-2.0 | core: `PriorityQueue` |
| Rust | `HashMap`, `HashSet` | hash table with `RandomState` (also the seed is a constructor parameter here) | O(1)* | MIT OR Apache-2.0 | core: `HashMap`, `HashSet` |
| Rust | `hash_map::Entry`, `btree_map::Entry` (`or_insert`, `or_insert_with`, `or_default`, `and_modify`, `or_insert_with_key`, `key`, `and_replace_entry_with`) | update-in-place entry API (also map: `IndexMap::entry`) | O(1) | MIT OR Apache-2.0 | core: `HashMap::get_or_init` |
| Rust | `BTreeMap::range`, `range_mut`, `first_key_value`, `last_key_value`, `pop_first`, `pop_last`, `append`, `split_off`, `retain`, `extract_if` | ordered map operations (also map: `RangeMap` for range queries) | O(log n), O(k) | MIT OR Apache-2.0 | core: `SortedMap` |
| Rust | `VecDeque::make_contiguous`, `rotate_left`, `rotate_right`, `splice`, `split_off`, `insert`, `remove`, `range`, `binary_search` | deque operations (also seq: `RingBuffer` (linear view)) | O(n), O(log n) | MIT OR Apache-2.0 | core: `Deque` |
| Rust | `Vec::sort_unstable`, `sort_unstable_by`, `sort_unstable_by_key`, `select_nth_unstable`, `partition_dedup`, `dedup`, `retain`, `rotate_left`, `rotate_right`, `swap_remove`, `truncate`, `splice`, `drain`, `split_off`, `resize`, `extend_from_slice`, `fill`, `copy_within`, `binary_search_by` | vector algorithms in place (also algo: `nth_element_in_place`, `dedup_in_place`, `rotate_in_place`) | O(n log n), O(n) | MIT OR Apache-2.0 | core: `Array::sort` |
| Rust | `slice::windows`, `chunks`, `chunks_exact`, `rchunks`, `split`, `splitn`, `split_first`, `split_last`, `split_at`, `starts_with`, `ends_with`, `strip_prefix`, `strip_suffix`, `concat`, `join`, `repeat`, `array_chunks`, `as_chunks`, `first_chunk`, `last_chunk` | views and splitting (also core: `ArrayView`) | O(1) create, O(n) | MIT OR Apache-2.0 | algo: `windows`, `chunks`, `split_at` |
| Rust | `Vec::Drain`, `Vec::Splice`, `Vec::IntoIter`, `vec::IntoIter::as_slice` | removal iterators | O(n) | MIT OR Apache-2.0 | drop: `drain`/`extract_if` return the removed elements directly here |
| Rust | `binary_heap::PeekMut`, `binary_heap::Drain`, `binary_heap::IntoIterSorted` | heap accessors | O(log n), O(n) | MIT OR Apache-2.0 | heap: `IndexHeap::peek_entry`, `IndexHeap::into_sorted_array` |
| Rust | `collections::TryReserveError`, `alloc::AllocError` | allocation failure | — | MIT OR Apache-2.0 | drop: allocation failure is not observable |
| Rust | `hash_map::RandomState`, `DefaultHasher`, `BuildHasher` | hashing state (also hash seed is a constructor parameter here) | — | MIT OR Apache-2.0 | core: `Hasher` |

## Rust crates

### `itertools` 0.15

The trait has about 140 adaptors. They are grouped by family below; each family is
one row, with the method names spelled out.

| Ref | Name | What it does | Cost | Licence | Home |
|:--|:--|:--|:--|:--|:--|
| itertools | `interleave`, `interleave_shortest`, `intersperse`, `intersperse_with` | alternate two runs, insert a separator | O(n) | MIT OR Apache-2.0 | algo: `interleave`, `interleave_shortest`, `intersperse` |
| itertools | `zip_longest`, `zip_eq`, `get` | zip with padding, zip with equality check, n-th element | O(n) | MIT OR Apache-2.0 | algo: `zip_longest`, `zip_eq`, `nth` |
| itertools | `batching`, `chunk_by`, `chunks`, `tuple_windows`, `circular_tuple_windows`, `tuples`, `array_windows`, `circular_array_windows` | fixed and predicate-based grouping | O(n) | MIT OR Apache-2.0 | algo: `chunks`, `chunk_by`, `windows`, `windows_circular` |
| itertools | `tee`, `multipeek`, `peeking_take_while`, `take_while_ref`, `take_while_inclusive`, `while_some`, `put_back_n` | buffered and peeking iteration | O(n) buffered | MIT OR Apache-2.0 | algo: `tee`, `peek_nth`, `take_while`, `take_while_inclusive` |
| itertools | `map_into`, `map_ok`, `filter_ok`, `filter_map_ok`, `flatten_ok`, `process_results`, `fold_ok`, `fold_options`, `try_collect`, `partition_result` | `Result`/`Option` plumbing inside an iterator | O(n) | MIT OR Apache-2.0 | drop: MoonBit's `Iter` carries plain values; error handling is the caller's `Result`, not an adaptor layer |
| itertools | `merge`, `merge_by`, `merge_join_by`, `kmerge`, `kmerge_by` | merge sorted runs | O(n log k) | MIT OR Apache-2.0 | algo: `k_way_merge`, `merge_join_by` |
| itertools | `cartesian_product`, `multi_cartesian_product` | Cartesian products | O(n·m) | MIT OR Apache-2.0 | algo: `product`, `multi_product` |
| itertools | `coalesce`, `dedup`, `dedup_by`, `dedup_with_count`, `dedup_by_with_count`, `duplicates`, `duplicates_by`, `duplicates_with_hasher`, `unique`, `unique_by`, `unique_with_hasher` | collapse or find repeats | O(n), O(n) with a set | MIT OR Apache-2.0 | algo: `dedup_in_place`, `duplicates`, `unique` |
| itertools | `tuple_combinations`, `array_combinations`, `combinations`, `combinations_with_replacement`, `array_combinations_with_replacement`, `permutations`, `powerset` | combinatorial enumeration | O(k) per item | MIT OR Apache-2.0 | algo: `combinations`, `combinations_with_replacement`, `permutations`, `powerset` |
| itertools | `pad_using`, `with_position`, `positions`, `update`, `next_array`, `collect_array`, `next_tuple`, `collect_tuple` | fill, annotate, and collect positions (the tuple collectors are not built: array literals do that) | O(n) | MIT OR Apache-2.0 | algo: `pad_using`, `with_position`, `positions` |
| itertools | `find_position`, `find_or_last`, `find_or_first`, `contains`, `position_max`, `position_max_by`, `position_max_by_key`, `position_min`, `position_min_by`, `position_min_by_key`, `position_minmax`, `position_minmax_by`, `position_minmax_by_key` | position-returning searches | O(n) | MIT OR Apache-2.0 | algo: `find_position`, `position_min`, `position_max`, `position_min_max` |
| itertools | `all_equal`, `all_unique`, `exactly_one`, `at_most_one` | cardinality tests | O(n) | MIT OR Apache-2.0 | algo: `all_equal`, `all_unique`, `exactly_one`, `at_most_one` |
| itertools | `dropping`, `dropping_back`, `tail`, `take`, `skip`, `take_while`, `skip_while`, `step_by`, `chain`, `rev`, `enumerate` | the plain iterator adaptors (also algo: `skip`, `chain`, `rev`, `enumerate`, `step_by`) | O(n) | MIT OR Apache-2.0 | core: `Iter::take`, `Iter::take_while` |
| itertools | `concat`, `collect_vec`, `set_from`, `join`, `format`, `format_with` | collect into a container or a string (also algo: `format_with`) | O(n) | MIT OR Apache-2.0 | core: `Iter::to_array`, `Array::join` |
| itertools | `fold1`, `tree_reduce`, `tree_fold1`, `fold_while`, `sum1`, `product1` | folds without an initial value | O(n) | MIT OR Apache-2.0 | algo: `fold_first`, `fold_while`, `tree_reduce` |
| itertools | `sorted`, `sorted_by`, `sorted_by_key`, `sorted_by_cached_key`, `sorted_unstable`, `sorted_unstable_by`, `sorted_unstable_by_key`, `k_smallest`, `k_smallest_by`, `k_smallest_by_key`, `k_smallest_relaxed`, `k_largest`, `k_largest_by`, `k_largest_by_key`, `k_largest_relaxed` | sort or select into a new run | O(n log n), O(n log k) | MIT OR Apache-2.0 | algo: `sorted`, `k_smallest`, `k_largest` |
| itertools | `partition_map`, `partition_result`, `into_group_map`, `into_group_map_by`, `into_grouping_map`, `into_grouping_map_by` | partition and group into maps (also algo: `partition_map`) | O(n) | MIT OR Apache-2.0 | map: `MultiMap`, `Counter` |
| itertools | `min_set`, `min_set_by`, `min_set_by_key`, `max_set`, `max_set_by`, `max_set_by_key`, `minmax`, `minmax_by_key`, `minmax_by` | all extrema, not just one | O(n) | MIT OR Apache-2.0 | algo: `min_set`, `max_set`, `min_max` |
| itertools | `counts`, `counts_by`, `counts_with_hasher` | count occurrences | O(n) | MIT OR Apache-2.0 | map: `Counter::from_iter` |
| itertools | `multiunzip`, `unzip`, `try_len`, `strip_prefix`, `strip_prefix_by` | unzip and prefix stripping (`multiunzip` and `try_len` are not built: a run's length is known here) | O(n) | MIT OR Apache-2.0 | algo: `strip_prefix` |
| itertools | `equal`, `assert_equal`, `partition` (free functions) | compare and partition two runs | O(n) | MIT OR Apache-2.0 | algo: `equal`, `partition_pair` |

### `indexmap` 2.14

| Ref | Name | What it does | Cost | Licence | Home |
|:--|:--|:--|:--|:--|:--|
| indexmap | `IndexMap` (`get_index`, `get_index_of`, `get_full`, `get_key_value`, `insert_full`, `shift_insert`, `swap_remove`, `shift_remove`, `swap_remove_index`, `shift_remove_index`, `move_index`, `swap_indices`, `sort_keys`, `sort_by`, `sorted_by`, `reverse`, `truncate`, `split_off`, `drain`, `retain`, `splice`, `as_slice`, `into_boxed_slice`) | hash map with insertion order and positional access | O(1)* by key, O(1) by index | MIT OR Apache-2.0 | map: `IndexMap` |
| indexmap | `IndexMap::entry`, `OccupiedEntry`, `VacantEntry`, `IndexedEntry`, `get_range`, `get_disjoint_mut` | entry and range access by position | O(1) | MIT OR Apache-2.0 | map: `IndexMap::entry`, `IndexMap::range` |
| indexmap | `IndexSet` (`insert_full`, `swap_remove`, `shift_remove`, `swap_remove_full`, `get_index`, `get_index_of`, `move_index`, `sort`, `difference`, `intersection`, `union`, `symmetric_difference`, `is_subset`, `is_superset`, `is_disjoint`) | ordered set with positional access | O(1)* | MIT OR Apache-2.0 | map: `IndexSet` |
| indexmap | `IndexMap::sort_by_cached_key`, `sort_unstable_keys`, `partition_point`, `binary_search_keys`, `with_capacity_and_hasher`, `hasher` | sorting and the hasher accessor | O(n log n) | MIT OR Apache-2.0 | map: `IndexMap::sort_by_key`, `partition_point` |

### `rust-phf` 0.14

| Ref | Name | What it does | Cost | Licence | Home |
|:--|:--|:--|:--|:--|:--|
| phf | `phf::Map` (`get`, `get_key`, `get_entry`, `contains_key`, `index`, `entries`, `keys`, `values`, `len`, `is_empty`) | map with a perfect hash built at compile time | O(1) lookup, no collisions | MIT | phf: `PhfMap` |
| phf | `phf::Set`, `phf::OrderedSet`, `phf::OrderedMap` | set and insertion-ordered forms | O(1) | MIT | phf: `PhfSet`, `PhfOrderedSet`, `PhfOrderedMap` |
| phf | `phf::MapEntry` (`Occupied`, `Vacant`), `phf::map::Entry` | entry over a perfect-hash map | O(1) | MIT | phf: `PhfMap::get_entry` |
| phf | `phf_codegen::Map`, `phf_codegen::Set`, `phf_codegen::OrderedMap`, `phf_codegen::OrderedSet` (`entry`, `build`, `build_into`) | generate the table source for a key set | build time | MIT | phf: `PhfBuilder` |
| phf | `phf_generator::generate_hash`, `HashState`, `FIXED_SEED` | the hash search behind `phf_codegen` | build time | MIT | phf: `PhfBuilder` |
| phf | `phf_macros::phf_map!`, `phf_set!`, `phf_ordered_map!`, `phf_ordered_set!` | declare a map with `phf` syntax | build time | MIT | phf: the moonast annotation over `PhfBuilder` |
| phf | `phf_shared::PhfHash`, `PhfBorrow`, `HashKey`, `displace`, `hash` | the traits a key must satisfy | O(1) | MIT | phf: the key constraint (`Hash` plus byte access) |

### `slotmap`, `bit-set`, `ego-tree`, `ropey`

| Ref | Name | What it does | Cost | Licence | Home |
|:--|:--|:--|:--|:--|:--|
| slotmap | `SlotMap` (`insert`, `insert_with_key`, `remove`, `get`, `get_mut`, `contains_key`, `keys`, `values`, `iter`, `retain`, `drain`, `clear`, `capacity`) | slab with generational keys | O(1)* | Zlib | seq: `SlotMap` |
| slotmap | `HopSlotMap`, `DenseSlotMap`, `SecondaryMap`, `SparseSecondaryMap` | variants trading memory for iteration order | O(1)* | Zlib | seq: `SlotMap`, `DenseSlotMap`, `SecondaryMap` |
| slotmap | `KeyData`, `Key`, `Key::data`, `KeyData::as_ffi`, `SlotMap::as_ffi` (`detach`, `reattach`) | the handle and its serialised form | O(1) | Zlib | seq: `SlotKey`, `SlotMap::key_at` |
| bit-set | `BitSet` (`insert`, `remove`, `contains`, `union`, `intersection`, `difference`, `symmetric_difference`, `union_with`, `intersection_with`, `difference_with`, `symmetric_difference_with`, `is_subset`, `is_superset`, `is_disjoint`, `iter`, `len`, `count_ones`, `set_bit`, `clear_bit`, `toggle`, `grow`) | growable set of usize | O(1) per bit, O(n/64) set ops | MIT OR Apache-2.0 | seq: `BitSet` |
| bit-set | `BitVec` (`push`, `pop`, `get`, `set`, `len`, `count_ones`, `iter`) | growable bit vector | O(1)* | MIT OR Apache-2.0 | seq: `BitVec` |
| bit-set | `bit_set::Iter`, `bit_vec::Iter`, `Blocks`, `block` access | block-level iteration | O(n/64) | MIT OR Apache-2.0 | seq: `BitSet::blocks`, `BitVec::blocks` |
| ego-tree | `Tree` (`new`, `with_capacity`, `append`, `insert_after`, `insert_before`, `prepend`, `detach`, `remove`, `node`, `node_mut`, `root`, `get`, `get_mut`, `contains`, `len`, `is_empty`, `sort_by`, `sort_by_key`, `clear`) | arena tree addressed by node id | O(1) link, O(k) subtree ops | MIT OR Apache-2.0 | tree: `ArenaTree` |
| ego-tree | `NodeId`, `Node`, `NodeMut`, `Cursor`, `Edge` (`Parent`, `PreviousSibling`, `NextSibling`, `FirstChild`, `LastChild`) | node handles and navigation | O(1) step | MIT OR Apache-2.0 | tree: `TreeId`, `ArenaTree::node`, `ArenaTree::children` |
| ego-tree | `Ancestors`, `Children`, `Descendants`, `Predecessors`, `Siblings`, `Traverse`, `TraverseMut` | iteration in tree order | O(1)* step, O(n) traversal | MIT OR Apache-2.0 | tree: `ArenaTree::ancestors`, `descendants`, `siblings`, `preorder` |
| ropey | `Rope` (`new`, `from_str`, `len_chars`, `len_bytes`, `len_lines`, `char`, `byte`, `line`, `slice`, `insert`, `insert_char`, `remove`, `append`, `append_char`, `write_to`, `to_string`, `chunk_at_byte`, `chunk_at_char`, `byte_to_char`, `char_to_byte`, `byte_to_line`, `line_to_byte`, `edit`, `split_off`, `clone`) | text rope over chunked strings | O(log n) edit, O(log n + k) slice | MIT | text: `Rope` |
| ropey | `RopeSlice` (`len_chars`, `len_bytes`, `char`, `slice`, `chars`, `bytes`, `lines`, `chunks`, `chunks_at_char`, `as_str`, `to_string`, `line_of_char`, `char_to_line`) | borrowed window into a rope | O(1) create | MIT | text: `RopeView` |
| ropey | `RopeBuilder` (`new`, `append`, `append_char`, `finish`) | incremental rope construction | O(n) | MIT | text: `RopeBuilder` |
| ropey | `Chars`, `Bytes`, `Lines`, `LinesWithEnding`, `Chunks`, `CharIndices`, `CharsAt` | rope iterators | O(1)* step | MIT | text: `Rope::chars`, `bytes`, `lines`, `chunks` |

### Small crates named by the task

| Ref | Name | What it does | Cost | Licence | Home |
|:--|:--|:--|:--|:--|:--|
| pickmap | `static_map!`, `StaticMap` (`get`, `get_in`, `len`, `is_empty`, `iter`), `Iter` | immutable string map generated at compile time | O(1) lookup | MIT OR Apache-2.0 | phf: `PhfMap` with the byte-slice lookup |
| cphf | `Generator`, `MapBuilder`, `SetBuilder`, `Keywords` (`Keyword`, `parse_keyword`, `uncased`), `PrimitiveKey`, `ConstKey` | perfect hashing over a key list known at compile time | build time | MIT | phf: `PhfBuilder` |
| quickphf | `Map`, `Set`, `RawMap`, `RawSet` (`get`, `contains_key`, `get_index`, `get_key_value`, `iter`, `keys`, `values`, `union`, `intersection`, `difference`, `symmetric_difference`, `is_subset`, `is_superset`, `is_disjoint`) | perfect hash built quickly at the cost of size | O(1) lookup | Zlib OR Apache-2.0 OR MIT | phf: `PhfMap` (`build = quick` preset) |
| entropy-map | `Mphf`, `MapWithDict`, `MapWithDictBitpacked`, `L12Rank` (`from_slice`, `get`, `get_values`, `keys`, `values`, `len`) | minimal perfect hash with bit-packed values | O(1) lookup | Apache-2.0 | phf: `PhfMap` (`keys = minimal` preset), `PhfRank` |
| rheaps | `BinaryArrayHeap`, `DaryArrayHeap`, `BinaryArrayAddressableHeap`, `DaryArrayAddressableHeap`, `BinaryArrayWeakHeap`, `BinaryArrayBulkInsertWeakHeap` | array heaps, addressable and bulk | O(log n) push/pop, O(1)* decrease-key | Apache-2.0 | heap: `DaryHeap`, `IndexHeap` |
| rheaps | `PairingHeap`, `CostlessMeldPairingHeap`, `PurePairingHeap`, `FibonacciHeap`, `SimpleFibonacciHeap`, `StrictFibonacciHeap`, `RankPairingHeap` | meldable and addressable tree heaps | O(1)* push, O(1)* decrease-key | Apache-2.0 | heap: `PairingHeap`, `FibonacciHeap` |
| rheaps | `LeftistHeap`, `SkewHeap`, `BinaryTreeSoftHeap`, `BinaryTreeSoftAddressableHeap`, `HollowHeap` | meldable heaps with distinct trade-offs | O(log n)* meld | Apache-2.0 | drop: the pairing and Fibonacci heaps cover melding; soft and hollow heaps buy a constant factor at the cost of correctness for some keys |
| rheaps | `monotone::radix` (`RadixHeap`, `FiniteF64`, `NonFiniteF64`) | monotone radix heap over integer keys | O(1)* push, O(log C) pop | Apache-2.0 | heap: `RadixHeap` |
| rheaps | `Heap`, `AddressableHeap`, `DecreaseKeyHeap`, `MeldableHeap`, `DoubleEndedHeap`, `ValueHeap`, `TryHeap`, `InvalidHandle`, `DecreaseKeyError`, `IncreaseKeyError` | the capability traits and errors | — | Apache-2.0 | heap: `Heap`, `MeldableHeap`, `IndexedHeap` traits, `heap::InvalidHandle` |
| dashmap | `DashMap`, `DashSet`, `Ref`, `RefMut`, `Entry` | sharded concurrent hash map | O(1)* | MIT | drop: no shared-memory threads |
| crossbeam | `crossbeam_deque::{Deque, Worker, Stealer, Injector}`, `crossbeam_queue::{ArrayQueue, SegQueue}`, `crossbeam_channel`, `crossbeam_skiplist::{SkipMap, SkipSet}`, `crossbeam_epoch` | lock-free queues, channels, skip lists | O(1)* | MIT OR Apache-2.0 | drop: no shared-memory threads; the single-threaded skip list is `tree: SkipList`, the queues are `moonbitlang/async`'s |
| rustc-hash | `FxHashMap`, `FxHashSet`, `FxHasher` | fast non-cryptographic hash for small keys | O(1)* | Apache-2.0 OR MIT | drop: the hash function is a seed parameter here, not a container variant |
| bitmap | `BitMap` (`insert`, `remove`, `contains`, `len`, `iter`, `union_with`, `intersection_with`), `BitMap::as_bit_vec` | bit set plus bit vector in one type | O(1) per bit | MIT OR Apache-2.0 | seq: `BitSet`, `BitVec` |

## Graph libraries

Graph depth is `moongraph`'s territory; `moongraph`'s own inventory carries one row per
algorithm. The rows here exist so that the boundary is stated: everything below is
`moongraph`, except the three structures this library keeps, which the graph algorithms
are built on.

| Ref | Name | What it does | Cost | Licence | Home |
|:--|:--|:--|:--|:--|:--|
| NetworkX | `Graph`, `DiGraph`, `MultiGraph`, `MultiDiGraph`, `SubGraph`, `ReverseView`, `to_undirected`, `to_directed` | graph containers and views | O(1) node, O(1) edge | BSD-3-Clause | moongraph |
| NetworkX | `UnionFind`, `nx.utils.UnionFind` (`union`, `find`, `to_sets`, `parents`, `weights`) | disjoint sets | O(α(n)) | BSD-3-Clause | tree: `DisjointSet` |
| NetworkX | `algorithms.traversal` (`bfs_edges`, `bfs_tree`, `bfs_predecessors`, `dfs_edges`, `dfs_tree`, `dfs_predecessors`, `edge_dfs`) | traversal | O(V+E) | BSD-3-Clause | moongraph |
| NetworkX | `algorithms.shortest_paths` (`dijkstra_path`, `bellman_ford_path`, `floyd_warshall`, `astar_path`, `johnson`, `bidirectional_dijkstra`, `all_pairs_dijkstra`, `single_source_shortest_path`) | shortest paths (built on the heaps in `heap`) | O(E log V), O(VE), O(V³) | BSD-3-Clause | moongraph |
| NetworkX | `algorithms.components`, `algorithms.connectivity` (`connected_components`, `strongly_connected_components`, `articulation_points`, `bridges`, `node_connectivity`, `edge_connectivity`, `minimum_node_cut`) | connectivity and cuts | O(V+E), O(V·E) for cuts | BSD-3-Clause | moongraph |
| NetworkX | `algorithms.flow` (`maximum_flow`, `minimum_cut`, `preflow_push`, `shortest_augmenting_path`, `edmonds_karp`, `dinitz`, `gomory_hu_tree`) | flows and cuts | O(V²E) and better | BSD-3-Clause | moongraph |
| NetworkX | `algorithms.matching` (`max_weight_matching`, `maximal_matching`, `min_weight_matching`, `hopcroft_karp_matching`, `eppstein_matching`) | matchings | O(V³) weighted | BSD-3-Clause | moongraph |
| NetworkX | `algorithms.tree.mst` (`minimum_spanning_tree`, `maximum_spanning_tree`, `minimum_spanning_edges`, `random_spanning_tree`) | spanning trees (built on the disjoint sets in `tree`) | O(E log V) | BSD-3-Clause | moongraph |
| NetworkX | `algorithms.centrality` (`betweenness_centrality`, `closeness_centrality`, `degree_centrality`, `eigenvector_centrality`, `pagerank`, `hits`, `katz_centrality`, `load_centrality`, `edge_betweenness_centrality`) | centrality and link analysis | O(V·E), O(V+E) per iteration | BSD-3-Clause | moongraph |
| NetworkX | `algorithms.community` (`louvain_communities`, `greedy_modularity_communities`, `label_propagation_communities`, `asyn_lpa_communities`, `modularity`, `partition_quality`) | community detection | O(V+E) per pass | BSD-3-Clause | moongraph |
| NetworkX | `algorithms.clique`, `algorithms.chordal`, `algorithms.isomorphism` (`find_cliques`, `graph_clique_number`, `is_chordal`, `is_isomorphic`, `could_be_isomorphic`, `vf2pp_is_isomorphic`) | cliques and isomorphism | exponential worst case | BSD-3-Clause | moongraph |
| NetworkX | `algorithms.coloring` (`greedy_color`, `equitable_color`), `algorithms.dominating` (`dominating_set`, `is_dominating_set`), `algorithms.covering` (`min_weighted_vertex_cover`, `min_edge_cover`) | colouring and covering | O(V+E), O(V·E) | BSD-3-Clause | moongraph |
| NetworkX | `algorithms.cycles` (`simple_cycles`, `cycle_basis`, `find_cycle`, `minimum_cycle_basis`), `algorithms.dag` (`topological_sort`, `topological_generations`, `is_directed_acyclic_graph`, `transitive_closure`, `dag_longest_path`), `algorithms.simple_paths` (`all_simple_paths`, `shortest_simple_paths`) | cycles, DAGs, simple paths | O(V+E), exponential enumeration | BSD-3-Clause | moongraph (`graphlib`'s `TopologicalSorter` is its shape) |
| NetworkX | `algorithms.operators` (`union`, `compose`, `complement`, `disjoint_union`, `intersection`, `difference`, `cartesian_product`, `tensor_product`, `power`, `condensed`) | graph algebra | O(V+E) | BSD-3-Clause | moongraph |
| NetworkX | `algorithms.bipartite` (`maximum_bipartite_matching`, `hopcroft_karp_matching`, `minimum_weight_full_matching`, `bipartite_sets`), `algorithms.link_prediction` (`jaccard_coefficient`, `adamic_adar_index`, `preferential_attachment`), `algorithms.similarity` (`graph_edit_distance`, `simrank_similarity`) | bipartite matching and similarity | O(V·E) | BSD-3-Clause | moongraph |
| NetworkX | `generators.classic`, `generators.random_graphs`, `generators.lattice`, `generators.small`, `generators.trees`, `generators.social`, `generators.community`, `generators.degree_seq`, `generators.ego`, `generators.intersection`, `generators.mycielski`, `generators.atlas` | graph generators | O(V+E) | BSD-3-Clause | moongraph |
| NetworkX | `readwrite` (`adjlist`, `edgelist`, `gexf`, `gml`, `graph6`, `graphml`, `pajek`, `sparse6`, `dot`, `leda`, `matrix_market`, `json_graph`) | graph file formats | O(V+E) | BSD-3-Clause | moongraph |
| igraph | `igraph_t`, `igraph_vector_t`, vertex and edge selectors, attributes; algorithms: `igraph_shortest_paths`, `igraph_community_*`, `igraph_layout_*`, `igraph_centrality_*`, `igraph_mincut`, `igraph_maxflow`, `igraph_isomorphism` | the C graph library | as NetworkX | GPL-2.0-or-later | moongraph (interface only) |
| graph-tool | `Graph`, `GraphView`, `Vertex`, `Edge`, `PropertyMap`; algorithms: `shortest_distance`, `betweenness`, `pagerank`, `min_st_cut`, `subgraph_isomorphism`, `community detection` (SBM, modularity), `layout` | the C++ graph library with Python bindings | as NetworkX | GPL-3.0-or-later | moongraph (interface only) |
| scikit-network | `Graph`, `Bipartite`, `DiGraph`; `ranking`, `path`, `centrality`, `clustering`, `classification`, `link_prediction`, `embedding`, `partition`, `connectivity`, `traversal` | sparse-matrix graph algorithms | as NetworkX | BSD-3-Clause | moongraph |
| EasyGraph | `Graph`, `DiGraph`, `multigraph`; `eg.connectivity`, `eg.centrality`, `eg.community`, `eg.path`, `eg.traversal`, `eg.isomorphism`, `eg.functional` | graph library with a NetworkX-like surface | as NetworkX | Apache-2.0 | moongraph |
| JGraphT | `Graph`, `DirectedGraph`, `WeightedGraph`, `GraphPath`, `Graphs`; algorithms: `DijkstraShortestPath`, `BellmanFordShortestPath`, `FloydWarshallShortestPaths`, `KShortestPaths`, `MaxFlow`, `MinCut`, `Matching`, `SpanningTree`, `Coloring`, `Clustering`, `Isomorphism`, `Planarity` | the Java graph library | as NetworkX | LGPL-2.1-or-later | moongraph (interface only) |
| petgraph | `Graph`, `StableGraph`, `GraphMap`, `Csr`, `MatrixGraph`; `algo::{dijkstra, bellman_ford, astar, tarjan_scc, kosaraju_scc, min_spanning_tree, isomorphism, floyd_warshall, k_shortest_path, maximal_cliques}`, `visit::{Bfs, Dfs, Topo, DfsPostOrder}`, `dot` | the Rust graph library | as NetworkX | MIT OR Apache-2.0 | moongraph |
| Boost.Graph | `adjacency_list`, `adjacency_matrix`, `compressed_sparse_row_graph`, `property_map`, `graph_traits`, `visitors`; `breadth_first_search`, `depth_first_search`, `dijkstra_shortest_paths`, `bellman_ford_shortest_paths`, `floyd_warshall_shortest_paths`, `kruskal_minimum_spanning_tree`, `prim_minimum_spanning_tree`, `boykov_kolmogorov_max_flow`, `edmonds_karp_max_flow`, `strong_components`, `connected_components`, `topological_sort`, `isomorphism`, `vertex_coloring`, `maximum_matching` | the C++ graph library | as NetworkX | BSL-1.0 | moongraph |

## Structures the task brief names that no reference ships

A few rows below have no reference implementation in the set above. They are named by
the task brief or are needed by a package the brief defines, so they are recorded with
the source the design follows: a paper, a documentation page, or an implementation
that was read from its published documentation rather than its source.

| Ref | Name | What it does | Cost | Licence | Home |
|:--|:--|:--|:--|:--|:--|
| Boost.Bloom 1.92 | `boost::bloom::filter<T, K, Subfilter, Stride>`, `block`, `multiblock`, `fast_multiblock32`, `fast_multiblock64`, `capacity_for`, `fpr_for`, `may_contain`, `insert`, `reset`, `operator&=`, `operator\|=`, `array` | Bloom filters with block and multiblock variants | O(K) per op, O(m/64) set ops | BSL-1.0 | sketch: `BloomFilter` |
| Guava 33 | `BloomFilter.create(Funnel, expectedInsertions, fpp)`, `mightContain`, `put`, `expectedFpp`, `isCompatible` | Bloom filter whose default false-positive rate is 3% | O(K) per op | Apache-2.0 | sketch: `BloomFilter` (the 1% default comes from Redis, see below) |
| Redis 8 | `BF.RESERVE key error_rate capacity`, `BF.ADD`, `BF.EXISTS`, `BF.MADD`, `BF.INFO`, `BF.SCANDUMP`, `BF.LOADCHUNK` | Bloom filter with a 1% default error rate and expandable capacity | O(K) per op | RSALv2/SSPLv1 (interface only) | sketch: `BloomFilter` (default false-positive rate 1%) |
| cuckoofilter 1.0 | `CuckooFilter`, `insert`, `contains`, `delete`, `lookup`, `size`, `load_factor` | Bloom filter that supports deletion | O(1) amortised | MIT | sketch: `CuckooFilter` |
| DataSketches 5.x | `update_theta_sketch`, `compact_theta_sketch`, `theta_union`, `theta_intersection`, `theta_a_not_b` | distinct counting with set algebra | O(1) per item, O(k) estimate | Apache-2.0 | sketch: `ThetaSketch` |
| DataSketches 5.x | `hll_sketch`, `hll_union`, `cpc_sketch`, `cpc_union` | cardinality estimation | O(1) per item | Apache-2.0 | sketch: `HyperLogLog` |
| DataSketches 5.x | `frequent_items_sketch`, `frequent_strings_sketch`, `row_sketch`, `frequency_merge` | heavy hitters over a stream, Count-Min style | O(1) per item | Apache-2.0 | sketch: `CountMinSketch`, `FrequentItems` |
| DataSketches 5.x | `kll_sketch`, `req_sketch`, `quantiles_sketch`, `kll_merge`, `req_merge` | quantile estimation (t-digest keeps tighter tails; see the dedup notes) | O(1)* per item, O(1) query | Apache-2.0 | sketch: `TDigest` (t-digest keeps tighter tails |
| t-digest (tdunning) 5.x | `TDigest`, `MergingDigest`, `AVLTreeDigest`, `add`, `merge`, `quantile`, `cdf`, `compress` | quantile sketch with accurate tails | O(1)* per item, O(1) query | Apache-2.0 | sketch: `TDigest` |
| go-zero 1.9 | `collection.Cache` (`Add`, `AddWithExpire`, `Get`, `Take`, `TakeWithExpire`, `Del`, `SetExpire`, `size`), `collection.LRU` | cache with LFU eviction by access count and per-entry expiry | O(1)* | MIT | cache: `LfuCache`, `ExpiringCache` |
| ARC (Megiddo & Modha 2003), PostgreSQL 17 `shared_buffer` | `cache` with adaptive recency and frequency lists | adaptive replacement cache balancing recency and frequency | O(1)* | paper / PostgreSQL licence (interface only) | cache: `ArcCache` |
| Segment tree (Bentley 1977), binary indexed tree (Fenwick 1994) | range queries and prefix sums over an array | range query and prefix-sum structures | O(log n) update and query | paper | tree: `SegmentTree`, `Fenwick` |
| Sparse set (Briggs & Torczon 1993) | `SparseSet` | dense array plus sparse index for O(1) membership and dense iteration | O(1) | paper | seq: `SparseSet` |
| Gap buffer (Emacs and the editors that followed) | `GapBuffer` | a movable gap in a contiguous buffer, cheap insertion at a point | O(1)* insert at the gap, O(n) move | paper / public-domain lineage | seq: `GapBuffer` |
| ART (Leis, Kemper & Neumann 2013), trie (Bentley & Sedgewick 1997) | `RadixTree`, `Trie` | radix tree and prefix trie | O(k) per key of length k | paper | map: `Trie`, `RadixTree` |
| Boost.ICL 1.92 | `interval_map`, `interval_set`, `split_interval_map`, `interval_base_map`, `interval_base_set`, `discrete_interval`, `continuous_interval` | maps keyed by intervals, with overlap queries | O(log n) | BSL-1.0 | map: `RangeMap`, `RangeSet` |
| Interval tree (CLRS; also Boost.Intrusive and CGAL) | `IntervalTree` | interval tree with overlap queries | O(log n + k) | — | tree: `IntervalTree` |

## What the union adds up to

395 rows, one per capability. Where each capability lands:

| Home | Rows |
|:--|--:|
| MoonBit core already has it | 80 |
| `algo` | 69 |
| `seq` | 24 |
| `map` | 23 |
| `heap` | 14 |
| `phf` | 11 |
| `sketch` | 8 |
| `text` | 11 |
| `cache` | 7 |
| `tree` | 8 |
| `moongraph` | 25 |
| `moonmath` | 22 |
| Not built, with the reason in the row | 93 |

Rows per reference, counting a row once under the library it was read from:

| Reference | Rows |
|:--|--:|
| C++ standard library | 71 |
| Boost (8 submodules) | 69 |
| Rust crates (`itertools`, `indexmap`, `phf`, `slotmap`, `bit-set`, `ego-tree`, `ropey`, the small ones) | 58 |
| Python | 56 |
| Graph libraries | 24 |
| Folly | 18 |
| CGAL | 16 |
| ETL | 15 |
| Rust standard library | 15 |
| EASTL | 14 |
| Abseil | 10 |
| Structures with no reference implementation | 16 |
| GTL | 8 |
| STXXL | 5 |

The nine packages carry 175 rows, so the average package is about 19 rows of
reference material behind it.

## Where the libraries disagree, and which way this library goes

**Hash tables.** Six references ship one and all of them differ in the details:
`std::unordered_map` (node-based, chained), Abseil's flat table, Folly's F14
(SIMD probe), GTL's phmap, EASTL's `hash_map`, ETL's fixed-capacity table. MoonBit
core already has `HashMap` as an open-addressing table with `Hash + Eq`, and `Map`
as the same table with insertion order. Adding a sixth would be a tuning surface,
not a capability. The only hash shape core does not have is *positional* access —
get the k-th entry, move an entry to position k, remove by swapping — which is
`indexmap`'s whole point. That is `map: IndexMap` / `IndexSet`, and the rest of the
hash tables in the list are `drop` with that reason written out. The same argument
retires the node/flat/dense variants, the concurrent ones (no shared-memory
threads) and `FxHashMap` (a hash function, not a container — it becomes the
`hash_seed` parameter).

**Ordered maps.** The references split three ways: red-black trees (`std::map`),
B-trees (Abseil, GTL, Rust's `BTreeMap`), and sorted contiguous arrays (`flat_map`,
`sorted_vector_map`, `vector_map`, ETL's `flat_map`). Core's `SortedMap` is a
B-tree, which settles the first two. The third is a genuinely different trade —
O(log n) lookup with a fraction of the pointer chasing, at O(n) insert — and
several libraries keep it precisely because it wins for small or read-mostly maps.
So `map: FlatMap` / `FlatSet` exist, with the same method names as `SortedMap`.

**Repeated keys.** `std::multimap` is ordered, `boost::unordered_multimap` is hashed,
Python's idiom is `defaultdict(list)`, and Boost.MultiIndex solves it generally by
letting one element set carry several indexes. The general solution needs a type
parameterised over a list of index types, which MoonBit cannot express, so
MultiIndex is `drop`. What remains is the two orderings, so the package carries
`MultiMap` (hashed, values in insertion order) and `SortedMultiMap` (ordered by key
then by value), with `MultiSet`/`SortedMultiSet` as aliases over `Unit` values rather
than separate implementations.

**Heaps.** Boost.Heap offers six and `rheaps` offers twenty-odd. They are not
variations on a theme: a d-ary heap is faster per push, a pairing heap melds in
O(1) and supports decrease-key without the Fibonacci heap's bookkeeping, a min-max
heap gives both ends, and a radix heap beats all of them on monotone integer keys
(Dijkstra). The six the brief names are kept because each wins a different case;
the leftist, skew, rank-pairing, soft, weak and hollow heaps are dropped because
they either match the pairing heap's asymptotics (leftist, skew, rank-pairing) or
trade correctness guarantees for constants (soft, hollow) that this library does
not want to explain. `IndexHeap` is the addressable form, since decrease-key is
what callers actually ask for.

**Deques and ring buffers.** `std::deque`, `boost::circular_buffer`,
`folly::FixedCapacityRingQueue`, Rust's `VecDeque` and `boost::container::devector`
overlap. The split kept here: core's `Deque` for the unbounded case, `seq: RingBuffer`
for the fixed-capacity case where the oldest element is overwritten. The ring
buffer's `overflow` option covers `static_vector` (refuse) directly;
`circular_buffer_space_optimized` differs only in allocating its storage lazily, which
is how `RingBuffer` behaves already, so it needs no second type. `devector` and `segtor`
are dropped: their selling point is stable element addresses, which the runtime
gives for free.

**Caches.** Three references, three policies: Folly evicts the least recently used,
GTL's `lru_cache` and Python's `lru_cache` do the same with a different API, and
go-zero adds an LFU mode plus per-entry expiry. ARC is not in any of them but is
the one policy that adapts between recency and frequency, and the brief names it.
So the package has `LruCache` (the default), `LfuCache` (go-zero's policy),
`ArcCache` (Megiddo–Modha) and `ExpiringCache` (a TTL layer that composes with any
of them rather than a fourth policy). A capacity is required on `LruCache`: there is
no safe default, and every reference that ships one requires it too.

**Sketches.** For cardinality the references disagree between HyperLogLog and
Theta, and the disagreement is real: Theta supports union and intersection with
bounded error, HLL only union, but HLL is smaller for the same accuracy. Both are
kept. For quantiles, KLL/REQ and t-digest disagree about which end of the
distribution deserves accuracy: KLL minimises rank error everywhere, t-digest keeps
the tails sharp, which is what latency monitoring wants. `TDigest` is kept and KLL
is dropped as a second quantile sketch. For heavy hitters, Count-Min is the
algorithm and DataSketches' frequent-items sketch is the same idea with a merge
step, so one `CountMinSketch` covers it. For membership, Bloom is kept with the
1% default false-positive rate (Redis's default; Guava's is 3%) and `CuckooFilter`
is kept separately because deletion is the capability Bloom cannot offer.

**Text search.** KMP, Boyer–Moore and Aho–Corasick all appear in Boost and in the
literature, and they are not substitutes: KMP guarantees O(n+m) with no preprocessing
surprise, Boyer–Moore is the fastest for one pattern in practice, Aho–Corasick is the
only one that searches many patterns at once. All three are in `text`.

**Diffing.** CPython's `difflib` is the reference, down to its quirks. The one worth
a decision is `autojunk`: by default `SequenceMatcher` treats elements that occur in
more than 1% of a sequence of 200 or more as junk, which makes diffs of repetitive
files surprisingly cheap and surprisingly empty. The default is kept, as an
`autojunk` option that can be turned off, because matching the reference is worth
more than a cleaner rule.

**Perfect hashing.** Four crates, four strategies: `phf` searches for a hash at build
time and stores the displacement table, `quickphf` builds fast but stores more,
`cphf` does the search at compile time in a const context, and `pickmap` specialises
in string keys. They differ in when the work happens (build script, compile time,
runtime) and in size, not in lookup cost. MoonBit has neither build scripts nor
const evaluation of arbitrary code, so `phf: PhfBuilder` generates the table when the
build runs, and the annotation over it produces the `let` that the program links
against — which is `cphf`'s and `phf`'s model, with `quickphf`'s build-now option
available as a preset.

**Handles.** `slotmap` uses an index plus a generation counter, `slab`/`Slab` uses
an index plus a free list and no generation, and `ego-tree` uses a node id that is
never reused. The brief fixes the handle as index plus generation, so `seq: SlotMap`
does that and gets the "old handle returns `None`" guarantee; the plain slab is
`seq: Slab` without the generation, for callers who do not need the check.

**Errors and knobs.** Every reference that validates its input reports differently:
C++ throws `std::invalid_argument`, Rust returns a `Result` error type per crate,
Python raises `ValueError`. The project's convention is one error type, `Refused`,
and that is what the interface table uses for a zero capacity, a probability
outside (0, 1) or a capacity that cannot hold the given elements. Out-of-range
index reads return `Option` instead, and only `op_get` aborts, because core aborts
there.

## Settled at review

1. **`seq: LinkedList` stays.** Core's `List` is a persistent singly linked list, so
   splice and split are O(n) there; a doubly linked list with O(1) splice is a
   capability, not a duplicate. It is one more type in `seq`, and the two rows that
   need it (`std::list`, Rust's `LinkedList`) now point at something real.
2. **`MultiSet` and `SortedMultiSet` stay aliases.** `MultiSet[K]` is
   `MultiMap[K, Unit]` and `SortedMultiSet[K]` is `SortedMultiMap[K, Unit]`, both
   re-exported from the root package. Four types would be four sets of doc comments
   over two implementations.
3. **The default hash seed is drawn from the organisation's entropy path**, not a
   constant: `@moonseed.bytes(32, @moonseed.system.source)` through
   `@moonrand.seeded`, one 32-bit draw. Per-process variation is the point — it is
   what stops a caller's key set from being laid out to collide. Reproducibility
   moves to the call: generated vectors and cross-checked fixtures pass
   `hash_seed=0` explicitly. `tree` uses the same seed for skip list levels and
   treap priorities; `phf` keeps a fixed seed because its generated table is
   checked in and compared byte for byte.
4. **`phf` is in the first implementation round**, with a moonast generator over
   `PhfBuilder`. If the generator turns out not to be available, the runtime
   `PhfBuilder::build` path is still specified, so the package ships either way.
5. **`Rope`, `RopeView` and `RopeBuilder` move to `text`.** The brief put the rope in
   `seq`; it moves because it is the one type there that is not parameterised over an
   element — `String` chunks, `Char` indices, line arithmetic — and because `text`
   holds the matchers that want to read one. With the rope in `text`, a matcher can
   take a `RopeView` without `text` depending on `seq`; with it in `seq` that edge
   would appear the first time anyone searched a document in place. `GapBuffer[T]`
   stays in `seq`: it is generic, and being useful to an editor is not the same as
   being about text. The counts move with it — `seq` 28 → 24, `text` 7 → 11 — and the
   root package re-exports the three types from `text`.
