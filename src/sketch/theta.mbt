///|
/// A sketch that keeps the `k` smallest hashes it has seen and reports a count
/// from the largest one it kept: if the threshold sits at `theta`, then `k / theta`
/// scales a sample of `k` hashes to the whole set. Because the kept hashes are
/// exactly the ones below the threshold, the estimate is a maximum-likelihood
/// one, and two sketches combine by keeping the union's `k` smallest.
///
/// ```mbt check
/// test {
///   let sketch : @sketch.ThetaSketch[Int32] = @sketch.ThetaSketch::new(
///     nominal_entries=1024,
///   )
///   for i in 0..<500 {
///     sketch.add(i)
///   }
///   assert_true(sketch.estimate() > 450.0)
///   assert_true(sketch.estimate() < 550.0)
/// }
/// ```
#warnings("-unused_type_variable")
pub struct ThetaSketch[T] {
  seed : Int32
  nominal : Int32
  /// Sorted and free of duplicates.
  hashes : Array[UInt64]
  mut theta : UInt64
}

///|
pub fn[T] ThetaSketch::new(
  nominal_entries~ : Int32 = 4096,
  hash_seed~ : Int32 = @spec.hash_seed(),
) -> ThetaSketch[T] raise @spec.Refused {
  if nominal_entries <= 0 {
    raise @spec.Refused::Capacity(got=nominal_entries)
  }
  {
    seed: hash_seed,
    nominal: nominal_entries,
    hashes: [],
    theta: 0xFFFFFFFFFFFFFFFFUL,
  }
}

///|
fn[T] ThetaSketch::position_of(self : ThetaSketch[T], hash : UInt64) -> Int32 {
  let mut low = 0
  let mut high = self.hashes.length()
  while low < high {
    let mid = (low + high) / 2
    if self.hashes[mid] < hash {
      low = mid + 1
    } else {
      high = mid
    }
  }
  low
}

///|
pub fn[T : Hash] ThetaSketch::add(self : ThetaSketch[T], item : T) -> Unit {
  let hash = hash_with_seed(item, self.seed)
  if hash >= self.theta {
    return
  }
  let at = self.position_of(hash)
  if at < self.hashes.length() && self.hashes[at] == hash {
    return
  }
  self.hashes.insert(at, hash)
  while self.hashes.length() > self.nominal {
    let dropped = self.hashes.pop().unwrap()
    self.theta = dropped
  }
}

///|
/// The number of distinct items, exact while the sketch holds fewer than the
/// nominal count and estimated from the threshold after that.
pub fn[T] ThetaSketch::estimate(self : ThetaSketch[T]) -> Double {
  if self.hashes.length() < self.nominal {
    self.hashes.length().to_double()
  } else {
    let scale = self.theta.to_double() / 18446744073709551616.0
    if scale <= 0.0 {
      self.hashes.length().to_double()
    } else {
      self.hashes.length().to_double() / scale
    }
  }
}

///|
pub fn[T] ThetaSketch::nominal_entries(self : ThetaSketch[T]) -> Int32 {
  self.nominal
}

///|
pub fn[T] ThetaSketch::is_empty(self : ThetaSketch[T]) -> Bool {
  self.hashes.length() == 0
}

///|
pub fn[T] ThetaSketch::theta(self : ThetaSketch[T]) -> UInt64 {
  self.theta
}

///|
/// Keeps the union's `k` smallest hashes, which is what makes two sketches
/// combinable without losing the sample.
pub fn[T] ThetaSketch::union(
  self : ThetaSketch[T],
  other : ThetaSketch[T],
) -> ThetaSketch[T] {
  let result : ThetaSketch[T] = {
    seed: self.seed,
    nominal: self.nominal,
    hashes: [],
    theta: if self.theta < other.theta {
      self.theta
    } else {
      other.theta
    },
  }
  for hash in self.hashes {
    if hash < result.theta {
      result.hashes.push(hash)
    }
  }
  for hash in other.hashes {
    if hash < result.theta {
      let at = result.position_of(hash)
      if at >= result.hashes.length() || result.hashes[at] != hash {
        result.hashes.insert(at, hash)
      }
    }
  }
  while result.hashes.length() > result.nominal {
    let dropped = result.hashes.pop().unwrap()
    result.theta = dropped
  }
  result
}

///|
/// The hashes both sketches kept, which estimates the intersection of the two
/// sets while both were sampling at the same threshold.
pub fn[T] ThetaSketch::intersection(
  self : ThetaSketch[T],
  other : ThetaSketch[T],
) -> ThetaSketch[T] {
  let result : ThetaSketch[T] = {
    seed: self.seed,
    nominal: self.nominal,
    hashes: [],
    theta: if self.theta < other.theta {
      self.theta
    } else {
      other.theta
    },
  }
  for hash in self.hashes {
    if hash < result.theta {
      let at = other.position_of(hash)
      if at < other.hashes.length() && other.hashes[at] == hash {
        result.hashes.push(hash)
      }
    }
  }
  result
}

///|
/// The hashes of this sketch that the other one does not have.
pub fn[T] ThetaSketch::a_not_b(
  self : ThetaSketch[T],
  other : ThetaSketch[T],
) -> ThetaSketch[T] {
  let result : ThetaSketch[T] = {
    seed: self.seed,
    nominal: self.nominal,
    hashes: [],
    theta: if self.theta < other.theta {
      self.theta
    } else {
      other.theta
    },
  }
  for hash in self.hashes {
    if hash < result.theta {
      let at = other.position_of(hash)
      if at >= other.hashes.length() || other.hashes[at] != hash {
        result.hashes.push(hash)
      }
    }
  }
  result
}

///|
pub fn[T] ThetaSketch::copy(self : ThetaSketch[T]) -> ThetaSketch[T] {
  {
    seed: self.seed,
    nominal: self.nominal,
    hashes: self.hashes.copy(),
    theta: self.theta,
  }
}

///|
pub fn[T] ThetaSketch::encode(self : ThetaSketch[T]) -> Bytes {
  let writer = Writer::new()
  writer.write_header(MAGIC_THETA)
  writer.write_u32(self.seed.reinterpret_as_uint())
  writer.write_u32(self.nominal.reinterpret_as_uint())
  writer.write_u64(self.theta)
  for hash in self.hashes {
    writer.write_u64(hash)
  }
  writer.to_bytes()
}

///|
pub fn[T] ThetaSketch::decode(
  view : BytesView,
) -> ThetaSketch[T] raise @spec.Refused {
  let reader = Reader::new(view)
  reader.read_header(MAGIC_THETA)
  let seed = reader.read_u32().reinterpret_as_int()
  let nominal = reader.read_u32().reinterpret_as_int()
  let theta = reader.read_u64()
  if nominal <= 0 {
    decode_failure()
  }
  let count = reader.remaining() / 8
  let hashes : Array[UInt64] = []
  for _ in 0..<count {
    hashes.push(reader.read_u64())
  }
  reader.expect_end()
  { seed, nominal, hashes, theta, }
}
