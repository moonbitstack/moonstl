///|
/// A binary heap whose entries are addressed by `HeapKey`: an `update` or a
/// `remove_at` reaches one element without searching, because every slot knows
/// its position in the heap array and every position knows its slot.
///
/// ```mbt check
/// test {
///   let heap : @heap.IndexHeap[Int32] = @heap.IndexHeap::new()
///   let a = heap.insert(5)
///   let b = heap.insert(1)
///   assert_true(heap.update(a, 0))
///   assert_true(heap.peek() == Some(0))
///   assert_true(heap.remove_at(b) == Some(1))
///   assert_true(heap.length() == 1)
/// }
/// ```
pub struct IndexHeap[T] {
  cmp : (T, T) -> Int32
  values : Array[T?]
  generations : Array[UInt32]
  /// Slot to heap position, `-1` when the slot is empty.
  positions : Array[Int32]
  /// Heap position to slot.
  heap : Array[Int32]
  free : Array[Int32]
  mut len : Int32
}

///|
/// An empty heap popping from the `order` end, `Min` by default, with a position for every key it holds.
pub fn[T : Compare] IndexHeap::new(order~ : Order = Min) -> IndexHeap[T] {
  IndexHeap::new_by(cmp=order_comparator(order))
}

///|
/// An empty heap ordered by `cmp`, which reports the smaller of two elements as negative.
pub fn[T] IndexHeap::new_by(cmp~ : (T, T) -> Int32) -> IndexHeap[T] {
  {
    cmp,
    values: [],
    generations: [],
    positions: [],
    heap: [],
    free: [],
    len: 0,
  }
}

///|
fn[T] IndexHeap::swap_positions(
  self : IndexHeap[T],
  a : Int32,
  b : Int32,
) -> Unit {
  let slot_a = self.heap[a]
  let slot_b = self.heap[b]
  self.heap[a] = slot_b
  self.heap[b] = slot_a
  self.positions[slot_a] = b
  self.positions[slot_b] = a
}

///|
fn[T] IndexHeap::better(self : IndexHeap[T], a : Int32, b : Int32) -> Bool {
  let left = self.values[self.heap[a]].unwrap()
  let right = self.values[self.heap[b]].unwrap()
  (self.cmp)(left, right) < 0
}

///|
fn[T] IndexHeap::sift_up(self : IndexHeap[T], start : Int32) -> Unit {
  let mut at = start
  while at > 0 {
    let parent = (at - 1) / 2
    if self.better(at, parent) {
      self.swap_positions(at, parent)
      at = parent
    } else {
      break
    }
  }
}

///|
fn[T] IndexHeap::sift_down(self : IndexHeap[T], start : Int32) -> Unit {
  let mut at = start
  let size = self.heap.length()
  while true {
    let left = 2 * at + 1
    if left >= size {
      break
    }
    let right = left + 1
    let mut best = left
    if right < size && self.better(right, left) {
      best = right
    }
    if self.better(best, at) {
      self.swap_positions(at, best)
      at = best
    } else {
      break
    }
  }
}

///|
/// Stores `value` and returns the handle that addresses it.
pub fn[T] IndexHeap::insert(self : IndexHeap[T], value : T) -> HeapKey[T] {
  let slot = match self.free.pop() {
    Some(slot) => {
      self.values[slot] = Some(value)
      slot
    }
    None => {
      self.values.push(Some(value))
      self.generations.push(0U)
      self.positions.push(-1)
      self.values.length() - 1
    }
  }
  self.positions[slot] = self.heap.length()
  self.heap.push(slot)
  self.len = self.len + 1
  self.sift_up(self.heap.length() - 1)
  { index: slot, generation: self.generations[slot], }
}

///|
fn[T] IndexHeap::position_of(self : IndexHeap[T], key : HeapKey[T]) -> Int32? {
  if key.index < 0 || key.index >= self.values.length() {
    return None
  }
  if self.generations[key.index] != key.generation {
    return None
  }
  if self.values[key.index] is None {
    return None
  }
  Some(self.positions[key.index])
}

