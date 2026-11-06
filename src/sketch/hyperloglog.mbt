///|
/// The number of leading zero bits of a 64-bit word.
fn leading_zeros(value : UInt64) -> Int32 {
  if value == 0UL {
    return 64
  }
  let mut at = 63
  while at >= 0 {
    let one : UInt64 = 1
    if (value & (one << at)) != 0UL {
      return 63 - at
    }
    at = at - 1
  }
  64
}

///|
/// An estimate of how many distinct items were added, from one small register
/// per bucket: each item sets its bucket to the longest run of leading zeroes
/// its hash produced, and the harmonic mean of the registers is the estimate.
/// The error is about `1.04 / sqrt(m)`, so a thousand registers buy three
/// percent, and neither the memory nor the insert cost depends on the count.
///
/// ```mbt check
/// test {
///   let log : @sketch.HyperLogLog[Int32] = @sketch.HyperLogLog::new(precision=12)
///   for i in 0..<1000 {
///     log.add(i)
///   }
///   let estimate = log.estimate()
///   assert_true(estimate > 900.0)
///   assert_true(estimate < 1100.0)
/// }
/// ```
#warnings("-unused_type_variable")
pub struct HyperLogLog[T] {
  seed : Int32
  precision : Int32
  registers : Array[Int32]
}

///|
/// `precision` is the number of bits that choose the bucket, so the register
/// count is `2^precision`. The usual range is 4 to 18: below 4 the error is
/// unusable, above 18 the register array is no longer small.
pub fn[T] HyperLogLog::new(
  precision~ : Int32 = 14,
  hash_seed~ : Int32 = @spec.hash_seed(),
) -> HyperLogLog[T] raise @spec.Refused {
  if precision < 4 || precision > 18 {
    raise @spec.Refused::Precision(got=precision)
  }
  let count = 1 << precision
  let registers : Array[Int32] = []
  for _ in 0..<count {
    registers.push(0)
  }
  { seed: hash_seed, precision, registers, }
}

///|
pub fn[T : Hash] HyperLogLog::add(self : HyperLogLog[T], item : T) -> Unit {
  let hash = hash_with_seed(item, self.seed)
  let bucket = (hash >> (64 - self.precision)).to_uint().reinterpret_as_int()
  let rest = hash << self.precision
  let mut rank = leading_zeros(rest) + 1
  let ceiling = 64 - self.precision + 1
  if rank > ceiling {
    rank = ceiling
  }
  if rank > self.registers[bucket] {
    self.registers[bucket] = rank
  }
}

///|
/// The constant that corrects the harmonic mean for the register count.
fn hll_alpha(registers : Int32) -> Double {
  if registers == 16 {
    0.673
  } else if registers == 32 {
    0.697
  } else if registers == 64 {
    0.709
  } else {
    0.7213 / (1.0 + 1.079 / registers.to_double())
  }
}

///|
pub fn[T] HyperLogLog::estimate(self : HyperLogLog[T]) -> Double {
  let count = self.registers.length().to_double()
  let mut sum = 0.0
  let mut zeros = 0
  for register in self.registers {
    sum = sum + @math.pow(2.0, -register.to_double())
    if register == 0 {
      zeros = zeros + 1
    }
  }
  let raw = hll_alpha(self.registers.length()) * count * count / sum
  let two_64 = 18446744073709551616.0
  if raw <= 2.5 * count && zeros > 0 {
    // Below the range where the raw estimate is trustworthy, counting the empty
    // buckets is far more accurate.
    count * @math.ln(count / zeros.to_double())
  } else if raw > two_64 / 30.0 {
    -two_64 * @math.ln(1.0 - raw / two_64)
  } else {
    raw
  }
}

///|
/// Folds another log of the same precision into this one, register by register.
pub fn[T] HyperLogLog::merge(
  self : HyperLogLog[T],
  other : HyperLogLog[T],
) -> Unit raise @spec.Refused {
  if self.precision != other.precision {
    raise @spec.Refused::Incompatible
  }
  for i in 0..<self.registers.length() {
    if other.registers[i] > self.registers[i] {
      self.registers[i] = other.registers[i]
    }
  }
}

///|
pub fn[T] HyperLogLog::precision(self : HyperLogLog[T]) -> Int32 {
  self.precision
}

///|
pub fn[T] HyperLogLog::is_empty(self : HyperLogLog[T]) -> Bool {
  for register in self.registers {
    if register != 0 {
      return false
    }
  }
  true
}

///|
pub fn[T] HyperLogLog::clear(self : HyperLogLog[T]) -> Unit {
  for i in 0..<self.registers.length() {
    self.registers[i] = 0
  }
}

///|
pub fn[T] HyperLogLog::copy(self : HyperLogLog[T]) -> HyperLogLog[T] {
  {
    seed: self.seed,
    precision: self.precision,
    registers: self.registers.copy(),
  }
}

///|
pub fn[T] HyperLogLog::encode(self : HyperLogLog[T]) -> Bytes {
  let writer = Writer::new()
  writer.write_header(MAGIC_HYPERLOGLOG)
  writer.write_u32(self.seed.reinterpret_as_uint())
  writer.write_u32(self.precision.reinterpret_as_uint())
  for register in self.registers {
    writer.write_byte(register)
  }
  writer.to_bytes()
}

///|
pub fn[T] HyperLogLog::decode(
  view : BytesView,
) -> HyperLogLog[T] raise @spec.Refused {
  let reader = Reader::new(view)
  reader.read_header(MAGIC_HYPERLOGLOG)
  let seed = reader.read_u32().reinterpret_as_int()
  let precision = reader.read_u32().reinterpret_as_int()
  if precision < 4 || precision > 18 {
    decode_failure()
  }
  let registers : Array[Int32] = []
  for _ in 0..<(1 << precision) {
    registers.push(reader.read_byte())
  }
  reader.expect_end()
  { seed, precision, registers, }
}
