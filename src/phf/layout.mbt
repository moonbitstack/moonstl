///|
/// The trade `PhfBuilder` makes between build time, table size and stored index.
///
/// `Search` is the `phf` crate's default: a displacement table over a table of
/// about `10/9` slots per key, found by searching each bucket's displacement.
/// `Quick` follows `quickphf`: the table holds about two slots per key, so almost
/// every bucket is placed at displacement zero and the search disappears.
/// `Minimal` follows `entropy-map`: the entries are kept dense and the slot is
/// turned into an entry index by a rank structure over the occupied slots.
#derive(Eq, Debug)
pub(all) enum PhfBuild {
  Search
  Quick
  Minimal
}

///|
pub extend PhfBuild with Eq::{equal, not_equal}

///|
pub extend PhfBuild with Debug::{to_repr}

///|
pub impl Show for PhfBuild with fn output(self, logger) {
  logger.write_string(
    match self {
      Search => "Search"
      Quick => "Quick"
      Minimal => "Minimal"
    },
  )
}

///|
pub extend PhfBuild with Show::{to_string, output}

///|
/// How a table is laid out. `seed` is fixed rather than drawn from the process
/// entropy on purpose: the generated source is checked in and compared byte for
/// byte, so the search has to start from the same place on every machine.
#derive(Eq, Debug)
pub(all) struct PhfOptions {
  build : PhfBuild
  seed : Int32
}

///|
pub extend PhfOptions with Eq::{equal, not_equal}

///|
pub extend PhfOptions with Debug::{to_repr}

///|
/// The preset: the `phf` crate's displacement search, starting from seed zero.
pub let phf_options : PhfOptions = { build: Search, seed: 0, }

///|
/// A perfect hash layout: everything a lookup needs that does not depend on the
/// key or the value type.
///
/// A key in bucket `b` with hash `h` sits in slot
/// `((h & 0xFFFFFFFF) + disps[b]) % table_len`. With `build` set to `Minimal`
/// that slot is an intermediate value only: the map keeps a rank structure over
/// the occupied slots and stores the entries densely.
///
/// The fields are public because a generated module embeds one of these as a
/// plain struct literal instead of running the builder at start-up. Nothing
/// trusts such a literal: `PhfMap::from_layout` re-derives the slots from the
/// keys it is given and refuses a layout that does not fit them.
#derive(Eq, Debug)
pub(all) struct PhfLayout {
  build : PhfBuild
  salt : UInt64
  buckets : Int32
  table_len : Int32
  length : Int32
  disps : Array[Int32]
}

///|
pub extend PhfLayout with Eq::{equal, not_equal}

///|
pub extend PhfLayout with Debug::{to_repr}

///|
/// How a slot becomes an entry index. `Direct` is a slot-to-index array with `-1`
/// for a free slot; `Ranked` is the `Minimal` representation.
pub enum PhfIndex {
  Direct(FixedArray[Int32])
  Ranked(PhfRank)
}

///|
/// The `Minimal` index: a bitmap of the occupied slots, the number of set bits
/// before each word, and one `Int32` per entry in slot order. Reading an index
/// costs a shift, a mask and a popcount instead of a table lookup, and the stored
/// data is one word per 64 slots plus one index per key.
pub struct PhfRank {
  words : FixedArray[UInt64]
  prefixes : FixedArray[Int32]
  dense : FixedArray[Int32]
}

///|
fn PhfRank::lookup(self : PhfRank, slot : Int32) -> Int32? {
  let word = slot / 64
  let offset = slot % 64
  let bit : UInt64 = 1
  if ((self.words[word] >> offset) & bit) == bit {
    let lower = (self.words[word] & ((bit << offset) - bit)).popcnt()
    Some(self.dense[self.prefixes[word] + lower])
  } else {
    None
  }
}

///|
fn PhfIndex::lookup(self : PhfIndex, slot : Int32) -> Int32? {
  match self {
    Direct(slots) => {
      let index = slots[slot]
      if index < 0 {
        None
      } else {
        Some(index)
      }
    }
    Ranked(rank) => rank.lookup(slot)
  }
}

///|
/// The build parameters of a layout kind. `bucket_div` keys share a bucket on
/// average; the load ratio determines the table size; `max_displacement` bounds
/// the per-bucket search before the builder moves on to another salt.
priv struct BuildParams {
  bucket_div : Int32
  load_den : Int32
  load_num : Int32
  max_displacement : Int32
}

