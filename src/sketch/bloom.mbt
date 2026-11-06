///|
/// One over the natural logarithm of two, which turns a ratio into a bit count.
let inv_ln2 : Double = 1.4426950408889634

///|
/// The two knobs of a Bloom filter. A record rather than two parameters,
/// because callers change one of them far more often than both.
#derive(Eq, Debug)
pub(all) struct BloomOptions {
  /// The share of absent items that may be reported as present. `0.01` is
  /// Redis's default, where Guava's is `0.03`.
  false_positive_rate : Double
  /// Whether the filter grows past the expected item count.
  growth : Growth
}

///|
pub extend BloomOptions with Eq::{equal, not_equal}

///|
pub extend BloomOptions with Debug::{to_repr}

///|
pub let bloom_options : BloomOptions = {
  false_positive_rate: 0.01,
  growth: Fixed,
}

///|
/// How a Bloom filter behaves once it holds more items than it was sized for.
#derive(Eq, Debug)
pub(all) enum Growth {
  /// Keep the same bit array. The false-positive rate degrades, and
  /// `estimated_false_positive_rate` reports what it has become. This is
  /// Guava's behaviour.
  Fixed
  /// Add a new, twice as large and half as tolerant layer, which is the
  /// layered scheme RedisBloom uses. The combined rate stays at the requested
  /// one; the cost is memory that grows with the item count.
  Scalable
}

///|
pub extend Growth with Eq::{equal, not_equal}

///|
pub extend Growth with Debug::{to_repr}

///|
/// One bloom of a filter. A `Fixed` filter holds exactly one; a `Scalable`
/// filter adds one when the newest is full.
pub struct BloomLayer {
  words : Array[UInt64]
  bit_count : Int32
  capacity : Int32
  mut items : Int64
  rate : Double
}

///|
/// A Bloom filter answers membership with no false negatives: an item it has
/// taken in is always reported as possibly present. Absent items are reported
/// as present at most at the requested rate, and the bit count follows from the
/// expected item count and that rate, so no caller picks a size by hand.
///
/// The item type is hashed with the filter's seed, which is stored with the
/// bits so that a decoded filter answers exactly as the one that wrote it.
#warnings("-unused_type_variable")
pub struct BloomFilter[T] {
  hash_seed : Int32
  hashes : Int32
  expected_items : Int32
  false_positive_rate : Double
  growth : Growth
  layers : Array[BloomLayer]
  mut items : Int64
}

///|
/// The bit count that keeps a layer of `capacity` items at or below `rate`
/// with `hashes` probes, from `m = -k n / @math.ln(1 - p^(1/k))`.
fn bloom_bit_size(capacity : Int32, rate : Double, hashes : Int32) -> Double {
  let per_bit = 1.0 - @math.pow(rate, 1.0 / hashes.to_double())
  -(hashes.to_double() * capacity.to_double()) / @math.ln(per_bit)
}

///|
/// The optimal probe count for a rate, `k = log2(1/p)`, at least one. It is
/// computed once per filter and used by every layer, so that a scalable filter
/// keeps one probe pattern across its layers.
fn bloom_hash_count(rate : Double) -> Int32 {
  let optimal = -@math.ln(rate) * inv_ln2
  let mut count = optimal.round().to_int()
  if count < 1 {
    count = 1
  }
  // Probe counts beyond this only cover rates below 1e-18, where the bit
  // array is already larger than any caller will allocate.
  if count > 64 {
    count = 64
  }
  count
}

///|
/// The target rate of one layer. Layer `i` is `0.5^(i+1)` of the requested
/// rate, so the layers' rates sum to it; this is the tightening ratio of
/// RedisBloom's scalable filter.
fn bloom_layer_rate(rate : Double, index : Int32) -> Double {
  let scaled = rate * @math.pow(0.5, (index + 1).to_double())
  if scaled <
    0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001 {
    0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001
  } else {
    scaled
  }
}

