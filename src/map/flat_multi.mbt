///|
/// A multimap held as a sorted array of pairs: keys in order, and the values of
/// one key in order among themselves. Repeats are kept, so this is the flat
/// counterpart of `SortedMultiMap`.
///
/// ```mbt check
/// test {
///   let map : @map.FlatMultiMap[Int32, String] = @map.FlatMultiMap::new()
///   map.insert(2, "b")
///   map.insert(1, "a")
///   map.insert(1, "c")
///   @test.assert_eq(map.get(1), ["a", "c"])
///   @test.assert_eq(map.length(), 3)
///   @test.assert_eq(map.key_count(), 2)
/// }
/// ```
pub struct FlatMultiMap[K, V] {
  entries : Array[(K, V)]
}

///|
/// A flat multiset keeps repeats in sorted order and counts them.
pub type FlatMultiSet[K] = FlatMultiMap[K, Unit]

///|
/// An empty multimap whose entries live in one run sorted by key and then by value, with room for `capacity` of them.
pub fn[K, V] FlatMultiMap::new(capacity~ : Int32 = 0) -> FlatMultiMap[K, V] {
  let entries : Array[(K, V)] = []
  if capacity > 0 {
    entries.reserve_capacity(capacity)
  }
  { entries, }
}

///|
/// Where the pair belongs: after every pair that is smaller.
fn[K : Compare, V : Compare] FlatMultiMap::locate(
  self : FlatMultiMap[K, V],
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
    if order <= 0 {
      low = mid + 1
    } else {
      high = mid
    }
  }
  low
}

///|
/// The first position of `key`.
fn[K : Compare, V] FlatMultiMap::lower_pos(
  self : FlatMultiMap[K, V],
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
/// Adds `value` under `key` in sorted position; a pair that is already there is not added twice.
pub fn[K : Compare, V : Compare] FlatMultiMap::insert(
  self : FlatMultiMap[K, V],
  key : K,
  value : V,
) -> Unit {
  let at = self.locate(key, value)
  self.entries.insert(at, (key, value))
}

///|
/// The values under `key`, ascending.
pub fn[K : Compare, V] FlatMultiMap::get(
  self : FlatMultiMap[K, V],
  key : K,
) -> Array[V] {
  let values : Array[V] = []
  let mut at = self.lower_pos(key)
  while at < self.entries.length() && self.entries[at].0.compare(key) == 0 {
    values.push(self.entries[at].1)
    at = at + 1
  }
  values
}

///|
/// How many values are stored under `key`.
pub fn[K : Compare, V] FlatMultiMap::count(
  self : FlatMultiMap[K, V],
  key : K,
) -> Int32 {
  let mut at = self.lower_pos(key)
  let mut count = 0
  while at < self.entries.length() && self.entries[at].0.compare(key) == 0 {
    count = count + 1
    at = at + 1
  }
  count
}

///|
/// Whether `key` has at least one value.
pub fn[K : Compare, V] FlatMultiMap::contains(
  self : FlatMultiMap[K, V],
  key : K,
) -> Bool {
  self.count(key) > 0
}

///|
/// Drops every value of `key` and returns them.
pub fn[K : Compare, V] FlatMultiMap::remove(
  self : FlatMultiMap[K, V],
  key : K,
) -> Array[V] {
  let values : Array[V] = []
  let start = self.lower_pos(key)
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
/// Drops one pair equal to `(key, value)`.
pub fn[K : Compare, V : Compare] FlatMultiMap::remove_entry(
  self : FlatMultiMap[K, V],
  key : K,
  value : V,
) -> Bool {
  let mut at = self.lower_pos(key)
  while at < self.entries.length() && self.entries[at].0.compare(key) == 0 {
    if self.entries[at].1.compare(value) == 0 {
      let _ = self.entries.remove(at)
      return true
    }
    at = at + 1
  }
  false
}

///|
/// Every entry whose key is from `start` up to `end`, in order.
pub fn[K : Compare, V] FlatMultiMap::range(
  self : FlatMultiMap[K, V],
  start~ : K,
  end~ : K,
) -> Iter[(K, V)] {
  let mut cursor = self.lower_pos(start)
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
pub fn[K, V] FlatMultiMap::first(self : FlatMultiMap[K, V]) -> (K, V)? {
  self.entries.get(0)
}

///|
/// The largest entry, or `None` when the map is empty.
pub fn[K, V] FlatMultiMap::last(self : FlatMultiMap[K, V]) -> (K, V)? {
  self.entries.get(self.entries.length() - 1)
}

///|
/// Removes and returns the smallest entry.
pub fn[K, V] FlatMultiMap::pop_first(self : FlatMultiMap[K, V]) -> (K, V)? {
  if self.entries.length() == 0 {
    None
  } else {
    Some(self.entries.remove(0))
  }
}

///|
/// Removes and returns the largest entry.
pub fn[K, V] FlatMultiMap::pop_last(self : FlatMultiMap[K, V]) -> (K, V)? {
  self.entries.pop()
}

///|
/// Every entry in key order, and within one key in value order.
pub fn[K, V] FlatMultiMap::iter(self : FlatMultiMap[K, V]) -> Iter[(K, V)] {
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
pub fn[K, V] FlatMultiMap::length(self : FlatMultiMap[K, V]) -> Int32 {
  self.entries.length()
}

///|
/// The number of distinct keys.
pub fn[K : Compare, V] FlatMultiMap::key_count(
  self : FlatMultiMap[K, V],
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
pub fn[K, V] FlatMultiMap::is_empty(self : FlatMultiMap[K, V]) -> Bool {
  self.entries.length() == 0
}

///|
/// Removes every entry, keeping the room the run has.
pub fn[K, V] FlatMultiMap::clear(self : FlatMultiMap[K, V]) -> Unit {
  self.entries.clear()
}

///|
/// A copy that owns its array: a change to either multimap is invisible to the other.
pub fn[K, V] FlatMultiMap::copy(
  self : FlatMultiMap[K, V],
) -> FlatMultiMap[K, V] {
  { entries: self.entries.copy(), }
}

///|
/// Every entry in key order, as a new array.
pub fn[K, V] FlatMultiMap::to_array(self : FlatMultiMap[K, V]) -> Array[(K, V)] {
  self.entries.copy()
}

///|
pub impl[K : Eq, V : Eq] Eq for FlatMultiMap[K, V] with fn equal(self, other) {
  self.entries == other.entries
}

///|
pub extend FlatMultiMap with Eq::{equal, not_equal}

///|
pub impl[K : Show, V : Show] Show for FlatMultiMap[K, V] with fn output(
  self,
  logger,
) {
  logger.write_string("[")
  for i, entry in self.entries {
    if i > 0 {
      logger.write_string(", ")
    }
    logger.write_string("(")
    entry.0.output(logger)
    logger.write_string(", ")
    entry.1.output(logger)
    logger.write_string(")")
  }
  logger.write_string("]")
}

///|
pub extend FlatMultiMap with Show::{to_string, output}
