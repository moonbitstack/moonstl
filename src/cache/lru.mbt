///|
/// A node of one of the order lists. The slot array is indexed by a slab-style
/// handle; a free slot holds `None`, so a stale handle cannot be mistaken for a
/// live one.
pub struct LruNode[K, V] {
  key : K
  mut value : V
  mut prev : Int32
  mut next : Int32
}

///|
/// A least-recently-used cache with a fixed capacity: `get` marks an entry as
/// the most recent, and an insert past the capacity drops the entry that has
/// gone untouched the longest.
///
/// ```mbt check
/// test {
///   let cache : @cache.LruCache[String, Int32] = @cache.LruCache::new(capacity=2)
///   let _ = cache.set("a", 1)
///   let _ = cache.set("b", 2)
///   let _ = cache.get("a")
///   let _ = cache.set("c", 3)
///   @test.assert_eq(cache.get("b"), None)
///   @test.assert_eq(cache.get("a"), Some(1))
/// }
/// ```
pub struct LruCache[K, V] {
  index : @map.IndexMap[K, Int32]
  slots : Array[LruNode[K, V]?]
  free : Array[Int32]
  mut capacity : Int32
  /// The least recently used entry.
  mut head : Int32
  /// The most recently used entry.
  mut tail : Int32
  mut hits : Int64
  mut misses : Int64
  mut evictions : Int64
  on_evict : ((K, V) -> Unit)?
}

///|
/// A cache holding at most `capacity` entries and dropping the least recently used one to make room. `on_evict` sees every entry the policy drops; a capacity of zero or less raises `Refused::Capacity`.
pub fn[K, V] LruCache::new(
  capacity~ : Int32,
  on_evict? : (K, V) -> Unit,
  hash_seed~ : Int32 = @spec.hash_seed(),
) -> LruCache[K, V] raise @spec.Refused {
  if capacity <= 0 {
    raise @spec.Refused::Capacity(got=capacity)
  }
  {
    index: @map.IndexMap::new(capacity~, hash_seed~),
    slots: [],
    free: [],
    capacity,
    head: -1,
    tail: -1,
    hits: 0L,
    misses: 0L,
    evictions: 0L,
    on_evict,
  }
}

///|
fn[K, V] LruCache::node(self : LruCache[K, V], slot : Int32) -> LruNode[K, V] {
  match self.slots[slot] {
    Some(node) => node
    None => abort("moonstl: a live cache slot is empty")
  }
}

///|
fn[K, V] LruCache::detach(self : LruCache[K, V], slot : Int32) -> Unit {
  let node = self.node(slot)
  if node.prev >= 0 {
    self.node(node.prev).next = node.next
  } else {
    self.head = node.next
  }
  if node.next >= 0 {
    self.node(node.next).prev = node.prev
  } else {
    self.tail = node.prev
  }
  node.prev = -1
  node.next = -1
}

///|
fn[K, V] LruCache::append_tail(self : LruCache[K, V], slot : Int32) -> Unit {
  let node = self.node(slot)
  node.prev = self.tail
  node.next = -1
  if self.tail >= 0 {
    self.node(self.tail).next = slot
  } else {
    self.head = slot
  }
  self.tail = slot
}

///|
fn[K, V] LruCache::touch(self : LruCache[K, V], slot : Int32) -> Unit {
  if self.tail == slot {
    return
  }
  self.detach(slot)
  self.append_tail(slot)
}

///|
fn[K, V] LruCache::alloc(self : LruCache[K, V], key : K, value : V) -> Int32 {
  let node : LruNode[K, V] = { key, value, prev: -1, next: -1, }
  match self.free.pop() {
    Some(slot) => {
      self.slots[slot] = Some(node)
      slot
    }
    None => {
      self.slots.push(Some(node))
      self.slots.length() - 1
    }
  }
}

///|
fn[K, V] LruCache::drop_entry(self : LruCache[K, V], slot : Int32) -> Unit {
  self.detach(slot)
  self.slots[slot] = None
  self.free.push(slot)
}

///|
fn[K : Hash + Eq, V] LruCache::take_lru(self : LruCache[K, V]) -> (K, V)? {
  if self.head < 0 {
    return None
  }
  let slot = self.head
  let node = self.node(slot)
  let key = node.key
  let value = node.value
  let _ = self.index.remove(key)
  self.drop_entry(slot)
  self.evictions += 1L
  match self.on_evict {
    Some(callback) => callback(key, value)
    None => ()
  }
  Some((key, value))
}

///|
/// The value stored under `key`, marking the entry as the most recently used.
///
/// ```mbt check
/// test {
///   let cache : @cache.LruCache[Int32, String] = @cache.LruCache::new(capacity=1)
///   let _ = cache.set(1, "one")
///   @test.assert_eq(cache.get(1), Some("one"))
///   @test.assert_eq(cache.get(2), None)
///   @test.assert_eq(cache.stats().misses, 1L)
/// }
/// ```
pub fn[K : Hash + Eq, V] LruCache::get(self : LruCache[K, V], key : K) -> V? {
  match self.index.get(key) {
    Some(slot) => {
      self.touch(slot)
      self.hits += 1L
      Some(self.node(slot).value)
    }
    None => {
      self.misses += 1L
      None
    }
  }
}

///|
/// The value stored under `key`, without changing the order. A cache that peeks
/// keeps whatever it looked at alive, which is how a scan warms entries without
/// keeping them.
pub fn[K : Hash + Eq, V] LruCache::peek(self : LruCache[K, V], key : K) -> V? {
  match self.index.get(key) {
    Some(slot) => Some(self.node(slot).value)
    None => None
  }
}