///|
/// The value behind `key`, or `None` when the handle no longer names an entry.
pub fn[T] IndexHeap::get(self : IndexHeap[T], key : HeapKey[T]) -> T? {
  match self.position_of(key) {
    Some(_) => self.values[key.index]
    None => None
  }
}

///|
/// Whether `key` still names an entry.
pub fn[T] IndexHeap::contains(self : IndexHeap[T], key : HeapKey[T]) -> Bool {
  self.position_of(key) is Some(_)
}

///|
/// Replaces the element and restores the order around it, which is what makes
/// this heap addressable: the entry may move up or down.
pub fn[T] IndexHeap::update(
  self : IndexHeap[T],
  key : HeapKey[T],
  value : T,
) -> Bool {
  match self.position_of(key) {
    Some(at) => {
      self.values[key.index] = Some(value)
      self.sift_up(at)
      self.sift_down(self.positions[key.index])
      true
    }
    None => false
  }
}

///|
/// The element the order puts first, or `None` when the heap is empty.
pub fn[T] IndexHeap::peek(self : IndexHeap[T]) -> T? {
  if self.heap.length() == 0 {
    None
  } else {
    self.values[self.heap[0]]
  }
}

///|
/// Removes and returns the element the order puts first, or `None` when the heap is empty.
pub fn[T] IndexHeap::pop(self : IndexHeap[T]) -> T? {
  if self.heap.length() == 0 {
    return None
  }
  let slot = self.heap[0]
  let value = self.values[slot]
  self.detach_at(0)
  value
}

///|
/// Removes the element at heap position `at`, keeping the array dense.
fn[T] IndexHeap::detach_at(self : IndexHeap[T], at : Int32) -> Unit {
  let slot = self.heap[at]
  let last = self.heap.length() - 1
  if at != last {
    self.swap_positions(at, last)
  }
  let _ = self.heap.pop()
  self.positions[slot] = -1
  self.values[slot] = None
  self.generations[slot] = self.generations[slot] + 1U
  self.free.push(slot)
  self.len = self.len - 1
  if at < self.heap.length() {
    self.sift_up(at)
    self.sift_down(self.positions[self.heap[at]])
  }
}

///|
/// Removes the entry `key` names and returns its value, leaving the rest of the heap ordered.
pub fn[T] IndexHeap::remove_at(self : IndexHeap[T], key : HeapKey[T]) -> T? {
  match self.position_of(key) {
    Some(at) => {
      let value = self.values[key.index]
      self.detach_at(at)
      value
    }
    None => None
  }
}

///|
/// How many entries the heap holds.
pub fn[T] IndexHeap::length(self : IndexHeap[T]) -> Int32 {
  self.len
}

///|
/// Whether the heap holds no entry.
pub fn[T] IndexHeap::is_empty(self : IndexHeap[T]) -> Bool {
  self.len == 0
}

///|
/// Removes every entry; the handles issued before it name nothing afterwards.
pub fn[T] IndexHeap::clear(self : IndexHeap[T]) -> Unit {
  self.values.clear()
  self.generations.clear()
  self.positions.clear()
  self.heap.clear()
  self.free.clear()
  self.len = 0
}

///|
/// The entries in heap order, which is not the order they pop in.
pub fn[T] IndexHeap::to_array(self : IndexHeap[T]) -> Array[T] {
  let out : Array[T] = []
  for value in self.values {
    if value is Some(value) {
      out.push(value)
    }
  }
  out
}

///|
/// The elements in pop order, emptying the heap.
pub fn[T] IndexHeap::into_sorted_array(self : IndexHeap[T]) -> Array[T] {
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
/// A copy whose entries and handles stand on their own: a handle issued by either heap names the same value in it.
pub fn[T] IndexHeap::copy(self : IndexHeap[T]) -> IndexHeap[T] {
  {
    cmp: self.cmp,
    values: self.values.copy(),
    generations: self.generations.copy(),
    positions: self.positions.copy(),
    heap: self.heap.copy(),
    free: self.free.copy(),
    len: self.len,
  }
}
