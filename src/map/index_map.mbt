///|
/// An associative container that keeps insertion order and gives every entry a
/// position: `get_index` reads by position, `get_index_of` reads the position of
/// a key, and the entries can be reordered without touching the table's
/// contents. `swap_remove` is the default removal because it is O(1); a caller
/// that needs the remaining positions to stay contiguous uses `shift_remove`.
///
/// ```mbt check
/// test {
///   let map : @map.IndexMap[String, Int32] = @map.IndexMap::new()
///   let _ = map.set("a", 1)
///   let _ = map.set("b", 2)
///   @test.assert_eq(map.get_index_of("b"), Some(1))
///   @test.assert_eq(map.get_index(0), Some(("a", 1)))
///   let _ = map.swap_remove("a")
///   @test.assert_eq(map.get_index(0), Some(("b", 2)))
/// }
/// ```
pub struct IndexMap[K, V] {
  /// The entries, dense and in position order.
  mut entries : Array[(K, V)]
  /// The hash of each entry, kept beside it so a reorder never rehashes.
  mut hashes : Array[Int32]
  /// The open-addressed table: a slot holds an entry index, or one of the two
  /// markers above.
  mut slots : Array[Int32]
  /// Where each entry sits in the table, so a swap or a shift can repoint one
  /// entry without a search.
  mut slot_of : Array[Int32]
  mut live : Int32
  mut graves : Int32
  seed : Int32
}

///|
/// A table with room for `capacity` entries, laid out from `hash_seed`. A fixed
/// seed makes the layout, and with it nothing visible, reproducible; the order
/// of the entries does not depend on it.
pub fn[K, V] IndexMap::new(
  capacity~ : Int32 = 0,
  hash_seed~ : Int32 = @spec.hash_seed(),
) -> IndexMap[K, V] {
  let buckets = bucket_count(if capacity > 0 { capacity * 2 } else { 8 })
  {
    entries: [],
    hashes: [],
    slots: Array::make(buckets, slot_free),
    slot_of: [],
    live: 0,
    graves: 0,
    seed: hash_seed,
  }
}

///|
pub fn[K : Hash + Eq, V] IndexMap::from_array(
  entries : ArrayView[(K, V)],
  hash_seed~ : Int32 = @spec.hash_seed(),
) -> IndexMap[K, V] {
  let map : IndexMap[K, V] = IndexMap::new(
    capacity=entries.length(),
    hash_seed~,
  )
  for entry in entries {
    let _ = map.set(entry.0, entry.1)
  }
  map
}

///|
pub fn[K : Hash + Eq, V] IndexMap::from_iter(
  entries : Iter[(K, V)],
  hash_seed~ : Int32 = @spec.hash_seed(),
) -> IndexMap[K, V] {
  let map : IndexMap[K, V] = IndexMap::new(hash_seed~)
  for entry in entries {
    let _ = map.set(entry.0, entry.1)
  }
  map
}

///|
/// The entry index of `key`, or `None`. Probing continues past a dead slot,
/// because a key inserted into a reused slot sits behind one.
fn[K : Hash + Eq, V] IndexMap::find(self : IndexMap[K, V], key : K) -> Int32? {
  let mask = self.slots.length() - 1
  let hash = hash_seeded(key, self.seed)
  let mut i = hash & mask
  while true {
    let entry = self.slots[i]
    if entry == slot_free {
      return None
    }
    if entry >= 0 && self.hashes[entry] == hash && self.entries[entry].0 == key {
      return Some(entry)
    }
    i = (i + 1) & mask
  }
  None
}

///|
/// Rebuilds the table from the entries. Called after a reorder, and when the
/// dead slots outnumber the live ones.
fn[K, V] IndexMap::rebuild(self : IndexMap[K, V]) -> Unit {
  let buckets = bucket_count(
    if self.entries.length() == 0 {
      8
    } else {
      self.entries.length() * 2
    },
  )
  self.slots = Array::make(buckets, slot_free)
  self.slot_of = Array::make(self.entries.length(), -1)
  self.live = 0
  self.graves = 0
  let mask = buckets - 1
  for index in 0..<self.entries.length() {
    let hash = self.hashes[index]
    let mut slot = hash & mask
    while self.slots[slot] != slot_free {
      slot = (slot + 1) & mask
    }
    self.slots[slot] = index
    self.slot_of[index] = slot
    self.live = self.live + 1
  }
}

