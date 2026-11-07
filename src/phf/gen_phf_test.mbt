// Differential vectors for `phf`. The values are computed by the Python
// standard library (scripts/gen_vectors.py) and, byte for byte, by the Rust
// standard library (scripts/rust_vectors); scripts/check_vector_agreement.sh
// re-checks the two agree. They are the reference: the tests replay the same
// operations on the library and assert it produces the same results. CI
// replays these vectors; it does not regenerate them.

///|
/// The keys of the perfect hash map.
let phf_keys : Array[String] = [
  "alpha", "beta", "gamma", "delta", "epsilon", "zeta", "eta", "theta",
]

///|
/// The value of each key.
let phf_values : Array[Int32] = [1, 2, 3, 4, 5, 6, 7, 8]

///|
/// Keys not in the map.
let phf_absent : Array[String] = ["iota", "kappa", "lambda", "mu", "nu"]

///|
/// The index of each key in the ordered map.
let phf_index : Array[Int32] = [0, 1, 2, 3, 4, 5, 6, 7]

///|
test "differential: perfect hash map answers its key set" {
  let builder : @phf.PhfBuilder[String, Int32] = @phf.PhfBuilder::new(
    phf_options=@phf.phf_options,
  )
  for i in 0..<phf_keys.length() {
    let _ = builder.entry(phf_keys[i], phf_values[i])
  }
  let map : @phf.PhfMap[String, Int32] = builder.build()
  for i in 0..<phf_keys.length() {
    @test.assert_eq(map.get(phf_keys[i]), Some(phf_values[i]))
  }
  for k in phf_absent {
    @test.assert_eq(map.contains(k), false)
  }
  @test.assert_eq(map.length(), phf_keys.length())
}

///|
test "differential: ordered perfect hash map gives the index" {
  let builder : @phf.PhfBuilder[String, Int32] = @phf.PhfBuilder::new(
    phf_options=@phf.phf_options,
  )
  for i in 0..<phf_keys.length() {
    let _ = builder.entry(phf_keys[i], phf_values[i])
  }
  let om : @phf.PhfOrderedMap[String, Int32] = builder.build_ordered()
  for i in 0..<phf_keys.length() {
    @test.assert_eq(om.index(phf_keys[i]), Some(phf_index[i]))
  }
}
