///|
/// A sketch that counts: the estimate for an item is the smallest counter its
/// probes land on, which never underestimates because every counter it reads
/// was incremented by that item too. The width and depth come from the error
/// the caller tolerates, so nobody picks them by hand.
///
/// ```mbt check
/// test {
///   let sketch : @sketch.CountMinSketch[String] = @sketch.CountMinSketch::new(
///     epsilon=0.01,
///     confidence=0.99,
///   )
///   for _ in 0..<5 {
///     sketch.insert("a")
///   }
///   assert_true(sketch.estimate("a") >= 5)
///   assert_true(sketch.estimate("b") == 0)
///   assert_true(sketch.total() == 5L)
/// }
/// ```
#warnings("-unused_type_variable")
pub struct CountMinSketch[T] {
  seed : Int32
  width : Int32
  depth : Int32
  counters : Array[Int32]
  mut total : Int64
}

///|
/// `epsilon` bounds the overestimate as a share of the total, `confidence` is
/// how sure that bound is. The width is `ceil(e / epsilon)` and the depth
/// `ceil(ln(1 / (1 - confidence)))`, the derivation in Cormode and Muthukrishnan.
pub fn[T] CountMinSketch::new(
  epsilon~ : Double = 0.01,
  confidence~ : Double = 0.99,
  hash_seed~ : Int32 = @spec.hash_seed(),
) -> CountMinSketch[T] raise @spec.Refused {
  if !(epsilon > 0.0) || !(epsilon < 1.0) {
    raise @spec.Refused::Probability(got=epsilon)
  }
  if !(confidence > 0.0) || !(confidence < 1.0) {
    raise @spec.Refused::Probability(got=confidence)
  }
  let width = (2.718281828459045 / epsilon).ceil().to_int()
  let depth = @math.ln(1.0 / (1.0 - confidence)).ceil().to_int()
  let w = if width < 1 { 1 } else { width }
  let d = if depth < 1 { 1 } else { depth }
  let counters : Array[Int32] = []
  for _ in 0..<(w * d) {
    counters.push(0)
  }
  { seed: hash_seed, width: w, depth: d, counters, total: 0L, }
}

///|
/// The column an item probes in row `row`.
fn[T] CountMinSketch::column(
  self : CountMinSketch[T],
  item_hash : UInt64,
  row : Int32,
) -> Int32 {
  let mixed = mix64(item_hash ^ (row.to_uint64() * 0x9e3779b97f4a7c15UL))
  (mixed % self.width.to_uint64()).to_uint().reinterpret_as_int()
}

///|
/// Counts one occurrence. The conservative update raises only the counters that
/// hold the current minimum, which is what keeps the estimate from drifting up
/// faster than it has to.
pub fn[T : Hash] CountMinSketch::insert(
  self : CountMinSketch[T],
  item : T,
) -> Unit {
  let hash = hash_with_seed(item, self.seed)
  let mut lowest = 2147483647
  for row in 0..<self.depth {
    let at = row * self.width + self.column(hash, row)
    if self.counters[at] < lowest {
      lowest = self.counters[at]
    }
  }
  for row in 0..<self.depth {
    let at = row * self.width + self.column(hash, row)
    if self.counters[at] == lowest {
      self.counters[at] = self.counters[at] + 1
    }
  }
  self.total = self.total + 1L
}

///|
/// Adds `amount` occurrences at once.
pub fn[T : Hash] CountMinSketch::insert_by(
  self : CountMinSketch[T],
  item : T,
  amount : Int32,
) -> Unit {
  for _ in 0..<amount {
    self.insert(item)
  }
}

///|
pub fn[T : Hash] CountMinSketch::estimate(
  self : CountMinSketch[T],
  item : T,
) -> Int32 {
  let hash = hash_with_seed(item, self.seed)
  let mut lowest = 2147483647
  for row in 0..<self.depth {
    let at = row * self.width + self.column(hash, row)
    if self.counters[at] < lowest {
      lowest = self.counters[at]
    }
  }
  if lowest == 2147483647 {
    0
  } else {
    lowest
  }
}

///|
pub fn[T] CountMinSketch::total(self : CountMinSketch[T]) -> Int64 {
  self.total
}

///|
pub fn[T] CountMinSketch::width(self : CountMinSketch[T]) -> Int32 {
  self.width
}

///|
pub fn[T] CountMinSketch::depth(self : CountMinSketch[T]) -> Int32 {
  self.depth
}

///|
pub fn[T] CountMinSketch::is_empty(self : CountMinSketch[T]) -> Bool {
  self.total == 0L
}

///|
pub fn[T] CountMinSketch::clear(self : CountMinSketch[T]) -> Unit {
  for i in 0..<self.counters.length() {
    self.counters[i] = 0
  }
  self.total = 0L
}

///|
/// Adds another sketch of the same shape into this one.
pub fn[T] CountMinSketch::merge(
  self : CountMinSketch[T],
  other : CountMinSketch[T],
) -> Unit raise @spec.Refused {
  if self.width != other.width || self.depth != other.depth {
    raise @spec.Refused::Incompatible
  }
  for i in 0..<self.counters.length() {
    self.counters[i] = self.counters[i] + other.counters[i]
  }
  self.total = self.total + other.total
}

///|
pub fn[T] CountMinSketch::copy(self : CountMinSketch[T]) -> CountMinSketch[T] {
  {
    seed: self.seed,
    width: self.width,
    depth: self.depth,
    counters: self.counters.copy(),
    total: self.total,
  }
}

///|
pub fn[T] CountMinSketch::encode(self : CountMinSketch[T]) -> Bytes {
  let writer = Writer::new()
  writer.write_header(MAGIC_COUNT_MIN)
  writer.write_u32(self.seed.reinterpret_as_uint())
  writer.write_u32(self.width.reinterpret_as_uint())
  writer.write_u32(self.depth.reinterpret_as_uint())
  writer.write_i64(self.total)
  for counter in self.counters {
    writer.write_u32(counter.reinterpret_as_uint())
  }
  writer.to_bytes()
}

///|
pub fn[T] CountMinSketch::decode(
  view : BytesView,
) -> CountMinSketch[T] raise @spec.Refused {
  let reader = Reader::new(view)
  reader.read_header(MAGIC_COUNT_MIN)
  let seed = reader.read_u32().reinterpret_as_int()
  let width = reader.read_u32().reinterpret_as_int()
  let depth = reader.read_u32().reinterpret_as_int()
  let total = reader.read_i64()
  if width <= 0 || depth <= 0 || total < 0 {
    decode_failure()
  }
  let counters : Array[Int32] = []
  for _ in 0..<(width * depth) {
    counters.push(reader.read_u32().reinterpret_as_int())
  }
  reader.expect_end()
  { seed, width, depth, counters, total, }
}
