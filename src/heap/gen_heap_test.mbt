// Differential vectors for `heap`. The values are computed by the Python
// standard library (scripts/gen_vectors.py) and, byte for byte, by the Rust
// standard library (scripts/rust_vectors); scripts/check_vector_agreement.sh
// re-checks the two agree. They are the reference: the tests replay the same
// operations on the library and assert it produces the same results. CI
// replays these vectors; it does not regenerate them.

///|
/// Values pushed onto the heaps.
let heap_inserts : Array[Int32] = [7, 3, 9, 1, 5, 8, 2, 6, 4]

///|
/// A min-heap pops them in this order.
let heap_min_order : Array[Int32] = [1, 2, 3, 4, 5, 6, 7, 8, 9]

///|
/// A max-heap pops them in this order.
let heap_max_order : Array[Int32] = [9, 8, 7, 6, 5, 4, 3, 2, 1]

///|
/// Values for the pairing and fibonacci heaps.
let heap_pf_values : Array[Int32] = [11, 3, 7, 1, 9, 5, 2]

///|
/// Both heaps pop them in this order.
let heap_pf_order : Array[Int32] = [1, 2, 3, 5, 7, 9, 11]

///|
/// Values pushed onto the min-max heap.
let heap_mm_values : Array[Int32] = [5, 2, 9, 1, 7]

///|
/// Alternating pop_min, pop_max, ... results.
let heap_mm_seq : Array[Int32] = [1, 9, 2, 7, 5]

///|
/// Keys pushed onto a radix heap, non-decreasing from the last popped.
let heap_radix_key : Array[Int32] = [9, 4, 1, 3, 7, 2, 5, 6, 8, 0]

///|
/// The keys pop out in this order.
let heap_radix_order : Array[Int32] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

///|
test "differential: d-ary heap pop order matches sorted" {
  let h : @heap.DaryHeap[Int32] = @heap.DaryHeap::new()
  for v in heap_inserts {
    h.push(v)
  }
  @test.assert_eq(h.into_sorted_array(), heap_min_order)
  let mx : @heap.DaryHeap[Int32] = @heap.DaryHeap::new(order=@heap.Order::Max)
  for v in heap_inserts {
    mx.push(v)
  }
  @test.assert_eq(mx.into_sorted_array(), heap_max_order)
}

///|
test "differential: pairing and fibonacci heaps match sorted" {
  let p : @heap.PairingHeap[Int32] = @heap.PairingHeap::new()
  let f : @heap.FibonacciHeap[Int32] = @heap.FibonacciHeap::new()
  for v in heap_pf_values {
    let _ = p.insert(v)
    let _ = f.insert(v)
  }
  @test.assert_eq(p.into_sorted_array(), heap_pf_order)
  @test.assert_eq(f.into_sorted_array(), heap_pf_order)
}

///|
test "differential: min-max heap alternates from both ends" {
  let h : @heap.MinMaxHeap[Int32] = @heap.MinMaxHeap::new()
  for v in heap_mm_values {
    h.push(v)
  }
  @test.assert_eq(h.pop_min(), Some(heap_mm_seq[0]))
  @test.assert_eq(h.pop_max(), Some(heap_mm_seq[1]))
  @test.assert_eq(h.pop_min(), Some(heap_mm_seq[2]))
  @test.assert_eq(h.pop_max(), Some(heap_mm_seq[3]))
  @test.assert_eq(h.pop_min(), Some(heap_mm_seq[4]))
}

///|
test "differential: radix heap pops in key order" {
  let h : @heap.RadixHeap[Int32] = @heap.RadixHeap::new()
  for k in heap_radix_key {
    let _ = h.push(k.to_uint64(), k)
  }
  for i in 0..<heap_radix_order.length() {
    @test.assert_eq(
      h.pop_min(),
      Some((heap_radix_order[i].to_uint64(), heap_radix_order[i])),
    )
  }
}
