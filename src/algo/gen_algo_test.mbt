// Differential vectors for `algo`. The values are computed by the Python
// standard library (scripts/gen_vectors.py) and, byte for byte, by the Rust
// standard library (scripts/rust_vectors); scripts/check_vector_agreement.sh
// re-checks the two agree. They are the reference: the tests replay the same
// operations on the library and assert it produces the same results. CI
// replays these vectors; it does not regenerate them.

///|
/// A sorted run with repeats, the shared bisect input.
let algo_sorted : Array[Int32] = [1, 2, 2, 3, 5, 5, 5, 8, 13, 21, 34, 55]

///|
/// bisect_left of every probe 0..59 into algo_sorted.
let algo_bisect_left : Array[Int32] = [
  0, 0, 1, 3, 4, 4, 7, 7, 7, 8, 8, 8, 8, 8, 9, 9, 9, 9, 9, 9, 9, 9, 10, 10, 10, 10,
  10, 10, 10, 10, 10, 10, 10, 10, 10, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11,
  11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 12, 12, 12, 12,
]

///|
/// bisect_right of every probe 0..59 into algo_sorted.
let algo_bisect_right : Array[Int32] = [
  0, 1, 3, 4, 4, 7, 7, 7, 8, 8, 8, 8, 8, 9, 9, 9, 9, 9, 9, 9, 9, 10, 10, 10, 10,
  10, 10, 10, 10, 10, 10, 10, 10, 10, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11,
  11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 12, 12, 12, 12, 12,
]

///|
/// The permutation pool.
let algo_perm_pool : Array[Int32] = [1, 2, 3]

///|
/// The combination pool.
let algo_combo_pool : Array[Int32] = [1, 2, 3, 4]

///|
/// The three Cartesian pools.
let algo_cart_pools : Array[ArrayView[Int32]] = [[1, 2][:], [3, 4][:], [5][:]]

///|
/// Every permutation of the pool, in itertools order.
let algo_perms : Array[Array[Int32]] = [
  [1, 2, 3],
  [1, 3, 2],
  [2, 1, 3],
  [2, 3, 1],
  [3, 1, 2],
  [3, 2, 1],
]

///|
/// Length-2 permutations.
let algo_perms2 : Array[Array[Int32]] = [
  [1, 2],
  [1, 3],
  [2, 1],
  [2, 3],
  [3, 1],
  [3, 2],
]

///|
/// 3-combinations.
let algo_combos : Array[Array[Int32]] = [
  [1, 2, 3],
  [1, 2, 4],
  [1, 3, 4],
  [2, 3, 4],
]

///|
/// 3-combinations with replacement.
let algo_combor : Array[Array[Int32]] = [
  [1, 1, 1],
  [1, 1, 2],
  [1, 1, 3],
  [1, 1, 4],
  [1, 2, 2],
  [1, 2, 3],
  [1, 2, 4],
  [1, 3, 3],
  [1, 3, 4],
  [1, 4, 4],
  [2, 2, 2],
  [2, 2, 3],
  [2, 2, 4],
  [2, 3, 3],
  [2, 3, 4],
  [2, 4, 4],
  [3, 3, 3],
  [3, 3, 4],
  [3, 4, 4],
  [4, 4, 4],
]

///|
/// Cartesian product.
let algo_cart : Array[Array[Int32]] = [
  [1, 3, 5],
  [1, 4, 5],
  [2, 3, 5],
  [2, 4, 5],
]

///|
/// Every subset, ordered by size then position.
let algo_powerset : Array[Array[Int32]] = [
  [],
  [1],
  [2],
  [3],
  [1, 2],
  [1, 3],
  [2, 3],
  [1, 2, 3],
]

///|
/// The shared sequence run.
let algo_seq : Array[Int32] = [3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5]

///|
/// The run sorted ascending.
let algo_sorted_run : Array[Int32] = [1, 1, 2, 3, 3, 4, 5, 5, 5, 6, 9]

///|
/// Running sums of the run.
let algo_prefix : Array[Int32] = [3, 4, 8, 9, 14, 23, 25, 31, 36, 39, 44]

///|
/// The run rotated three right.
let algo_rotated : Array[Int32] = [1, 5, 9, 2, 6, 5, 3, 5, 3, 1, 4]

///|
/// Left merge run.
let algo_merge_left : Array[Int32] = [1, 4, 7, 8]

///|
/// Right merge run.
let algo_merge_right : Array[Int32] = [2, 3, 5, 9]

///|
/// The two runs merged.
let algo_merged : Array[Int32] = [1, 2, 3, 4, 5, 7, 8, 9]

///|
/// The run with repeats removed.
let algo_unique : Array[Int32] = [1, 2, 3, 4]

///|
/// The repeated values.
let algo_dupes : Array[Int32] = [1, 3]

///|
/// Every length-3 window of the run, left to right.
let algo_seq_windows : Array[Array[Int32]] = [
  [3, 1, 4],
  [1, 4, 1],
  [4, 1, 5],
  [1, 5, 9],
  [5, 9, 2],
  [9, 2, 6],
  [2, 6, 5],
  [6, 5, 3],
  [5, 3, 5],
]

