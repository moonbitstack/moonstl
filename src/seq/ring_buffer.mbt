///|
/// What a full `RingBuffer` does with the element it cannot keep. `Overwrite`
/// drops the element at the opposite end, which is how a fixed-size buffer of
/// recent samples is usually written; `Refuse` leaves the buffer untouched and
/// hands the new element back, so a caller that must not lose data sees the
/// refusal in the return value instead of an exception.
#derive(Eq, Debug)
pub(all) enum Overflow {
  Overwrite
  Refuse
}

///|
pub extend Overflow with Eq::{equal, not_equal}

///|
pub extend Overflow with Debug::{to_repr}

///|

///|

///|
pub impl Show for Overflow with fn output(self, logger) {
  match self {
    Overwrite => logger.write_string("overwrite")
    Refuse => logger.write_string("refuse")
  }
}

///|
pub extend Overflow with Show::{output, to_string}

///|
/// A fixed-ceiling ring of elements. The storage is a plain array with the
/// live elements starting at `head` and wrapping around, so every operation
/// that touches an end is constant time whatever the length.
///
/// `capacity` is a ceiling, not a reservation: the array starts empty and is
/// doubled — up to the ceiling — as the buffer fills, and empty slots beyond
/// `len` hold copies of an element already in the buffer. Those stale copies
/// are outside every view the buffer hands out.
pub struct RingBuffer[T] {
  mut slots : Array[T]
  mut head : Int32
  mut len : Int32
  mut capacity : Int32
  overflow : Overflow
}

///|
/// An empty buffer with a ceiling of `capacity` elements. A ceiling of zero or
/// less is refused because a buffer that can hold nothing could never accept a
/// push.
///
/// ```mbt check
/// test {
///   let buffer : @seq.RingBuffer[Int32] = @seq.RingBuffer::new(capacity=2)
///   @test.assert_eq(buffer.capacity(), 2)
///   assert_true(buffer.is_empty())
/// }
/// ```
pub fn[T] RingBuffer::new(
  capacity~ : Int32,
  overflow~ : Overflow = Overwrite,
) -> RingBuffer[T] raise @spec.Refused {
  require_capacity(capacity)
  { slots: [], head: 0, len: 0, capacity, overflow, }
}

///|
/// A buffer holding `values` in order. When the run is longer than `capacity`,
/// the policy decides which end survives: `Overwrite` keeps the last
/// `capacity` elements, as pushing them one by one would, and `Refuse` keeps
/// the first.
pub fn[T] RingBuffer::from_array(
  capacity~ : Int32,
  values : ArrayView[T],
  overflow~ : Overflow = Overwrite,
) -> RingBuffer[T] raise @spec.Refused {
  let buffer = RingBuffer::new(capacity~, overflow~)
  for value in values {
    ignore(buffer.push_back(value))
  }
  buffer
}

///|
/// The lazy form of `from_array`; the same overflow rule picks which end of a
/// run longer than the ceiling survives.
pub fn[T] RingBuffer::from_iter(
  capacity~ : Int32,
  values : Iter[T],
  overflow~ : Overflow = Overwrite,
) -> RingBuffer[T] raise @spec.Refused {
  let buffer = RingBuffer::new(capacity~, overflow~)
  for value in values {
    ignore(buffer.push_back(value))
  }
  buffer
}

///|
fn[T] RingBuffer::grow(self : RingBuffer[T], filler : T) -> Unit {
  let old = self.slots.length()
  let target = grown_size(old, self.len + 1, self.capacity)
  let next : Array[T] = []
  if old == 0 {
    next.push(filler)
  } else {
    for i in 0..<self.len {
      next.push(self.slots[(self.head + i) % old])
    }
    let fill = next[0]
    while next.length() < target {
      next.push(fill)
    }
  }
  self.slots = next
  self.head = 0
}

///|
/// Appends at the back. Returns the element dropped from the front when the
/// buffer was full and the policy is `Overwrite`; returns the pushed element —
/// and changes nothing — when the policy is `Refuse` and there is no room; and
/// returns `None` when the element simply fitted.
pub fn[T] RingBuffer::push_back(self : RingBuffer[T], value : T) -> T? {
  if self.len == self.capacity {
    match self.overflow {
      Overwrite => {
        let dropped = self.slots[self.head]
        let slots_len = self.slots.length()
        self.head = (self.head + 1) % slots_len
        self.len = self.len - 1
        self.slots[(self.head + self.len) % slots_len] = value
        self.len = self.len + 1
        Some(dropped)
      }
      Refuse => Some(value)
    }
  } else {
    if self.len == self.slots.length() {
      self.grow(value)
    }
    let slots_len = self.slots.length()
    self.slots[(self.head + self.len) % slots_len] = value
    self.len = self.len + 1
    None
  }
}

