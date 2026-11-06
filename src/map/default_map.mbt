///|
/// A map that answers a lookup with a value it makes up on the spot: the
/// factory is called with the key, so a reader never has to write the
/// check-then-insert pair by hand.
///
/// ```mbt check
/// test {
///   let map : @map.DefaultMap[String, Int32] = @map.DefaultMap::new(factory=key => {
///     key.length()
///   })
///   @test.assert_eq(map.get_or_init("abc"), 3)
///   @test.assert_eq(map.length(), 1)
///   @test.assert_eq(map.get("abc"), Some(3))
/// }
/// ```
pub struct DefaultMap[K, V] {
  map : IndexMap[K, V]
  factory : (K) -> V
}

///|
pub fn[K, V] DefaultMap::new(
  factory~ : (K) -> V,
  capacity~ : Int32 = 0,
  hash_seed~ : Int32 = @spec.hash_seed(),
) -> DefaultMap[K, V] {
  { map: IndexMap::new(capacity~, hash_seed~), factory, }
}

///|
/// The value under `key`, inserting `factory(key)` when the key is new.
pub fn[K : Hash + Eq, V] DefaultMap::get_or_init(
  self : DefaultMap[K, V],
  key : K,
) -> V {
  match self.map.get(key) {
    Some(value) => value
    None => {
      let value = (self.factory)(key)
      let _ = self.map.set(key, value)
      value
    }
  }
}

///|
pub fn[K : Hash + Eq, V] DefaultMap::get(
  self : DefaultMap[K, V],
  key : K,
) -> V? {
  self.map.get(key)
}

///|
pub fn[K : Hash + Eq, V] DefaultMap::set(
  self : DefaultMap[K, V],
  key : K,
  value : V,
) -> V? {
  self.map.set(key, value)
}

///|
pub fn[K : Hash + Eq, V] DefaultMap::remove(
  self : DefaultMap[K, V],
  key : K,
) -> V? {
  self.map.remove(key)
}

///|
pub fn[K : Hash + Eq, V] DefaultMap::contains(
  self : DefaultMap[K, V],
  key : K,
) -> Bool {
  self.map.contains(key)
}

///|
pub fn[K, V] DefaultMap::iter(self : DefaultMap[K, V]) -> Iter[(K, V)] {
  self.map.iter()
}

///|
pub fn[K, V] DefaultMap::keys(self : DefaultMap[K, V]) -> Iter[K] {
  self.map.keys()
}

///|
pub fn[K, V] DefaultMap::values(self : DefaultMap[K, V]) -> Iter[V] {
  self.map.values()
}

///|
pub fn[K, V] DefaultMap::length(self : DefaultMap[K, V]) -> Int32 {
  self.map.length()
}

///|
pub fn[K, V] DefaultMap::is_empty(self : DefaultMap[K, V]) -> Bool {
  self.map.is_empty()
}

///|
pub fn[K, V] DefaultMap::clear(self : DefaultMap[K, V]) -> Unit {
  self.map.clear()
}

///|
pub fn[K, V] DefaultMap::copy(self : DefaultMap[K, V]) -> DefaultMap[K, V] {
  { map: self.map.copy(), factory: self.factory, }
}

///|
pub impl[K : Eq, V : Eq] Eq for DefaultMap[K, V] with fn equal(self, other) {
  self.map.equal(other.map)
}

///|
pub extend DefaultMap with Eq::{equal, not_equal}

///|
pub impl[K : Show, V : Show] Show for DefaultMap[K, V] with fn output(
  self,
  logger,
) {
  self.map.output(logger)
}

///|
pub extend DefaultMap with Show::{to_string, output}
