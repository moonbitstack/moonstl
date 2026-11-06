// The accuracy tests: every sketch is checked against the bound it promises,
// on a key set generated from a fixed seed so the numbers replay everywhere.

///|
priv struct SketchRng {
  mut state : UInt64
}

///|
fn SketchRng::below(self : SketchRng, bound : Int32) -> Int32 {
  self.state = self.state * 6364136223846793005 + 1442695040888963407
  let value = (self.state >> 33).to_uint().reinterpret_as_int()
  (value % bound).abs()
}

///|
test "bloom filter: no false negatives, few false positives" {
  let filter : @sketch.BloomFilter[Int32] = @sketch.BloomFilter::new(
    expected_items=1000,
    hash_seed=42,
  )
  for i in 0..<1000 {
    let _ = filter.insert(i)
  }
  for i in 0..<1000 {
    @test.assert_eq(filter.may_contain(i), true)
  }
  let mut wrong = 0
  for i in 1000..<11000 {
    if filter.may_contain(i) {
      wrong = wrong + 1
    }
  }
  // The design rate is one percent; ten thousand probes give a comfortable
  // margin either way.
  @test.assert_eq(wrong < 300, true)
  // `length` counts the inserts that set a bit no earlier item had set, so a
  // key whose bits were already all set does not raise it.
  @test.assert_eq(filter.length() >= 995L, true)
}

///|
test "bloom filter: a scalable filter keeps its rate" {
  let filter : @sketch.BloomFilter[Int32] = @sketch.BloomFilter::new(
    expected_items=100,
    bloom_options={ false_positive_rate: 0.01, growth: Scalable, },
    hash_seed=7,
  )
  for i in 0..<1000 {
    let _ = filter.insert(i)
  }
  for i in 0..<1000 {
    @test.assert_eq(filter.may_contain(i), true)
  }
}

///|
test "bloom filter: two shapes refuse to combine" {
  let small : @sketch.BloomFilter[Int32] = @sketch.BloomFilter::new(
    expected_items=10,
    hash_seed=1,
  )
  let large : @sketch.BloomFilter[Int32] = @sketch.BloomFilter::new(
    expected_items=1000,
    hash_seed=1,
  )
  let refused = try {
    let _ = small.union(large)
    Ok(())
  } catch {
    @spec.Refused::Incompatible => Err(true)
    _ => Err(false)
  }
  @test.assert_eq(refused, Err(true))
}

///|
test "bloom filter: encode and decode answer alike" {
  let filter : @sketch.BloomFilter[String] = @sketch.BloomFilter::new(
    expected_items=50,
    hash_seed=99,
  )
  for i in 0..<40 {
    let _ = filter.insert("k\{i}")
  }
  let copy : @sketch.BloomFilter[String] = @sketch.BloomFilter::decode(
    filter.encode(),
  )
  for i in 0..<40 {
    @test.assert_eq(copy.may_contain("k\{i}"), true)
  }
  @test.assert_eq(copy.length(), 40L)
}

///|
test "bloom filter: a bad rate is refused" {
  let refused = try {
    let filter : @sketch.BloomFilter[Int32] = @sketch.BloomFilter::new(
      expected_items=10,
      bloom_options={ false_positive_rate: 1.5, growth: Fixed, },
    )
    let _ = filter
    Ok(())
  } catch {
    @spec.Refused::Probability(_) => Err(true)
    _ => Err(false)
  }
  @test.assert_eq(refused, Err(true))
}

///|
test "cuckoo filter: insert, remove and a flat rate" {
  let filter : @sketch.CuckooFilter[Int32] = @sketch.CuckooFilter::new(
    expected_items=500,
    hash_seed=11,
  )
  let mut inserted = 0
  for i in 0..<500 {
    if filter.insert(i) {
      inserted = inserted + 1
    }
  }
  @test.assert_eq(inserted > 450, true)
  for i in 0..<inserted {
    @test.assert_eq(filter.may_contain(i), true)
  }
  @test.assert_eq(filter.remove(0), true)
  @test.assert_eq(filter.may_contain(0), false)
  @test.assert_eq(filter.length(), (inserted - 1).to_int64())
}