///|
/// Builds a layer, or `None` when its bit array would not fit an `Int32` bit
/// count, which is where growth stops.
fn bloom_layer(capacity : Int32, rate : Double, hashes : Int32) -> BloomLayer? {
  let bits = bloom_bit_size(capacity, rate, hashes)
  // The largest whole number of 64-bit words an Int32 bit count can describe.
  if bits > 2147483584.0 {
    return None
  }
  let mut words = (bits.ceil().to_int() + 63) / 64
  if words < 1 {
    words = 1
  }
  Some({
    words: Array::make(words, 0UL),
    bit_count: words * 64,
    capacity,
    items: 0,
    rate,
  })
}

///|
/// The bit positions a hash selects in a layer, by Kirsch-Mitzenmacher double
/// hashing: `(h1 + i * h2) mod m` for `i` in `[0, k)`. The two halves of one
/// 64-bit hash are independent enough for this, and one hash per item is what
/// makes `insert` O(k) rather than O(k) hashes.
fn bloom_position(hash : UInt64, index : Int32, bit_count : Int32) -> Int32 {
  let step = (hash >> 32) | 1UL
  ((hash + index.to_uint64() * step) % bit_count.to_uint64())
  .to_uint()
  .reinterpret_as_int()
}

///|
/// Sets the layer's bits for a hash and reports whether any of them was clear.
fn bloom_set(layer : BloomLayer, hash : UInt64, hashes : Int32) -> Bool {
  let mut changed = false
  for index in 0..<hashes {
    let position = bloom_position(hash, index, layer.bit_count)
    let word = position / 64
    let mask = 1UL << (position % 64)
    if (layer.words[word] & mask) == 0UL {
      layer.words[word] = layer.words[word] | mask
      changed = true
    }
  }
  changed
}

///|
/// Whether every one of the layer's bits for a hash is set.
fn bloom_test(layer : BloomLayer, hash : UInt64, hashes : Int32) -> Bool {
  for index in 0..<hashes {
    let position = bloom_position(hash, index, layer.bit_count)
    let word = position / 64
    let mask = 1UL << (position % 64)
    if (layer.words[word] & mask) == 0UL {
      return false
    }
  }
  true
}

///|
/// Builds a filter sized for `expected_items` at
/// `bloom_options.false_positive_rate`.
///
/// The bit count is `m = -k n / @math.ln(1 - p^(1/k))` with `k = log2(1/p)`, the
/// standard optimum; with the default rate of 1% that is 9.6 bits per item and
/// 7 probes. A `Scalable` filter starts with one layer and adds more as it
/// fills.
///
/// ```mbt check
/// test {
///   let filter : @sketch.BloomFilter[String] = @sketch.BloomFilter::new(
///     expected_items=1000,
///   ) catch {
///     _ => abort("valid parameters")
///   }
///   assert_false(filter.may_contain("absent"))
///   assert_true(filter.insert("present"))
///   assert_true(filter.may_contain("present"))
/// }
/// ```
pub fn[T] BloomFilter::new(
  expected_items~ : Int32,
  bloom_options~ : BloomOptions = bloom_options,
  hash_seed~ : Int32 = @spec.hash_seed(),
) -> BloomFilter[T] raise @spec.Refused {
  if expected_items <= 0 {
    raise @spec.Refused::Capacity(got=expected_items)
  }
  let rate = bloom_options.false_positive_rate
  if !(rate > 0.0) || !(rate < 1.0) {
    raise @spec.Refused::Probability(got=rate)
  }
  let hashes = bloom_hash_count(rate)
  let layer = match
    bloom_layer(expected_items, bloom_layer_rate(rate, 0), hashes) {
    Some(layer) => layer
    None => raise @spec.Refused::Capacity(got=expected_items)
  }
  {
    hash_seed,
    hashes,
    expected_items,
    false_positive_rate: rate,
    growth: bloom_options.growth,
    layers: [layer],
    items: 0,
  }
}