///|
/// reservoir_sample(k=3, seed=1) over the run.
let algo_sample_1 : Array[Int32] = [2, 6, 4]

///|
/// reservoir_sample(k=3, seed=7) over the run.
let algo_sample_7 : Array[Int32] = [9, 1, 6]

///|
/// reservoir_sample(k=3, seed=2685821657736338717) over the run.
let algo_sample_2545f4914f6cdd1d : Array[Int32] = [1, 3, 5]

///|
test "differential: bisect matches the reference" {
  for p in 0..<60 {
    @test.assert_eq(@algo.bisect_left(algo_sorted[:], p), algo_bisect_left[p])
    @test.assert_eq(@algo.bisect_right(algo_sorted[:], p), algo_bisect_right[p])
    @test.assert_eq(
      @algo.equal_range(algo_sorted[:], p),
      (algo_bisect_left[p], algo_bisect_right[p]),
    )
  }
}

///|
test "differential: generators match itertools" {
  @test.assert_eq(
    @algo.Permutations::new(algo_perm_pool[:]).iter().to_array(),
    algo_perms,
  )
  @test.assert_eq(
    @algo.Permutations::new(algo_perm_pool[:], length=2).iter().to_array(),
    algo_perms2,
  )
  @test.assert_eq(
    @algo.Combinations::new(algo_combo_pool[:], k=3).iter().to_array(),
    algo_combos,
  )
  @test.assert_eq(
    @algo.CombinationsWithReplacement::new(algo_combo_pool[:], k=3)
    .iter()
    .to_array(),
    algo_combor,
  )
  @test.assert_eq(
    @algo.Product::new(algo_cart_pools).iter().to_array(),
    algo_cart,
  )
  @test.assert_eq(
    @algo.Powerset::new([1, 2, 3][:]).iter().to_array(),
    algo_powerset,
  )
}

///|
test "differential: selection, order, prefix and merge match" {
  let run : Array[Int32] = algo_seq
  @test.assert_eq(@algo.sorted(run[:]), algo_sorted_run)
  let probe = run.copy()
  @algo.nth_element_in_place(probe, 4)
  @test.assert_eq(probe[4], algo_sorted_run[4])
  @test.assert_eq(@algo.k_smallest(5, run[:]), algo_sorted_run[:5].to_owned())
  @test.assert_eq(
    @algo.k_largest(3, run[:]),
    algo_sorted_run[8:].to_owned().rev(),
  )
  @test.assert_eq(@algo.prefix_sum(run[:], op=(a, b) => a + b), algo_prefix)
  @test.assert_eq(@algo.rotate(run[:], mid=3), algo_rotated)
  @test.assert_eq(
    @algo.merge(algo_merge_left[:], algo_merge_right[:]),
    algo_merged,
  )
  let a : Array[Int32] = algo_merge_left
  let b : Array[Int32] = algo_merge_right
  let merged = a.copy()
  @algo.merge_in_place(merged, b)
  @test.assert_eq(merged, algo_merged)
}

///|
test "differential: dedup and run queries" {
  let v : Array[Int32] = [1, 1, 2, 3, 3, 3, 4]
  @test.assert_eq(@algo.unique(v[:]), algo_unique)
  @test.assert_eq(@algo.duplicates(v[:]), algo_dupes)
  @test.assert_eq(@algo.all_equal([7, 7, 7][:]), true)
  @test.assert_eq(@algo.all_unique([1, 2, 3][:]), true)
  @test.assert_eq(@algo.is_palindrome([1, 2, 1][:]), true)
  @test.assert_eq(@algo.mismatch([1, 2, 3][:], [1, 2, 4][:]), Some((2, 2)))
  @test.assert_eq(@algo.find_run([1, 4, 7, 1, 4, 9][:], [1, 4][:]), Some(0))
  @test.assert_eq(@algo.clamp(12, min=0, max=10), 10)
}

///|
test "differential: windows match the reference slices" {
  @test.assert_eq(@algo.windows(algo_seq[:], 3).to_array(), algo_seq_windows)
  @test.assert_eq(@algo.windows(algo_seq[:], 11).to_array().length(), 1)
  @test.assert_eq(@algo.windows(algo_seq[:], 12).to_array().length(), 0)
}

///|
test "differential: a seeded draw matches the reference" {
  @test.assert_eq(
    @algo.reservoir_sample(algo_seq[:].iter(), k=3, seed=1UL),
    algo_sample_1,
  )
  @test.assert_eq(
    @algo.reservoir_sample(algo_seq[:].iter(), k=3, seed=7UL),
    algo_sample_7,
  )
  @test.assert_eq(
    @algo.reservoir_sample(algo_seq[:].iter(), k=3, seed=0x2545f4914f6cdd1dUL),
    algo_sample_2545f4914f6cdd1d,
  )
}