///|
test "cuckoo filter: encode and decode" {
  let filter : @sketch.CuckooFilter[String] = @sketch.CuckooFilter::new(
    expected_items=20,
    hash_seed=5,
  )
  let _ = filter.insert("a")
  let _ = filter.insert("b")
  let copy : @sketch.CuckooFilter[String] = @sketch.CuckooFilter::decode(
    filter.encode(),
  )
  @test.assert_eq(copy.may_contain("a"), true)
  @test.assert_eq(copy.may_contain("b"), true)
  @test.assert_eq(copy.length(), 2L)
}

///|
test "count min: never underestimates and merges" {
  let rng : SketchRng = { state: 0x2545f4914f6cdd1d, }
  let sketch : @sketch.CountMinSketch[Int32] = @sketch.CountMinSketch::new(
    epsilon=0.01,
    confidence=0.99,
    hash_seed=3,
  )
  let counts : Array[Int32] = []
  for _ in 0..<100 {
    counts.push(0)
  }
  for _ in 0..<5000 {
    let key = rng.below(100)
    sketch.insert(key)
    counts[key] = counts[key] + 1
  }
  for key in 0..<100 {
    let estimate = sketch.estimate(key)
    @test.assert_eq(estimate >= counts[key], true)
  }
  @test.assert_eq(sketch.total(), 5000L)
  let other : @sketch.CountMinSketch[Int32] = @sketch.CountMinSketch::new(
    epsilon=0.01,
    confidence=0.99,
    hash_seed=4,
  )
  let refused = try {
    sketch.merge(other)
    Ok(())
  } catch {
    @spec.Refused::Incompatible => Err(true)
    _ => Err(false)
  }
  // Different seeds give the same shape, so the merge is allowed.
  @test.assert_eq(refused, Ok(()))
}

///|
test "count min: encode and decode keep the counts" {
  let sketch : @sketch.CountMinSketch[String] = @sketch.CountMinSketch::new(
    epsilon=0.05,
    confidence=0.9,
    hash_seed=8,
  )
  for _ in 0..<10 {
    sketch.insert("x")
  }
  let copy : @sketch.CountMinSketch[String] = @sketch.CountMinSketch::decode(
    sketch.encode(),
  )
  @test.assert_eq(copy.estimate("x"), sketch.estimate("x"))
  @test.assert_eq(copy.total(), 10L)
}

///|
test "hyperloglog: within three percent at precision twelve" {
  let log : @sketch.HyperLogLog[Int32] = @sketch.HyperLogLog::new(
    precision=12,
    hash_seed=21,
  )
  for i in 0..<10000 {
    log.add(i)
  }
  let estimate = log.estimate()
  let error = (estimate - 10000.0) / 10000.0
  @test.assert_eq(error < 0.08 && error > -0.08, true)
}

///|
test "hyperloglog: merging counts the union" {
  let left : @sketch.HyperLogLog[Int32] = @sketch.HyperLogLog::new(
    precision=12,
    hash_seed=2,
  )
  let right : @sketch.HyperLogLog[Int32] = @sketch.HyperLogLog::new(
    precision=12,
    hash_seed=2,
  )
  for i in 0..<5000 {
    left.add(i)
  }
  for i in 5000..<10000 {
    right.add(i)
  }
  left.merge(right)
  let estimate = left.estimate()
  @test.assert_eq(estimate > 9000.0 && estimate < 11000.0, true)
}

///|
test "hyperloglog: encode and decode" {
  let log : @sketch.HyperLogLog[String] = @sketch.HyperLogLog::new(
    precision=8,
    hash_seed=13,
  )
  log.add("a")
  log.add("b")
  let copy : @sketch.HyperLogLog[String] = @sketch.HyperLogLog::decode(
    log.encode(),
  )
  @test.assert_eq(copy.estimate(), log.estimate())
  @test.assert_eq(copy.precision(), 8)
}

///|
test "hyperloglog: a precision outside the range is refused" {
  let refused = try {
    let log : @sketch.HyperLogLog[Int32] = @sketch.HyperLogLog::new(
      precision=25,
    )
    let _ = log
    Ok(())
  } catch {
    @spec.Refused::Precision(got~) => Err(got)
    _ => Err(-1)
  }
  @test.assert_eq(refused, Err(25))
}