///|
/// Adds an item and reports whether the filter changed. `true` means the item
/// was certainly absent before: at least one of its bits was clear. A `false`
/// return leaves the filter untouched.
///
/// A `Scalable` filter opens a new layer first when the newest one is full.
pub fn[T : Hash] BloomFilter::insert(self : BloomFilter[T], item : T) -> Bool {
  if self.may_contain(item) {
    return false
  }
  self.grow_if_needed()
  let index = self.layers.length() - 1
  let hash = hash_with_seed(item, self.hash_seed)
  let changed = bloom_set(self.layers[index], hash, self.hashes)
  if changed {
    let layer = self.layers[index]
    layer.items = layer.items + 1
    self.layers[index] = layer
    self.items = self.items + 1
  }
  changed
}

///|
/// Opens layers until the newest one has room, or until the next layer would
/// not fit. Only a `Scalable` filter grows; a `Fixed` one keeps filling its
/// last layer at a worsening rate.
fn[T] BloomFilter::grow_if_needed(self : BloomFilter[T]) -> Unit {
  if self.growth is Fixed {
    return
  }
  let mut growing = true
  while growing {
    growing = false
    let index = self.layers.length() - 1
    let last = self.layers[index]
    if last.items < last.capacity.to_int64() {
      return
    }
    // Capacity doubles and the rate halves; a layer that would not fit ends
    // the growth rather than failing the insert, which cannot raise.
    if last.capacity <= 1073741824 {
      let next_capacity = last.capacity * 2
      let next_rate = bloom_layer_rate(
        self.false_positive_rate,
        self.layers.length(),
      )
      match bloom_layer(next_capacity, next_rate, self.hashes) {
        Some(layer) => {
          self.layers.push(layer)
          growing = true
        }
        None => ()
      }
    }
  }
}

///|
/// Whether the item may be present. It is always `true` for an item that has
/// been inserted, and may be `true` for an absent one at the filter's rate.
pub fn[T : Hash] BloomFilter::may_contain(
  self : BloomFilter[T],
  item : T,
) -> Bool {
  let hash = hash_with_seed(item, self.hash_seed)
  for index in 0..<self.layers.length() {
    if bloom_test(self.layers[index], hash, self.hashes) {
      return true
    }
  }
  false
}

///|
/// The rate the filter would show at its present fill, `(1 - e^(-kn/m))^k`
/// per layer, combined across layers. It assumes the hash behaves ideally, so
/// it is an estimate of the design, not a measurement of inserted keys.
pub fn[T] BloomFilter::estimated_false_positive_rate(
  self : BloomFilter[T],
) -> Double {
  let mut survives = 1.0
  for index in 0..<self.layers.length() {
    let layer = self.layers[index]
    if layer.items > 0 {
      let n = layer.items.to_double()
      let m = layer.bit_count.to_double()
      let k = self.hashes.to_double()
      let filled = 1.0 - @math.exp(-(k * n) / m)
      let rate = @math.pow(filled, k)
      survives = survives * (1.0 - rate)
    }
  }
  1.0 - survives
}

///|
/// The union of two filters of the same shape, by a bitwise or. Items that
/// were in either filter are reported present, at a rate no worse than the
/// worse of the two.
pub fn[T] BloomFilter::union(
  self : BloomFilter[T],
  other : BloomFilter[T],
) -> BloomFilter[T] raise @spec.Refused {
  self.combine(other, true)
}

///|
/// The intersection of two filters of the same shape, by a bitwise and. An
/// item in both is still reported present; an item in only one has at least
/// one clear bit in the other, so it usually drops out.
pub fn[T] BloomFilter::intersection(
  self : BloomFilter[T],
  other : BloomFilter[T],
) -> BloomFilter[T] raise @spec.Refused {
  self.combine(other, false)
}

