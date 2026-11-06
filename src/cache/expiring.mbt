///|
/// A node of the recency list, with the moment it stops being valid.
pub struct ExpNode[K, V] {
  key : K
  mut value : V
  mut expire_at : Int64
  /// Bumped on every change of the expiry, so a heap entry that no longer
  /// matches the node can be recognised as stale and skipped.
  mut stamp : Int32
  mut prev : Int32
  mut next : Int32
}

///|
/// A cache whose entries expire: an entry is dropped when it is read after its
/// deadline, when a purge finds it, and by the least-recently-used rule when
/// the capacity is full. Expiry is lazy, so a purge is the only thing that
/// walks the expired entries in bulk.
///
/// The cache never reads a clock of its own — `now` is the caller's, which is
/// what lets a test move time without waiting. `ttl` and every deadline are in
/// the units of that clock.
///
/// ```mbt check
/// test {
///   let mut clock : Int64 = 0L
///   let cache : @cache.ExpiringCache[String, Int32] = @cache.ExpiringCache::new(
///     ttl=10L,
///     capacity=2,
///     now=() => clock,
///   )
///   let _ = cache.set("a", 1)
///   @test.assert_eq(cache.get("a"), Some(1))
///   clock = 11L
///   @test.assert_eq(cache.get("a"), None)
/// }
/// ```
pub struct ExpiringCache[K, V] {
  index : @map.IndexMap[K, Int32]
  slots : Array[ExpNode[K, V]?]
  free : Array[Int32]
  capacity : Int32
  ttl : Int64
  now : () -> Int64
  mut head : Int32
  mut tail : Int32
  heap : Array[(Int64, Int32, Int32)]
  mut stamp_counter : Int32
  mut evictions : Int64
}

///|
pub fn[K, V] ExpiringCache::new(
  ttl~ : Int64,
  capacity~ : Int32,
  now~ : () -> Int64,
  hash_seed~ : Int32 = @spec.hash_seed(),
) -> ExpiringCache[K, V] raise @spec.Refused {
  if capacity <= 0 {
    raise @spec.Refused::Capacity(got=capacity)
  }
  {
    index: @map.IndexMap::new(capacity~, hash_seed~),
    slots: [],
    free: [],
    capacity,
    ttl,
    now,
    head: -1,
    tail: -1,
    heap: [],
    stamp_counter: 0,
    evictions: 0L,
  }
}

///|
fn[K, V] ExpiringCache::node(
  self : ExpiringCache[K, V],
  slot : Int32,
) -> ExpNode[K, V] {
  match self.slots[slot] {
    Some(node) => node
    None => abort("moonstl: a live cache slot is empty")
  }
}

