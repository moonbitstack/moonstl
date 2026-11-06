///|
/// A d-ary heap: a heap laid out in a contiguous array where every node has up
/// to `arity` children.
///
/// A binary heap does one comparison per level; a 4-ary heap does three but
/// halves the number of levels, and the children of one node sit next to each
/// other in memory, so a wider heap usually wins on modern caches. `arity: 4` is
/// Boost.Heap's default for `d_ary_heap`.
///
/// The heap is a multiset: it does not remove duplicates, and its iteration
/// order is the internal array order, which is only partially ordered. Use
/// `into_sorted_array` when the order matters.
///
/// ```mbt check
/// test {
///   let heap : @heap.DaryHeap[Int32] = try! @heap.DaryHeap::new()
///   heap.push(3)
///   heap.push(1)
///   heap.push(2)
///   assert_true(heap.peek() == Some(1))
///   assert_true(heap.pop() == Some(1))
///   assert_true(heap.length() == 2)
/// }
/// ```
#derive(Debug)
pub struct DaryHeap[T] {
  arity : Int32
  cmp : (T, T) -> Int32
  items : Array[T]
}

///|

///|
/// Builds a min or max heap ordered by `T : Compare`.
///
/// `arity` is the number of children a node has and has to be at least 2;
/// anything smaller is refused because it does not describe a tree.
pub fn[T : Compare] DaryHeap::new(
  arity~ : Int32 = 4,
  order~ : Order = Min,
) -> DaryHeap[T] raise @spec.Refused {
  DaryHeap::new_by(cmp=order_comparator(order), arity~)
}

///|
/// Builds a min heap ordered by `cmp`, which has to return a negative number
/// when its first argument has to be popped first.
///
/// Use this for an ordering `Compare` cannot express — a case-insensitive key, a
/// field of a record, a reversed priority — rather than wrapping the element.
pub fn[T] DaryHeap::new_by(
  cmp~ : (T, T) -> Int32,
  arity~ : Int32 = 4,
) -> DaryHeap[T] raise @spec.Refused {
  if arity < 2 {
    raise @spec.Refused::Arity(got=arity)
  }
  { arity, cmp, items: [], }
}

///|
/// An empty 4-ary min heap, the settings `new` defaults to.
pub impl[T : Compare] Default for DaryHeap[T] with fn default() {
  { arity: 4, cmp: order_comparator(Min), items: [], }
}

///|
pub extend DaryHeap with Default::{default}

///|
/// Builds a heap from `items` in O(n), by sifting down from the last parent
/// rather than pushing one at a time.
///
/// ```mbt check
/// test {
///   let heap : @heap.DaryHeap[Int32] = try! @heap.DaryHeap::from_array([
///     5, 1, 4, 1, 3,
///   ])
///   assert_true(heap.into_sorted_array() == [1, 1, 3, 4, 5])
/// }
/// ```
pub fn[T : Compare] DaryHeap::from_array(
  items : ArrayView[T],
  arity~ : Int32 = 4,
  order~ : Order = Min,
) -> DaryHeap[T] raise @spec.Refused {
  DaryHeap::from_array_by(items, cmp=order_comparator(order), arity~)
}

///|
/// Builds a heap ordered by `cmp` from `items` in O(n).
pub fn[T] DaryHeap::from_array_by(
  items : ArrayView[T],
  cmp~ : (T, T) -> Int32,
  arity~ : Int32 = 4,
) -> DaryHeap[T] raise @spec.Refused {
  let heap = DaryHeap::new_by(cmp~, arity~)
  heap.items.push_iter(items.iter())
  dary_heapify(heap.items, arity, cmp)
  heap
}

///|
/// Builds a heap from an iterator in O(n log n).
pub fn[T : Compare] DaryHeap::from_iter(
  iter : Iter[T],
  arity~ : Int32 = 4,
  order~ : Order = Min,
) -> DaryHeap[T] raise @spec.Refused {
  DaryHeap::from_iter_by(iter, cmp=order_comparator(order), arity~)
}

///|
/// Builds a heap ordered by `cmp` from an iterator.
pub fn[T] DaryHeap::from_iter_by(
  iter : Iter[T],
  cmp~ : (T, T) -> Int32,
  arity~ : Int32 = 4,
) -> DaryHeap[T] raise @spec.Refused {
  let heap = DaryHeap::new_by(cmp~, arity~)
  heap.items.push_iter(iter)
  dary_heapify(heap.items, arity, cmp)
  heap
}

///|
/// The number of elements the heap holds.
pub fn[T] DaryHeap::length(self : DaryHeap[T]) -> Int32 {
  self.items.length()
}

///|
/// Whether the heap holds no elements.
pub fn[T] DaryHeap::is_empty(self : DaryHeap[T]) -> Bool {
  self.items.is_empty()
}

///|
/// Adds one element in O(log_d n).
///
/// ```mbt check
/// test {
///   let heap : @heap.DaryHeap[Int32] = try! @heap.DaryHeap::new()
///   heap.push(2)
///   heap.push(1)
///   assert_true(heap.peek() == Some(1))
/// }
/// ```
pub fn[T] DaryHeap::push(self : DaryHeap[T], value : T) -> Unit {
  self.items.push(value)
  dary_sift_up(self.items, self.items.length() - 1, self.arity, self.cmp)
}

///|
/// The element a pop would return, without removing it, in O(1).
pub fn[T] DaryHeap::peek(self : DaryHeap[T]) -> T? {
  if self.items.is_empty() {
    None
  } else {
    Some(self.items[0])
  }
}