///|
/// The entry index of `key` after storing `value` there, and the value that was
/// there before. The position of an existing entry does not change.
pub fn[K : Hash + Eq, V] IndexMap::insert_full(
  self : IndexMap[K, V],
  key : K,
  value : V,
) -> (Int32, V?) {
  match self.find(key) {
    Some(index) => {
      let old = self.entries[index].1
      let held = self.entries[index].0
      self.entries[index] = (held, value)
      (index, Some(old))
    }
    None => {
      if (self.live + self.graves + 1) * 4 >= self.slots.length() * 3 {
        self.rebuild()
      }
      let hash = hash_seeded(key, self.seed)
      let mask = self.slots.length() - 1
      let mut slot = hash & mask
      let mut dead = -1
      while true {
        let entry = self.slots[slot]
        if entry == slot_free {
          break
        }
        if entry == slot_dead && dead < 0 {
          dead = slot
        }
        slot = (slot + 1) & mask
      }
      let chosen = if dead >= 0 { dead } else { slot }
      let index = self.entries.length()
      self.entries.push((key, value))
      self.hashes.push(hash)
      self.slot_of.push(chosen)
      self.slots[chosen] = index
      if dead >= 0 {
        self.graves = self.graves - 1
      }
      self.live = self.live + 1
      (index, None)
    }
  }
}

///|
/// Stores `value` under `key` and returns the value it replaced.
pub fn[K : Hash + Eq, V] IndexMap::set(
  self : IndexMap[K, V],
  key : K,
  value : V,
) -> V? {
  let (_, old) = self.insert_full(key, value)
  old
}

///|
/// Replaces the value of an entry that is already there, and reports whether
/// there was one.
pub fn[K : Hash + Eq, V] IndexMap::update(
  self : IndexMap[K, V],
  key : K,
  f : (V) -> V,
) -> Bool {
  match self.find(key) {
    Some(index) => {
      let held = self.entries[index].0
      self.entries[index] = (held, f(self.entries[index].1))
      true
    }
    None => false
  }
}

///|
/// Stores `value` under `key` only when the key is new, which is how a caller
/// keeps the first value written.
pub fn[K : Hash + Eq, V] IndexMap::set_default(
  self : IndexMap[K, V],
  key : K,
  value : V,
) -> V {
  match self.find(key) {
    Some(index) => self.entries[index].1
    None => {
      let _ = self.insert_full(key, value)
      value
    }
  }
}

///|
pub fn[K : Hash + Eq, V] IndexMap::get(self : IndexMap[K, V], key : K) -> V? {
  match self.find(key) {
    Some(index) => Some(self.entries[index].1)
    None => None
  }
}

///|
/// The key and the value of an entry, which unlike `get` hands back the key the
/// map actually holds.
pub fn[K : Hash + Eq, V] IndexMap::get_key_value(
  self : IndexMap[K, V],
  key : K,
) -> (K, V)? {
  match self.find(key) {
    Some(index) => Some(self.entries[index])
    None => None
  }
}

///|
pub fn[K : Hash + Eq, V] IndexMap::contains(
  self : IndexMap[K, V],
  key : K,
) -> Bool {
  self.find(key) is Some(_)
}

///|
pub fn[K, V] IndexMap::get_index(
  self : IndexMap[K, V],
  index : Int32,
) -> (K, V)? {
  self.entries.get(index)
}

///|
pub fn[K : Hash + Eq, V] IndexMap::get_index_of(
  self : IndexMap[K, V],
  key : K,
) -> Int32? {
  self.find(key)
}

///|
pub fn[K : Hash + Eq, V] IndexMap::get_full(
  self : IndexMap[K, V],
  key : K,
) -> (Int32, K, V)? {
  match self.find(key) {
    Some(index) => {
      let (held, value) = self.entries[index]
      Some((index, held, value))
    }
    None => None
  }
}

