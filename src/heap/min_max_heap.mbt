///|
/// The level of a position in a heap laid out as an array, counting from zero at
/// the root. Even levels are min levels, odd levels are max levels.
fn heap_level(index : Int32) -> Int32 {
  let mut level = 0
  let mut size = 1
  while size <= index + 1 {
    size = size * 2
    level = level + 1
  }
  level - 1
}

///|
/// A double-ended priority queue: both the smallest and the largest element are
/// one comparison away, and both can be popped in logarithmic time. The array
/// alternates min levels and max levels, so the smallest is at the root and the
/// largest is one of its two children.
///
/// ```mbt check
/// test {
///   let heap : @heap.MinMaxHeap[Int32] = @heap.MinMaxHeap::new()
///   for value in [5, 1, 9, 3, 7] {
///     heap.push(value)
///   }
///   assert_true(heap.peek_min() == Some(1))
///   assert_true(heap.peek_max() == Some(9))
///   assert_true(heap.pop_min() == Some(1))
///   assert_true(heap.pop_max() == Some(9))
/// }
/// ```
pub struct MinMaxHeap[T] {
  cmp : (T, T) -> Int32
  items : Array[T]
}

///|
/// An empty heap that answers from both ends of the order.
pub fn[T : Compare] MinMaxHeap::new() -> MinMaxHeap[T] {
  { cmp: order_comparator(Min), items: [], }
}

///|
/// An empty heap ordered by `cmp`, which reports the smaller of two elements as negative.
pub fn[T] MinMaxHeap::new_by(cmp~ : (T, T) -> Int32) -> MinMaxHeap[T] {
  { cmp, items: [], }
}

///|
fn[T] MinMaxHeap::before(self : MinMaxHeap[T], a : Int32, b : Int32) -> Bool {
  (self.cmp)(self.items[a], self.items[b]) < 0
}

///|
fn[T] MinMaxHeap::swap_at(self : MinMaxHeap[T], a : Int32, b : Int32) -> Unit {
  self.items.swap(a, b)
}

///|
fn is_min_level(index : Int32) -> Bool {
  heap_level(index) % 2 == 0
}

///|
/// Walks a position down through a min level: the smallest of its children and
/// grandchildren takes its place, and a grandchild that is still larger than its
/// own parent is swapped up once more.
fn[T] MinMaxHeap::sift_down_min(self : MinMaxHeap[T], start : Int32) -> Unit {
  let size = self.items.length()
  let mut at = start
  while true {
    let mut best = at
    let mut best_is_grandchild = false
    for child in [2 * at + 1, 2 * at + 2] {
      if child < size && self.before(child, best) {
        best = child
      }
    }
    if best != at {
      best_is_grandchild = false
    }
    for grandchild in [4 * at + 3, 4 * at + 4, 4 * at + 5, 4 * at + 6] {
      if grandchild < size && self.before(grandchild, best) {
        best = grandchild
        best_is_grandchild = true
      }
    }
    if best == at {
      return
    }
    self.swap_at(at, best)
    if best_is_grandchild {
      let parent = (best - 1) / 2
      if self.before(parent, best) {
        self.swap_at(best, parent)
      }
    }
    at = best
  }
}

///|
fn[T] MinMaxHeap::sift_down_max(self : MinMaxHeap[T], start : Int32) -> Unit {
  let size = self.items.length()
  let mut at = start
  while true {
    let mut best = at
    let mut best_is_grandchild = false
    for child in [2 * at + 1, 2 * at + 2] {
      if child < size && self.before(best, child) {
        best = child
      }
    }
    if best != at {
      best_is_grandchild = false
    }
    for grandchild in [4 * at + 3, 4 * at + 4, 4 * at + 5, 4 * at + 6] {
      if grandchild < size && self.before(best, grandchild) {
        best = grandchild
        best_is_grandchild = true
      }
    }
    if best == at {
      return
    }
    self.swap_at(at, best)
    if best_is_grandchild {
      let parent = (best - 1) / 2
      if self.before(best, parent) {
        self.swap_at(best, parent)
      }
    }
    at = best
  }
}

