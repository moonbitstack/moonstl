///|
/// A map from a key to a list of values: one entry per key, and the values of a
/// key keep the order they were inserted in.
///
/// ```mbt check
/// test {
///   let map : @map.MultiMap[String, Int32] = @map.MultiMap::new()
///   map.insert("a", 1)
///   map.insert("a", 2)
///   @test.assert_eq(map.get("a"), [1, 2])
///   @test.assert_eq(map.length(), 2)
///   @test.assert_eq(map.key_count(), 1)
/// }
/// ```
pub struct MultiMap[K, V] {
  map : IndexMap[K, Array[V]]
  mut total : Int32
}

///|
/// A multiset is a multimap whose values carry no information.
pub type MultiSet[K] = MultiMap[K, Unit]

///|
/// A multimap with room for `capacity` values, its key table laid out from `hash_seed`.
pub fn[K, V] MultiMap::new(
  capacity~ : Int32 = 0,
  hash_seed~ : Int32 = @spec.hash_seed(),
) -> MultiMap[K, V] {
  { map: IndexMap::new(capacity~, hash_seed~), total: 0, }
}

///|
/// Adds `value` under `key`, keeping the values of a key in the order they were added.
pub fn[K : Hash + Eq, V] MultiMap::insert(
  self : MultiMap[K, V],
  key : K,
  value : V,
) -> Unit {
  match self.map.get(key) {
    Some(values) => values.push(value)
    None => {
      let values : Array[V] = [value]
      let _ = self.map.set(key, values)
    }
  }
  self.total = self.total + 1
}

///|
/// The values of `key`, in insertion order. The array is a copy, so a caller
/// cannot write into the map through it.
pub fn[K : Hash + Eq, V] MultiMap::get(
  self : MultiMap[K, V],
  key : K,
) -> Array[V] {
  match self.map.get(key) {
    Some(values) => values.copy()
    None => []
  }
}

///|
/// The values under `key`, in the order they were added; a key that is absent yields nothing.
pub fn[K : Hash + Eq, V] MultiMap::iter_values(
  self : MultiMap[K, V],
  key : K,
) -> Iter[V] {
  let values = self.get(key)
  let mut cursor = 0
  Iter::new(() => {
    if cursor >= values.length() {
      None
    } else {
      let value = values[cursor]
      cursor = cursor + 1
      Some(value)
    }
  })
}

///|
/// Whether `key` has at least one value.
pub fn[K : Hash + Eq, V] MultiMap::contains(
  self : MultiMap[K, V],
  key : K,
) -> Bool {
  self.map.contains(key)
}

///|
/// Whether `value` is one of the values under `key`.
pub fn[K : Hash + Eq, V : Eq] MultiMap::contains_entry(
  self : MultiMap[K, V],
  key : K,
  value : V,
) -> Bool {
  match self.map.get(key) {
    Some(values) => values.contains(value)
    None => false
  }
}

///|
/// Drops every value of `key` and returns them.
pub fn[K : Hash + Eq, V] MultiMap::remove(
  self : MultiMap[K, V],
  key : K,
) -> Array[V] {
  match self.map.remove(key) {
    Some(values) => {
      self.total = self.total - values.length()
      values
    }
    None => []
  }
}

///|
/// Drops one occurrence of `value` under `key`.
pub fn[K : Hash + Eq, V : Eq] MultiMap::remove_entry(
  self : MultiMap[K, V],
  key : K,
  value : V,
) -> Bool {
  match self.map.get(key) {
    Some(values) => {
      let at = values.search_by(v => v == value)
      guard at is Some(at) else { return false }
      let _ = values.remove(at)
      self.total = self.total - 1
      if values.length() == 0 {
        let _ = self.map.remove(key)
      }
      true
    }
    None => false
  }
}

///|
/// The number of values held, counting repeats.
pub fn[K, V] MultiMap::length(self : MultiMap[K, V]) -> Int32 {
  self.total
}

///|
/// The number of distinct keys.
pub fn[K, V] MultiMap::key_count(self : MultiMap[K, V]) -> Int32 {
  self.map.length()
}

///|
/// Whether no value is stored under any key.
pub fn[K, V] MultiMap::is_empty(self : MultiMap[K, V]) -> Bool {
  self.total == 0
}

///|
/// Every pair, key by key, the values of a key in insertion order.
pub fn[K, V] MultiMap::iter(self : MultiMap[K, V]) -> Iter[(K, V)] {
  let entries = self.map.to_array()
  let mut key_at = 0
  let mut value_at = 0
  Iter::new(() => {
    while key_at < entries.length() {
      let (key, values) = entries[key_at]
      if value_at < values.length() {
        let value = values[value_at]
        value_at = value_at + 1
        return Some((key, value))
      }
      key_at = key_at + 1
      value_at = 0
    }
    None
  })
}

