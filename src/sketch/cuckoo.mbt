///|
/// The shape of a Cuckoo filter. A fingerprint of `fingerprint_bits` is short
/// enough that the whole table fits in cache and long enough that a false
/// positive stays rare; four slots per bucket is the number the paper measured.
#derive(Eq, Debug)
pub(all) struct CuckooOptions {
  fingerprint_bits : Int32
  bucket_size : Int32
}

///|
pub extend CuckooOptions with Eq::{equal, not_equal}

///|
pub extend CuckooOptions with Debug::{to_repr}

///|
/// The preset: 12-bit fingerprints and four slots per bucket, as the original
/// paper's default.
pub let cuckoo_options : CuckooOptions = {
  fingerprint_bits: 12,
  bucket_size: 4,
}

///|
/// A filter that can forget: every item lives as a short fingerprint in one of
/// two buckets, and the second bucket is computed from the fingerprint alone,
/// so a removal does not have to remember where the item went. An insert that
/// cannot place its fingerprint after a bounded number of kicks reports failure
/// instead of looping, which is the one thing a Cuckoo filter trades away: its
/// false-positive rate, unlike a Bloom filter's, stays flat as it fills.
///
/// ```mbt check
/// test {
///   let filter : @sketch.CuckooFilter[String] = @sketch.CuckooFilter::new(
///     expected_items=100,
///   )
///   assert_true(filter.insert("a"))
///   assert_true(filter.may_contain("a"))
///   assert_true(filter.remove("a"))
///   assert_true(!filter.may_contain("a"))
/// }
/// ```
#warnings("-unused_type_variable")
pub struct CuckooFilter[T] {
  seed : Int32
  /// A zero entry is an empty slot; a fingerprint is stored as `value + 1`.
  slots : Array[Int32]
  buckets : Int32
  bucket_size : Int32
  bits : Int32
  mask : UInt64
  mut items : Int64
}

///|
/// A filter sized for `expected_items`, with the fingerprint width and bucket size `cuckoo_options` sets; a size or a rate it cannot use raises `Refused`.
pub fn[T] CuckooFilter::new(
  expected_items~ : Int32,
  cuckoo_options~ : CuckooOptions = cuckoo_options,
  hash_seed~ : Int32 = @spec.hash_seed(),
) -> CuckooFilter[T] raise @spec.Refused {
  if expected_items <= 0 {
    raise @spec.Refused::Capacity(got=expected_items)
  }
  let bits = cuckoo_options.fingerprint_bits
  let bucket_size = cuckoo_options.bucket_size
  if bits < 1 || bits > 30 {
    raise @spec.Refused::Precision(got=bits)
  }
  if bucket_size < 1 {
    raise @spec.Refused::Capacity(got=bucket_size)
  }
  // Four slots per item keeps the load factor at a quarter, where the kicks
  // almost never fail.
  let wanted = expected_items * 4 / bucket_size
  let mut buckets = 1
  while buckets < wanted && buckets < 0x20000000 {
    buckets = buckets * 2
  }
  let slots : Array[Int32] = []
  for _ in 0..<(buckets * bucket_size) {
    slots.push(0)
  }
  let mask : UInt64 = (1UL << bits) - 1UL
  { seed: hash_seed, slots, buckets, bucket_size, bits, mask, items: 0L, }
}

///|
fn[T] CuckooFilter::fingerprint(self : CuckooFilter[T], hash : UInt64) -> Int32 {
  let value = ((hash >> 32) & self.mask).to_uint().reinterpret_as_int()
  if value == 0 {
    1
  } else {
    value
  }
}

///|
fn[T] CuckooFilter::alternate(
  self : CuckooFilter[T],
  index : Int32,
  print : Int32,
) -> Int32 {
  let mixed = mix64(print.to_uint64() ^ 0x9e3779b97f4a7c15UL)
  let offset = (mixed % self.buckets.to_uint64()).to_uint().reinterpret_as_int()
  (index ^ offset) % self.buckets
}

///|
/// Stores the item and reports whether it found a slot. `false` means the table
/// is too full for this fingerprint, not that the item is absent: the filter is
/// unchanged and the caller should rebuild it larger.
pub fn[T : Hash] CuckooFilter::insert(self : CuckooFilter[T], item : T) -> Bool {
  let hash = hash_with_seed(item, self.seed)
  let print = self.fingerprint(hash)
  let first = (hash % self.buckets.to_uint64()).to_uint().reinterpret_as_int()
  let second = self.alternate(first, print)
  for index in [first, second] {
    let start = index * self.bucket_size
    for slot in start..<(start + self.bucket_size) {
      if self.slots[slot] == 0 {
        self.slots[slot] = print
        self.items = self.items + 1L
        return true
      }
    }
  }
  // Both buckets are full: move a fingerprint to its other bucket, repeatedly,
  // and give up after a bounded number of moves.
  let mut index = first
  let mut carried = print
  let mut kicks = 0
  while kicks < 500 {
    let start = index * self.bucket_size
    let slot = start + kicks % self.bucket_size
    let evicted = self.slots[slot]
    self.slots[slot] = carried
    carried = evicted
    index = self.alternate(index, carried)
    let other = index * self.bucket_size
    for candidate in other..<(other + self.bucket_size) {
      if self.slots[candidate] == 0 {
        self.slots[candidate] = carried
        self.items = self.items + 1L
        return true
      }
    }
    kicks = kicks + 1
  }
  false
}

