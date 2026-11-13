///|
/// The first position whose key is not less than `key`.
fn[K : Compare] lower_bound(keys : Array[K], key : K) -> Int32 {
  let mut low = 0
  let mut high = keys.length()
  while low < high {
    let mid = (low + high) / 2
    if keys[mid].compare(key) < 0 {
      low = mid + 1
    } else {
      high = mid
    }
  }
  low
}

///|
/// A map held as a sorted array of keys with a parallel array of values: a
/// lookup is a binary search over contiguous memory, which is the shape to
/// reach for when a table is built once and read many times.
///
/// ```mbt check
/// test {
///   let map : @map.FlatMap[Int32, String] = @map.FlatMap::new()
///   let _ = map.set(2, "b")
///   let _ = map.set(1, "a")
///   @test.assert_eq(map.keys().to_array(), [1, 2])
///   @test.assert_eq(map.get(2), Some("b"))
///   @test.assert_eq(map.index_of(3), Err(2))
/// }
/// ```
pub struct FlatMap[K, V] {
  keys : Array[K]
  values : Array[V]
}

///|
/// An empty map whose entries live in one sorted run, with room for `capacity` of them.
pub fn[K, V] FlatMap::new(capacity~ : Int32 = 0) -> FlatMap[K, V] {
  let keys : Array[K] = []
  let values : Array[V] = []
  if capacity > 0 {
    keys.reserve_capacity(capacity)
    values.reserve_capacity(capacity)
  }
  { keys, values, }
}

///|
/// Sorts the pairs by key; when a key repeats, the last pair in the array wins.
pub fn[K : Compare, V] FlatMap::from_array(
  entries : ArrayView[(K, V)],
) -> FlatMap[K, V] {
  let ordered : Array[(Int32, (K, V))] = []
  for i, entry in entries {
    ordered.push((i, entry))
  }
  ordered.sort_by((a, b) => {
    let order = a.1.0.compare(b.1.0)
    if order != 0 {
      order
    } else {
      a.0.compare(b.0)
    }
  })
  let map : FlatMap[K, V] = FlatMap::new(capacity=entries.length())
  for (_, entry) in ordered {
    let _ = map.set(entry.0, entry.1)
  }
  map
}

///|
/// Where `key` is, or where it would be inserted.
pub fn[K : Compare, V] FlatMap::index_of(
  self : FlatMap[K, V],
  key : K,
) -> Result[Int32, Int32] {
  let at = lower_bound(self.keys, key)
  if at < self.keys.length() && self.keys[at].compare(key) == 0 {
    Ok(at)
  } else {
    Err(at)
  }
}

///|
/// The value under `key`, or `None`; the lookup is a binary search over the sorted keys.
pub fn[K : Compare, V] FlatMap::get(self : FlatMap[K, V], key : K) -> V? {
  match self.index_of(key) {
    Ok(at) => Some(self.values[at])
    Err(_) => None
  }
}

///|
/// Whether `key` has an entry.
pub fn[K : Compare, V] FlatMap::contains(self : FlatMap[K, V], key : K) -> Bool {
  self.index_of(key) is Ok(_)
}

///|
/// Stores `value` under `key`, inserting the key in order, and returns the value it replaced.
pub fn[K : Compare, V] FlatMap::set(
  self : FlatMap[K, V],
  key : K,
  value : V,
) -> V? {
  match self.index_of(key) {
    Ok(at) => {
      let old = self.values[at]
      self.values[at] = value
      Some(old)
    }
    Err(at) => {
      self.keys.insert(at, key)
      self.values.insert(at, value)
      None
    }
  }
}

///|
/// The entry at position `index` in key order, or `None` when the position is past the last one.
pub fn[K, V] FlatMap::get_index(self : FlatMap[K, V], index : Int32) -> (K, V)? {
  if index < 0 || index >= self.keys.length() {
    None
  } else {
    Some((self.keys[index], self.values[index]))
  }
}

///|
/// Removes `key` and returns the value it held, closing the gap in the run.
pub fn[K : Compare, V] FlatMap::remove(self : FlatMap[K, V], key : K) -> V? {
  match self.index_of(key) {
    Ok(at) => {
      let _ = self.keys.remove(at)
      Some(self.values.remove(at))
    }
    Err(_) => None
  }
}

///|
/// The pairs whose keys fall between `start` and `end`, both included.
pub fn[K : Compare, V] FlatMap::range(
  self : FlatMap[K, V],
  start~ : K,
  end~ : K,
) -> Iter[(K, V)] {
  let mut cursor = lower_bound(self.keys, start)
  Iter::new(() => {
    if cursor >= self.keys.length() || self.keys[cursor].compare(end) > 0 {
      None
    } else {
      let entry = (self.keys[cursor], self.values[cursor])
      cursor = cursor + 1
      Some(entry)
    }
  })
}

///|
/// The entry with the smallest key, or `None` when the map is empty.
pub fn[K, V] FlatMap::first(self : FlatMap[K, V]) -> (K, V)? {
  self.get_index(0)
}

///|
/// The entry with the largest key, or `None` when the map is empty.
pub fn[K, V] FlatMap::last(self : FlatMap[K, V]) -> (K, V)? {
  self.get_index(self.keys.length() - 1)
}

