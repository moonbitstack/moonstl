///|
/// The slot a key lands in, given its hash and the bucket's displacement.
fn slot_for(layout : PhfLayout, hash : UInt64, bucket : Int32) -> Int32 {
  phf_slot(hash, layout.disps[bucket], layout.table_len)
}

///|
/// A table whose hash was computed while it was built, so a lookup is one hash,
/// one displacement table read and one comparison — there is no probe sequence
/// to walk and no cluster to fall into. The layout is a value, which is what
/// lets a generated module carry one as a literal; `from_layout` re-derives
/// every slot from the keys and refuses a layout that does not fit them.
///
/// ```mbt check
/// test {
///   let builder : @phf.PhfBuilder[String, Int32] = @phf.PhfBuilder::new()
///   builder.entry("a", 1)
///   builder.entry("b", 2)
///   let table = builder.build()
///   assert_true(table.get("a") == Some(1))
///   assert_true(table.get("b") == Some(2))
///   assert_true(table.get("c") == None)
///   assert_true(table.length() == 2)
/// }
/// ```
pub struct PhfMap[K, V] {
  layout : PhfLayout
  keys : Array[K]
  values : Array[V]
  index : PhfIndex
}

///|
/// Rebuilds the slot table from the keys and checks that the layout describes
/// them: the entries are taken in declaration order, so their indices are the
/// ones a built table would have.
fn[K : PhfKey, V] build_index(
  layout : PhfLayout,
  entries : Array[(K, V)],
) -> PhfIndex raise @spec.Refused {
  let owner = FixedArray::make(layout.table_len, -1)
  for i, entry in entries {
    let hash = phf_hash(PhfKey::to_bytes(entry.0), layout.salt)
    let bucket = phf_bucket(hash, layout.buckets)
    let slot = slot_for(layout, hash, bucket)
    if slot < 0 || slot >= layout.table_len || owner[slot] >= 0 {
      raise @spec.Refused::Incompatible
    }
    owner[slot] = i
  }
  make_index(owner, layout)
}

///|
/// A table from a layout and its entries. The entries are hashed again, so a
/// layout that does not describe them — a stale generated table, a hand-written
/// literal that drifted — is refused instead of answering wrongly.
pub fn[K : PhfKey, V] PhfMap::from_layout(
  layout : PhfLayout,
  entries : Array[(K, V)],
) -> PhfMap[K, V] raise @spec.Refused {
  if layout.length != entries.length() {
    raise @spec.Refused::Incompatible
  }
  let index = build_index(layout, entries)
  let keys : Array[K] = []
  let values : Array[V] = []
  for entry in entries {
    keys.push(entry.0)
    values.push(entry.1)
  }
  { layout, keys, values, index, }
}

///|
pub fn[K : PhfKey + Eq, V] PhfMap::get(self : PhfMap[K, V], key : K) -> V? {
  self.get_entry(key).map(entry => entry.1)
}

///|
/// The key and the value under `key`, which hands back the key the table
/// actually holds.
pub fn[K : PhfKey + Eq, V] PhfMap::get_key_value(
  self : PhfMap[K, V],
  key : K,
) -> (K, V)? {
  self.get_entry(key)
}

///|
/// Where `key` sits among the entries, which is also the position it was
/// declared in.
fn[K : PhfKey + Eq, V] PhfMap::position(self : PhfMap[K, V], key : K) -> Int32? {
  let hash = phf_hash(PhfKey::to_bytes(key), self.layout.salt)
  let bucket = phf_bucket(hash, self.layout.buckets)
  let slot = slot_for(self.layout, hash, bucket)
  match self.index.lookup(slot) {
    Some(at) if self.keys[at] == key => Some(at)
    _ => None
  }
}

///|
fn[K : PhfKey + Eq, V] PhfMap::get_entry(
  self : PhfMap[K, V],
  key : K,
) -> (K, V)? {
  self.position(key).map(at => (self.keys[at], self.values[at]))
}