///|
/// Every value paired with its key, in key order and then in the order the values were added.
pub fn[K, V] MultiMap::iter2(self : MultiMap[K, V]) -> Iter2[K, V] {
  let walk = self.iter()
  Iter2::new(() => walk.next(), size_hint=self.total)
}

///|
/// The keys in the order they were first added.
pub fn[K, V] MultiMap::keys(self : MultiMap[K, V]) -> Iter[K] {
  self.map.keys()
}

///|
/// Removes every key and every value.
pub fn[K, V] MultiMap::clear(self : MultiMap[K, V]) -> Unit {
  self.map.clear()
  self.total = 0
}

///|
/// A copy that owns its arrays: a change to either multimap is invisible to the other.
pub fn[K : Hash + Eq, V] MultiMap::copy(
  self : MultiMap[K, V],
) -> MultiMap[K, V] {
  let result : MultiMap[K, V] = MultiMap::new()
  for (key, values) in self.map.iter() {
    result.total = result.total + values.length()
    let _ = result.map.set(key, values.copy())
  }
  result
}

///|
pub impl[K : Eq, V : Eq] Eq for MultiMap[K, V] with fn equal(self, other) {
  self.map.equal(other.map)
}

///|
pub extend MultiMap with Eq::{equal, not_equal}

///|
pub impl[K : Show, V : Show] Show for MultiMap[K, V] with fn output(
  self,
  logger,
) {
  logger.write_string("{")
  let mut first = true
  for (key, values) in self.map.iter() {
    if !first {
      logger.write_string(", ")
    }
    first = false
    key.output(logger)
    logger.write_string(": [")
    for i, value in values {
      if i > 0 {
        logger.write_string(", ")
      }
      value.output(logger)
    }
    logger.write_string("]")
  }
  logger.write_string("}")
}

///|
pub extend MultiMap with Show::{to_string, output}

///|
/// A multimap held as a sorted array: the keys are in order, and the values of
/// one key are in order among themselves as well, so `range` and `first` walk
/// the pairs in the order a reader expects.
///
/// ```mbt check
/// test {
///   let map : @map.SortedMultiMap[Int32, String] = @map.SortedMultiMap::new()
///   map.insert(2, "b")
///   map.insert(1, "a")
///   map.insert(1, "b")
///   @test.assert_eq(map.first(), Some((1, "a")))
///   @test.assert_eq(map.get(1), ["a", "b"])
/// }
/// ```
pub struct SortedMultiMap[K, V] {
  entries : Array[(K, V)]
}

///|
/// A sorted multiset is a sorted multimap whose values carry no information.
pub type SortedMultiSet[K] = SortedMultiMap[K, Unit]

///|
/// An empty multimap that keeps its entries in key order.
pub fn[K, V] SortedMultiMap::new() -> SortedMultiMap[K, V] {
  { entries: [], }
}

///|
fn[K : Compare, V : Compare] SortedMultiMap::locate(
  self : SortedMultiMap[K, V],
  key : K,
  value : V,
) -> Int32 {
  let mut low = 0
  let mut high = self.entries.length()
  while low < high {
    let mid = (low + high) / 2
    let entry = self.entries[mid]
    let order = if entry.0.compare(key) == 0 {
      entry.1.compare(value)
    } else {
      entry.0.compare(key)
    }
    if order < 0 {
      low = mid + 1
    } else {
      high = mid
    }
  }
  low
}

///|
fn[K : Compare, V] SortedMultiMap::lower_bound(
  self : SortedMultiMap[K, V],
  key : K,
) -> Int32 {
  let mut low = 0
  let mut high = self.entries.length()
  while low < high {
    let mid = (low + high) / 2
    if self.entries[mid].0.compare(key) < 0 {
      low = mid + 1
    } else {
      high = mid
    }
  }
  low
}

///|
/// Adds `value` under `key`; the entry goes where key order puts it, and equal keys keep the values in the order they were added.
pub fn[K : Compare, V : Compare] SortedMultiMap::insert(
  self : SortedMultiMap[K, V],
  key : K,
  value : V,
) -> Unit {
  let at = self.locate(key, value)
  self.entries.insert(at, (key, value))
}

///|
/// The values of `key`, in order.
pub fn[K : Compare, V] SortedMultiMap::get(
  self : SortedMultiMap[K, V],
  key : K,
) -> Array[V] {
  let values : Array[V] = []
  let mut at = self.lower_bound(key)
  while at < self.entries.length() && self.entries[at].0.compare(key) == 0 {
    values.push(self.entries[at].1)
    at = at + 1
  }
  values
}

///|
/// Whether `key` has at least one value.
pub fn[K : Compare, V] SortedMultiMap::contains(
  self : SortedMultiMap[K, V],
  key : K,
) -> Bool {
  let at = self.lower_bound(key)
  at < self.entries.length() && self.entries[at].0.compare(key) == 0
}