///|
/// Removes and returns the first element in O(log_d n), or `None` when the heap
/// is empty.
pub fn[T] DaryHeap::pop(self : DaryHeap[T]) -> T? {
  let last = self.items.length() - 1
  if last < 0 {
    return None
  }
  self.items.swap(0, last)
  let value = self.items.pop()
  if last > 0 {
    dary_sift_down(self.items, 0, self.arity, self.cmp)
  }
  value
}

///|
/// Removes the first element and puts `value` in its place in one sift down,
/// which is cheaper than `pop` followed by `push`. Returns the element removed.
///
/// On an empty heap this is a plain `push` that returns `None`.
pub fn[T] DaryHeap::replace(self : DaryHeap[T], value : T) -> T? {
  if self.items.is_empty() {
    self.items.push(value)
    return None
  }
  let removed = self.items[0]
  self.items[0] = value
  dary_sift_down(self.items, 0, self.arity, self.cmp)
  Some(removed)
}

///|
/// Pushes `value` and pops the first element in one sift, which is Python's
/// `heappushpop`: the result is `value` itself when it would be popped straight
/// away, so a bound on a stream costs no tree update.
///
/// On an empty heap this is a `push` that returns `None`.
pub fn[T] DaryHeap::push_pop(self : DaryHeap[T], value : T) -> T? {
  if self.items.is_empty() {
    self.items.push(value)
    return None
  }
  if (self.cmp)(value, self.items[0]) <= 0 {
    return Some(value)
  }
  let removed = self.items[0]
  self.items[0] = value
  dary_sift_down(self.items, 0, self.arity, self.cmp)
  Some(removed)
}

///|
/// Removes every element.
pub fn[T] DaryHeap::clear(self : DaryHeap[T]) -> Unit {
  self.items.clear()
}

///|
/// A copy that shares no storage with the original; the comparator is shared
/// because it is a pure function of two elements.
pub fn[T] DaryHeap::copy(self : DaryHeap[T]) -> DaryHeap[T] {
  { arity: self.arity, cmp: self.cmp, items: self.items.copy(), }
}

///|
/// The elements in the heap's internal array order, which is only partially
/// ordered.
pub fn[T] DaryHeap::iter(self : DaryHeap[T]) -> Iter[T] {
  self.items.iter()
}

///|
/// The elements in the heap's internal array order. Use `into_sorted_array` for
/// the order the heap pops in.
pub fn[T] DaryHeap::to_array(self : DaryHeap[T]) -> Array[T] {
  self.items.copy()
}

///|
/// Drains the heap into an array in pop order, leaving it empty.
///
/// ```mbt check
/// test {
///   let heap : @heap.DaryHeap[Int32] = try! @heap.DaryHeap::from_array([3, 1, 2])
///   assert_true(heap.into_sorted_array() == [1, 2, 3])
///   assert_true(heap.is_empty())
/// }
/// ```
pub fn[T] DaryHeap::into_sorted_array(self : DaryHeap[T]) -> Array[T] {
  let sorted = []
  let mut next = self.pop()
  while next is Some(value) {
    sorted.push(value)
    next = self.pop()
  }
  sorted
}

///|
/// Two heaps are equal when they hold the same elements with the same
/// multiplicities; the branching factor is not part of the value.
pub impl[T : Eq] Eq for DaryHeap[T] with fn equal(self, other) {
  same_multiset(self.items, other.items, self.cmp)
}

///|
pub extend DaryHeap with Eq::{equal, not_equal}

///|
/// Hashed as a multiset, so it agrees with `Eq` whatever order the two heaps
/// happen to store the elements in.
pub impl[T : Hash] Hash for DaryHeap[T] with fn hash_combine(self, hasher) {
  hasher.combine(self.items.length())
  hasher.combine(multiset_hash(self.items))
}

///|
pub extend DaryHeap with Hash::{hash, hash_combine}

///|
pub impl[T : Show] Show for DaryHeap[T] with fn output(self, logger) {
  logger.write_string("DaryHeap(")
  logger.write_iter(self.items.iter())
  logger.write_string(")")
}

///|
pub extend DaryHeap with Show::{to_string, output}

///|
pub extend DaryHeap with @moonbitlang/core/debug.Debug::{to_repr}

///|

///|
/// Restores the heap property upward from `start`.
fn[T] dary_sift_up(
  items : Array[T],
  start : Int32,
  arity : Int32,
  cmp : (T, T) -> Int32,
) -> Unit {
  let mut child = start
  while child > 0 {
    let parent = (child - 1) / arity
    if cmp(items[child], items[parent]) >= 0 {
      break
    }
    items.swap(child, parent)
    child = parent
  }
}

///|
/// Restores the heap property downward from `start`.
fn[T] dary_sift_down(
  items : Array[T],
  start : Int32,
  arity : Int32,
  cmp : (T, T) -> Int32,
) -> Unit {
  let n = items.length()
  let mut node = start
  while true {
    let first = node * arity + 1
    if first >= n {
      break
    }
    let last = if first + arity - 1 < n { first + arity - 1 } else { n - 1 }
    let mut best = first
    for i in (first + 1)..<=last {
      if cmp(items[i], items[best]) < 0 {
        best = i
      }
    }
    if cmp(items[best], items[node]) >= 0 {
      break
    }
    items.swap(node, best)
    node = best
  }
}

///|
/// Turns an arbitrary array into a heap in O(n) by sifting down from the last
/// parent, which is the bottom-up build every array heap uses.
fn[T] dary_heapify(
  items : Array[T],
  arity : Int32,
  cmp : (T, T) -> Int32,
) -> Unit {
  if items.is_empty() {
    return
  }
  let mut node = (items.length() - 2) / arity
  while node >= 0 {
    dary_sift_down(items, node, arity, cmp)
    node = node - 1
  }
}
