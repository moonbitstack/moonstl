///|
/// A Fibonacci heap: roots and children sit in circular doubly linked lists,
/// so an insert only splices one node in, a meld only joins two lists, and a
/// `decrease_key` only cuts one subtree loose — each of them constant amortised
/// time. The price is paid on `pop`, which consolidates the roots by degree.
///
/// ```mbt check
/// test {
///   let heap : @heap.FibonacciHeap[Int32] = @heap.FibonacciHeap::new()
///   let a = heap.insert(5)
///   let _ = heap.insert(2)
///   let _ = heap.insert(8)
///   assert_true(heap.peek() == Some(2))
///   assert_true(heap.decrease_key(a, 1))
///   assert_true(heap.pop() == Some(1))
/// }
/// ```
pub struct FibonacciHeap[T] {
  cmp : (T, T) -> Int32
  values : Array[T?]
  parents : Array[Int32]
  /// One child of each node; the rest are its siblings in a circular list.
  child : Array[Int32]
  left : Array[Int32]
  right : Array[Int32]
  degree : Array[Int32]
  marked : Array[Bool]
  generations : Array[UInt32]
  free : Array[Int32]
  mut min : Int32
  mut len : Int32
}

///|
/// An empty heap popping from the `order` end, `Min` by default.
pub fn[T : Compare] FibonacciHeap::new(
  order~ : Order = Min,
) -> FibonacciHeap[T] {
  FibonacciHeap::new_by(cmp=order_comparator(order))
}

///|
/// An empty heap ordered by `cmp`, which reports the smaller of two elements as negative.
pub fn[T] FibonacciHeap::new_by(cmp~ : (T, T) -> Int32) -> FibonacciHeap[T] {
  {
    cmp,
    values: [],
    parents: [],
    child: [],
    left: [],
    right: [],
    degree: [],
    marked: [],
    generations: [],
    free: [],
    min: -1,
    len: 0,
  }
}

///|
fn[T] FibonacciHeap::value(self : FibonacciHeap[T], node : Int32) -> T {
  match self.values[node] {
    Some(value) => value
    None => abort("moonstl: a Fibonacci heap node that holds nothing")
  }
}

///|
fn[T] FibonacciHeap::alloc(self : FibonacciHeap[T], value : T) -> Int32 {
  let node = match self.free.pop() {
    Some(node) => {
      self.values[node] = Some(value)
      node
    }
    None => {
      self.values.push(Some(value))
      self.parents.push(-1)
      self.child.push(-1)
      self.left.push(-1)
      self.right.push(-1)
      self.degree.push(0)
      self.marked.push(false)
      self.generations.push(0U)
      self.values.length() - 1
    }
  }
  self.parents[node] = -1
  self.child[node] = -1
  self.left[node] = node
  self.right[node] = node
  self.degree[node] = 0
  self.marked[node] = false
  node
}

///|
fn[T] FibonacciHeap::release(self : FibonacciHeap[T], node : Int32) -> Unit {
  self.values[node] = None
  self.parents[node] = -1
  self.child[node] = -1
  self.left[node] = -1
  self.right[node] = -1
  self.degree[node] = 0
  self.marked[node] = false
  self.generations[node] = self.generations[node] + 1U
  self.free.push(node)
}

///|
/// Splices `node` into the circular list that holds `anchor`, right after it.
fn[T] FibonacciHeap::splice_after(
  self : FibonacciHeap[T],
  node : Int32,
  anchor : Int32,
) -> Unit {
  let next = self.right[anchor]
  self.right[node] = next
  self.left[node] = anchor
  self.right[anchor] = node
  self.left[next] = node
}

///|
fn[T] FibonacciHeap::unlink(self : FibonacciHeap[T], node : Int32) -> Unit {
  let left = self.left[node]
  let right = self.right[node]
  self.left[right] = left
  self.right[left] = right
  self.left[node] = node
  self.right[node] = node
}

///|
fn[T] FibonacciHeap::precedes(
  self : FibonacciHeap[T],
  a : Int32,
  b : Int32,
) -> Bool {
  (self.cmp)(self.value(a), self.value(b)) < 0
}

///|
/// Adds `value` and returns the handle that keeps naming it, whatever else the heap does.
pub fn[T] FibonacciHeap::insert(
  self : FibonacciHeap[T],
  value : T,
) -> HeapKey[T] {
  let node = self.alloc(value)
  if self.min < 0 {
    self.min = node
  } else {
    self.splice_after(node, self.min)
    if self.precedes(node, self.min) {
      self.min = node
    }
  }
  self.len = self.len + 1
  { index: node, generation: self.generations[node], }
}

