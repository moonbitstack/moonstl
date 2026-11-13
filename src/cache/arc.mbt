///|
/// The four lists the ARC paper keeps. Two of them hold resident entries, two
/// hold the keys of entries that were dropped recently and nothing else.
let arc_t1 : Int32 = 0

///|
let arc_t2 : Int32 = 1

///|
let arc_b1 : Int32 = 2

///|
let arc_b2 : Int32 = 3

///|
/// A node of any of the four lists. A ghost carries `None` as its value: the
/// key is remembered so that a returning key can be recognised, the value is
/// gone.
pub struct ArcNode[K, V] {
  key : K
  mut value : V?
  mut list : Int32
  mut prev : Int32
  mut next : Int32
}

///|
/// A cache that keeps the recency and the frequency of what it sees in balance,
/// in the manner of ARC: a hit on a re-requested key raises the share of the
/// cache given to frequent entries (`recent_target` moves up), a key that
/// falls back into the ghost lists takes that share down. `lists` reports the
/// four list sizes, which is how the adaptation is observed.
///
/// ```mbt check
/// test {
///   let cache : @cache.ArcCache[String, Int32] = @cache.ArcCache::new(capacity=2)
///   let _ = cache.set("a", 1)
///   let _ = cache.set("b", 2)
///   let _ = cache.get("a")
///   let _ = cache.set("c", 3)
///   let (t1, t2, b1, b2) = cache.lists()
///   @test.assert_eq(t1 + t2, 2)
///   @test.assert_eq(b1 + b2 <= 2, true)
/// }
/// ```
pub struct ArcCache[K, V] {
  index : @map.IndexMap[K, Int32]
  slots : Array[ArcNode[K, V]?]
  free : Array[Int32]
  heads : Array[Int32]
  tails : Array[Int32]
  sizes : Array[Int32]
  capacity : Int32
  /// The size ARC wants the recency list to have, `p` in the paper.
  mut recent_target : Int32
  mut hits : Int64
  mut misses : Int64
  mut evictions : Int64
  on_evict : ((K, V) -> Unit)?
}

///|
/// A cache holding at most `capacity` entries, balancing recency against frequency as it watches which of the two it was missing. `on_evict` sees every entry the policy drops; a capacity of zero or less raises `Refused::Capacity`.
pub fn[K, V] ArcCache::new(
  capacity~ : Int32,
  on_evict? : (K, V) -> Unit,
  hash_seed~ : Int32 = @spec.hash_seed(),
) -> ArcCache[K, V] raise @spec.Refused {
  if capacity <= 0 {
    raise @spec.Refused::Capacity(got=capacity)
  }
  {
    index: @map.IndexMap::new(capacity~, hash_seed~),
    slots: [],
    free: [],
    heads: [-1, -1, -1, -1],
    tails: [-1, -1, -1, -1],
    sizes: [0, 0, 0, 0],
    capacity,
    recent_target: 0,
    hits: 0L,
    misses: 0L,
    evictions: 0L,
    on_evict,
  }
}

///|
fn[K, V] ArcCache::node(self : ArcCache[K, V], slot : Int32) -> ArcNode[K, V] {
  match self.slots[slot] {
    Some(node) => node
    None => abort("moonstl: a live cache slot is empty")
  }
}

///|
fn[K, V] ArcCache::unlink(self : ArcCache[K, V], slot : Int32) -> Unit {
  let node = self.node(slot)
  let list = node.list
  if node.prev >= 0 {
    self.node(node.prev).next = node.next
  } else {
    self.heads[list] = node.next
  }
  if node.next >= 0 {
    self.node(node.next).prev = node.prev
  } else {
    self.tails[list] = node.prev
  }
  self.sizes[list] = self.sizes[list] - 1
  node.prev = -1
  node.next = -1
}

///|
fn[K, V] ArcCache::link(
  self : ArcCache[K, V],
  list : Int32,
  slot : Int32,
) -> Unit {
  let node = self.node(slot)
  node.list = list
  node.prev = self.tails[list]
  node.next = -1
  if self.tails[list] >= 0 {
    self.node(self.tails[list]).next = slot
  } else {
    self.heads[list] = slot
  }
  self.tails[list] = slot
  self.sizes[list] = self.sizes[list] + 1
}

///|
fn[K, V] ArcCache::alloc(
  self : ArcCache[K, V],
  key : K,
  value : V?,
  list : Int32,
) -> Int32 {
  let node : ArcNode[K, V] = { key, value, list, prev: -1, next: -1, }
  let slot = match self.free.pop() {
    Some(slot) => {
      self.slots[slot] = Some(node)
      slot
    }
    None => {
      self.slots.push(Some(node))
      self.slots.length() - 1
    }
  }
  slot
}

///|
/// Removes a node from whichever list holds it and forgets its key.
fn[K : Hash + Eq, V] ArcCache::drop_node(
  self : ArcCache[K, V],
  slot : Int32,
) -> Unit {
  let key = self.node(slot).key
  self.unlink(slot)
  let _ = self.index.remove(key)
  self.slots[slot] = None
  self.free.push(slot)
}

