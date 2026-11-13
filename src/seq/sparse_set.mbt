///|
/// A set whose elements are kept densely, one array for the elements and one
/// index from element to its position. Membership is a lookup and iteration
/// walks contiguous memory, which is what a caller who filters a dense
/// collection wants; the price is a hash index beside the array.
///
/// ```mbt check
/// test {
///   let set : @seq.SparseSet[String] = @seq.SparseSet::new()
///   @test.assert_eq(set.insert("a"), true)
///   @test.assert_eq(set.insert("a"), false)
///   @test.assert_eq(set.contains("a"), true)
///   @test.assert_eq(set.to_array(), ["a"])
/// }
/// ```
pub struct SparseSet[T] {
  dense : Array[T]
  positions : Map[T, Int32]
}

///|
/// An empty set with room for `capacity` values.
pub fn[T : Hash + Eq] SparseSet::new(capacity~ : Int32 = 0) -> SparseSet[T] {
  let dense : Array[T] = []
  if capacity > 0 {
    dense.reserve_capacity(capacity)
  }
  { dense, positions: Map([]), }
}

///|
/// Adds `value` and reports whether it was new.
pub fn[T : Hash + Eq] SparseSet::insert(self : SparseSet[T], value : T) -> Bool {
  if self.positions.contains(value) {
    false
  } else {
    self.positions.set(value, self.dense.length())
    self.dense.push(value)
    true
  }
}

///|
/// Removes `value` by filling its place with the last one, and reports whether it was there.
pub fn[T : Hash + Eq] SparseSet::remove(self : SparseSet[T], value : T) -> Bool {
  match self.positions.get(value) {
    Some(at) => {
      let last = self.dense.length() - 1
      if at != last {
        let moved = self.dense[last]
        self.dense[at] = moved
        self.positions.set(moved, at)
      }
      let _ = self.dense.pop()
      self.positions.remove(value)
      true
    }
    None => false
  }
}

///|
/// Whether `value` is in the set.
pub fn[T : Hash + Eq] SparseSet::contains(
  self : SparseSet[T],
  value : T,
) -> Bool {
  self.positions.contains(value)
}

///|
/// The position of `value` in the dense array, or `None` when it is not in the set.
pub fn[T : Hash + Eq] SparseSet::get_index(
  self : SparseSet[T],
  value : T,
) -> Int32? {
  self.positions.get(value)
}

///|
/// How many values the set holds.
pub fn[T] SparseSet::length(self : SparseSet[T]) -> Int32 {
  self.dense.length()
}

///|
/// Whether the set holds no value.
pub fn[T] SparseSet::is_empty(self : SparseSet[T]) -> Bool {
  self.dense.length() == 0
}

///|
/// The values in dense order, which a removal changes.
pub fn[T] SparseSet::iter(self : SparseSet[T]) -> Iter[T] {
  let mut cursor = 0
  Iter::new(() => {
    if cursor >= self.dense.length() {
      None
    } else {
      let value = self.dense[cursor]
      cursor = cursor + 1
      Some(value)
    }
  })
}

///|
/// The values in dense order, as a new array.
pub fn[T] SparseSet::to_array(self : SparseSet[T]) -> Array[T] {
  self.dense.copy()
}

///|
/// Removes every value, keeping the room the dense array has.
pub fn[T] SparseSet::clear(self : SparseSet[T]) -> Unit {
  self.dense.clear()
  self.positions.clear()
}

///|
/// A copy that owns its arrays: a change to either set is invisible to the other.
pub fn[T] SparseSet::copy(self : SparseSet[T]) -> SparseSet[T] {
  { dense: self.dense.copy(), positions: self.positions.copy(), }
}