///|
/// The element the order puts first, or `None` when the heap is empty.
pub fn[T] FibonacciHeap::peek(self : FibonacciHeap[T]) -> T? {
  if self.min < 0 {
    None
  } else {
    self.values[self.min]
  }
}

///|
/// Moves a node and its siblings from its parent's child list to the root list.
fn[T] FibonacciHeap::promote_children(
  self : FibonacciHeap[T],
  node : Int32,
) -> Unit {
  let first = self.child[node]
  if first < 0 {
    return
  }
  let children : Array[Int32] = []
  let mut current = first
  while true {
    children.push(current)
    current = self.right[current]
    if current == first {
      break
    }
  }
  for child in children {
    self.unlink(child)
    self.parents[child] = -1
    self.marked[child] = false
    self.splice_after(child, self.min)
  }
  self.child[node] = -1
  self.degree[node] = 0
}

///|
/// Removes and returns the element the order puts first, or `None` when the heap is empty.
pub fn[T] FibonacciHeap::pop(self : FibonacciHeap[T]) -> T? {
  if self.min < 0 {
    return None
  }
  let node = self.min
  let value = self.values[node]
  self.promote_children(node)
  if self.right[node] == node {
    self.min = -1
  } else {
    self.min = self.right[node]
    self.unlink(node)
    self.consolidate()
  }
  self.release(node)
  self.len = self.len - 1
  value
}

///|
/// Joins roots of equal degree until each degree appears once, then points
/// `min` at the smallest root. This is what keeps the tree shallow.
fn[T] FibonacciHeap::consolidate(self : FibonacciHeap[T]) -> Unit {
  let roots : Array[Int32] = []
  let start = self.min
  let mut current = start
  while true {
    roots.push(current)
    current = self.right[current]
    if current == start {
      break
    }
  }
  let by_degree : Array[Int32] = []
  for root in roots {
    let mut carried = root
    let mut degree = self.degree[carried]
    while degree < by_degree.length() && by_degree[degree] >= 0 {
      let held = by_degree[degree]
      by_degree[degree] = -1
      let take_carried = self.precedes(carried, held)
      let small = if take_carried { carried } else { held }
      let big = if take_carried { held } else { carried }
      self.unlink(big)
      self.parents[big] = small
      if self.child[small] < 0 {
        self.child[small] = big
        self.left[big] = big
        self.right[big] = big
      } else {
        self.splice_after(big, self.child[small])
      }
      self.degree[small] = self.degree[small] + 1
      self.marked[big] = false
      carried = small
      degree = self.degree[carried]
    }
    while by_degree.length() <= degree {
      by_degree.push(-1)
    }
    by_degree[degree] = carried
  }
  let mut best = -1
  for candidate in by_degree {
    if candidate >= 0 {
      if best < 0 || self.precedes(candidate, best) {
        best = candidate
      }
    }
  }
  if best >= 0 {
    self.min = best
  }
}

///|
/// Cuts `node` out of `parent`'s child list and puts it in the root list.
fn[T] FibonacciHeap::cut(
  self : FibonacciHeap[T],
  node : Int32,
  parent : Int32,
) -> Unit {
  if self.child[parent] == node {
    if self.right[node] == node {
      self.child[parent] = -1
    } else {
      self.child[parent] = self.right[node]
    }
  }
  self.unlink(node)
  self.degree[parent] = self.degree[parent] - 1
  self.parents[node] = -1
  self.marked[node] = false
  self.splice_after(node, self.min)
}

///|
/// Cuts a second child loose from the same parent, and keeps walking up while
/// the parent is marked.
fn[T] FibonacciHeap::cascading_cut(
  self : FibonacciHeap[T],
  node : Int32,
) -> Unit {
  let mut at = node
  while true {
    let parent = self.parents[at]
    if parent < 0 {
      return
    }
    if !self.marked[at] {
      self.marked[at] = true
      return
    }
    self.cut(at, parent)
    at = parent
  }
}

///|
fn[T] FibonacciHeap::locate(
  self : FibonacciHeap[T],
  key : HeapKey[T],
) -> Int32? {
  if key.index < 0 || key.index >= self.values.length() {
    return None
  }
  if self.generations[key.index] != key.generation ||
    self.values[key.index] is None {
    return None
  }
  Some(key.index)
}

///|
/// The value behind `key`, or `None` when the handle no longer names an entry.
pub fn[T] FibonacciHeap::get(self : FibonacciHeap[T], key : HeapKey[T]) -> T? {
  match self.locate(key) {
    Some(node) => self.values[node]
    None => None
  }
}