///|
/// Removes and returns the entry with the smallest key.
pub fn[K, V] FlatMap::pop_first(self : FlatMap[K, V]) -> (K, V)? {
  if self.keys.length() == 0 {
    None
  } else {
    let key = self.keys.remove(0)
    Some((key, self.values.remove(0)))
  }
}

///|
/// Removes and returns the entry with the largest key.
pub fn[K, V] FlatMap::pop_last(self : FlatMap[K, V]) -> (K, V)? {
  if self.keys.length() == 0 {
    return None
  }
  let value = self.values.remove(self.values.length() - 1)
  let key = self.keys.remove(self.keys.length() - 1)
  Some((key, value))
}

///|
/// The entries in key order.
pub fn[K, V] FlatMap::iter(self : FlatMap[K, V]) -> Iter[(K, V)] {
  let mut cursor = 0
  Iter::new(() => {
    if cursor >= self.keys.length() {
      None
    } else {
      let entry = (self.keys[cursor], self.values[cursor])
      cursor = cursor + 1
      Some(entry)
    }
  })
}

///|
/// The keys in order.
pub fn[K, V] FlatMap::keys(self : FlatMap[K, V]) -> Iter[K] {
  let mut cursor = 0
  Iter::new(() => {
    if cursor >= self.keys.length() {
      None
    } else {
      let key = self.keys[cursor]
      cursor = cursor + 1
      Some(key)
    }
  })
}

///|
/// The values in key order.
pub fn[K, V] FlatMap::values(self : FlatMap[K, V]) -> Iter[V] {
  let mut cursor = 0
  Iter::new(() => {
    if cursor >= self.values.length() {
      None
    } else {
      let value = self.values[cursor]
      cursor = cursor + 1
      Some(value)
    }
  })
}

///|
/// How many entries the map holds.
pub fn[K, V] FlatMap::length(self : FlatMap[K, V]) -> Int32 {
  self.keys.length()
}

///|
/// How many entries the run has room for before it grows.
pub fn[K, V] FlatMap::capacity(self : FlatMap[K, V]) -> Int32 {
  self.keys.capacity()
}

///|
/// Makes room for `capacity` entries in one allocation, so the inserts that follow do not grow the run again.
pub fn[K, V] FlatMap::reserve_capacity(
  self : FlatMap[K, V],
  capacity~ : Int32,
) -> Unit {
  self.keys.reserve_capacity(capacity)
  self.values.reserve_capacity(capacity)
}

///|
/// Releases the room past the last entry.
pub fn[K, V] FlatMap::shrink_to_fit(self : FlatMap[K, V]) -> Unit {
  self.keys.shrink_to_fit()
  self.values.shrink_to_fit()
}

///|
/// Whether the map holds no entry.
pub fn[K, V] FlatMap::is_empty(self : FlatMap[K, V]) -> Bool {
  self.keys.length() == 0
}

///|
/// Removes every entry, keeping the room the run has.
pub fn[K, V] FlatMap::clear(self : FlatMap[K, V]) -> Unit {
  self.keys.clear()
  self.values.clear()
}

///|
/// A copy that owns its arrays: a change to either map is invisible to the other.
pub fn[K, V] FlatMap::copy(self : FlatMap[K, V]) -> FlatMap[K, V] {
  { keys: self.keys.copy(), values: self.values.copy(), }
}

///|
pub impl[K : Eq, V : Eq] Eq for FlatMap[K, V] with fn equal(self, other) {
  self.keys == other.keys && self.values == other.values
}

///|
pub extend FlatMap with Eq::{equal, not_equal}

///|
pub impl[K : Show, V : Show] Show for FlatMap[K, V] with fn output(self, logger) {
  logger.write_string("{")
  for i in 0..<self.keys.length() {
    if i > 0 {
      logger.write_string(", ")
    }
    self.keys[i].output(logger)
    logger.write_string(": ")
    self.values[i].output(logger)
  }
  logger.write_string("}")
}

///|
pub extend FlatMap with Show::{to_string, output}

///|
/// A set held as a sorted array of elements, the companion of `FlatMap`.
///
/// ```mbt check
/// test {
///   let set : @map.FlatSet[Int32] = @map.FlatSet::new()
///   @test.assert_eq(set.insert(3), true)
///   @test.assert_eq(set.insert(3), false)
///   @test.assert_eq(set.get_index(0), Some(3))
/// }
/// ```
pub struct FlatSet[K] {
  keys : Array[K]
}

///|
/// An empty set whose values live in one sorted run, with room for `capacity` of them.
pub fn[K] FlatSet::new(capacity~ : Int32 = 0) -> FlatSet[K] {
  let keys : Array[K] = []
  if capacity > 0 {
    keys.reserve_capacity(capacity)
  }
  { keys, }
}

///|
/// A set holding the values written out, in order and without repeats.
pub fn[K : Compare] FlatSet::from_array(values : ArrayView[K]) -> FlatSet[K] {
  let sorted = values.to_owned()
  sorted.sort()
  let set : FlatSet[K] = FlatSet::new(capacity=sorted.length())
  for value in sorted {
    let _ = set.insert(value)
  }
  set
}

