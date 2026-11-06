///|
/// A stack of maps read as one: a lookup falls through the stack from the front,
/// and a write always lands in the front map. That is what a layered
/// configuration needs — a child scope that sees its parent's settings but
/// shadows them without touching them.
///
/// ```mbt check
/// test {
///   let base : Map[String, Int32] = Map([])
///   base.set("a", 1)
///   let chain : @map.ChainMap[String, Int32] = @map.ChainMap::new([base])
///   @test.assert_eq(chain.get("a"), Some(1))
///   let child = chain.new_child()
///   child.set("a", 2)
///   @test.assert_eq(child.get("a"), Some(2))
///   @test.assert_eq(chain.get("a"), Some(1))
/// }
/// ```
pub struct ChainMap[K, V] {
  chain : Array[Map[K, V]]
}

///|
/// Builds a chain over `maps`, the first of which is written to.
pub fn[K, V] ChainMap::new(maps : Array[Map[K, V]]) -> ChainMap[K, V] {
  { chain: maps, }
}

///|
/// Puts a fresh empty map in front, which is how a narrower scope is opened.
pub fn[K : Hash + Eq, V] ChainMap::new_child(
  self : ChainMap[K, V],
) -> ChainMap[K, V] {
  let chain : Array[Map[K, V]] = [Map([])]
  for map in self.chain {
    chain.push(map)
  }
  { chain, }
}

///|
/// The chain without its front map, or `None` when only one is left.
pub fn[K, V] ChainMap::parent(self : ChainMap[K, V]) -> ChainMap[K, V]? {
  if self.chain.length() <= 1 {
    return None
  }
  let chain : Array[Map[K, V]] = []
  for i in 1..<self.chain.length() {
    chain.push(self.chain[i])
  }
  Some({ chain, })
}

///|
pub fn[K : Hash + Eq, V] ChainMap::get(self : ChainMap[K, V], key : K) -> V? {
  for map in self.chain {
    match map.get(key) {
      Some(value) => return Some(value)
      None => ()
    }
  }
  None
}

///|
/// Writes into the front map, which is the only map a chain ever changes.
pub fn[K : Hash + Eq, V] ChainMap::set(
  self : ChainMap[K, V],
  key : K,
  value : V,
) -> Unit {
  self.chain[0].set(key, value)
}

///|
/// Removes `key` from every map in the chain, so a shadowed value does not
/// reappear once the front one is dropped.
pub fn[K : Hash + Eq, V] ChainMap::remove(
  self : ChainMap[K, V],
  key : K,
) -> Unit {
  for map in self.chain {
    map.remove(key)
  }
}

///|
pub fn[K : Hash + Eq, V] ChainMap::contains(
  self : ChainMap[K, V],
  key : K,
) -> Bool {
  for map in self.chain {
    if map.contains(key) {
      return true
    }
  }
  false
}

///|
/// The maps of the chain, front first.
pub fn[K, V] ChainMap::maps(self : ChainMap[K, V]) -> Array[Map[K, V]] {
  self.chain.copy()
}

///|
/// The number of distinct keys the chain answers for.
pub fn[K : Hash + Eq, V] ChainMap::length(self : ChainMap[K, V]) -> Int32 {
  let seen : Map[K, Unit] = Map([])
  let mut count = 0
  for map in self.chain {
    for (key, _) in map.iter() {
      if !seen.contains(key) {
        seen.set(key, ())
        count = count + 1
      }
    }
  }
  count
}

///|
/// Every pair the chain answers for: the first map that holds a key decides its
/// value.
pub fn[K : Hash + Eq, V] ChainMap::iter(self : ChainMap[K, V]) -> Iter[(K, V)] {
  let merged = self.flatten()
  merged.iter()
}

///|
/// Copies the chain into one map, which is what a child does when it has to
/// stop following its parent.
pub fn[K : Hash + Eq, V] ChainMap::flatten(self : ChainMap[K, V]) -> Map[K, V] {
  let result : Map[K, V] = Map([])
  for map in self.chain {
    for (key, value) in map.iter() {
      if !result.contains(key) {
        result.set(key, value)
      }
    }
  }
  result
}

///|
pub fn[K, V] ChainMap::copy(self : ChainMap[K, V]) -> ChainMap[K, V] {
  let chain : Array[Map[K, V]] = []
  for map in self.chain {
    chain.push(map.copy())
  }
  { chain, }
}