///|
/// Removes the entry at `index` by moving the last entry into its place, and
/// returns it. The entry that moved keeps its key and takes the removed
/// position.
pub fn[K, V] IndexMap::swap_remove_index(
  self : IndexMap[K, V],
  index : Int32,
) -> (K, V)? {
  let size = self.entries.length()
  if index < 0 || index >= size {
    return None
  }
  let removed = self.entries[index]
  let dead = self.slot_of[index]
  let last = size - 1
  if index != last {
    self.entries[index] = self.entries[last]
    self.hashes[index] = self.hashes[last]
    self.slot_of[index] = self.slot_of[last]
    self.slots[self.slot_of[index]] = index
  }
  let _ = self.entries.pop()
  let _ = self.hashes.pop()
  let _ = self.slot_of.pop()
  self.slots[dead] = slot_dead
  self.live = self.live - 1
  self.graves = self.graves + 1
  Some(removed)
}

///|
/// Removes the entry at `index` and closes the gap, so every entry after it
/// moves down one position.
pub fn[K, V] IndexMap::shift_remove_index(
  self : IndexMap[K, V],
  index : Int32,
) -> (K, V)? {
  let size = self.entries.length()
  if index < 0 || index >= size {
    return None
  }
  let removed = self.entries[index]
  let dead = self.slot_of[index]
  for i in index..<(size - 1) {
    self.entries[i] = self.entries[i + 1]
    self.hashes[i] = self.hashes[i + 1]
    self.slot_of[i] = self.slot_of[i + 1]
    self.slots[self.slot_of[i]] = i
  }
  let _ = self.entries.pop()
  let _ = self.hashes.pop()
  let _ = self.slot_of.pop()
  self.slots[dead] = slot_dead
  self.live = self.live - 1
  self.graves = self.graves + 1
  Some(removed)
}

///|
pub fn[K : Hash + Eq, V] IndexMap::remove(self : IndexMap[K, V], key : K) -> V? {
  match self.find(key) {
    Some(index) => {
      let (_, value) = self.swap_remove_index(index).unwrap()
      Some(value)
    }
    None => None
  }
}

///|
pub fn[K : Hash + Eq, V] IndexMap::swap_remove(
  self : IndexMap[K, V],
  key : K,
) -> V? {
  self.remove(key)
}

///|
pub fn[K : Hash + Eq, V] IndexMap::shift_remove(
  self : IndexMap[K, V],
  key : K,
) -> V? {
  match self.find(key) {
    Some(index) => {
      let (_, value) = self.shift_remove_index(index).unwrap()
      Some(value)
    }
    None => None
  }
}

///|
/// Moves the entry at `from` to `to`, shifting everything between them.
pub fn[K, V] IndexMap::move_index(
  self : IndexMap[K, V],
  from : Int32,
  to : Int32,
) -> Unit {
  let size = self.entries.length()
  if from < 0 || from >= size || to < 0 || to >= size || from == to {
    return
  }
  let entry = self.entries[from]
  let hash = self.hashes[from]
  if from < to {
    for i in from..<to {
      self.entries[i] = self.entries[i + 1]
      self.hashes[i] = self.hashes[i + 1]
      self.slot_of[i] = self.slot_of[i + 1]
      self.slots[self.slot_of[i]] = i
    }
  } else {
    let mut i = from
    while i > to {
      self.entries[i] = self.entries[i - 1]
      self.hashes[i] = self.hashes[i - 1]
      self.slot_of[i] = self.slot_of[i - 1]
      self.slots[self.slot_of[i]] = i
      i = i - 1
    }
  }
  self.entries[to] = entry
  self.hashes[to] = hash
  self.rebuild()
}

///|
pub fn[K, V] IndexMap::swap_indices(
  self : IndexMap[K, V],
  a : Int32,
  b : Int32,
) -> Unit {
  let size = self.entries.length()
  if a < 0 || a >= size || b < 0 || b >= size || a == b {
    return
  }
  let entry = self.entries[a]
  let hash = self.hashes[a]
  self.entries[a] = self.entries[b]
  self.hashes[a] = self.hashes[b]
  self.entries[b] = entry
  self.hashes[b] = hash
  let slot_a = self.slot_of[a]
  let slot_b = self.slot_of[b]
  self.slot_of[a] = slot_b
  self.slot_of[b] = slot_a
  self.slots[self.slot_of[a]] = a
  self.slots[self.slot_of[b]] = b
}

///|
fn[K, V] IndexMap::resort(
  self : IndexMap[K, V],
  cmp : ((K, V), (K, V)) -> Int32,
) -> Unit {
  let items : Array[((K, V), Int32)] = []
  for i in 0..<self.entries.length() {
    items.push((self.entries[i], self.hashes[i]))
  }
  items.sort_by((a, b) => cmp(a.0, b.0))
  for i in 0..<items.length() {
    self.entries[i] = items[i].0
    self.hashes[i] = items[i].1
  }
  self.rebuild()
}