///|
/// Where `key` is, or where it would be inserted.
pub fn[K : Compare] FlatSet::index_of(
  self : FlatSet[K],
  key : K,
) -> Result[Int32, Int32] {
  let at = lower_bound(self.keys, key)
  if at < self.keys.length() && self.keys[at].compare(key) == 0 {
    Ok(at)
  } else {
    Err(at)
  }
}

///|
/// Adds the element and reports whether it was new.
pub fn[K : Compare] FlatSet::insert(self : FlatSet[K], key : K) -> Bool {
  match self.index_of(key) {
    Ok(_) => false
    Err(at) => {
      self.keys.insert(at, key)
      true
    }
  }
}

///|
/// Whether `value` is in the set; the lookup is a binary search over the sorted run.
pub fn[K : Compare] FlatSet::contains(self : FlatSet[K], key : K) -> Bool {
  self.index_of(key) is Ok(_)
}

///|
/// Removes `value`, closing the gap in the run, and reports whether it was there.
pub fn[K : Compare] FlatSet::remove(self : FlatSet[K], key : K) -> Bool {
  match self.index_of(key) {
    Ok(at) => {
      let _ = self.keys.remove(at)
      true
    }
    Err(_) => false
  }
}

///|
/// The value at position `index` in order, or `None` when the position is past the last one.
pub fn[K] FlatSet::get_index(self : FlatSet[K], index : Int32) -> K? {
  self.keys.get(index)
}

///|
/// The values from `start` up to `end`, in order.
pub fn[K : Compare] FlatSet::range(
  self : FlatSet[K],
  start~ : K,
  end~ : K,
) -> Iter[K] {
  let mut cursor = lower_bound(self.keys, start)
  Iter::new(() => {
    if cursor >= self.keys.length() || self.keys[cursor].compare(end) > 0 {
      None
    } else {
      let key = self.keys[cursor]
      cursor = cursor + 1
      Some(key)
    }
  })
}

///|
/// The smallest value, or `None` when the set is empty.
pub fn[K] FlatSet::first(self : FlatSet[K]) -> K? {
  self.keys.get(0)
}

///|
/// The largest value, or `None` when the set is empty.
pub fn[K] FlatSet::last(self : FlatSet[K]) -> K? {
  self.keys.get(self.keys.length() - 1)
}

///|
/// Removes and returns the smallest value.
pub fn[K] FlatSet::pop_first(self : FlatSet[K]) -> K? {
  if self.keys.length() == 0 {
    None
  } else {
    Some(self.keys.remove(0))
  }
}

///|
/// Removes and returns the largest value.
pub fn[K] FlatSet::pop_last(self : FlatSet[K]) -> K? {
  self.keys.pop()
}

///|
/// The values in order.
pub fn[K] FlatSet::iter(self : FlatSet[K]) -> Iter[K] {
  let mut cursor = 0
  Iter::new(() => {
    if cursor >= self.keys.length() {
      None
    } else {
      let key = self.keys[cursor]
      cursor = cursor + 1
      Some(key)
    }
  })
}

///|
/// The values in order, as a new array.
pub fn[K] FlatSet::to_array(self : FlatSet[K]) -> Array[K] {
  self.keys.copy()
}

///|
/// How many values the set holds.
pub fn[K] FlatSet::length(self : FlatSet[K]) -> Int32 {
  self.keys.length()
}

///|
/// How many values the run has room for before it grows.
pub fn[K] FlatSet::capacity(self : FlatSet[K]) -> Int32 {
  self.keys.capacity()
}

///|
/// Makes room for `capacity` values in one allocation.
pub fn[K] FlatSet::reserve_capacity(
  self : FlatSet[K],
  capacity~ : Int32,
) -> Unit {
  self.keys.reserve_capacity(capacity)
}

///|
/// Releases the room past the last value.
pub fn[K] FlatSet::shrink_to_fit(self : FlatSet[K]) -> Unit {
  self.keys.shrink_to_fit()
}

///|
/// Whether the set holds no value.
pub fn[K] FlatSet::is_empty(self : FlatSet[K]) -> Bool {
  self.keys.length() == 0
}

///|
/// Removes every value, keeping the room the run has.
pub fn[K] FlatSet::clear(self : FlatSet[K]) -> Unit {
  self.keys.clear()
}

///|
/// A copy that owns its array: a change to either set is invisible to the other.
pub fn[K] FlatSet::copy(self : FlatSet[K]) -> FlatSet[K] {
  { keys: self.keys.copy(), }
}

///|
pub impl[K : Eq] Eq for FlatSet[K] with fn equal(self, other) {
  self.keys == other.keys
}

///|
pub extend FlatSet with Eq::{equal, not_equal}

///|
pub impl[K : Show] Show for FlatSet[K] with fn output(self, logger) {
  logger.write_string("{")
  for i, key in self.keys {
    if i > 0 {
      logger.write_string(", ")
    }
    key.output(logger)
  }
  logger.write_string("}")
}

///|
pub extend FlatSet with Show::{to_string, output}