///|
fn build_params(build : PhfBuild) -> BuildParams {
  match build {
    Search =>
      { bucket_div: 4, load_den: 10, load_num: 9, max_displacement: 65536, }
    Quick => { bucket_div: 4, load_den: 2, load_num: 1, max_displacement: 8, }
    Minimal =>
      { bucket_div: 8, load_den: 16, load_num: 15, max_displacement: 65536, }
  }
}

///|
/// The number of buckets. A bucket is placed as a run of consecutive slots, so
/// four keys per bucket keeps the displacement search short without making the
/// displacement table itself large.
fn bucket_count(n : Int32, params : BuildParams) -> Int32 {
  let count = n / params.bucket_div
  if count < 1 {
    1
  } else {
    count
  }
}

///|
/// The smallest table that holds `n` keys at the given load, never below eight
/// slots so that tiny key sets still have room for a bucket.
fn table_len_for(n : Int32, params : BuildParams) -> Int32 {
  let numerator = n.to_int64().reinterpret_as_uint64() *
    params.load_den.to_int64().reinterpret_as_uint64()
  let denominator = params.load_num.to_int64().reinterpret_as_uint64()
  let scaled = (numerator + denominator - 1) / denominator
  if scaled < 8 {
    8
  } else {
    scaled.to_int()
  }
}

///|
/// Whether a bucket can never be placed: two keys with low hashes equal modulo
/// the table length collide for every displacement. Detecting that saves a full
/// sweep of displacements before giving up on the salt.
fn bucket_is_impossible(
  hashes : FixedArray[UInt64],
  items : FixedArray[Int32],
  start : Int32,
  count : Int32,
  table_len : Int32,
) -> Bool {
  let modulus = table_len.to_int64().reinterpret_as_uint64()
  for i in 0..<count {
    let a = (hashes[items[start + i]] & 0xFFFFFFFF) % modulus
    for j in 0..<i {
      if (hashes[items[start + j]] & 0xFFFFFFFF) % modulus == a {
        return true
      }
    }
  }
  false
}

///|
/// Places every bucket, largest first, at the smallest displacement that keeps
/// the bucket's slots free and distinct. Returns the displacement of each bucket,
/// or `None` when this salt cannot place the key set.
fn place_buckets(
  hashes : FixedArray[UInt64],
  buckets : Int32,
  table_len : Int32,
  max_displacement : Int32,
) -> Array[Int32]? {
  let n = hashes.length()
  let counts : FixedArray[Int32] = FixedArray::make(buckets, 0)
  let bucket_of : FixedArray[Int32] = FixedArray::make(n, 0)
  for i in 0..<n {
    let bucket = phf_bucket(hashes[i], buckets)
    bucket_of[i] = bucket
    counts[bucket] = counts[bucket] + 1
  }
  let starts : FixedArray[Int32] = FixedArray::make(buckets, 0)
  let mut running = 0
  for b in 0..<buckets {
    starts[b] = running
    running = running + counts[b]
  }
  let items : FixedArray[Int32] = FixedArray::make(n, 0)
  let cursor : FixedArray[Int32] = FixedArray::make(buckets, 0)
  for b in 0..<buckets {
    cursor[b] = starts[b]
  }
  for i in 0..<n {
    let bucket = bucket_of[i]
    items[cursor[bucket]] = i
    cursor[bucket] = cursor[bucket] + 1
  }
  let order : Array[Int32] = []
  for b in 0..<buckets {
    order.push(b)
  }
  order.sort_by(fn(a, b) {
    let left = counts[a]
    let right = counts[b]
    if left > right {
      -1
    } else if left < right {
      1
    } else {
      a - b
    }
  })
  let owner : FixedArray[Int32] = FixedArray::make(table_len, -1)
  let disps : Array[Int32] = []
  for _ in 0..<buckets {
    disps.push(0)
  }
  for position in 0..<buckets {
    let bucket = order[position]
    let count = counts[bucket]
    if count > 0 {
      if bucket_is_impossible(hashes, items, starts[bucket], count, table_len) {
        return None
      }
      let slots : FixedArray[Int32] = FixedArray::make(count, 0)
      let mut chosen = -1
      let mut displacement = 0
      while chosen < 0 && displacement < max_displacement {
        let mut fits = true
        let mut j = 0
        while fits && j < count {
          let slot = phf_slot(
            hashes[items[starts[bucket] + j]],
            displacement,
            table_len,
          )
          if owner[slot] >= 0 {
            fits = false
          } else {
            let mut t = 0
            while fits && t < j {
              if slots[t] == slot {
                fits = false
              }
              t = t + 1
            }
            if fits {
              slots[j] = slot
            }
          }
          j = j + 1
        }
        if fits {
          chosen = displacement
        }
        displacement = displacement + 1
      }
      if chosen < 0 {
        return None
      }
      for j in 0..<count {
        owner[slots[j]] = items[starts[bucket] + j]
      }
      disps[bucket] = chosen
    }
  }
  Some(disps)
}

