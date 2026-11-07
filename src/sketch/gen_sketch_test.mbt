// Differential vectors for `sketch`. The values are computed by the Python
// standard library (scripts/gen_vectors.py) and, byte for byte, by the Rust
// standard library (scripts/rust_vectors); scripts/check_vector_agreement.sh
// re-checks the two agree. They are the reference: the tests replay the same
// operations on the library and assert it produces the same results. CI
// replays these vectors; it does not regenerate them.

///|
/// The items fed to a wide count-min sketch.
let sketch_cm_items : Array[String] = ["a", "a", "a", "b", "b", "c"]

///|
/// The true counts of a, b, c.
let sketch_cm_true : Array[Int32] = [3, 2, 1]

///|
/// The promised upper bound: true count plus the error.
let sketch_cm_upper : Array[Int32] = [4, 3, 2]

///|
/// Distinct integers added to the HLL.
let sketch_hll_count : Int32 = 10000

///|
/// The relative standard error at precision 12.
let sketch_hll_rel : Double = 0.016250000

///|
/// The true 5, 50 and 95 percentiles of 1..1000.
let sketch_td_true : Array[Double] = [
  50.000000000, 500.000000000, 950.000000000,
]

///|
/// The design false-positive rate of the bloom filter.
let sketch_bloom_fp_rate : Double = 0.010000000

///|
test "differential: count-min is within the promised error" {
  let sketch : @sketch.CountMinSketch[String] = @sketch.CountMinSketch::new(
    epsilon=0.01,
    confidence=0.99,
  )
  let keys : Array[String] = ["a", "b", "c"]
  for item in sketch_cm_items {
    let _ = sketch.insert(item)
  }
  for i in 0..<3 {
    let est = sketch.estimate(keys[i])
    @test.assert_eq(est >= sketch_cm_true[i], true)
    @test.assert_eq(est <= sketch_cm_upper[i], true)
  }
}

///|
test "differential: hyperloglog is within three standard errors" {
  let hll : @sketch.HyperLogLog[Int32] = @sketch.HyperLogLog::new(
    precision=12,
    hash_seed=0,
  )
  for i in 0..<sketch_hll_count {
    hll.add(i)
  }
  let est = hll.estimate()
  let low = sketch_hll_count.to_double() * (1.0 - 3.0 * sketch_hll_rel)
  let high = sketch_hll_count.to_double() * (1.0 + 3.0 * sketch_hll_rel)
  @test.assert_eq(est >= low && est <= high, true)
}

///|
test "differential: t-digest quantiles are near the true ones" {
  let td : @sketch.TDigest = @sketch.TDigest::new(compression=100.0)
  for i in 1..<1001 {
    td.add(i.to_double())
  }
  let p05 = td.quantile(0.05)
  let p50 = td.quantile(0.5)
  let p95 = td.quantile(0.95)
  @test.assert_eq(
    p05 > sketch_td_true[0] - 8.0 && p05 < sketch_td_true[0] + 8.0,
    true,
  )
  @test.assert_eq(
    p50 > sketch_td_true[1] - 8.0 && p50 < sketch_td_true[1] + 8.0,
    true,
  )
  @test.assert_eq(
    p95 > sketch_td_true[2] - 8.0 && p95 < sketch_td_true[2] + 8.0,
    true,
  )
}

///|
test "differential: bloom has no false negatives" {
  let bloom : @sketch.BloomFilter[String] = @sketch.BloomFilter::new(
    expected_items=200,
  )
  for i in 0..<200 {
    let _ = bloom.insert("k" + i.to_string())
  }
  for i in 0..<200 {
    @test.assert_eq(bloom.may_contain("k" + i.to_string()), true)
  }
  let mut false_pos = 0
  for i in 0..<200 {
    if bloom.may_contain("q" + i.to_string()) {
      false_pos = false_pos + 1
    }
  }
  @test.assert_eq(
    false_pos.to_double() / 200.0 < 2.0 * sketch_bloom_fp_rate,
    true,
  )
}