///|
/// Sorts the entries by key and renumbers the positions.
pub fn[K : Compare, V] IndexMap::sort_keys(self : IndexMap[K, V]) -> Unit {
  self.resort((a, b) => a.0.compare(b.0))
}

///|
pub fn[K, V] IndexMap::sort_by(
  self : IndexMap[K, V],
  cmp : ((K, V), (K, V)) -> Int32,
) -> Unit {
  self.resort(cmp)
}

///|
pub fn[K, V, R : Compare] IndexMap::sort_by_key(
  self : IndexMap[K, V],
  project~ : (K) -> R,
) -> Unit {
  self.resort((a, b) => project(a.0).compare(project(b.0)))
}

///|
/// The entries from `start` for `len` positions, clamped to the container.
pub fn[K, V] IndexMap::range(
  self : IndexMap[K, V],
  start~ : Int32,
  len~ : Int32,
) -> Iter[(K, V)] {
  let from = if start < 0 { 0 } else { start }
  let size = self.entries.length()
  let stop = if from >= size {
    from
  } else if len < 0 {
    from
  } else if from + len > size {
    size
  } else {
    from + len
  }
  let mut cursor = from
  Iter::new(() => {
    if cursor >= stop {
      None
    } else {
      let entry = self.entries[cursor]
      cursor = cursor + 1
      Some(entry)
    }
  })
}

///|
pub fn[K, V] IndexMap::iter(self : IndexMap[K, V]) -> Iter[(K, V)] {
  self.range(start=0, len=self.entries.length())
}

///|
pub fn[K, V] IndexMap::iter2(self : IndexMap[K, V]) -> Iter2[K, V] {
  let walk = self.iter()
  Iter2::new(() => walk.next(), size_hint=self.length())
}

///|
pub fn[K, V] IndexMap::keys(self : IndexMap[K, V]) -> Iter[K] {
  self.iter().map(entry => entry.0)
}

///|
pub fn[K, V] IndexMap::values(self : IndexMap[K, V]) -> Iter[V] {
  self.iter().map(entry => entry.1)
}

///|
pub fn[K, V] IndexMap::length(self : IndexMap[K, V]) -> Int32 {
  self.entries.length()
}

///|
pub fn[K, V] IndexMap::is_empty(self : IndexMap[K, V]) -> Bool {
  self.entries.length() == 0
}

///|
/// The number of slots the table has, which is what `reserve_capacity` raises.
pub fn[K, V] IndexMap::capacity(self : IndexMap[K, V]) -> Int32 {
  self.slots.length()
}

///|
pub fn[K, V] IndexMap::reserve_capacity(
  self : IndexMap[K, V],
  capacity~ : Int32,
) -> Unit {
  if capacity > 0 && capacity * 2 > self.slots.length() {
    let wanted = bucket_count(capacity * 2)
    let buckets = if wanted > self.slots.length() {
      wanted
    } else {
      self.slots.length() * 2
    }
    self.slots = Array::make(buckets, slot_free)
    self.slot_of = Array::make(self.entries.length(), -1)
    self.live = 0
    self.graves = 0
    let mask = buckets - 1
    for index in 0..<self.entries.length() {
      let hash = self.hashes[index]
      let mut slot = hash & mask
      while self.slots[slot] != slot_free {
        slot = (slot + 1) & mask
      }
      self.slots[slot] = index
      self.slot_of[index] = slot
      self.live = self.live + 1
    }
  }
}

///|
pub fn[K, V] IndexMap::shrink_to_fit(self : IndexMap[K, V]) -> Unit {
  self.rebuild()
}

///|
pub fn[K, V] IndexMap::clear(self : IndexMap[K, V]) -> Unit {
  self.entries.clear()
  self.hashes.clear()
  self.slot_of.clear()
  self.slots = Array::make(8, slot_free)
  self.live = 0
  self.graves = 0
}