///|
fn[T] BloomFilter::combine(
  self : BloomFilter[T],
  other : BloomFilter[T],
  union : Bool,
) -> BloomFilter[T] raise @spec.Refused {
  if self.expected_items != other.expected_items ||
    self.false_positive_rate != other.false_positive_rate ||
    self.growth != other.growth ||
    self.hashes != other.hashes ||
    self.layers.length() != other.layers.length() {
    raise @spec.Refused::Incompatible
  }
  let result = self.copy()
  for index in 0..<result.layers.length() {
    let left = result.layers[index]
    let right = other.layers[index]
    if left.bit_count != right.bit_count || left.capacity != right.capacity {
      raise @spec.Refused::Incompatible
    }
    for word in 0..<left.words.length() {
      if union {
        left.words[word] = left.words[word] | right.words[word]
      } else {
        left.words[word] = left.words[word] & right.words[word]
      }
    }
    // The bits do not record how many items the two filters shared, so the
    // count is bounded rather than computed exactly.
    left.items = if union {
      if left.items > right.items {
        left.items
      } else {
        right.items
      }
    } else if left.items < right.items {
      left.items
    } else {
      right.items
    }
    result.layers[index] = left
  }
  result.items = if union {
    if self.items > other.items {
      self.items
    } else {
      other.items
    }
  } else if self.items < other.items {
    self.items
  } else {
    other.items
  }
  result
}

///|
/// The number of items the filter has taken in. An item the filter already
/// reported as present does not increase it, so this is the `n` of the rate
/// formula.
pub fn[T] BloomFilter::length(self : BloomFilter[T]) -> Int64 {
  self.items
}

///|
/// The number of items the filter is sized for, summed over layers.
pub fn[T] BloomFilter::capacity(self : BloomFilter[T]) -> Int32 {
  let mut total = 0
  for index in 0..<self.layers.length() {
    total = total + self.layers[index].capacity
  }
  total
}

///|
/// The number of bits in the filter, summed over layers.
pub fn[T] BloomFilter::bit_count(self : BloomFilter[T]) -> Int32 {
  let mut total = 0
  for index in 0..<self.layers.length() {
    total = total + self.layers[index].bit_count
  }
  total
}

///|
/// Whether the filter holds no items.
pub fn[T] BloomFilter::is_empty(self : BloomFilter[T]) -> Bool {
  self.items == 0
}

///|
/// Empties the filter, returning a scalable one to a single layer.
pub fn[T] BloomFilter::clear(self : BloomFilter[T]) -> Unit {
  while self.layers.length() > 1 {
    let _ = self.layers.pop()
  }
  let layer = self.layers[0]
  for word in 0..<layer.words.length() {
    layer.words[word] = 0UL
  }
  layer.items = 0
  self.layers[0] = layer
  self.items = 0
}

///|
/// A deep copy: the two filters share no bit array.
pub fn[T] BloomFilter::copy(self : BloomFilter[T]) -> BloomFilter[T] {
  let layers = Array::make(self.layers.length(), self.layers[0])
  for index in 0..<self.layers.length() {
    let layer = self.layers[index]
    layers[index] = {
      words: layer.words.copy(),
      bit_count: layer.bit_count,
      capacity: layer.capacity,
      items: layer.items,
      rate: layer.rate,
    }
  }
  {
    hash_seed: self.hash_seed,
    hashes: self.hashes,
    expected_items: self.expected_items,
    false_positive_rate: self.false_positive_rate,
    growth: self.growth,
    layers,
    items: self.items,
  }
}

///|
/// The filter as bytes: magic, version, seed, shape, then each layer's words
/// little-endian. A decoded filter answers exactly as the one that encoded it.
pub fn[T] BloomFilter::encode(self : BloomFilter[T]) -> Bytes {
  let writer = Writer::new()
  writer.write_u32(MAGIC_BLOOM)
  writer.write_byte(FORMAT_VERSION)
  writer.write_u32(self.hash_seed.reinterpret_as_uint())
  writer.write_u32(self.expected_items.reinterpret_as_uint())
  writer.write_double(self.false_positive_rate)
  let growth_byte = if self.growth is Fixed { 0 } else { 1 }
  writer.write_byte(growth_byte)
  writer.write_u32(self.hashes.reinterpret_as_uint())
  writer.write_i64(self.items)
  writer.write_u32(self.layers.length().reinterpret_as_uint())
  for index in 0..<self.layers.length() {
    let layer = self.layers[index]
    writer.write_u32(layer.capacity.reinterpret_as_uint())
    writer.write_double(layer.rate)
    writer.write_i64(layer.items)
    writer.write_u32(layer.words.length().reinterpret_as_uint())
    for word in 0..<layer.words.length() {
      writer.write_u64(layer.words[word])
    }
  }
  writer.to_bytes()
}

