///|
/// Marks an empty slot of the open-addressed table.
let slot_free : Int32 = -1

///|
/// Marks a slot whose entry has gone. A cluster keeps being probed past it, and
/// it is reused by the next insert that passes through, which is what keeps a
/// delete from breaking the chain of an open-addressed table.
let slot_dead : Int32 = -2

///|
/// Mixes an element's hash with the process seed. The seed has to reach every
/// bit of the result: a table laid out from a predictable hash is a table an
/// attacker can fill with collisions.
fn[K : Hash] hash_seeded(key : K, seed : Int32) -> Int32 {
  let low = key.hash().to_int64() & 0xffffffffL
  let high = seed.to_int64() & 0xffffffffL
  let mut z = (low.reinterpret_as_uint64() << 32) | high.reinterpret_as_uint64()
  z = (z ^ (z >> 30)) * 0xbf58476d1ce4e5b9
  z = (z ^ (z >> 27)) * 0x94d049bb133111eb
  z = z ^ (z >> 31)
  (z >> 33).to_uint().reinterpret_as_int() & 0x7fffffff
}

///|
/// The smallest power of two at least `n`, and at least 8.
fn bucket_count(n : Int32) -> Int32 {
  let mut count = 8
  while count < n && count < 0x40000000 {
    count = count * 2
  }
  count
}
