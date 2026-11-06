///|
/// The finalizer splitmix64 applies: two multiply/xor-shift rounds and a final
/// xor-shift. It spreads every input bit across the whole word, which is what
/// lets the high half of the result select a bucket and the low half a slot.
fn phf_mix64(value : UInt64) -> UInt64 {
  let mut z = value
  z = (z ^ (z >> 30)) * 0xbf58476d1ce4e5b9
  z = (z ^ (z >> 27)) * 0x94d049bb133111eb
  z ^ (z >> 31)
}

///|
/// The hash a table is both built and probed with: FNV-1a 64 over the key bytes,
/// starting from the salt, then the splitmix64 finalizer.
///
/// Only fixed constants and integer arithmetic are used. The core `Hash` trait
/// cannot be used instead: its output is allowed to vary between processes and
/// backends, while a generated table has to lay out identically everywhere.
fn phf_hash(bytes : BytesView, salt : UInt64) -> UInt64 {
  let mut hash : UInt64 = 0xcbf29ce484222325 ^ salt
  for i in 0..<bytes.length() {
    hash = (hash ^ bytes[i].to_uint64()) * 0x100000001b3
  }
  phf_mix64(hash)
}

///|
/// The salt for a given seed and attempt number. Attempt zero uses the seed the
/// caller asked for, so a table that places every bucket on the first attempt —
/// which is the normal case — depends on nothing but `seed` and the key order.
fn phf_salt(seed : Int32, attempt : Int32) -> UInt64 {
  let seed_bits = seed.to_int64().reinterpret_as_uint64()
  let attempt_bits = attempt.to_int64().reinterpret_as_uint64()
  phf_mix64(seed_bits ^ (attempt_bits << 32))
}

///|
/// The bucket a hash belongs to. The high half of the hash is independent enough
/// from the low half that the two can choose bucket and slot without interfering.
fn phf_bucket(hash : UInt64, buckets : Int32) -> Int32 {
  ((hash >> 32) % buckets.to_int64().reinterpret_as_uint64()).to_int()
}

///|
/// The slot a hash with a given bucket displacement lands in. `d` only shifts
/// the start of the bucket's run, so all the keys of a bucket keep their relative
/// order and cannot collide with each other once their positions are distinct.
fn phf_slot(hash : UInt64, displacement : Int32, table_len : Int32) -> Int32 {
  let low = hash & 0xFFFFFFFF
  ((low + displacement.to_int64().reinterpret_as_uint64()) %
  table_len.to_int64().reinterpret_as_uint64()).to_int()
}