///|
/// Drops the least recently seen ghost of `list`, which is what keeps the
/// directory from growing past twice the capacity.
fn[K : Hash + Eq, V] ArcCache::drop_ghost(
  self : ArcCache[K, V],
  list : Int32,
) -> Unit {
  let slot = self.heads[list]
  if slot >= 0 {
    self.drop_node(slot)
  }
}

///|
/// Removes the least recently used resident of `list` from the cache
/// altogether, calling the eviction hook. Used when the directory is full of
/// residents and there is no ghost to displace.
fn[K : Hash + Eq, V] ArcCache::evict_resident(
  self : ArcCache[K, V],
  list : Int32,
) -> (K, V)? {
  let slot = self.heads[list]
  if slot < 0 {
    return None
  }
  let node = self.node(slot)
  let key = node.key
  let value = node.value
  self.drop_node(slot)
  self.evictions += 1L
  match value {
    Some(value) => {
      match self.on_evict {
        Some(callback) => callback(key, value)
        None => ()
      }
      Some((key, value))
    }
    None => None
  }
}

///|
/// The `REPLACE` step of the paper: moves the least recently used resident of
/// the list that is over its share into its ghost list, dropping the entry.
fn[K, V] ArcCache::replace(self : ArcCache[K, V], key_in_b2 : Bool) -> (K, V)? {
  let t1 = self.sizes[arc_t1]
  let from_t1 = if t1 > 0 {
    t1 > self.recent_target || (key_in_b2 && t1 == self.recent_target)
  } else {
    false
  }
  let list = if from_t1 {
    arc_t1
  } else if self.sizes[arc_t2] > 0 {
    arc_t2
  } else if t1 > 0 {
    arc_t1
  } else {
    return None
  }
  let slot = self.heads[list]
  let node = self.node(slot)
  let key = node.key
  let value = node.value
  self.unlink(slot)
  node.value = None
  self.link(if from_t1 { arc_b1 } else { arc_b2 }, slot)
  match value {
    Some(value) => {
      self.evictions += 1L
      match self.on_evict {
        Some(callback) => callback(key, value)
        None => ()
      }
      Some((key, value))
    }
    None => None
  }
}

///|
/// `true` when the key is resident. A key that is only remembered in a ghost
/// list is not contained.
pub fn[K : Hash + Eq, V] ArcCache::contains(
  self : ArcCache[K, V],
  key : K,
) -> Bool {
  match self.index.get(key) {
    Some(slot) => {
      let list = self.node(slot).list
      list == arc_t1 || list == arc_t2
    }
    None => false
  }
}

///|
/// The value under `key`, counting a hit and moving the entry into the frequent list; a miss counts too.
pub fn[K : Hash + Eq, V] ArcCache::get(self : ArcCache[K, V], key : K) -> V? {
  match self.index.get(key) {
    Some(slot) => {
      let node = self.node(slot)
      if node.list == arc_t1 || node.list == arc_t2 {
        let value = node.value
        self.unlink(slot)
        self.link(arc_t2, slot)
        self.hits += 1L
        value
      } else {
        self.misses += 1L
        None
      }
    }
    None => {
      self.misses += 1L
      None
    }
  }
}

///|
/// Stores `value` under `key` and returns the resident the insert displaced,
/// if any. A key that returns from a ghost list is admitted straight into the
/// frequent list and the share given to frequent entries moves in its favour.
pub fn[K : Hash + Eq, V] ArcCache::set(
  self : ArcCache[K, V],
  key : K,
  value : V,
) -> (K, V)? {
  match self.index.get(key) {
    Some(slot) => {
      let list = self.node(slot).list
      if list == arc_b1 || list == arc_b2 {
        let returned = if list == arc_b1 {
          let step = self.sizes[arc_b2] / self.sizes[arc_b1]
          let target = self.recent_target + (if step > 1 { step } else { 1 })
          self.recent_target = if target > self.capacity {
            self.capacity
          } else {
            target
          }
          self.replace(false)
        } else {
          let step = self.sizes[arc_b1] / self.sizes[arc_b2]
          let target = self.recent_target - (if step > 1 { step } else { 1 })
          self.recent_target = if target < 0 { 0 } else { target }
          self.replace(true)
        }
        let node = self.node(slot)
        node.value = Some(value)
        self.unlink(slot)
        self.link(arc_t2, slot)
        returned
      } else {
        let node = self.node(slot)
        let old = node.value
        node.value = Some(value)
        self.unlink(slot)
        self.link(arc_t2, slot)
        match old {
          Some(old) => Some((key, old))
          None => None
        }
      }
    }
    None => {
      let mut displaced : (K, V)? = None
      let t1 = self.sizes[arc_t1]
      let b1 = self.sizes[arc_b1]
      let total = t1 + self.sizes[arc_t2] + b1 + self.sizes[arc_b2]
      if t1 + b1 == self.capacity {
        if t1 < self.capacity {
          self.drop_ghost(arc_b1)
          displaced = self.replace(false)
        } else {
          displaced = self.evict_resident(arc_t1)
        }
      } else if t1 + b1 < self.capacity && total >= self.capacity {
        if total == 2 * self.capacity {
          self.drop_ghost(arc_b2)
        }
        displaced = self.replace(false)
      }
      let slot = self.alloc(key, Some(value), arc_t1)
      let _ = self.index.set(key, slot)
      self.link(arc_t1, slot)
      displaced
    }
  }
}

