///|
/// A node of the frequency lists. Every live entry sits in the list of its own
/// frequency, most recently used first, so the entry to drop is the head of the
/// lowest non-empty list.
pub struct LfuNode[K, V] {
  key : K
  mut value : V
  mut freq : Int32
  mut prev : Int32
  mut next : Int32
}

///|
/// One frequency list. Buckets are indexed by frequency and grown on demand.
pub struct LfuBucket {
  mut head : Int32
  mut tail : Int32
}

///|
/// A least-frequently-used cache: an insert past the capacity drops the entry
/// with the smallest access count, and among equals the one that has gone
/// untouched the longest. A hit moves the entry into the list of the next
/// frequency, which is what keeps both operations O(1).
///
/// ```mbt check
/// test {
///   let cache : @cache.LfuCache[String, Int32] = @cache.LfuCache::new(capacity=2)
///   let _ = cache.set("a", 1)
///   let _ = cache.set("b", 2)
///   let _ = cache.get("a")
///   let _ = cache.set("c", 3)
///   @test.assert_eq(cache.get("b"), None)
///   @test.assert_eq(cache.frequency("a"), Some(2))
/// }
/// ```
pub struct LfuCache[K, V] {
  index : @map.IndexMap[K, Int32]
  slots : Array[LfuNode[K, V]?]
  free : Array[Int32]
  buckets : Array[LfuBucket]
  mut capacity : Int32
  mut min_freq : Int32
  mut hits : Int64
  mut misses : Int64
  mut evictions : Int64
  on_evict : ((K, V) -> Unit)?
}

///|
/// A cache holding at most `capacity` entries and dropping the least frequently used one to make room, breaking a tie by recency. `on_evict` sees every entry the policy drops; a capacity of zero or less raises `Refused::Capacity`.
pub fn[K, V] LfuCache::new(
  capacity~ : Int32,
  on_evict? : (K, V) -> Unit,
  hash_seed~ : Int32 = @spec.hash_seed(),
) -> LfuCache[K, V] raise @spec.Refused {
  if capacity <= 0 {
    raise @spec.Refused::Capacity(got=capacity)
  }
  {
    index: @map.IndexMap::new(capacity~, hash_seed~),
    slots: [],
    free: [],
    buckets: [{ head: -1, tail: -1, }],
    capacity,
    min_freq: 0,
    hits: 0L,
    misses: 0L,
    evictions: 0L,
    on_evict,
  }
}

///|
fn[K, V] LfuCache::node(self : LfuCache[K, V], slot : Int32) -> LfuNode[K, V] {
  match self.slots[slot] {
    Some(node) => node
    None => abort("moonstl: a live cache slot is empty")
  }
}

///|
fn[K, V] LfuCache::bucket(cache : LfuCache[K, V], freq : Int32) -> LfuBucket {
  while cache.buckets.length() <= freq {
    cache.buckets.push({ head: -1, tail: -1, })
  }
  cache.buckets[freq]
}

///|
fn[K, V] LfuCache::link(
  self : LfuCache[K, V],
  freq : Int32,
  slot : Int32,
) -> Unit {
  let bucket = self.bucket(freq)
  let node = self.node(slot)
  node.freq = freq
  node.prev = bucket.tail
  node.next = -1
  if bucket.tail >= 0 {
    self.node(bucket.tail).next = slot
  } else {
    bucket.head = slot
  }
  bucket.tail = slot
}

///|
fn[K, V] LfuCache::unlink(self : LfuCache[K, V], slot : Int32) -> Unit {
  let node = self.node(slot)
  let bucket = self.bucket(node.freq)
  if node.prev >= 0 {
    self.node(node.prev).next = node.next
  } else {
    bucket.head = node.next
  }
  if node.next >= 0 {
    self.node(node.next).prev = node.prev
  } else {
    bucket.tail = node.prev
  }
  node.prev = -1
  node.next = -1
}