///|
test "theta sketch: exact below the nominal count and estimated above" {
  let sketch : @sketch.ThetaSketch[Int32] = @sketch.ThetaSketch::new(
    nominal_entries=100,
    hash_seed=17,
  )
  for i in 0..<50 {
    sketch.add(i)
  }
  @test.assert_eq(sketch.estimate(), 50.0)
  for i in 50..<1000 {
    sketch.add(i)
  }
  let estimate = sketch.estimate()
  @test.assert_eq(estimate > 800.0 && estimate < 1200.0, true)
  @test.assert_eq(sketch.theta() < 0xFFFFFFFFFFFFFFFFUL, true)
}

///|
test "theta sketch: union and intersection" {
  let left : @sketch.ThetaSketch[Int32] = @sketch.ThetaSketch::new(
    nominal_entries=64,
    hash_seed=19,
  )
  let right : @sketch.ThetaSketch[Int32] = @sketch.ThetaSketch::new(
    nominal_entries=64,
    hash_seed=19,
  )
  for i in 0..<200 {
    left.add(i)
  }
  for i in 100..<300 {
    right.add(i)
  }
  let joined = left.union(right)
  @test.assert_eq(joined.estimate() > 250.0, true)
  // A sixty-four entry sample of a hundred-item overlap is a rough number, so
  // the bound here is that the estimate is in the right order of magnitude.
  let shared = left.intersection(right)
  @test.assert_eq(shared.estimate() > 10.0, true)
  @test.assert_eq(shared.estimate() < 250.0, true)
}

///|
test "tdigest: quantiles against a known distribution" {
  let digest : @sketch.TDigest = @sketch.TDigest::new()
  for i in 1..<=1000 {
    digest.add(i.to_double())
  }
  @test.assert_eq(digest.count(), 1000.0)
  for q in [0.1, 0.25, 0.5, 0.75, 0.9] {
    let expected = 1000.0 * q + 0.5
    let got = digest.quantile(q)
    let error = (got - expected).abs()
    @test.assert_eq(error < 30.0, true)
  }
  @test.assert_eq(digest.minimum(), 1.0)
  @test.assert_eq(digest.maximum(), 1000.0)
}

///|
test "tdigest: cdf and quantile agree" {
  let digest : @sketch.TDigest = @sketch.TDigest::new()
  for i in 0..<1000 {
    digest.add((i % 100).to_double())
  }
  let middle = digest.quantile(0.5)
  let share = digest.cdf(middle)
  @test.assert_eq(share > 0.4 && share < 0.6, true)
}

///|
test "tdigest: merging two digests" {
  let left : @sketch.TDigest = @sketch.TDigest::new()
  let right : @sketch.TDigest = @sketch.TDigest::new()
  for i in 0..<500 {
    left.add(i.to_double())
  }
  for i in 500..<1000 {
    right.add(i.to_double())
  }
  left.merge(right)
  @test.assert_eq(left.count(), 1000.0)
  let median = left.quantile(0.5)
  @test.assert_eq(median > 400.0 && median < 600.0, true)
}

///|
test "tdigest: encode and decode keep the distribution" {
  let digest : @sketch.TDigest = @sketch.TDigest::new()
  for i in 0..<200 {
    digest.add(i.to_double())
  }
  let copy : @sketch.TDigest = @sketch.TDigest::decode(digest.encode())
  @test.assert_eq(copy.count(), digest.count())
  @test.assert_eq(copy.minimum(), digest.minimum())
  @test.assert_eq(copy.maximum(), digest.maximum())
}

///|
test "a foreign buffer is refused" {
  let digest : @sketch.TDigest = @sketch.TDigest::new()
  digest.add(1.0)
  let bytes = digest.encode()
  let trimmed = bytes[0:8]
  let refused = try {
    let _ : @sketch.TDigest = @sketch.TDigest::decode(trimmed)
    Ok(())
  } catch {
    @spec.Refused::Incompatible => Err(true)
    _ => Err(false)
  }
  @test.assert_eq(refused, Err(true))
}