///|
fn[T] MinMaxHeap::trickle_up_min(self : MinMaxHeap[T], start : Int32) -> Unit {
  let mut at = start
  while at >= 3 {
    let grandparent = (at - 3) / 4
    if self.before(at, grandparent) {
      self.swap_at(at, grandparent)
      at = grandparent
    } else {
      break
    }
  }
}

///|
fn[T] MinMaxHeap::trickle_up_max(self : MinMaxHeap[T], start : Int32) -> Unit {
  let mut at = start
  while at >= 3 {
    let grandparent = (at - 3) / 4
    if self.before(grandparent, at) {
      self.swap_at(at, grandparent)
      at = grandparent
    } else {
      break
    }
  }
}

///|
fn[T] MinMaxHeap::bubble_up(self : MinMaxHeap[T], start : Int32) -> Unit {
  let at = start
  if at == 0 {
    return
  }
  let parent = (at - 1) / 2
  if is_min_level(at) {
    if self.before(parent, at) {
      self.swap_at(at, parent)
      self.trickle_up_max(parent)
    } else {
      self.trickle_up_min(at)
    }
  } else if self.before(at, parent) {
    self.swap_at(at, parent)
    self.trickle_up_min(parent)
  } else {
    self.trickle_up_max(at)
  }
}

///|
/// Adds `value` to the heap.
pub fn[T] MinMaxHeap::push(self : MinMaxHeap[T], value : T) -> Unit {
  self.items.push(value)
  self.bubble_up(self.items.length() - 1)
}

///|
/// The smallest element, or `None` when the heap is empty.
pub fn[T] MinMaxHeap::peek_min(self : MinMaxHeap[T]) -> T? {
  self.items.get(0)
}

///|
/// The largest element, or `None` when the heap is empty.
pub fn[T] MinMaxHeap::peek_max(self : MinMaxHeap[T]) -> T? {
  let size = self.items.length()
  if size == 0 {
    return None
  }
  if size == 1 {
    return self.items.get(0)
  }
  if size == 2 {
    return self.items.get(1)
  }
  if self.before(1, 2) {
    self.items.get(2)
  } else {
    self.items.get(1)
  }
}

///|
/// Removes and returns the smallest element, or `None` when the heap is empty.
pub fn[T] MinMaxHeap::pop_min(self : MinMaxHeap[T]) -> T? {
  let size = self.items.length()
  if size == 0 {
    return None
  }
  let first = self.items[0]
  let last = self.items.pop().unwrap()
  if size > 1 {
    self.items[0] = last
    self.sift_down_min(0)
  }
  Some(first)
}

///|
/// Removes and returns the largest element, or `None` when the heap is empty.
pub fn[T] MinMaxHeap::pop_max(self : MinMaxHeap[T]) -> T? {
  let size = self.items.length()
  if size == 0 {
    return None
  }
  if size == 1 {
    return self.items.pop()
  }
  let at = if size == 2 || self.before(2, 1) { 1 } else { 2 }
  let largest = self.items[at]
  let last = self.items.pop().unwrap()
  if at < self.items.length() {
    self.items[at] = last
    self.sift_down_max(at)
  }
  Some(largest)
}

///|
/// How many entries the heap holds.
pub fn[T] MinMaxHeap::length(self : MinMaxHeap[T]) -> Int32 {
  self.items.length()
}

///|
/// Whether the heap holds no entry.
pub fn[T] MinMaxHeap::is_empty(self : MinMaxHeap[T]) -> Bool {
  self.items.length() == 0
}

///|
/// Removes every entry.
pub fn[T] MinMaxHeap::clear(self : MinMaxHeap[T]) -> Unit {
  self.items.clear()
}

///|
/// The elements in heap order, which is neither ascending nor descending.
pub fn[T] MinMaxHeap::to_array(self : MinMaxHeap[T]) -> Array[T] {
  self.items.copy()
}

///|
/// A copy that owns its array: a change to either heap is invisible to the other.
pub fn[T] MinMaxHeap::copy(self : MinMaxHeap[T]) -> MinMaxHeap[T] {
  { cmp: self.cmp, items: self.items.copy(), }
}
