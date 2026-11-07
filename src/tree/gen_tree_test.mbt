// Differential vectors for `tree`. The values are computed by the Python
// standard library (scripts/gen_vectors.py) and, byte for byte, by the Rust
// standard library (scripts/rust_vectors); scripts/check_vector_agreement.sh
// re-checks the two agree. They are the reference: the tests replay the same
// operations on the library and assert it produces the same results. CI
// replays these vectors; it does not regenerate them.

///|
/// Values loaded into a Fenwick tree.
let tree_fenwick_arr : Array[Int32] = [1, 3, 2, 8, 1, 5, 4]

///|
/// Sum of the first i elements, for i in 0..n.
let tree_fenwick_prefix : Array[Int32] = [0, 1, 4, 6, 14, 15, 20]

///|
/// Sum over every [i, j) with i in 0..n and j in i..n.
let tree_fenwick_range : Array[Int32] = [
  0, 1, 4, 6, 14, 15, 20, 24, 0, 3, 5, 13, 14, 19, 23, 0, 2, 10, 11, 16, 20, 0, 8,
  9, 14, 18, 0, 1, 6, 10, 0, 5, 9, 0, 4,
]

///|
/// Values loaded into a segment tree.
let tree_seg_arr : Array[Int32] = [3, 1, 4, 1, 5, 9, 2]

///|
/// The queried ranges.
let tree_seg_queries : Array[(Int32, Int32)] = [
  (0, 7),
  (0, 4),
  (3, 7),
  (1, 6),
  (2, 5),
  (4, 7),
  (0, 1),
  (6, 7),
]

///|
/// Sum over each queried range.
let tree_seg_expected : Array[Int32] = [25, 9, 17, 20, 10, 16, 3, 2]

///|
/// Unions applied to a disjoint set of seven nodes.
let tree_ds_union : Array[(Int32, Int32)] = [
  (0, 1),
  (2, 3),
  (0, 2),
  (4, 5),
  (5, 6),
  (1, 4),
]

///|
/// The number of components afterwards.
let tree_ds_count : Int32 = 1

///|
/// Selected connectivity checks.
let tree_ds_connected : Array[(Int32, Int32, Bool)] = [
  (0, 6, true),
  (0, 4, true),
  (2, 1, true),
  (0, 3, true),
  (4, 6, true),
]

///|
/// Keys inserted into a treap.
let tree_treap_keys : Array[Int32] = [50, 30, 70, 20, 40, 60, 80, 10, 25, 35]

///|
/// In-order traversal yields the keys sorted.
let tree_treap_inorder : Array[Int32] = [10, 20, 25, 30, 35, 40, 50, 60, 70, 80]

///|
test "differential: fenwick prefix and range sums match" {
  let tree : @tree.Fenwick[Int32] = @tree.Fenwick::from_array(
    tree_fenwick_arr[:],
  )
  for i in 0..<tree_fenwick_arr.length() {
    @test.assert_eq(tree.prefix_sum(i), tree_fenwick_prefix[i])
  }
  let mut ri = 0
  for i in 0..<tree_fenwick_arr.length() {
    for j in i..<(tree_fenwick_arr.length() + 1) {
      @test.assert_eq(tree.range_sum(i, j), tree_fenwick_range[ri])
      ri = ri + 1
    }
  }
}

///|
test "differential: segment tree range sums match" {
  let tree : @tree.SegmentTree[Int32] = @tree.SegmentTree::from_array(
    tree_seg_arr[:],
    op=(a, b) => a + b,
    identity=0,
  )
  for q in 0..<tree_seg_expected.length() {
    let (a, b) = tree_seg_queries[q]
    @test.assert_eq(tree.query(a, b), tree_seg_expected[q])
  }
}

///|
test "differential: disjoint set components match" {
  let ds : @tree.DisjointSet = @tree.DisjointSet::new()
  for _ in 0..<7 {
    let _ = ds.add()
  }
  for p in tree_ds_union {
    let _ = ds.union(p.0, p.1)
  }
  @test.assert_eq(ds.set_count(), tree_ds_count)
  for c in tree_ds_connected {
    @test.assert_eq(ds.connected(c.0, c.1), c.2)
  }
  let mut total = 0
  for s in ds.to_sets() {
    total = total + s.length()
  }
  @test.assert_eq(total, 7)
}

///|
test "differential: treap in-order traversal is sorted" {
  let m : @tree.Treap[Int32, Int32] = @tree.Treap::new()
  for k in tree_treap_keys {
    let _ = m.set(k, k * 2)
  }
  let keys = m.to_array().map(e => e.0)
  @test.assert_eq(keys, tree_treap_inorder)
}
