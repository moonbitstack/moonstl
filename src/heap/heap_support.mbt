///|
/// The comparator an `Order` names, oriented so that a negative result means
/// the first argument is popped first.
fn[T : Compare] order_comparator(order : Order) -> (T, T) -> Int32 {
  match order {
    Min => fn(a, b) { a.compare(b) }
    Max => fn(a, b) { b.compare(a) }
  }
}

///|
/// Whether two sequences hold the same multiset of elements.
///
/// A heap has no meaningful element order of its own, so two heaps are equal
/// when they hold the same elements with the same multiplicities. Both sides are
/// sorted by the heap's comparator first, which the comparator has to agree with
/// `Eq` for the answer to be meaningful.
fn[T : Eq] same_multiset(
  left : Array[T],
  right : Array[T],
  cmp : (T, T) -> Int32,
) -> Bool {
  if left.length() != right.length() {
    return false
  }
  let a = left.copy()
  let b = right.copy()
  a.sort_by(cmp)
  b.sort_by(cmp)
  for i in 0..<a.length() {
    if a[i] != b[i] {
      return false
    }
  }
  true
}

///|
/// A hash of a multiset that does not depend on the order the elements are
/// stored in: the element hashes are added, which is commutative.
fn[T : Hash] multiset_hash(values : Array[T]) -> Int32 {
  let mut acc : Int32 = 0
  for value in values {
    acc = acc + value.hash()
  }
  acc
}