///|
/// Whether `item` may have been added: `true` means it was added or the filter is wrong, `false` means it certainly was not.
pub fn[T : Hash] CuckooFilter::may_contain(
  self : CuckooFilter[T],
  item : T,
) -> Bool {
  let hash = hash_with_seed(item, self.seed)
  let print = self.fingerprint(hash)
  let first = (hash % self.buckets.to_uint64()).to_uint().reinterpret_as_int()
  let second = self.alternate(first, print)
  for index in [first, second] {
    let start = index * self.bucket_size
    for slot in start..<(start + self.bucket_size) {
      if self.slots[slot] == print {
        return true
      }
    }
  }
  false
}

///|
/// Removes one copy of the item and reports whether a fingerprint matched.
pub fn[T : Hash] CuckooFilter::remove(self : CuckooFilter[T], item : T) -> Bool {
  let hash = hash_with_seed(item, self.seed)
  let print = self.fingerprint(hash)
  let first = (hash % self.buckets.to_uint64()).to_uint().reinterpret_as_int()
  let second = self.alternate(first, print)
  for index in [first, second] {
    let start = index * self.bucket_size
    for slot in start..<(start + self.bucket_size) {
      if self.slots[slot] == print {
        self.slots[slot] = 0
        self.items = self.items - 1L
        return true
      }
    }
  }
  false
}

///|
/// The share of lookups that a table of this load factor reports wrongly, from
/// the paper's `2 b / 2^f`.
pub fn[T] CuckooFilter::estimated_false_positive_rate(
  self : CuckooFilter[T],
) -> Double {
  let capacity = (self.buckets * self.bucket_size).to_double()
  let load = if capacity == 0.0 {
    0.0
  } else {
    self.items.to_double() / capacity
  }
  let bits = @math.pow(2.0, self.bits.to_double())
  let rate = 2.0 * self.bucket_size.to_double() * load / bits
  if rate > 1.0 {
    1.0
  } else {
    rate
  }
}

///|
/// How many items were added.
pub fn[T] CuckooFilter::length(self : CuckooFilter[T]) -> Int64 {
  self.items
}

///|
/// Whether nothing has been added.
pub fn[T] CuckooFilter::is_empty(self : CuckooFilter[T]) -> Bool {
  self.items == 0L
}

///|
/// How many items the filter can hold before an insert has nowhere to go.
pub fn[T] CuckooFilter::capacity(self : CuckooFilter[T]) -> Int32 {
  self.buckets * self.bucket_size
}

///|
/// Empties every bucket.
pub fn[T] CuckooFilter::clear(self : CuckooFilter[T]) -> Unit {
  for i in 0..<self.slots.length() {
    self.slots[i] = 0
  }
  self.items = 0L
}

///|
/// A copy that owns its buckets: an add to either filter leaves the other alone.
pub fn[T] CuckooFilter::copy(self : CuckooFilter[T]) -> CuckooFilter[T] {
  {
    seed: self.seed,
    slots: self.slots.copy(),
    buckets: self.buckets,
    bucket_size: self.bucket_size,
    bits: self.bits,
    mask: self.mask,
    items: self.items,
  }
}

///|
/// The filter as bytes, in the format this module reads back with `decode`.
pub fn[T] CuckooFilter::encode(self : CuckooFilter[T]) -> Bytes {
  let writer = Writer::new()
  writer.write_header(MAGIC_CUCKOO)
  writer.write_u32(self.seed.reinterpret_as_uint())
  writer.write_u32(self.buckets.reinterpret_as_uint())
  writer.write_u32(self.bucket_size.reinterpret_as_uint())
  writer.write_u32(self.bits.reinterpret_as_uint())
  writer.write_i64(self.items)
  for slot in self.slots {
    writer.write_u32(slot.reinterpret_as_uint())
  }
  writer.to_bytes()
}

///|
/// Reads a filter back from the bytes `encode` wrote, refusing anything that is not one of its states.
pub fn[T] CuckooFilter::decode(
  view : BytesView,
) -> CuckooFilter[T] raise @spec.Refused {
  let reader = Reader::new(view)
  reader.read_header(MAGIC_CUCKOO)
  let seed = reader.read_u32().reinterpret_as_int()
  let buckets = reader.read_u32().reinterpret_as_int()
  let bucket_size = reader.read_u32().reinterpret_as_int()
  let bits = reader.read_u32().reinterpret_as_int()
  let items = reader.read_i64()
  if buckets <= 0 || bucket_size <= 0 || bits < 1 || bits > 30 || items < 0 {
    decode_failure()
  }
  let slots : Array[Int32] = []
  for _ in 0..<(buckets * bucket_size) {
    slots.push(reader.read_u32().reinterpret_as_int())
  }
  reader.expect_end()
  let mask : UInt64 = (1UL << bits) - 1UL
  { seed, slots, buckets, bucket_size, bits, mask, items, }
}
