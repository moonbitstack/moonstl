///|
/// A set that keeps insertion order and gives every element a position, the
/// companion of `IndexMap` the way `HashSet` is the companion of `HashMap`.
///
/// ```mbt check
/// test {
///   let set : @map.IndexSet[Int32] = @map.IndexSet::new()
///   @test.assert_eq(set.insert(7), (0, true))
///   @test.assert_eq(set.insert(7), (0, false))
///   @test.assert_eq(set.get_index(0), Some(7))
/// }
/// ```
pub struct IndexSet[K] {
  map : IndexMap[K, Unit]
}

///|
pub fn[K] IndexSet::new(
  capacity~ : Int32 = 0,
  hash_seed~ : Int32 = @spec.hash_seed(),
) -> IndexSet[K] {
  { map: IndexMap::new(capacity~, hash_seed~), }
}

///|
pub fn[K : Hash + Eq] IndexSet::from_array(
  values : ArrayView[K],
  hash_seed~ : Int32 = @spec.hash_seed(),
) -> IndexSet[K] {
  let set : IndexSet[K] = IndexSet::new(capacity=values.length(), hash_seed~)
  for value in values {
    let _ = set.insert(value)
  }
  set
}

///|
pub fn[K : Hash + Eq] IndexSet::from_iter(
  values : Iter[K],
  hash_seed~ : Int32 = @spec.hash_seed(),
) -> IndexSet[K] {
  let set : IndexSet[K] = IndexSet::new(hash_seed~)
  for value in values {
    let _ = set.insert(value)
  }
  set
}

///|
/// The position of the element and whether it was new.
pub fn[K : Hash + Eq] IndexSet::insert(
  self : IndexSet[K],
  value : K,
) -> (Int32, Bool) {
  let (index, old) = self.map.insert_full(value, ())
  (index, old is None)
}

///|
pub fn[K : Hash + Eq] IndexSet::contains(self : IndexSet[K], value : K) -> Bool {
  self.map.contains(value)
}

///|
pub fn[K : Hash + Eq] IndexSet::remove(self : IndexSet[K], value : K) -> Bool {
  self.map.remove(value) is Some(_)
}

///|
pub fn[K : Hash + Eq] IndexSet::swap_remove(
  self : IndexSet[K],
  value : K,
) -> Bool {
  self.map.swap_remove(value) is Some(_)
}

///|
pub fn[K : Hash + Eq] IndexSet::shift_remove(
  self : IndexSet[K],
  value : K,
) -> Bool {
  self.map.shift_remove(value) is Some(_)
}

///|
pub fn[K] IndexSet::get_index(self : IndexSet[K], index : Int32) -> K? {
  match self.map.get_index(index) {
    Some(entry) => Some(entry.0)
    None => None
  }
}

///|
pub fn[K : Hash + Eq] IndexSet::get_index_of(
  self : IndexSet[K],
  value : K,
) -> Int32? {
  self.map.get_index_of(value)
}

///|
pub fn[K] IndexSet::move_index(
  self : IndexSet[K],
  from : Int32,
  to : Int32,
) -> Unit {
  self.map.move_index(from, to)
}

///|
pub fn[K] IndexSet::swap_indices(
  self : IndexSet[K],
  a : Int32,
  b : Int32,
) -> Unit {
  self.map.swap_indices(a, b)
}

///|
pub fn[K : Compare] IndexSet::sort_keys(self : IndexSet[K]) -> Unit {
  self.map.sort_keys()
}

///|
pub fn[K] IndexSet::sort_by(self : IndexSet[K], cmp : (K, K) -> Int32) -> Unit {
  self.map.sort_by((a, b) => cmp(a.0, b.0))
}

///|
/// The elements from `start` for `len` positions.
pub fn[K] IndexSet::range(
  self : IndexSet[K],
  start~ : Int32,
  len~ : Int32,
) -> Iter[K] {
  self.map.range(start~, len~).map(entry => entry.0)
}

///|
pub fn[K] IndexSet::iter(self : IndexSet[K]) -> Iter[K] {
  self.map.keys()
}

///|
pub fn[K] IndexSet::to_array(self : IndexSet[K]) -> Array[K] {
  let values : Array[K] = []
  for value in self.iter() {
    values.push(value)
  }
  values
}

