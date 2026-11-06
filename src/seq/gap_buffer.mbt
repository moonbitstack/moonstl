///|
/// An array with a hole in it: the elements before the hole are kept in order,
/// the ones after it are kept reversed, and moving the hole is the only
/// operation that shifts more than one element. Typing at the hole is therefore
/// constant time, which is what a text editor's buffer wants.
///
/// ```mbt check
/// test {
///   let buffer : @seq.GapBuffer[Int32] = @seq.GapBuffer::new()
///   buffer.insert(0, 1)
///   buffer.insert(1, 3)
///   buffer.insert(1, 2)
///   @test.assert_eq(buffer.to_array(), [1, 2, 3])
///   @test.assert_eq(buffer.remove(1), Some(2))
///   @test.assert_eq(buffer.to_array(), [1, 3])
/// }
/// ```
pub struct GapBuffer[T] {
  before : Array[T]
  /// Reversed: the last element is the one right after the gap.
  after : Array[T]
}

///|
pub fn[T] GapBuffer::new(capacity~ : Int32 = 0) -> GapBuffer[T] {
  let before : Array[T] = []
  if capacity > 0 {
    before.reserve_capacity(capacity)
  }
  { before, after: [], }
}

///|
pub fn[T] GapBuffer::from_array(
  values : ArrayView[T],
  capacity~ : Int32 = 0,
) -> GapBuffer[T] {
  let buffer : GapBuffer[T] = GapBuffer::new(capacity~)
  for value in values {
    buffer.before.push(value)
  }
  buffer
}

///|
/// Puts the hole at `index`, moving as few elements as the distance allows.
pub fn[T] GapBuffer::move_gap_to(self : GapBuffer[T], index : Int32) -> Unit {
  let target = if index < 0 {
    0
  } else if index > self.length() {
    self.length()
  } else {
    index
  }
  while self.before.length() > target {
    match self.before.pop() {
      Some(value) => self.after.push(value)
      None => break
    }
  }
  while self.before.length() < target {
    match self.after.pop() {
      Some(value) => self.before.push(value)
      None => break
    }
  }
}

///|
/// Inserts at the hole, which is constant time once the hole is there.
pub fn[T] GapBuffer::insert(
  self : GapBuffer[T],
  index : Int32,
  value : T,
) -> Unit {
  self.move_gap_to(index)
  self.before.push(value)
}

///|
pub fn[T] GapBuffer::remove(self : GapBuffer[T], index : Int32) -> T? {
  if index < 0 || index >= self.length() {
    return None
  }
  self.move_gap_to(index)
  if self.after.length() > 0 {
    self.after.pop()
  } else {
    self.before.pop()
  }
}

///|
pub fn[T] GapBuffer::get(self : GapBuffer[T], index : Int32) -> T? {
  let front = self.before.length()
  if index < 0 {
    None
  } else if index < front {
    Some(self.before[index])
  } else {
    let back = index - front
    if back >= self.after.length() {
      None
    } else {
      Some(self.after[self.after.length() - 1 - back])
    }
  }
}

///|
pub fn[T] GapBuffer::at(self : GapBuffer[T], index : Int32) -> T {
  match self.get(index) {
    Some(value) => value
    None => abort("moonstl: a gap buffer index outside the buffer")
  }
}

///|
pub fn[T] GapBuffer::set(self : GapBuffer[T], index : Int32, value : T) -> Bool {
  match self.get(index) {
    Some(_) => {
      self.move_gap_to(index)
      if self.after.length() > 0 {
        self.after[self.after.length() - 1] = value
      } else {
        self.before[self.before.length() - 1] = value
      }
      true
    }
    None => false
  }
}

///|
pub fn[T] GapBuffer::length(self : GapBuffer[T]) -> Int32 {
  self.before.length() + self.after.length()
}

///|
pub fn[T] GapBuffer::is_empty(self : GapBuffer[T]) -> Bool {
  self.length() == 0
}

///|
pub fn[T] GapBuffer::iter(self : GapBuffer[T]) -> Iter[T] {
  let mut cursor = 0
  Iter::new(() => {
    let value = self.get(cursor)
    match value {
      Some(_) => cursor = cursor + 1
      None => ()
    }
    value
  })
}

///|
pub fn[T] GapBuffer::to_array(self : GapBuffer[T]) -> Array[T] {
  let out : Array[T] = []
  for value in self.before {
    out.push(value)
  }
  for i in 0..<self.after.length() {
    out.push(self.after[self.after.length() - 1 - i])
  }
  out
}

///|
pub fn[T] GapBuffer::clear(self : GapBuffer[T]) -> Unit {
  self.before.clear()
  self.after.clear()
}

///|
pub fn[T] GapBuffer::copy(self : GapBuffer[T]) -> GapBuffer[T] {
  { before: self.before.copy(), after: self.after.copy(), }
}
