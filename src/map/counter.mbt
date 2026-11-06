///|
/// A multiset of counts: each key carries how many times it was seen, and a key
/// whose count reaches zero leaves the counter so that iteration only ever sees
/// keys that are present.
///
/// ```mbt check
/// test {
///   let counter : @map.Counter[String] = @map.Counter::new()
///   @test.assert_eq(counter.incr("a"), 1)
///   @test.assert_eq(counter.incr_by("a", 2), 3)
///   @test.assert_eq(counter.decr("a"), 2)
///   @test.assert_eq(counter.total(), 2L)
/// }
/// ```
pub struct Counter[K] {
  map : IndexMap[K, Int32]
  mut total_count : Int64
}

///|
pub fn[K] Counter::new(
  capacity~ : Int32 = 0,
  hash_seed~ : Int32 = @spec.hash_seed(),
) -> Counter[K] {
  { map: IndexMap::new(capacity~, hash_seed~), total_count: 0L, }
}

///|
/// Adds one and returns the new count.
pub fn[K : Hash + Eq] Counter::incr(self : Counter[K], key : K) -> Int32 {
  self.incr_by(key, 1)
}

///|
/// Adds `amount`, which may be negative, and returns the new count. A count
/// that reaches zero or below removes the key.
pub fn[K : Hash + Eq] Counter::incr_by(
  self : Counter[K],
  key : K,
  amount : Int32,
) -> Int32 {
  let current = self.get(key)
  let next = current + amount
  self.total_count = self.total_count + amount.to_int64()
  if next <= 0 {
    if current > 0 {
      let _ = self.map.remove(key)
    }
    return 0
  }
  let _ = self.map.set(key, next)
  next
}

///|
pub fn[K : Hash + Eq] Counter::decr(self : Counter[K], key : K) -> Int32 {
  self.incr_by(key, -1)
}

///|
pub fn[K : Hash + Eq] Counter::decr_by(
  self : Counter[K],
  key : K,
  amount : Int32,
) -> Int32 {
  self.incr_by(key, -amount)
}

///|
/// The count of `key`, zero when it has none.
pub fn[K : Hash + Eq] Counter::get(self : Counter[K], key : K) -> Int32 {
  match self.map.get(key) {
    Some(count) => count
    None => 0
  }
}

///|
/// The sum of every count.
pub fn[K] Counter::total(self : Counter[K]) -> Int64 {
  self.total_count
}

///|
/// The `n` keys with the largest counts, ties in insertion order. `n` below
/// zero means every key.
pub fn[K] Counter::most_common(
  self : Counter[K],
  n~ : Int32,
) -> Array[(K, Int32)] {
  let entries = self.map.to_array()
  let ranked : Array[(Int32, (K, Int32))] = []
  for i, entry in entries {
    ranked.push((i, entry))
  }
  ranked.sort_by((a, b) => {
    let order = b.1.1.compare(a.1.1)
    if order != 0 {
      order
    } else {
      a.0.compare(b.0)
    }
  })
  let wanted = if n < 0 || n > entries.length() { entries.length() } else { n }
  let result : Array[(K, Int32)] = []
  for i in 0..<wanted {
    result.push(ranked[i].1)
  }
  result
}

///|
/// Every key repeated as many times as it was counted.
pub fn[K] Counter::elements(self : Counter[K]) -> Iter[K] {
  let entries = self.map.to_array()
  let mut key_at = 0
  let mut left = 0
  Iter::new(() => {
    while key_at < entries.length() {
      if left == 0 {
        left = entries[key_at].1
        if left == 0 {
          key_at = key_at + 1
          continue
        }
      }
      let key = entries[key_at].0
      left = left - 1
      if left == 0 {
        key_at = key_at + 1
      }
      return Some(key)
    }
    None
  })
}

///|
/// The sum of two counters, as a new one. The keys keep the order of `self`,
/// and keys only `other` has follow.
pub fn[K : Hash + Eq] Counter::add(
  self : Counter[K],
  other : Counter[K],
) -> Counter[K] {
  let result : Counter[K] = self.copy()
  for (key, count) in other.iter() {
    let _ = result.incr_by(key, count)
  }
  result
}

///|
/// Subtracts `other` from this counter in place, dropping keys that reach zero.
pub fn[K : Hash + Eq] Counter::subtract_in_place(
  self : Counter[K],
  other : Counter[K],
) -> Unit {
  for (key, count) in other.iter() {
    let _ = self.incr_by(key, -count)
  }
}

///|
pub fn[K] Counter::iter(self : Counter[K]) -> Iter[(K, Int32)] {
  self.map.iter()
}

///|
pub fn[K] Counter::keys(self : Counter[K]) -> Iter[K] {
  self.map.keys()
}

///|
pub fn[K] Counter::length(self : Counter[K]) -> Int32 {
  self.map.length()
}

///|
pub fn[K] Counter::is_empty(self : Counter[K]) -> Bool {
  self.map.is_empty()
}

///|
pub fn[K : Hash + Eq] Counter::retain(
  self : Counter[K],
  f : (K, Int32) -> Bool,
) -> Unit {
  let kept : Array[(K, Int32)] = []
  let mut total : Int64 = 0L
  for (key, count) in self.map.iter() {
    if f(key, count) {
      kept.push((key, count))
      total = total + count.to_int64()
    }
  }
  self.map.clear()
  for (key, count) in kept {
    let _ = self.map.set(key, count)
  }
  self.total_count = total
}

///|
pub fn[K] Counter::clear(self : Counter[K]) -> Unit {
  self.map.clear()
  self.total_count = 0L
}

///|
pub fn[K] Counter::copy(self : Counter[K]) -> Counter[K] {
  { map: self.map.copy(), total_count: self.total_count, }
}

///|
pub fn[K] Counter::to_array(self : Counter[K]) -> Array[(K, Int32)] {
  self.map.to_array()
}

///|
pub impl[K : Eq] Eq for Counter[K] with fn equal(self, other) {
  self.map.equal(other.map)
}

///|
pub extend Counter with Eq::{equal, not_equal}

///|
pub impl[K : Show] Show for Counter[K] with fn output(self, logger) {
  logger.write_string("{")
  let mut first = true
  for (key, count) in self.iter() {
    if !first {
      logger.write_string(", ")
    }
    first = false
    key.output(logger)
    logger.write_string(": ")
    logger.write_string(count.to_string())
  }
  logger.write_string("}")
}

///|
pub extend Counter with Show::{to_string, output}