///|
/// Prepends at the front, with the mirror-image overflow rule: a full
/// `Overwrite` buffer drops from the back, and a full `Refuse` buffer returns
/// the element it was asked to hold.
pub fn[T] RingBuffer::push_front(self : RingBuffer[T], value : T) -> T? {
  if self.len == self.capacity {
    match self.overflow {
      Overwrite => {
        let slots_len = self.slots.length()
        let dropped = self.slots[(self.head + self.len - 1) % slots_len]
        self.len = self.len - 1
        self.head = (self.head - 1 + slots_len) % slots_len
        self.slots[self.head] = value
        self.len = self.len + 1
        Some(dropped)
      }
      Refuse => Some(value)
    }
  } else {
    if self.len == self.slots.length() {
      self.grow(value)
    }
    let slots_len = self.slots.length()
    self.head = (self.head - 1 + slots_len) % slots_len
    self.slots[self.head] = value
    self.len = self.len + 1
    None
  }
}

///|
/// Removes and returns the oldest element, or `None` when the buffer is empty.
pub fn[T] RingBuffer::pop_front(self : RingBuffer[T]) -> T? {
  if self.len == 0 {
    None
  } else {
    let value = self.slots[self.head]
    self.head = (self.head + 1) % self.slots.length()
    self.len = self.len - 1
    Some(value)
  }
}

///|
/// Removes and returns the newest element, or `None` when the buffer is empty.
pub fn[T] RingBuffer::pop_back(self : RingBuffer[T]) -> T? {
  if self.len == 0 {
    None
  } else {
    let at = (self.head + self.len - 1) % self.slots.length()
    let value = self.slots[at]
    self.len = self.len - 1
    Some(value)
  }
}

///|
/// The oldest element without removing it.
pub fn[T] RingBuffer::front(self : RingBuffer[T]) -> T? {
  self.get(0)
}

///|
/// The newest element without removing it.
pub fn[T] RingBuffer::back(self : RingBuffer[T]) -> T? {
  self.get(self.len - 1)
}

///|
/// The element `index` positions from the front, counting from zero, or `None`
/// when there is no such element.
pub fn[T] RingBuffer::get(self : RingBuffer[T], index : Int32) -> T? {
  if index < 0 || index >= self.len {
    None
  } else {
    Some(self.slots[(self.head + index) % self.slots.length()])
  }
}

///|
/// The element `index` positions from the front. Aborts when out of range, as
/// an array index does.
pub fn[T] RingBuffer::at(self : RingBuffer[T], index : Int32) -> T {
  match self.get(index) {
    Some(value) => value
    None => abort("RingBuffer::at: index \{index} is outside 0..\{self.len}")
  }
}

///|
/// Replaces the element at `index`; aborts when out of range.
pub fn[T] RingBuffer::set(
  self : RingBuffer[T],
  index : Int32,
  value : T,
) -> Unit {
  if index < 0 || index >= self.len {
    abort("RingBuffer::set: index \{index} is outside 0..\{self.len}")
  }
  self.slots[(self.head + index) % self.slots.length()] = value
}

///|
/// Removes every element. The storage stays allocated so the buffer can be
/// refilled without growing again.
pub fn[T] RingBuffer::clear(self : RingBuffer[T]) -> Unit {
  self.head = 0
  self.len = 0
}

///|
/// The number of elements held.
pub fn[T] RingBuffer::length(self : RingBuffer[T]) -> Int32 {
  self.len
}

///|
/// The ceiling this buffer was built with; the number of elements cannot
/// exceed it.
pub fn[T] RingBuffer::capacity(self : RingBuffer[T]) -> Int32 {
  self.capacity
}

///|
/// Whether the buffer holds nothing.
pub fn[T] RingBuffer::is_empty(self : RingBuffer[T]) -> Bool {
  self.len == 0
}

///|
/// Whether the buffer holds as many elements as its ceiling allows, which is
/// the state that makes a push drop something.
pub fn[T] RingBuffer::is_full(self : RingBuffer[T]) -> Bool {
  self.len == self.capacity
}

///|
/// The policy this buffer applies when full.
pub fn[T] RingBuffer::overflow(self : RingBuffer[T]) -> Overflow {
  self.overflow
}