///|
/// Stores `value` under `key` and returns the entry the insert displaced: the
/// pair it replaced when the key was already present, the pair the policy
/// dropped otherwise, `None` when there was room. Compare the key of the
/// result to tell the two apart.
///
/// ```mbt check
/// test {
///   let cache : @cache.LruCache[String, Int32] = @cache.LruCache::new(capacity=1)
///   @test.assert_eq(cache.set("a", 1), None)
///   @test.assert_eq(cache.set("b", 2), Some(("a", 1)))
///   @test.assert_eq(cache.set("b", 3), Some(("b", 2)))
/// }
/// ```
pub fn[K : Hash + Eq, V] LruCache::set(
  self : LruCache[K, V],
  key : K,
  value : V,
) -> (K, V)? {
  match self.index.get(key) {
    Some(slot) => {
      let node = self.node(slot)
      let old = node.value
      node.value = value
      self.touch(slot)
      Some((key, old))
    }
    None => {
      let displaced = if self.index.length() == self.capacity {
        self.take_lru()
      } else {
        None
      }
      let slot = self.alloc(key, value)
      let _ = self.index.set(key, slot)
      self.append_tail(slot)
      displaced
    }
  }
}

///|
/// Removes the entry under `key`. A removal is not an eviction: `on_evict` is
/// not called and the counter does not move.
pub fn[K : Hash + Eq, V] LruCache::remove(self : LruCache[K, V], key : K) -> V? {
  match self.index.remove(key) {
    Some(slot) => {
      let value = self.node(slot).value
      self.drop_entry(slot)
      Some(value)
    }
    None => None
  }
}

///|
/// Whether `key` is in the cache, without counting a hit or changing the order.
pub fn[K : Hash + Eq, V] LruCache::contains(
  self : LruCache[K, V],
  key : K,
) -> Bool {
  self.index.contains(key)
}

///|
/// Changes the capacity, dropping the least recently used entries when the new
/// capacity is smaller than the number of entries held.
pub fn[K : Hash + Eq, V] LruCache::resize_capacity(
  self : LruCache[K, V],
  capacity~ : Int32,
) -> Unit raise @spec.Refused {
  if capacity <= 0 {
    raise @spec.Refused::Capacity(got=capacity)
  }
  while self.index.length() > capacity {
    let _ = self.take_lru()
  }
  self.capacity = capacity
}

///|
/// The entries from least to most recently used.
pub fn[K, V] LruCache::iter(self : LruCache[K, V]) -> Iter[(K, V)] {
  let mut cursor = self.head
  Iter::new(() => {
    if cursor < 0 {
      None
    } else {
      let node = self.node(cursor)
      cursor = node.next
      Some((node.key, node.value))
    }
  })
}

///|
/// The keys, least recently used first.
pub fn[K, V] LruCache::keys(self : LruCache[K, V]) -> Iter[K] {
  self.iter().map(pair => pair.0)
}

///|
/// The values, least recently used first.
pub fn[K, V] LruCache::values(self : LruCache[K, V]) -> Iter[V] {
  self.iter().map(pair => pair.1)
}

///|
/// How many entries the cache holds.
pub fn[K, V] LruCache::length(self : LruCache[K, V]) -> Int32 {
  self.index.length()
}

///|
/// How many entries the cache holds before it drops one.
pub fn[K, V] LruCache::capacity(self : LruCache[K, V]) -> Int32 {
  self.capacity
}

///|
/// Whether the cache holds no entry.
pub fn[K, V] LruCache::is_empty(self : LruCache[K, V]) -> Bool {
  self.index.is_empty()
}

///|
/// Removes every entry; `on_evict` does not see them, since this is the caller's own doing.
pub fn[K, V] LruCache::clear(self : LruCache[K, V]) -> Unit {
  self.index.clear()
  self.slots.clear()
  self.free.clear()
  self.head = -1
  self.tail = -1
}

///|
/// A copy whose entries and order stand on their own: a lookup in either cache leaves the other where it was.
pub fn[K, V] LruCache::copy(self : LruCache[K, V]) -> LruCache[K, V] {
  let slots : Array[LruNode[K, V]?] = []
  for slot in self.slots {
    match slot {
      Some(node) =>
        slots.push(
          Some({
            key: node.key,
            value: node.value,
            prev: node.prev,
            next: node.next,
          }),
        )
      None => slots.push(None)
    }
  }
  {
    index: self.index.copy(),
    slots,
    free: self.free.copy(),
    capacity: self.capacity,
    head: self.head,
    tail: self.tail,
    hits: self.hits,
    misses: self.misses,
    evictions: self.evictions,
    on_evict: self.on_evict,
  }
}

///|
/// The hit, miss and eviction counters, which `get` moves and `peek` does not.
pub fn[K, V] LruCache::stats(self : LruCache[K, V]) -> CacheStats {
  { hits: self.hits, misses: self.misses, evictions: self.evictions, }
}

///|
/// Counts every lookup, so two caches of equal content but different histories
/// are not equal.
pub impl[K : Hash + Eq, V : Eq] Eq for LruCache[K, V] with fn equal(self, other) {
  if self.length() != other.length() {
    return false
  }
  for pair in self.iter() {
    guard other.peek(pair.0) is Some(value) else { return false }
    if value != pair.1 {
      return false
    }
  }
  true
}

///|
pub extend LruCache with Eq::{equal, not_equal}

///|
pub impl[K : Show, V : Show] Show for LruCache[K, V] with fn output(
  self,
  logger,
) {
  logger.write_string("LruCache{")
  let mut first = true
  for pair in self.iter() {
    if !first {
      logger.write_string(", ")
    }
    first = false
    pair.0.output(logger)
    logger.write_string(": ")
    pair.1.output(logger)
  }
  logger.write_string("}")
}

///|
pub extend LruCache with Show::{to_string, output}
