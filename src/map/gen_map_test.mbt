// Differential vectors for `map`. The values are computed by the Python
// standard library (scripts/gen_vectors.py) and, byte for byte, by the Rust
// standard library (scripts/rust_vectors); scripts/check_vector_agreement.sh
// re-checks the two agree. They are the reference: the tests replay the same
// operations on the library and assert it produces the same results. CI
// replays these vectors; it does not regenerate them.

///|
/// The counter total after each step of the log.
let map_counter_totals : Array[Int64] = [1L, 2L, 3L, 4L, 5L, 4L, 8L, 7L, 8L]

///|
/// most_common(2) after each step.
let map_counter_most : Array[Array[(String, Int32)]] = [
  [("apple", 1)],
  [("apple", 1), ("banana", 1)],
  [("apple", 2), ("banana", 1)],
  [("apple", 2), ("banana", 1)],
  [("apple", 2), ("banana", 2)],
  [("banana", 2), ("apple", 1)],
  [("date", 4), ("banana", 2)],
  [("date", 3), ("banana", 2)],
  [("date", 3), ("apple", 2)],
]

///|
/// Keys fed to a FlatSet.
let map_flatset_from : Array[Int32] = [5, 1, 4, 2, 3, 1, 5, 0, 9, 2]

///|
/// The FlatSet contents, kept sorted.
let map_flatset_sorted : Array[Int32] = [0, 1, 2, 3, 4, 5, 9]

///|
/// range(start=2, end=5); the bounds are inclusive.
let map_flatset_range : Array[Int32] = [2, 3, 4, 5]

///|
/// The IndexMap after the log, in order.
let map_indexmap_final : Array[(String, Int32)] = [
  ("a", 10),
  ("d", 4),
  ("e", 5),
  ("f", 6),
]

///|
/// The position of each touched key after every step (-1 when absent).
let map_indexmap_pos : Array[Int32] = [0, 1, 2, 0, -1, 2, 3, -1, 3]

///|
/// Disjoint ranges.
let map_rangeset : Array[(Int32, Int32)] = [(1, 4), (10, 12), (15, 20)]

///|
/// The gaps between them.
let map_rangeset_gaps : Array[(Int32, Int32)] = [(4, 10), (12, 15)]

///|
test "differential: counter matches a reference" {
  let counter : @map.Counter[String] = @map.Counter::new()
  let log : Array[(String, String, Int32)] = [
    ("apple", "incr", 1),
    ("banana", "incr", 1),
    ("apple", "incr", 1),
    ("cherry", "incr", 1),
    ("banana", "incr", 1),
    ("apple", "decr", 1),
    ("date", "incr_by", 4),
    ("date", "decr_by", 1),
    ("apple", "incr", 1),
  ]
  for step in 0..<log.length() {
    let (key, verb, amount) = log[step]
    if verb == "incr" {
      let _ = counter.incr(key)
    } else if verb == "decr" {
      let _ = counter.decr(key)
    } else if verb == "incr_by" {
      let _ = counter.incr_by(key, amount)
    } else {
      let _ = counter.decr_by(key, amount)
    }
    @test.assert_eq(counter.total(), map_counter_totals[step])
    @test.assert_eq(counter.most_common(n=2), map_counter_most[step])
  }
}

///|
test "differential: flat set stays sorted" {
  let set : @map.FlatSet[Int32] = @map.FlatSet::new()
  for k in map_flatset_from {
    let _ = set.insert(k)
  }
  @test.assert_eq(set.to_array(), map_flatset_sorted)
  @test.assert_eq(set.range(start=2, end=5).to_array(), map_flatset_range)
  @test.assert_eq(set.index_of(4), Ok(4))
  @test.assert_eq(set.index_of(9), Ok(6))
  // The absent key reports its insertion point, where it would sit in order.
  @test.assert_eq(set.index_of(7), Err(6))
}

///|
test "differential: index map positions match a list model" {
  let m : @map.IndexMap[String, Int32] = @map.IndexMap::new()
  let log : Array[(String, String, Int32)] = [
    ("a", "set", 1),
    ("b", "set", 2),
    ("c", "set", 3),
    ("a", "set", 10),
    ("b", "shift_remove", 0),
    ("d", "set", 4),
    ("e", "set", 5),
    ("c", "shift_remove", 0),
    ("f", "set", 6),
  ]
  for step in 0..<log.length() {
    let (key, verb, value) = log[step]
    if verb == "set" {
      let _ = m.set(key, value)
    } else {
      let _ = m.shift_remove(key)
    }
    let want = map_indexmap_pos[step]
    if want < 0 {
      @test.assert_eq(m.get_index_of(key), None)
    } else {
      @test.assert_eq(m.get_index_of(key), Some(want))
    }
  }
  @test.assert_eq(m.to_array(), map_indexmap_final)
}

///|
test "differential: range set gaps match" {
  let set : @map.RangeSet[Int32] = @map.RangeSet::new()
  for r in map_rangeset {
    let _ = set.insert(start=r.0, end=r.1)
  }
  @test.assert_eq(set.gaps().to_array(), map_rangeset_gaps)
}