///|
/// Whether `key` still names an entry.
pub fn[T] FibonacciHeap::contains(
  self : FibonacciHeap[T],
  key : HeapKey[T],
) -> Bool {
  self.locate(key) is Some(_)
}

///|
/// Lowers the key of an entry that is already in the heap: a node that drops
/// below its parent is cut loose, which costs nothing to undo later because the
/// pop consolidates anyway. Refuses a value that is not a decrease.
pub fn[T] FibonacciHeap::decrease_key(
  self : FibonacciHeap[T],
  key : HeapKey[T],
  value : T,
) -> Bool {
  match self.locate(key) {
    Some(node) => {
      if (self.cmp)(value, self.value(node)) >= 0 {
        return false
      }
      self.values[node] = Some(value)
      let parent = self.parents[node]
      if parent >= 0 && self.precedes(node, parent) {
        self.cut(node, parent)
        self.cascading_cut(parent)
      }
      if self.min >= 0 && self.precedes(node, self.min) {
        self.min = node
      }
      true
    }
    None => false
  }
}

///|
/// Replaces the value whatever its direction: a node whose value no longer fits
/// under its parent is cut loose and the ancestors are repaired as a
/// `decrease_key` would repair them.
pub fn[T] FibonacciHeap::update(
  self : FibonacciHeap[T],
  key : HeapKey[T],
  value : T,
) -> Bool {
  match self.locate(key) {
    Some(node) => {
      self.values[node] = Some(value)
      let parent = self.parents[node]
      if parent >= 0 && self.precedes(node, parent) {
        self.cut(node, parent)
        self.cascading_cut(parent)
      }
      if self.min >= 0 && self.precedes(node, self.min) {
        self.min = node
      }
      true
    }
    None => false
  }
}

///|
/// Removes the entry `key` names and returns its value, leaving the rest of the heap ordered.
pub fn[T] FibonacciHeap::remove_at(
  self : FibonacciHeap[T],
  key : HeapKey[T],
) -> T? {
  match self.locate(key) {
    Some(node) => {
      let value = self.values[node]
      let parent = self.parents[node]
      if parent >= 0 {
        self.cut(node, parent)
        self.cascading_cut(parent)
      }
      self.promote_children(node)
      if self.min == node {
        if self.right[node] == node {
          self.min = -1
        } else {
          self.min = self.right[node]
        }
      }
      self.unlink(node)
      self.release(node)
      self.len = self.len - 1
      if self.min >= 0 && self.len > 0 {
        self.consolidate()
      }
      value
    }
    None => None
  }
}

///|
/// How many entries the heap holds.
pub fn[T] FibonacciHeap::length(self : FibonacciHeap[T]) -> Int32 {
  self.len
}

///|
/// Whether the heap holds no entry.
pub fn[T] FibonacciHeap::is_empty(self : FibonacciHeap[T]) -> Bool {
  self.len == 0
}

///|
/// Removes every entry; the handles issued before it name nothing afterwards.
pub fn[T] FibonacciHeap::clear(self : FibonacciHeap[T]) -> Unit {
  self.values.clear()
  self.parents.clear()
  self.child.clear()
  self.left.clear()
  self.right.clear()
  self.degree.clear()
  self.marked.clear()
  self.generations.clear()
  self.free.clear()
  self.min = -1
  self.len = 0
}

///|
/// The values in slot order, which is not the order they pop in.
pub fn[T] FibonacciHeap::to_array(self : FibonacciHeap[T]) -> Array[T] {
  let out : Array[T] = []
  for value in self.values {
    if value is Some(value) {
      out.push(value)
    }
  }
  out
}

///|
/// Empties the heap and returns its values in pop order.
pub fn[T] FibonacciHeap::into_sorted_array(self : FibonacciHeap[T]) -> Array[T] {
  let out : Array[T] = []
  while self.len > 0 {
    match self.pop() {
      Some(value) => out.push(value)
      None => break
    }
  }
  out
}

///|
/// Takes every entry of `other` into this heap and empties `other`; the handles issued by the other heap do not carry over.
pub fn[T] FibonacciHeap::merge(
  self : FibonacciHeap[T],
  other : FibonacciHeap[T],
) -> Unit {
  // Every node lives in the array of the heap that allocated it, so joining two
  // root lists would leave one heap pointing into the other's storage. The
  // entries are therefore reinserted, which costs O(n log n) rather than the
  // constant time a heap with a shared node pool would spend.
  for value in other.to_array() {
    let _ = self.insert(value)
  }
  other.clear()
}