///|
pub fn[K] IndexSet::length(self : IndexSet[K]) -> Int32 {
  self.map.length()
}

///|
pub fn[K] IndexSet::is_empty(self : IndexSet[K]) -> Bool {
  self.map.is_empty()
}

///|
pub fn[K] IndexSet::capacity(self : IndexSet[K]) -> Int32 {
  self.map.capacity()
}

///|
pub fn[K] IndexSet::clear(self : IndexSet[K]) -> Unit {
  self.map.clear()
}

///|
pub fn[K] IndexSet::copy(self : IndexSet[K]) -> IndexSet[K] {
  { map: self.map.copy(), }
}

///|
pub fn[K] IndexSet::retain(self : IndexSet[K], f : (K) -> Bool) -> Unit {
  self.map.retain((key, _) => f(key))
}

///|
pub fn[K] IndexSet::first(self : IndexSet[K]) -> K? {
  self.get_index(0)
}

///|
pub fn[K] IndexSet::last(self : IndexSet[K]) -> K? {
  self.get_index(self.length() - 1)
}

///|
/// The elements of this set that are not in `other`, in this set's order.
pub fn[K : Hash + Eq] IndexSet::difference(
  self : IndexSet[K],
  other : IndexSet[K],
) -> IndexSet[K] {
  let result : IndexSet[K] = IndexSet::new()
  for value in self.iter() {
    if !other.contains(value) {
      let _ = result.insert(value)
    }
  }
  result
}

///|
pub fn[K : Hash + Eq] IndexSet::intersection(
  self : IndexSet[K],
  other : IndexSet[K],
) -> IndexSet[K] {
  let result : IndexSet[K] = IndexSet::new()
  for value in self.iter() {
    if other.contains(value) {
      let _ = result.insert(value)
    }
  }
  result
}

///|
/// The elements of this set followed by the ones only `other` has.
pub fn[K : Hash + Eq] IndexSet::union(
  self : IndexSet[K],
  other : IndexSet[K],
) -> IndexSet[K] {
  let result : IndexSet[K] = self.copy()
  for value in other.iter() {
    let _ = result.insert(value)
  }
  result
}

///|
pub fn[K : Hash + Eq] IndexSet::symmetric_difference(
  self : IndexSet[K],
  other : IndexSet[K],
) -> IndexSet[K] {
  let result : IndexSet[K] = IndexSet::new()
  for value in self.iter() {
    if !other.contains(value) {
      let _ = result.insert(value)
    }
  }
  for value in other.iter() {
    if !self.contains(value) {
      let _ = result.insert(value)
    }
  }
  result
}

///|
pub fn[K : Hash + Eq] IndexSet::is_subset(
  self : IndexSet[K],
  other : IndexSet[K],
) -> Bool {
  for value in self.iter() {
    if !other.contains(value) {
      return false
    }
  }
  true
}

///|
pub fn[K : Hash + Eq] IndexSet::is_superset(
  self : IndexSet[K],
  other : IndexSet[K],
) -> Bool {
  other.is_subset(self)
}

///|
pub fn[K : Hash + Eq] IndexSet::is_disjoint(
  self : IndexSet[K],
  other : IndexSet[K],
) -> Bool {
  for value in self.iter() {
    if other.contains(value) {
      return false
    }
  }
  true
}

///|
pub impl[K : Eq] Eq for IndexSet[K] with fn equal(self, other) {
  self.map.equal(other.map)
}

///|
pub extend IndexSet with Eq::{equal, not_equal}

///|
pub impl[K : Hash] Hash for IndexSet[K] with fn hash_combine(self, hasher) {
  Hash::hash_combine(self.map, hasher)
}

///|
pub extend IndexSet with Hash::{hash, hash_combine}

///|
pub impl[K : Show] Show for IndexSet[K] with fn output(self, logger) {
  logger.write_string("{")
  let mut first = true
  for value in self.iter() {
    if !first {
      logger.write_string(", ")
    }
    first = false
    value.output(logger)
  }
  logger.write_string("}")
}

///|
pub extend IndexSet with Show::{to_string, output}