///|
/// Changes the ceiling. A ceiling below the current length, or zero or less,
/// is refused because the buffer would have to discard data to honour it.
/// Storage shrinks only to the new ceiling and never grows eagerly.
pub fn[T] RingBuffer::resize_capacity(
  self : RingBuffer[T],
  capacity~ : Int32,
) -> Unit raise @spec.Refused {
  require_capacity(capacity)
  if capacity < self.len {
    raise @spec.Refused::Capacity(got=capacity)
  }
  let slots_len = self.slots.length()
  if self.len == 0 {
    self.slots = []
    self.head = 0
  } else {
    let target = if slots_len < capacity { slots_len } else { capacity }
    let next : Array[T] = []
    for i in 0..<self.len {
      next.push(self.slots[(self.head + i) % slots_len])
    }
    let fill = next[0]
    while next.length() < target {
      next.push(fill)
    }
    self.slots = next
    self.head = 0
  }
  self.capacity = capacity
}

///|
/// The live elements as one or two contiguous array views, in logical order:
/// the run from the head to the end of the storage, then the run that wrapped
/// around to the start. Either view may be empty. Reading both views in order
/// visits the buffer without copying it.
pub fn[T] RingBuffer::as_views(
  self : RingBuffer[T],
) -> (ArrayView[T], ArrayView[T]) {
  let slots_len = self.slots.length()
  if self.len == 0 || slots_len == 0 {
    let empty : Array[T] = []
    (empty[:], empty[:])
  } else {
    let before_wrap = slots_len - self.head
    let first = if before_wrap < self.len { before_wrap } else { self.len }
    (self.slots[self.head:self.head + first], self.slots[0:self.len - first])
  }
}

///|
/// Rotates the storage so the live elements start at index zero, which makes
/// the first of `as_views` cover the whole buffer. Subsequent pushes and pops
/// wrap again; nothing else depends on the layout.
pub fn[T] RingBuffer::linearize(self : RingBuffer[T]) -> Unit {
  if self.head == 0 || self.len == 0 {
    self.head = 0
  } else {
    let slots_len = self.slots.length()
    let next : Array[T] = []
    for i in 0..<self.len {
      next.push(self.slots[(self.head + i) % slots_len])
    }
    let fill = next[0]
    while next.length() < slots_len {
      next.push(fill)
    }
    self.slots = next
    self.head = 0
  }
}

///|
/// The elements in logical order, oldest first.
pub fn[T] RingBuffer::to_array(self : RingBuffer[T]) -> Array[T] {
  let out : Array[T] = []
  let slots_len = self.slots.length()
  for i in 0..<self.len {
    out.push(self.slots[(self.head + i) % slots_len])
  }
  out
}

///|
/// The elements from oldest to newest.
pub fn[T] RingBuffer::iter(self : RingBuffer[T]) -> Iter[T] {
  self.to_array().iter()
}

///|
/// The elements from newest to oldest.
pub fn[T] RingBuffer::rev_iter(self : RingBuffer[T]) -> Iter[T] {
  self.to_array().rev_iter()
}

///|
/// An independent buffer with the same ceiling, policy and elements. Growing
/// one afterwards does not touch the other.
pub fn[T] RingBuffer::copy(self : RingBuffer[T]) -> RingBuffer[T] {
  {
    slots: self.slots.copy(),
    head: self.head,
    len: self.len,
    capacity: self.capacity,
    overflow: self.overflow,
  }
}

///|
/// Two buffers are equal when they hold the same elements in the same order.
/// The overflow policy and the physical layout are not part of the value.
pub impl[T : Eq] Eq for RingBuffer[T] with fn equal(self, other) {
  if self.len != other.len {
    false
  } else {
    let mut same = true
    let mut i = 0
    while same && i < self.len {
      if self.get(i) != other.get(i) {
        same = false
      }
      i = i + 1
    }
    same
  }
}

///|
pub extend RingBuffer with Eq::{equal, not_equal}

///|
/// Hashes the elements in logical order, so equal buffers hash alike whatever
/// their storage layout.
pub impl[T : Hash] Hash for RingBuffer[T] with fn hash_combine(self, hasher) {
  Hash::hash_combine(self.len, hasher)
  for i in 0..<self.len {
    Hash::hash_combine(self.at(i), hasher)
  }
}

///|
pub extend RingBuffer with Hash::{hash, hash_combine}

///|
pub impl[T : Show] Show for RingBuffer[T] with fn output(self, logger) {
  logger.write_string("RingBuffer[")
  show_items(self.to_array(), logger)
  logger.write_string("]")
}

///|
pub extend RingBuffer with Show::{output, to_string}

///|
pub impl[T : Debug] Debug for RingBuffer[T] with fn to_repr(self) {
  Repr::ctor("RingBuffer", [(None, Repr::array(debug_items(self.to_array())))])
}

///|
pub extend RingBuffer with Debug::{to_repr}