///|
/// Keeps the entries the predicate accepts, in their order, and renumbers the
/// positions when any were dropped.
pub fn[K, V] IndexMap::retain(
  self : IndexMap[K, V],
  f : (K, V) -> Bool,
) -> Unit {
  let kept : Array[(K, V)] = []
  let kept_hashes : Array[Int32] = []
  for i in 0..<self.entries.length() {
    if f(self.entries[i].0, self.entries[i].1) {
      kept.push(self.entries[i])
      kept_hashes.push(self.hashes[i])
    }
  }
  if kept.length() != self.entries.length() {
    self.entries = kept
    self.hashes = kept_hashes
    self.rebuild()
  }
}

///|
pub fn[K, V] IndexMap::truncate(self : IndexMap[K, V], length : Int32) -> Unit {
  let keep = if length < 0 { 0 } else { length }
  if keep >= self.entries.length() {
    return
  }
  while self.entries.length() > keep {
    let _ = self.entries.pop()
    let _ = self.hashes.pop()
    let _ = self.slot_of.pop()
  }
  self.rebuild()
}

///|
/// The entries from `at` on, as a new map; this map keeps the ones before it.
pub fn[K : Hash + Eq, V] IndexMap::split_off(
  self : IndexMap[K, V],
  at : Int32,
) -> IndexMap[K, V] {
  let tail : IndexMap[K, V] = IndexMap::new(hash_seed=self.seed)
  let size = self.entries.length()
  let cut = if at < 0 { 0 } else if at > size { size } else { at }
  for i in cut..<size {
    let _ = tail.set(self.entries[i].0, self.entries[i].1)
  }
  self.truncate(cut)
  tail
}

///|
pub fn[K, V] IndexMap::copy(self : IndexMap[K, V]) -> IndexMap[K, V] {
  {
    entries: self.entries.copy(),
    hashes: self.hashes.copy(),
    slots: self.slots.copy(),
    slot_of: self.slot_of.copy(),
    live: self.live,
    graves: self.graves,
    seed: self.seed,
  }
}

///|
pub fn[K, V] IndexMap::to_array(self : IndexMap[K, V]) -> Array[(K, V)] {
  self.entries.copy()
}

///|
pub impl[K : Eq, V : Eq] Eq for IndexMap[K, V] with fn equal(self, other) {
  if self.length() != other.length() {
    return false
  }
  for i in 0..<self.length() {
    if !self.entries[i].equal(other.entries[i]) {
      return false
    }
  }
  true
}

///|
pub extend IndexMap with Eq::{equal, not_equal}

///|
/// Order matters: two maps with the same pairs in a different order hash
/// differently, as they compare unequal.
pub impl[K : Hash, V : Hash] Hash for IndexMap[K, V] with fn hash_combine(
  self,
  hasher,
) {
  for entry in self.iter() {
    Hash::hash_combine(entry.0, hasher)
    Hash::hash_combine(entry.1, hasher)
  }
}

///|
pub extend IndexMap with Hash::{hash, hash_combine}

///|
pub impl[K : Show, V : Show] Show for IndexMap[K, V] with fn output(
  self,
  logger,
) {
  logger.write_string("{")
  let mut first = true
  for entry in self.iter() {
    if !first {
      logger.write_string(", ")
    }
    first = false
    entry.0.output(logger)
    logger.write_string(": ")
    entry.1.output(logger)
  }
  logger.write_string("}")
}

///|
pub extend IndexMap with Show::{to_string, output}

///|
pub impl[K : ToJson, V : ToJson] ToJson for IndexMap[K, V] with fn to_json(self) {
  let pairs : Array[Json] = []
  for entry in self.iter() {
    pairs.push(Json::array([Json(entry.0), Json(entry.1)]))
  }
  Json::array(pairs)
}

///|
pub extend IndexMap with ToJson::{to_json}

///|
pub impl[K : Hash + Eq + FromJson, V : FromJson] FromJson for IndexMap[K, V] with fn from_json(
  json,
  path,
) {
  guard json is Json::Array(items) else {
    raise JsonDecodeError((path, "IndexMap: expected an array of pairs"))
  }
  let map : IndexMap[K, V] = IndexMap::new()
  for i, item in items {
    guard item is Json::Array(pair) && pair.length() == 2 else {
      raise JsonDecodeError((path.add_index(i), "IndexMap: expected a pair"))
    }
    let key : K = FromJson::from_json(pair[0], path.add_index(i))
    let value : V = FromJson::from_json(pair[1], path.add_index(i))
    let _ = map.set(key, value)
  }
  map
}

///|
pub extend IndexMap with FromJson::{from_json}