///|
/// Drops the values of `key` and returns them.
pub fn[K : Compare, V] SortedMultiMap::remove(
  self : SortedMultiMap[K, V],
  key : K,
) -> Array[V] {
  let values : Array[V] = []
  let start = self.lower_bound(key)
  let mut end = start
  while end < self.entries.length() && self.entries[end].0.compare(key) == 0 {
    values.push(self.entries[end].1)
    end = end + 1
  }
  let mut write = start
  let mut read = end
  while read < self.entries.length() {
    self.entries[write] = self.entries[read]
    write = write + 1
    read = read + 1
  }
  while self.entries.length() > write {
    let _ = self.entries.pop()
  }
  values
}

///|
/// The pairs whose keys fall in `start` up to `end`, both included.
pub fn[K : Compare, V] SortedMultiMap::range(
  self : SortedMultiMap[K, V],
  start~ : K,
  end~ : K,
) -> Iter[(K, V)] {
  let from = self.lower_bound(start)
  let mut cursor = from
  Iter::new(() => {
    if cursor >= self.entries.length() ||
      self.entries[cursor].0.compare(end) > 0 {
      None
    } else {
      let entry = self.entries[cursor]
      cursor = cursor + 1
      Some(entry)
    }
  })
}

///|
/// The smallest entry, or `None` when the map is empty.
pub fn[K, V] SortedMultiMap::first(self : SortedMultiMap[K, V]) -> (K, V)? {
  self.entries.get(0)
}

///|
/// The largest entry, or `None` when the map is empty.
pub fn[K, V] SortedMultiMap::last(self : SortedMultiMap[K, V]) -> (K, V)? {
  self.entries.get(self.entries.length() - 1)
}

///|
/// Removes and returns the smallest entry.
pub fn[K, V] SortedMultiMap::pop_first(self : SortedMultiMap[K, V]) -> (K, V)? {
  if self.entries.length() == 0 {
    None
  } else {
    Some(self.entries.remove(0))
  }
}

///|
/// Removes and returns the largest entry.
pub fn[K, V] SortedMultiMap::pop_last(self : SortedMultiMap[K, V]) -> (K, V)? {
  self.entries.pop()
}

///|
/// Every entry in key order, and within one key in the order the values were added.
pub fn[K, V] SortedMultiMap::iter(self : SortedMultiMap[K, V]) -> Iter[(K, V)] {
  let mut cursor = 0
  Iter::new(() => {
    if cursor >= self.entries.length() {
      None
    } else {
      let entry = self.entries[cursor]
      cursor = cursor + 1
      Some(entry)
    }
  })
}

///|
/// How many entries, counting one per value, the map holds.
pub fn[K, V] SortedMultiMap::length(self : SortedMultiMap[K, V]) -> Int32 {
  self.entries.length()
}

///|
/// The number of distinct keys.
pub fn[K : Compare, V] SortedMultiMap::key_count(
  self : SortedMultiMap[K, V],
) -> Int32 {
  let mut count = 0
  let mut at = 0
  while at < self.entries.length() {
    count = count + 1
    let key = self.entries[at].0
    while at < self.entries.length() && self.entries[at].0.compare(key) == 0 {
      at = at + 1
    }
  }
  count
}

///|
/// Whether no value is stored under any key.
pub fn[K, V] SortedMultiMap::is_empty(self : SortedMultiMap[K, V]) -> Bool {
  self.entries.length() == 0
}

///|
/// Removes every entry.
pub fn[K, V] SortedMultiMap::clear(self : SortedMultiMap[K, V]) -> Unit {
  self.entries.clear()
}

///|
/// A copy that owns its array: a change to either multimap is invisible to the other.
pub fn[K, V] SortedMultiMap::copy(
  self : SortedMultiMap[K, V],
) -> SortedMultiMap[K, V] {
  { entries: self.entries.copy(), }
}

///|
/// Every entry in key order, as a new array.
pub fn[K, V] SortedMultiMap::to_array(
  self : SortedMultiMap[K, V],
) -> Array[(K, V)] {
  self.entries.copy()
}

///|
pub impl[K : Eq, V : Eq] Eq for SortedMultiMap[K, V] with fn equal(self, other) {
  self.entries == other.entries
}

///|
pub extend SortedMultiMap with Eq::{equal, not_equal}

///|
pub impl[K : Show, V : Show] Show for SortedMultiMap[K, V] with fn output(
  self,
  logger,
) {
  logger.write_string("{")
  for i, entry in self.entries {
    if i > 0 {
      logger.write_string(", ")
    }
    entry.0.output(logger)
    logger.write_string(": ")
    entry.1.output(logger)
  }
  logger.write_string("}")
}

///|
pub extend SortedMultiMap with Show::{to_string, output}