///|
/// Builds a layout for pre-computed key bytes.
///
/// The search is bounded twice over: each bucket tries at most
/// `max_displacement` displacements, and a salt that cannot place every bucket
/// is replaced by the next one. When every salt has failed the table doubles and
/// the search starts again, because a lower load factor makes a placement easier
/// to find. `None` means the bounds were exhausted.
fn search_layout(
  bytes : Array[Bytes],
  build : PhfBuild,
  seed : Int32,
) -> PhfLayout? {
  let n = bytes.length()
  let params = build_params(build)
  if n == 0 {
    return Some({
      build,
      salt: phf_salt(seed, 0),
      buckets: 1,
      table_len: 1,
      length: 0,
      disps: [0],
    })
  }
  let buckets = bucket_count(n, params)
  let mut table_len = table_len_for(n, params)
  let mut grow = 0
  while grow < 6 {
    let mut attempt = 0
    while attempt < 64 {
      let salt = phf_salt(seed, grow * 64 + attempt)
      let hashes : FixedArray[UInt64] = FixedArray::make(n, 0)
      for i in 0..<n {
        hashes[i] = phf_hash(bytes[i][:], salt)
      }
      match place_buckets(hashes, buckets, table_len, params.max_displacement) {
        Some(disps) =>
          return Some({ build, salt, buckets, table_len, length: n, disps, })
        None => attempt = attempt + 1
      }
    }
    if table_len > 0x10000000 {
      break
    }
    table_len = table_len * 2
    grow = grow + 1
  }
  None
}

///|
/// Turns a slot owner array into the index a map reads.
fn make_index(owner : FixedArray[Int32], layout : PhfLayout) -> PhfIndex {
  match layout.build {
    Minimal => Ranked(rank_from_owner(owner, layout.table_len, layout.length))
    _ => Direct(owner)
  }
}

///|
/// Builds the `Minimal` rank structure: the occupancy bitmap, the prefix popcount
/// of every word, and the entry indices in slot order.
fn rank_from_owner(
  owner : FixedArray[Int32],
  table_len : Int32,
  length : Int32,
) -> PhfRank {
  let word_count = (table_len + 63) / 64
  let words : FixedArray[UInt64] = FixedArray::make(word_count, 0)
  for slot in 0..<table_len {
    if owner[slot] >= 0 {
      let bit : UInt64 = 1
      words[slot / 64] = words[slot / 64] | (bit << (slot % 64))
    }
  }
  let prefixes : FixedArray[Int32] = FixedArray::make(word_count, 0)
  let mut running = 0
  for word in 0..<word_count {
    prefixes[word] = running
    running = running + words[word].popcnt()
  }
  let dense : FixedArray[Int32] = FixedArray::make(length, 0)
  let mut rank = 0
  for slot in 0..<table_len {
    if owner[slot] >= 0 {
      dense[rank] = owner[slot]
      rank = rank + 1
    }
  }
  { words, prefixes, dense, }
}

///|
/// A copy of a layout whose displacement array the map owns, so that mutating
/// the literal a caller still holds cannot corrupt lookups.
fn copy_layout(layout : PhfLayout) -> PhfLayout {
  {
    build: layout.build,
    salt: layout.salt,
    buckets: layout.buckets,
    table_len: layout.table_len,
    length: layout.length,
    disps: layout.disps.copy(),
  }
}

///|
/// The layout of an empty table: one bucket, one slot, no entries.