///|
/// Removes the entry under `key`, which is not an eviction: `on_evict` is not called and the counter does not move.
pub fn[K : Hash + Eq, V] ArcCache::remove(self : ArcCache[K, V], key : K) -> V? {
  match self.index.get(key) {
    Some(slot) => {
      let node = self.node(slot)
      let value = node.value
      let list = node.list
      self.drop_node(slot)
      if list == arc_t1 || list == arc_t2 {
        value
      } else {
        None
      }
    }
    None => None
  }
}

///|
/// The sizes of the four lists: the two resident ones and the two ghost ones.
pub fn[K, V] ArcCache::lists(
  self : ArcCache[K, V],
) -> (Int32, Int32, Int32, Int32) {
  (
    self.sizes[arc_t1],
    self.sizes[arc_t2],
    self.sizes[arc_b1],
    self.sizes[arc_b2],
  )
}

///|
/// The entries of the recent list and then of the frequent list, most recently used first within each.
pub fn[K, V] ArcCache::iter(self : ArcCache[K, V]) -> Iter[(K, V)] {
  let mut cursor = self.heads[arc_t1]
  let mut phase = arc_t1
  Iter::new(() => {
    while true {
      if cursor < 0 {
        if phase == arc_t1 {
          phase = arc_t2
          cursor = self.heads[arc_t2]
          continue
        }
        break
      }
      let node = self.node(cursor)
      cursor = node.next
      match node.value {
        Some(value) => return Some((node.key, value))
        None => continue
      }
    }
    None
  })
}

///|
/// The keys in the order `iter` walks them.
pub fn[K, V] ArcCache::keys(self : ArcCache[K, V]) -> Iter[K] {
  self.iter().map(pair => pair.0)
}

///|
/// The values in the order `iter` walks them.
pub fn[K, V] ArcCache::values(self : ArcCache[K, V]) -> Iter[V] {
  self.iter().map(pair => pair.1)
}

///|
/// How many entries the cache holds, both lists together.
pub fn[K, V] ArcCache::length(self : ArcCache[K, V]) -> Int32 {
  self.sizes[arc_t1] + self.sizes[arc_t2]
}

///|
/// How many entries the cache holds before it drops one.
pub fn[K, V] ArcCache::capacity(self : ArcCache[K, V]) -> Int32 {
  self.capacity
}

///|
/// Whether the cache holds no entry.
pub fn[K, V] ArcCache::is_empty(self : ArcCache[K, V]) -> Bool {
  self.length() == 0
}

///|
/// Removes every entry from both lists and from the two ghost lists.
pub fn[K, V] ArcCache::clear(self : ArcCache[K, V]) -> Unit {
  self.index.clear()
  self.slots.clear()
  self.free.clear()
  for i in 0..<4 {
    self.heads[i] = -1
    self.tails[i] = -1
    self.sizes[i] = 0
  }
  self.recent_target = 0
}

///|
/// A copy whose lists and entries stand on their own: a lookup in either cache leaves the other where it was.
pub fn[K, V] ArcCache::copy(self : ArcCache[K, V]) -> ArcCache[K, V] {
  let slots : Array[ArcNode[K, V]?] = []
  for slot in self.slots {
    match slot {
      Some(node) =>
        slots.push(
          Some({
            key: node.key,
            value: node.value,
            list: node.list,
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
    heads: self.heads.copy(),
    tails: self.tails.copy(),
    sizes: self.sizes.copy(),
    capacity: self.capacity,
    recent_target: self.recent_target,
    hits: self.hits,
    misses: self.misses,
    evictions: self.evictions,
    on_evict: self.on_evict,
  }
}

///|
/// The hit, miss and eviction counters, each moved by the operation that names it.
pub fn[K, V] ArcCache::stats(self : ArcCache[K, V]) -> CacheStats {
  { hits: self.hits, misses: self.misses, evictions: self.evictions, }
}

///|
pub impl[K : Hash + Eq, V : Eq] Eq for ArcCache[K, V] with fn equal(self, other) {
  if self.length() != other.length() {
    return false
  }
  for pair in self.iter() {
    guard other.get(pair.0) is Some(value) else { return false }
    if value != pair.1 {
      return false
    }
  }
  true
}

///|
pub extend ArcCache with Eq::{equal, not_equal}

///|
pub impl[K : Show, V : Show] Show for ArcCache[K, V] with fn output(
  self,
  logger,
) {
  logger.write_string("ArcCache{")
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
pub extend ArcCache with Show::{to_string, output}