///|
pub fn[K : PhfKey + Eq, V] PhfMap::contains(
  self : PhfMap[K, V],
  key : K,
) -> Bool {
  self.get_entry(key) is Some(_)
}

///|
pub fn[K : PhfKey + Eq, V] PhfMap::get_key(self : PhfMap[K, V], key : K) -> K? {
  match self.get_entry(key) {
    Some(entry) => Some(entry.0)
    None => None
  }
}

///|
/// The entry at a stored index, which is the order the builder took the entries
/// in.
pub fn[K, V] PhfMap::get_index(self : PhfMap[K, V], index : Int32) -> (K, V)? {
  if index < 0 || index >= self.keys.length() {
    None
  } else {
    Some((self.keys[index], self.values[index]))
  }
}

///|
pub fn[K, V] PhfMap::keys(self : PhfMap[K, V]) -> Iter[K] {
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
pub fn[K, V] PhfMap::values(self : PhfMap[K, V]) -> Iter[V] {
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
pub fn[K, V] PhfMap::iter(self : PhfMap[K, V]) -> Iter[(K, V)] {
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
pub fn[K, V] PhfMap::length(self : PhfMap[K, V]) -> Int32 {
  self.keys.length()
}

///|
pub fn[K, V] PhfMap::is_empty(self : PhfMap[K, V]) -> Bool {
  self.keys.length() == 0
}

///|
pub fn[K, V] PhfMap::layout(self : PhfMap[K, V]) -> PhfLayout {
  copy_layout(self.layout)
}

///|
pub fn[K, V] PhfMap::copy(self : PhfMap[K, V]) -> PhfMap[K, V] {
  {
    layout: copy_layout(self.layout),
    keys: self.keys.copy(),
    values: self.values.copy(),
    index: self.index,
  }
}

///|
/// Builds a perfect hash table from the entries it is given. A key may appear
/// once: the second `entry` for the same key is refused, because a table with
/// two entries in one bucket would have no displacement that places both.
///
/// ```mbt check
/// test {
///   let builder : @phf.PhfBuilder[String, Int32] = @phf.PhfBuilder::new()
///   builder.entry("x", 1)
///   let refused = try {
///     builder.entry("x", 2)
///     Ok(())
///   } catch {
///     @spec.Refused::DuplicateValue => Err(true)
///     _ => Err(false)
///   }
///   assert_true(refused == Err(true))
/// }
/// ```
pub struct PhfBuilder[K, V] {
  options : PhfOptions
  keys : Array[K]
  values : Array[V]
  seen : Map[Bytes, Unit]
}

///|
pub fn[K, V] PhfBuilder::new(
  phf_options~ : PhfOptions = phf_options,
) -> PhfBuilder[K, V] {
  { options: phf_options, keys: [], values: [], seen: Map([]), }
}

///|
pub fn[K : PhfKey, V] PhfBuilder::entry(
  self : PhfBuilder[K, V],
  key : K,
  value : V,
) -> Unit raise @spec.Refused {
  let bytes = PhfKey::to_bytes(key)
  if self.seen.contains(bytes) {
    raise @spec.Refused::DuplicateValue
  }
  self.seen.set(bytes, ())
  self.keys.push(key)
  self.values.push(value)
}

///|
/// The table. The search is deterministic for a fixed seed and entry order, so
/// the same entries give the same layout on every machine and every backend.
pub fn[K : PhfKey, V] PhfBuilder::build(
  self : PhfBuilder[K, V],
) -> PhfMap[K, V] raise @spec.Refused {
  let key_bytes : Array[Bytes] = []
  for key in self.keys {
    key_bytes.push(PhfKey::to_bytes(key))
  }
  let layout = match
    search_layout(key_bytes, self.options.build, self.options.seed) {
    Some(layout) => layout
    None => raise @spec.Refused::TooMany(limit=self.keys.length())
  }
  let entries : Array[(K, V)] = []
  for i in 0..<self.keys.length() {
    entries.push((self.keys[i], self.values[i]))
  }
  PhfMap::from_layout(layout, entries)
}

///|
pub fn[K, V] PhfBuilder::length(self : PhfBuilder[K, V]) -> Int32 {
  self.keys.length()
}

///|
/// The table as MoonBit source: the layout literal and the entries, so a
/// generated module compiles the table in instead of building it at start-up.
pub fn[K : PhfKey + Show, V : Show] PhfBuilder::build_source(
  self : PhfBuilder[K, V],
  name~ : String,
) -> String raise @spec.Refused {
  let table = self.build()
  let layout = table.layout
  let mut out = "@phf.PhfMap::from_layout(\{name}_layout, ["
  let mut first = true
  for entry in table.iter() {
    if !first {
      out = out + ", "
    }
    first = false
    out = out +
      "(" +
      Show::to_string(entry.0) +
      ", " +
      Show::to_string(entry.1) +
      ")"
  }
  out = out + "])"
  let header = "let \{name}_layout : @phf.PhfLayout = { build: \{layout.build}, salt: \{layout.salt}, buckets: \{layout.buckets}, table_len: \{layout.table_len}, length: \{layout.length}, disps: [" +
    disps_source(layout.disps) +
    "] }\n"
  header + out
}

///|
fn disps_source(disps : Array[Int32]) -> String {
  let mut out = ""
  for i, value in disps {
    if i > 0 {
      out = out + ", "
    }
    out = out + value.to_string()
  }
  out
}

///|
/// A set with the same layout as `PhfMap`, holding only the keys.
///
/// ```mbt check
/// test {
///   let builder : @phf.PhfBuilder[String, Unit] = @phf.PhfBuilder::new()
///   builder.entry("in", ())
///   let set = builder.build_set()
///   assert_true(set.contains("in"))
///   assert_true(!set.contains("out"))
/// }
/// ```
pub struct PhfSet[K] {
  map : PhfMap[K, Unit]
}

///|
pub fn[K : PhfKey, V] PhfBuilder::build_set(
  self : PhfBuilder[K, V],
) -> PhfSet[K] raise @spec.Refused {
  let map = self.build()
  let entries : Array[(K, Unit)] = []
  for key in map.keys() {
    entries.push((key, ()))
  }
  { map: PhfMap::from_layout(map.layout, entries), }
}

///|
/// A set from a layout and its keys, refused when the layout does not describe
/// them; what `#phf.set` generates.
pub fn[K : PhfKey] PhfSet::from_layout(
  layout : PhfLayout,
  keys : Array[K],
) -> PhfSet[K] raise @spec.Refused {
  { map: PhfMap::from_layout(layout, keys.map(key => (key, ()))), }
}

///|
pub fn[K : PhfKey + Eq] PhfSet::contains(self : PhfSet[K], key : K) -> Bool {
  self.map.contains(key)
}

///|
pub fn[K] PhfSet::iter(self : PhfSet[K]) -> Iter[K] {
  self.map.keys()
}

///|
pub fn[K] PhfSet::length(self : PhfSet[K]) -> Int32 {
  self.map.length()
}

///|
pub fn[K] PhfSet::is_empty(self : PhfSet[K]) -> Bool {
  self.map.is_empty()
}

///|
pub fn[K] PhfSet::get_index(self : PhfSet[K], index : Int32) -> K? {
  match self.map.get_index(index) {
    Some(entry) => Some(entry.0)
    None => None
  }
}

///|
/// A map that also reports the position its key was declared in, which is what
/// a generated table wants when the order in the source is the order a reader
/// should see.
///
/// ```mbt check
/// test {
///   let builder : @phf.PhfBuilder[String, Int32] = @phf.PhfBuilder::new()
///   builder.entry("b", 2)
///   builder.entry("a", 1)
///   let table = builder.build_ordered()
///   assert_true(table.index("b") == Some(0))
///   assert_true(table.index("a") == Some(1))
///   assert_true(table.get("a") == Some(1))
/// }
/// ```
pub struct PhfOrderedMap[K, V] {
  map : PhfMap[K, V]
}

///|
pub fn[K : PhfKey, V] PhfBuilder::build_ordered(
  self : PhfBuilder[K, V],
) -> PhfOrderedMap[K, V] raise @spec.Refused {
  { map: self.build(), }
}

///|
/// An ordered map from a layout and its entries in declaration order, refused
/// when the layout does not describe them; what `#phf.ordered_map` generates.
pub fn[K : PhfKey, V] PhfOrderedMap::from_layout(
  layout : PhfLayout,
  entries : Array[(K, V)],
) -> PhfOrderedMap[K, V] raise @spec.Refused {
  { map: PhfMap::from_layout(layout, entries), }
}

///|
pub fn[K : PhfKey + Eq, V] PhfOrderedMap::get(
  self : PhfOrderedMap[K, V],
  key : K,
) -> V? {
  self.map.get(key)
}

///|
pub fn[K : PhfKey + Eq, V] PhfOrderedMap::contains(
  self : PhfOrderedMap[K, V],
  key : K,
) -> Bool {
  self.map.contains(key)
}

///|
/// The declaration position of `key`.
pub fn[K : PhfKey + Eq, V] PhfOrderedMap::index(
  self : PhfOrderedMap[K, V],
  key : K,
) -> Int32? {
  self.map.position(key)
}

///|
pub fn[K, V] PhfOrderedMap::get_index(
  self : PhfOrderedMap[K, V],
  index : Int32,
) -> (K, V)? {
  self.map.get_index(index)
}

///|
pub fn[K, V] PhfOrderedMap::iter(self : PhfOrderedMap[K, V]) -> Iter[(K, V)] {
  self.map.iter()
}

///|
pub fn[K, V] PhfOrderedMap::keys(self : PhfOrderedMap[K, V]) -> Iter[K] {
  self.map.keys()
}

///|
pub fn[K, V] PhfOrderedMap::values(self : PhfOrderedMap[K, V]) -> Iter[V] {
  self.map.values()
}

///|
pub fn[K, V] PhfOrderedMap::length(self : PhfOrderedMap[K, V]) -> Int32 {
  self.map.length()
}

///|
pub fn[K, V] PhfOrderedMap::is_empty(self : PhfOrderedMap[K, V]) -> Bool {
  self.map.is_empty()
}

///|
/// A set whose elements keep the order they were declared in.
pub struct PhfOrderedSet[K] {
  map : PhfMap[K, Unit]
}

///|
pub fn[K : PhfKey, V] PhfBuilder::build_ordered_set(
  self : PhfBuilder[K, V],
) -> PhfOrderedSet[K] raise @spec.Refused {
  { map: self.build_set().map, }
}

///|
/// An ordered set from a layout and its keys in declaration order, refused when
/// the layout does not describe them; what `#phf.ordered_set` generates.
pub fn[K : PhfKey] PhfOrderedSet::from_layout(
  layout : PhfLayout,
  keys : Array[K],
) -> PhfOrderedSet[K] raise @spec.Refused {
  { map: PhfMap::from_layout(layout, keys.map(key => (key, ()))), }
}

///|
pub fn[K : PhfKey + Eq] PhfOrderedSet::contains(
  self : PhfOrderedSet[K],
  key : K,
) -> Bool {
  self.map.contains(key)
}

///|
pub fn[K : PhfKey + Eq] PhfOrderedSet::index(
  self : PhfOrderedSet[K],
  key : K,
) -> Int32? {
  self.map.position(key)
}

///|
pub fn[K] PhfOrderedSet::get_index(
  self : PhfOrderedSet[K],
  index : Int32,
) -> K? {
  match self.map.get_index(index) {
    Some(entry) => Some(entry.0)
    None => None
  }
}

///|
pub fn[K] PhfOrderedSet::iter(self : PhfOrderedSet[K]) -> Iter[K] {
  self.map.keys()
}

///|
pub fn[K] PhfOrderedSet::length(self : PhfOrderedSet[K]) -> Int32 {
  self.map.length()
}

///|
pub fn[K] PhfOrderedSet::is_empty(self : PhfOrderedSet[K]) -> Bool {
  self.map.is_empty()
}