///|
fn[K, V] ExpiringCache::unlink(
  self : ExpiringCache[K, V],
  slot : Int32,
) -> Unit {
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
fn[K, V] ExpiringCache::link(self : ExpiringCache[K, V], slot : Int32) -> Unit {
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
fn[K, V] ExpiringCache::touch(self : ExpiringCache[K, V], slot : Int32) -> Unit {
  if self.tail == slot {
    return
  }
  self.unlink(slot)
  self.link(slot)
}

///|
fn[K, V] ExpiringCache::alloc(
  self : ExpiringCache[K, V],
  key : K,
  value : V,
  expire_at : Int64,
) -> Int32 {
  self.stamp_counter += 1
  let node : ExpNode[K, V] = {
    key,
    value,
    expire_at,
    stamp: self.stamp_counter,
    prev: -1,
    next: -1,
  }
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
fn[K : Hash + Eq, V] ExpiringCache::drop_node(
  self : ExpiringCache[K, V],
  slot : Int32,
) -> Unit {
  let key = self.node(slot).key
  self.unlink(slot)
  let _ = self.index.remove(key)
  self.slots[slot] = None
  self.free.push(slot)
}

///|
fn[K, V] ExpiringCache::schedule(
  self : ExpiringCache[K, V],
  slot : Int32,
) -> Unit {
  let node = self.node(slot)
  let entry = (node.expire_at, slot, node.stamp)
  self.heap.push(entry)
  let mut i = self.heap.length() - 1
  while i > 0 {
    let parent = (i - 1) / 2
    if self.heap[parent].0 <= self.heap[i].0 {
      break
    }
    let tmp = self.heap[parent]
    self.heap[parent] = self.heap[i]
    self.heap[i] = tmp
    i = parent
  }
}

///|
fn[K, V] ExpiringCache::pop_heap(
  self : ExpiringCache[K, V],
) -> (Int64, Int32, Int32)? {
  let size = self.heap.length()
  if size == 0 {
    return None
  }
  let top = self.heap[0]
  let last = size - 1
  self.heap[0] = self.heap[last]
  self.heap.pop() |> ignore
  let mut i = 0
  while true {
    let left = 2 * i + 1
    let right = left + 1
    let mut smallest = i
    if left < last && self.heap[left].0 < self.heap[smallest].0 {
      smallest = left
    }
    if right < last && self.heap[right].0 < self.heap[smallest].0 {
      smallest = right
    }
    if smallest == i {
      break
    }
    let tmp = self.heap[smallest]
    self.heap[smallest] = self.heap[i]
    self.heap[i] = tmp
    i = smallest
  }
  Some(top)
}

///|
fn[K : Hash + Eq, V] ExpiringCache::take_lru(
  self : ExpiringCache[K, V],
) -> (K, V)? {
  if self.head < 0 {
    return None
  }
  let slot = self.head
  let node = self.node(slot)
  let key = node.key
  let value = node.value
  self.drop_node(slot)
  self.evictions += 1L
  Some((key, value))
}

///|
/// Stores `value` under `key` and gives it a deadline: `ttl` after the clock
/// now, or the deadline given. Returns the entry the insert displaced.
pub fn[K : Hash + Eq, V] ExpiringCache::set(
  self : ExpiringCache[K, V],
  key : K,
  value : V,
  ttl? : Int64,
) -> (K, V)? {
  let span = match ttl {
    Some(span) => span
    None => self.ttl
  }
  let expire_at = (self.now)() + span
  match self.index.get(key) {
    Some(slot) => {
      let node = self.node(slot)
      let old = node.value
      node.value = value
      node.expire_at = expire_at
      node.stamp = node.stamp + 1
      self.touch(slot)
      self.schedule(slot)
      Some((key, old))
    }
    None => {
      let displaced = if self.index.length() == self.capacity {
        self.take_lru()
      } else {
        None
      }
      let slot = self.alloc(key, value, expire_at)
      let _ = self.index.set(key, slot)
      self.link(slot)
      self.schedule(slot)
      displaced
    }
  }
}

///|
/// The value stored under `key`. An entry read after its deadline is dropped
/// and reads as absent.
pub fn[K : Hash + Eq, V] ExpiringCache::get(
  self : ExpiringCache[K, V],
  key : K,
) -> V? {
  match self.index.get(key) {
    Some(slot) => {
      let node = self.node(slot)
      if node.expire_at <= (self.now)() {
        self.drop_node(slot)
        None
      } else {
        self.touch(slot)
        Some(node.value)
      }
    }
    None => None
  }
}

///|
/// Drops every entry whose deadline has passed and reports how many went.
pub fn[K : Hash + Eq, V] ExpiringCache::purge(
  self : ExpiringCache[K, V],
) -> Int32 {
  let now = (self.now)()
  let mut dropped = 0
  while true {
    let top = match self.heap.length() {
      0 => None
      _ => Some(self.heap[0])
    }
    let (at, slot, stamp) = match top {
      Some(entry) => entry
      None => break
    }
    if at > now {
      break
    }
    let _ = self.pop_heap()
    match self.slots[slot] {
      Some(node) =>
        if node.stamp == stamp && node.expire_at <= now {
          self.drop_node(slot)
          dropped += 1
        }
      None => ()
    }
  }
  dropped
}

///|
/// Moves the deadline of an entry. `false` when the key is not in the cache.
pub fn[K : Hash + Eq, V] ExpiringCache::set_expire(
  self : ExpiringCache[K, V],
  key : K,
  at : Int64,
) -> Bool {
  match self.index.get(key) {
    Some(slot) => {
      let node = self.node(slot)
      node.expire_at = at
      node.stamp = node.stamp + 1
      self.schedule(slot)
      true
    }
    None => false
  }
}

///|
pub fn[K : Hash + Eq, V] ExpiringCache::remove(
  self : ExpiringCache[K, V],
  key : K,
) -> V? {
  match self.index.get(key) {
    Some(slot) => {
      let value = self.node(slot).value
      self.drop_node(slot)
      Some(value)
    }
    None => None
  }
}

///|
pub fn[K : Hash + Eq, V] ExpiringCache::contains(
  self : ExpiringCache[K, V],
  key : K,
) -> Bool {
  match self.index.get(key) {
    Some(slot) => self.node(slot).expire_at > (self.now)()
    None => false
  }
}

///|
/// The deadline of an entry, or `None` when it is not in the cache.
pub fn[K : Hash + Eq, V] ExpiringCache::expire_at(
  self : ExpiringCache[K, V],
  key : K,
) -> Int64? {
  match self.index.get(key) {
    Some(slot) => Some(self.node(slot).expire_at)
    None => None
  }
}

///|
/// The number of live entries. Expired entries are dropped first, so the count
/// is the count of what a `get` would find.
pub fn[K : Hash + Eq, V] ExpiringCache::length(
  self : ExpiringCache[K, V],
) -> Int32 {
  let _ = self.purge()
  self.index.length()
}

///|
pub fn[K : Hash + Eq, V] ExpiringCache::is_empty(
  self : ExpiringCache[K, V],
) -> Bool {
  self.length() == 0
}

///|
pub fn[K, V] ExpiringCache::capacity(self : ExpiringCache[K, V]) -> Int32 {
  self.capacity
}

///|
pub fn[K, V] ExpiringCache::clear(self : ExpiringCache[K, V]) -> Unit {
  self.index.clear()
  self.slots.clear()
  self.free.clear()
  self.heap.clear()
  self.head = -1
  self.tail = -1
}

///|
/// The entries from least to most recently used, expired ones already dropped.
pub fn[K : Hash + Eq, V] ExpiringCache::iter(
  self : ExpiringCache[K, V],
) -> Iter[(K, V)] {
  let _ = self.purge()
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
pub fn[K : Hash + Eq, V] ExpiringCache::keys(
  self : ExpiringCache[K, V],
) -> Iter[K] {
  self.iter().map(pair => pair.0)
}

///|
pub fn[K : Hash + Eq, V] ExpiringCache::values(
  self : ExpiringCache[K, V],
) -> Iter[V] {
  self.iter().map(pair => pair.1)
}

///|
pub fn[K, V] ExpiringCache::stats(self : ExpiringCache[K, V]) -> CacheStats {
  { hits: 0L, misses: 0L, evictions: self.evictions, }
}

///|
pub impl[K : Hash + Eq + Show, V : Show] Show for ExpiringCache[K, V] with fn output(
  self,
  logger,
) {
  logger.write_string("ExpiringCache{")
  let mut first = true
  for pair in self.iter() {
    if !first {
      logger.write_string(", ")
    }
    first = false
    Show::output(pair.0, logger)
    logger.write_string(": ")
    Show::output(pair.1, logger)
  }
  logger.write_string("}")
}

///|
pub extend ExpiringCache with Show::{to_string, output}
