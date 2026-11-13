///|
/// A two-way map: the pair `k -> v` can be read from either side, and neither a
/// key nor a value can appear twice. `set` keeps the mapping total by dropping
/// whatever the new pair collides with, and hands it back.
///
/// ```mbt check
/// test {
///   let bimap : @map.BiMap[Int32, String] = @map.BiMap::new()
///   let _ = bimap.set(1, "a")
///   let _ = bimap.set(2, "b")
///   @test.assert_eq(bimap.get_key("b"), Some(2))
///   @test.assert_eq(bimap.set(1, "b"), Some((1, "a")))
///   @test.assert_eq(bimap.get(1), Some("b"))
///   @test.assert_eq(bimap.get(2), None)
/// }
/// ```
pub struct BiMap[K, V] {
  forward : IndexMap[K, V]
  backward : IndexMap[V, K]
}

///|
/// An empty bijection, with room for `capacity` pairs and its tables laid out from `hash_seed`.
pub fn[K, V] BiMap::new(
  capacity~ : Int32 = 0,
  hash_seed~ : Int32 = @spec.hash_seed(),
) -> BiMap[K, V] {
  {
    forward: IndexMap::new(capacity~, hash_seed~),
    backward: IndexMap::new(capacity~, hash_seed~),
  }
}

///|
/// Stores the pair, dropping the pair the key belonged to and the pair the
/// value belonged to, and returns one of the dropped pairs — the one the key
/// displaced when there is one, otherwise the one the value displaced.
pub fn[K : Hash + Eq, V : Hash + Eq] BiMap::set(
  self : BiMap[K, V],
  key : K,
  value : V,
) -> (K, V)? {
  let previous_value = self.forward.get(key)
  let previous_key = self.backward.get(value)
  if previous_value is Some(current) && current == value {
    return None
  }
  let mut displaced : (K, V)? = None
  match previous_value {
    Some(old) => {
      let _ = self.forward.set(key, value)
      let _ = self.backward.remove(old)
      displaced = Some((key, old))
    }
    None => ()
  }
  match previous_key {
    Some(old) => {
      let _ = self.forward.remove(old)
      let _ = self.backward.set(value, key)
      if displaced is None {
        displaced = Some((old, value))
      }
    }
    None => ()
  }
  let _ = self.forward.set(key, value)
  let _ = self.backward.set(value, key)
  displaced
}

///|
/// Stores the pair only when neither side is taken, and refuses otherwise.
pub fn[K : Hash + Eq, V : Hash + Eq] BiMap::set_new(
  self : BiMap[K, V],
  key : K,
  value : V,
) -> Unit raise @spec.Refused {
  if self.forward.contains(key) || self.backward.contains(value) {
    raise @spec.Refused::DuplicateValue
  }
  let _ = self.forward.set(key, value)
  let _ = self.backward.set(value, key)
}

///|
/// The value `key` is mapped to, or `None`.
pub fn[K : Hash + Eq, V] BiMap::get(self : BiMap[K, V], key : K) -> V? {
  self.forward.get(key)
}

///|
/// The key a value belongs to, which is the reverse of `get`.
pub fn[K, V : Hash + Eq] BiMap::get_key(self : BiMap[K, V], value : V) -> K? {
  self.backward.get(value)
}

///|
/// Whether `key` is on the key side.
pub fn[K : Hash + Eq, V] BiMap::contains_key(
  self : BiMap[K, V],
  key : K,
) -> Bool {
  self.forward.contains(key)
}

///|
/// Whether `value` is on the value side.
pub fn[K, V : Hash + Eq] BiMap::contains_value(
  self : BiMap[K, V],
  value : V,
) -> Bool {
  self.backward.contains(value)
}

///|
/// Removes the pair whose key is `key` from both sides and returns it.
pub fn[K : Hash + Eq, V : Hash + Eq] BiMap::remove_key(
  self : BiMap[K, V],
  key : K,
) -> (K, V)? {
  match self.forward.remove(key) {
    Some(value) => {
      let _ = self.backward.remove(value)
      Some((key, value))
    }
    None => None
  }
}

///|
/// Removes the pair whose value is `value` from both sides and returns it.
pub fn[K : Hash + Eq, V : Hash + Eq] BiMap::remove_value(
  self : BiMap[K, V],
  value : V,
) -> (K, V)? {
  match self.backward.remove(value) {
    Some(key) => {
      let _ = self.forward.remove(key)
      Some((key, value))
    }
    None => None
  }
}

///|
/// How many pairs the bijection holds.
pub fn[K, V] BiMap::length(self : BiMap[K, V]) -> Int32 {
  self.forward.length()
}

///|
/// Whether the bijection holds no pair.
pub fn[K, V] BiMap::is_empty(self : BiMap[K, V]) -> Bool {
  self.forward.is_empty()
}

///|
/// The pairs in insertion order.
pub fn[K, V] BiMap::iter(self : BiMap[K, V]) -> Iter[(K, V)] {
  self.forward.iter()
}

///|
/// The keys in insertion order.
pub fn[K, V] BiMap::keys(self : BiMap[K, V]) -> Iter[K] {
  self.forward.keys()
}

///|
/// The values, in the order their keys were inserted.
pub fn[K, V] BiMap::values(self : BiMap[K, V]) -> Iter[V] {
  self.forward.values()
}

///|
/// Removes every pair from both sides.
pub fn[K, V] BiMap::clear(self : BiMap[K, V]) -> Unit {
  self.forward.clear()
  self.backward.clear()
}

///|
/// A copy that owns both tables: a change to either bijection is invisible to the other.
pub fn[K, V] BiMap::copy(self : BiMap[K, V]) -> BiMap[K, V] {
  { forward: self.forward.copy(), backward: self.backward.copy(), }
}

///|
pub impl[K : Eq, V : Eq] Eq for BiMap[K, V] with fn equal(self, other) {
  self.forward.equal(other.forward)
}

///|
pub extend BiMap with Eq::{equal, not_equal}

///|
pub impl[K : Show, V : Show] Show for BiMap[K, V] with fn output(self, logger) {
  logger.write_string("BiMap")
  self.forward.output(logger)
}

///|
pub extend BiMap with Show::{to_string, output}
