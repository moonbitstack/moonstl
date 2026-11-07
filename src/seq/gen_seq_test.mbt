// Differential vectors for `seq`. The values are computed by the Python
// standard library (scripts/gen_vectors.py) and, byte for byte, by the Rust
// standard library (scripts/rust_vectors); scripts/check_vector_agreement.sh
// re-checks the two agree. They are the reference: the tests replay the same
// operations on the library and assert it produces the same results. CI
// replays these vectors; it does not regenerate them.

///|
/// Values pushed onto a fixed-capacity ring buffer.
let seq_ring_pushes : Array[Int32] = [1, 2, 3, 4, 5]

///|
/// The ring contents front to back once full.
let seq_ring_final : Array[Int32] = [3, 4, 5]

///|
/// The indices of the set bits.
let seq_bits_set : Array[Int32] = [0, 1, 3, 7, 15, 33]

///|
/// Set bits in [0, i), for each i.
let seq_bits_rank : Array[Int32] = [
  0, 1, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
  5, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6,
]

///|
/// The k-th set bit, -1 when out of range.
let seq_bits_select : Array[Int32] = [0, 1, 3, 7, 15, 33]

///|
/// The text after the edit log.
let seq_gap_final : Array[Char] = ['c', 'b', 'a', 'x']

///|
/// The list after the push and pop log.
let seq_list_final : Array[Int32] = [1, 2]

///|
test "differential: ring buffer overwrite keeps the newest" {
  let ring : @seq.RingBuffer[Int32] = @seq.RingBuffer::new(
    capacity=3,
    overflow=@seq.Overflow::Overwrite,
  )
  for v in seq_ring_pushes {
    let _ = ring.push_back(v)
  }
  @test.assert_eq(ring.to_array(), seq_ring_final)
  @test.assert_eq(ring.front(), Some(3))
  @test.assert_eq(ring.back(), Some(5))
}

///|
test "differential: bit set rank and select match" {
  let set : @seq.BitSet = @seq.BitSet::new(capacity=40)
  for b in seq_bits_set {
    let _ = set.insert(b)
  }
  for i in 0..<40 {
    @test.assert_eq(set.rank(i), seq_bits_rank[i])
  }
  for k in 0..<seq_bits_select.length() {
    let want = seq_bits_select[k]
    if want < 0 {
      @test.assert_eq(set.select(k), None)
    } else {
      @test.assert_eq(set.select(k), Some(want))
    }
  }
}

///|
test "differential: gap buffer edits match a reference" {
  let buf : @seq.GapBuffer[Char] = @seq.GapBuffer::new()
  let _ = buf.insert(0, 'a')
  let _ = buf.insert(1, 'b')
  let _ = buf.insert(0, 'c')
  let _ = buf.insert(3, 'a')
  let _ = buf.remove(1)
  let _ = buf.insert(6, 'x')
  @test.assert_eq(buf.to_array(), seq_gap_final)
}

///|
test "differential: linked list edits match a reference" {
  let ll : @seq.LinkedList[Int32] = @seq.LinkedList::new()
  ll.push_back(1)
  ll.push_front(0)
  ll.push_back(2)
  ll.push_back(3)
  let _ = ll.pop_front()
  let _ = ll.pop_back()
  @test.assert_eq(ll.to_array(), seq_list_final)
}