///|
fn[K, V] LfuCache::alloc(self : LfuCache[K, V], key : K, value : V) -> Int32 {
  let node : LfuNode[K, V] = { key, value, freq: 0, prev: -1, next: -1, }
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
fn[K, V] LfuCache::drop_slot(self : LfuCache[K, V], slot : Int32) -> Unit {
  self.unlink(slot)
  self.slots[slot] = None
  self.free.push(slot)
}

///|
/// The entry the policy drops first: the head of the lowest non-empty
/// frequency list.
fn[K : Hash + Eq, V] LfuCache::take_lfu(self : LfuCache[K, V]) -> (K, V)? {
  if self.index.length() == 0 {
    return None
  }
  let mut freq = self.min_freq
  while freq < self.buckets.length() && self.buckets[freq].head < 0 {
    freq += 1
  }
  if freq >= self.buckets.length() {
    return None
  }
  let slot = self.buckets[freq].head
  let node = self.node(slot)
  let key = node.key
  let value = node.value
  let _ = self.index.remove(key)
  self.drop_slot(slot)
  self.min_freq = freq
  self.evictions += 1L
  match self.on_evict {
    Some(callback) => callback(key, value)
    None => ()
  }
  Some((key, value))
}

///|
fn[K, V] LfuCache::promote(self : LfuCache[K, V], slot : Int32) -> Unit {
  let freq = self.node(slot).freq
  self.unlink(slot)
  if freq == self.min_freq && self.bucket(freq).head < 0 {
    self.min_freq = freq + 1
  }
  self.link(freq + 1, slot)
}

///|
/// The value under `key`, counting a hit and raising the key's frequency by one; a miss counts too.
pub fn[K : Hash + Eq, V] LfuCache::get(self : LfuCache[K, V], key : K) -> V? {
  match self.index.get(key) {
    Some(slot) => {
      self.promote(slot)
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
/// The value stored under `key` without counting the access.
pub fn[K : Hash + Eq, V] LfuCache::peek(self : LfuCache[K, V], key : K) -> V? {
  match self.index.get(key) {
    Some(slot) => Some(self.node(slot).value)
    None => None
  }
}

///|
/// Stores `value` under `key`, starting its frequency at one, and returns the entry the insert displaced: the pair it replaced when the key was already present, the pair the policy dropped otherwise.
pub fn[K : Hash + Eq, V] LfuCache::set(
  self : LfuCache[K, V],
  key : K,
  value : V,
) -> (K, V)? {
  match self.index.get(key) {
    Some(slot) => {
      let node = self.node(slot)
      let old = node.value
      node.value = value
      self.promote(slot)
      Some((key, old))
    }
    None => {
      let displaced = if self.index.length() == self.capacity {
        self.take_lfu()
      } else {
        None
      }
      let slot = self.alloc(key, value)
      let _ = self.index.set(key, slot)
      self.link(1, slot)
      self.min_freq = 1
      displaced
    }
  }
}

///|
/// Removes the entry and returns it, which is how a cache is drained one entry
/// at a time.
pub fn[K : Hash + Eq, V] LfuCache::take(self : LfuCache[K, V], key : K) -> V? {
  self.remove(key)
}

///|
/// Removes the entry under `key`, which is not an eviction: `on_evict` is not called and the counter does not move.
pub fn[K : Hash + Eq, V] LfuCache::remove(self : LfuCache[K, V], key : K) -> V? {
  match self.index.remove(key) {
    Some(slot) => {
      let value = self.node(slot).value
      self.drop_slot(slot)
      Some(value)
    }
    None => None
  }
}

///|
/// Whether `key` is in the cache, without counting a hit or raising its frequency.
pub fn[K : Hash + Eq, V] LfuCache::contains(
  self : LfuCache[K, V],
  key : K,
) -> Bool {
  self.index.contains(key)
}

///|
/// The access count of `key`, which is one more than the number of `get` calls
/// that have hit it since it was inserted.
pub fn[K : Hash + Eq, V] LfuCache::frequency(
  self : LfuCache[K, V],
  key : K,
) -> Int32? {
  match self.index.get(key) {
    Some(slot) => Some(self.node(slot).freq)
    None => None
  }
}

///|
/// Changes how many entries the cache holds, dropping by frequency until it fits; a capacity of zero or less raises `Refused::Capacity`.
pub fn[K : Hash + Eq, V] LfuCache::resize_capacity(
  self : LfuCache[K, V],
  capacity~ : Int32,
) -> Unit raise @spec.Refused {
  if capacity <= 0 {
    raise @spec.Refused::Capacity(got=capacity)
  }
  while self.index.length() > capacity {
    let _ = self.take_lfu()
  }
  self.capacity = capacity
}

///|
/// The entries in the order their keys were added; `frequency` reads the count that decides eviction.
pub fn[K, V] LfuCache::iter(self : LfuCache[K, V]) -> Iter[(K, V)] {
  let pairs = self.index.to_array()
  let mut cursor = 0
  Iter::new(() => {
    if cursor >= pairs.length() {
      None
    } else {
      let (key, slot) = pairs[cursor]
      cursor = cursor + 1
      Some((key, self.node(slot).value))
    }
  })
}

///|
/// The keys in the order they were added.
pub fn[K, V] LfuCache::keys(self : LfuCache[K, V]) -> Iter[K] {
  self.index.keys()
}

///|
/// The values in the order their keys were added.
pub fn[K, V] LfuCache::values(self : LfuCache[K, V]) -> Iter[V] {
  self.iter().map(pair => pair.1)
}

///|
/// How many entries the cache holds.
pub fn[K, V] LfuCache::length(self : LfuCache[K, V]) -> Int32 {
  self.index.length()
}

///|
/// How many entries the cache holds before it drops one.
pub fn[K, V] LfuCache::capacity(self : LfuCache[K, V]) -> Int32 {
  self.capacity
}

///|
/// Whether the cache holds no entry.
pub fn[K, V] LfuCache::is_empty(self : LfuCache[K, V]) -> Bool {
  self.index.is_empty()
}

///|
/// Removes every entry and resets every frequency.
pub fn[K, V] LfuCache::clear(self : LfuCache[K, V]) -> Unit {
  self.index.clear()
  self.slots.clear()
  self.free.clear()
  self.buckets.clear()
  self.buckets.push({ head: -1, tail: -1, })
  self.min_freq = 0
}

///|
/// A copy whose entries, frequencies and order stand on their own: a lookup in either cache leaves the other where it was.
pub fn[K, V] LfuCache::copy(self : LfuCache[K, V]) -> LfuCache[K, V] {
  let slots : Array[LfuNode[K, V]?] = []
  for slot in self.slots {
    match slot {
      Some(node) =>
        slots.push(
          Some({
            key: node.key,
            value: node.value,
            freq: node.freq,
            prev: node.prev,
            next: node.next,
          }),
        )
      None => slots.push(None)
    }
  }
  let buckets : Array[LfuBucket] = []
  for bucket in self.buckets {
    buckets.push({ head: bucket.head, tail: bucket.tail, })
  }
  {
    index: self.index.copy(),
    slots,
    free: self.free.copy(),
    buckets,
    capacity: self.capacity,
    min_freq: self.min_freq,
    hits: self.hits,
    misses: self.misses,
    evictions: self.evictions,
    on_evict: self.on_evict,
  }
}

///|
/// The hit, miss and eviction counters, each moved by the operation that names it.
pub fn[K, V] LfuCache::stats(self : LfuCache[K, V]) -> CacheStats {
  { hits: self.hits, misses: self.misses, evictions: self.evictions, }
}

///|
pub impl[K : Hash + Eq, V : Eq] Eq for LfuCache[K, V] with fn equal(self, other) {
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
pub extend LfuCache with Eq::{equal, not_equal}

///|
pub impl[K : Show, V : Show] Show for LfuCache[K, V] with fn output(
  self,
  logger,
) {
  logger.write_string("LfuCache{")
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
pub extend LfuCache with Show::{to_string, output}