///|
pub fn[T] BloomFilter::decode(
  view : BytesView,
) -> BloomFilter[T] raise @spec.Refused {
  let reader = Reader::new(view)
  reader.read_header(MAGIC_BLOOM)
  let seed = reader.read_u32().reinterpret_as_int()
  let expected_items = reader.read_u32().reinterpret_as_int()
  let rate = reader.read_double()
  let growth = match reader.read_byte() {
    0 => Fixed
    1 => Scalable
    _ => decode_failure()
  }
  let hashes = reader.read_u32().reinterpret_as_int()
  let items = reader.read_i64()
  let layer_count = reader.read_count(24)
  if expected_items <= 0 ||
    !(rate > 0.0) ||
    !(rate < 1.0) ||
    hashes < 1 ||
    hashes > 64 ||
    layer_count < 1 ||
    items < 0 {
    decode_failure()
  }
  let layers = Array::make(layer_count, {
    words: [],
    bit_count: 0,
    capacity: 0,
    items: 0,
    rate: 1.0,
  })
  for index in 0..<layer_count {
    let capacity = reader.read_u32().reinterpret_as_int()
    let layer_rate = reader.read_double()
    let layer_items = reader.read_i64()
    let word_count = reader.read_count(8)
    if capacity <= 0 ||
      word_count < 1 ||
      !(layer_rate > 0.0) ||
      !(layer_rate < 1.0) ||
      layer_items < 0 {
      decode_failure()
    }
    let words = Array::make(word_count, 0UL)
    for word in 0..<word_count {
      words[word] = reader.read_u64()
    }
    layers[index] = {
      words,
      bit_count: word_count * 64,
      capacity,
      items: layer_items,
      rate: layer_rate,
    }
  }
  reader.expect_end()
  {
    hash_seed: seed,
    hashes,
    expected_items,
    false_positive_rate: rate,
    growth,
    layers,
    items,
  }
}

///|
pub impl[T] Eq for BloomFilter[T] with fn equal(self, other) {
  self.hash_seed == other.hash_seed &&
  self.hashes == other.hashes &&
  self.expected_items == other.expected_items &&
  self.false_positive_rate == other.false_positive_rate &&
  self.growth == other.growth &&
  self.items == other.items &&
  self.layers.length() == other.layers.length() &&
  ({
    let mut same = true
    for index in 0..<self.layers.length() {
      let left = self.layers[index]
      let right = other.layers[index]
      if left.bit_count != right.bit_count ||
        left.capacity != right.capacity ||
        left.items != right.items ||
        left.rate != right.rate {
        same = false
      } else {
        for word in 0..<left.words.length() {
          if left.words[word] != right.words[word] {
            same = false
          }
        }
      }
    }
    same
  })
}

///|
pub impl[T] Hash for BloomFilter[T] with fn hash_combine(self, hasher) {
  hasher.combine(self.encode())
}

///|
pub extend BloomFilter with Eq::{equal, not_equal}

///|
pub extend BloomFilter with Hash::{hash, hash_combine}

///|
pub impl[T] Show for BloomFilter[T] with fn output(self, logger) {
  logger.write_string(
    "BloomFilter(bits=\{self.bit_count()}, hashes=\{self.hashes}, items=\{self.items})",
  )
}

///|

///|

///|
pub extend BloomFilter with Show::{to_string, output}

///|
