// Partitioning, run editing and merging. Every function that mutates the
// caller's run says `_in_place`.

///|
/// Groups the run so that every element satisfying `pred` comes first, and
/// returns the boundary: the number of elements that satisfy `pred`.
/// Unstable and linear.
pub fn[T] partition_in_place(a : Array[T], pred : (T) -> Bool) -> Int32 {
  let mut i = 0
  let mut j = a.length()
  while i < j {
    if pred(a[i]) {
      i = i + 1
    } else {
      j = j - 1
      a.swap(i, j)
    }
  }
  i
}

///|
/// Like `partition_in_place`, but keeps the relative order within both groups.
/// The partition is done by recursively partitioning halves and rotating the
/// two middle blocks into place, which is O(n log n) time and O(log n) stack.
pub fn[T] stable_partition_in_place(a : Array[T], pred : (T) -> Bool) -> Int32 {
  stable_partition_range(a, 0, a.length(), pred)
}

///|
/// Stable partition of `a[lo:hi]`, returning its boundary.
fn[T] stable_partition_range(
  a : Array[T],
  lo : Int32,
  hi : Int32,
  pred : (T) -> Bool,
) -> Int32 {
  if hi - lo <= 1 {
    if hi > lo && pred(a[lo]) {
      return lo + 1
    }
    return lo
  }
  let mid = lo + (hi - lo) / 2
  let left_end = stable_partition_range(a, lo, mid, pred)
  let right_end = stable_partition_range(a, mid, hi, pred)
  rotate_range(a, left_end, mid, right_end)
  left_end + (right_end - mid)
}

///|
/// Rotates `a[lo:hi]` so that the element at `mid` becomes the first.
fn[T] rotate_range(a : Array[T], lo : Int32, mid : Int32, hi : Int32) -> Unit {
  if lo == mid || mid == hi {
    return
  }
  reverse_range(a, lo, mid)
  reverse_range(a, mid, hi)
  reverse_range(a, lo, hi)
}

///|
/// Splits the run into the elements satisfying `pred` and the rest, both in
/// their original order.
pub fn[T] partition_copy(
  a : ArrayView[T],
  pred : (T) -> Bool,
) -> (Array[T], Array[T]) {
  let yes : Array[T] = []
  let no : Array[T] = []
  for x in a {
    if pred(x) {
      yes.push(x)
    } else {
      no.push(x)
    }
  }
  (yes, no)
}

///|
/// Applies `f` to every element: the mapped results keep their original order
/// in the first array, the elements for which `f` returns `None` keep theirs
/// in the second.
pub fn[A, B] partition_pair(
  a : ArrayView[A],
  f : (A) -> B?,
) -> (Array[B], Array[A]) {
  let mapped : Array[B] = []
  let rest : Array[A] = []
  for x in a {
    match f(x) {
      Some(y) => mapped.push(y)
      None => rest.push(x)
    }
  }
  (mapped, rest)
}

///|
/// Rotates the run left by `mid`: the element at `mid` becomes the first and
/// the elements before it move to the end. `mid` is clamped to the run.
pub fn[T] rotate_in_place(a : Array[T], mid~ : Int32) -> Unit {
  let n = a.length()
  let m = if mid < 0 { 0 } else if mid > n { n } else { mid }
  rotate_range(a, 0, m, n)
}

///|
/// `rotate_in_place` on a copy, leaving the input alone.
pub fn[T] rotate(a : ArrayView[T], mid~ : Int32) -> Array[T] {
  let out = a.to_owned()
  rotate_in_place(out, mid~)
  out
}

///|
/// Moves the run left by `n` positions: the result starts at the element that
/// was at `n`, and the vacated tail repeats the last element. The length does
/// not change. `n` is clamped to the run.
///
/// C++20's `std::shift_left` leaves the tail in an unspecified state; this
/// function makes the state deterministic by duplicating the boundary element.
pub fn[T] shift_left_in_place(a : Array[T], n~ : Int32) -> Unit {
  let len = a.length()
  if len == 0 {
    return
  }
  let k = if n < 0 { 0 } else if n > len { len } else { n }
  if k == 0 {
    return
  }
  let last = a[len - 1]
  let mut i = 0
  while i < len - k {
    a[i] = a[i + k]
    i = i + 1
  }
  while i < len {
    a[i] = last
    i = i + 1
  }
}

///|
/// Moves the run right by `n` positions: the vacated head repeats the first
/// element, and the elements that would pass the end are dropped. The length
/// does not change. `n` is clamped to the run.
///
/// C++20's `std::shift_right` leaves the head in an unspecified state; this
/// function makes the state deterministic by duplicating the boundary element.
pub fn[T] shift_right_in_place(a : Array[T], n~ : Int32) -> Unit {
  let len = a.length()
  if len == 0 {
    return
  }
  let k = if n < 0 { 0 } else if n > len { len } else { n }
  if k == 0 {
    return
  }
  let first = a[0]
  let mut i = len - 1
  while i >= k {
    a[i] = a[i - k]
    i = i - 1
  }
  let mut j = 0
  while j < k {
    a[j] = first
    j = j + 1
  }
}

///|
/// Replaces every element equal to `old` with `new` and returns how many
/// elements were replaced.
pub fn[T : Eq] replace_in_place(a : Array[T], old : T, new : T) -> Int32 {
  let mut count = 0
  let mut i = 0
  while i < a.length() {
    if a[i] == old {
      a[i] = new
      count = count + 1
    }
    i = i + 1
  }
  count
}

///|
/// Gathers every element satisfying `pred` into one contiguous block that
/// starts as close to `mid` as the run allows, preserving the relative order
/// of the gathered elements (and, here, of the rest too).
///
/// Returns the index just past the gathered block. A `mid` that would push
/// the block past the end is moved left so the block still fits.
pub fn[T] gather_in_place(
  a : Array[T],
  mid~ : Int32,
  pred : (T) -> Bool,
) -> Int32 {
  let n = a.length()
  let chosen : Array[T] = []
  let rest : Array[T] = []
  for x in a {
    if pred(x) {
      chosen.push(x)
    } else {
      rest.push(x)
    }
  }
  let k = chosen.length()
  let mut start = if mid < 0 { 0 } else if mid > n { n } else { mid }
  if start + k > n {
    start = n - k
  }
  if start < 0 {
    start = 0
  }
  let mut idx = 0
  while idx < start {
    a[idx] = rest[idx]
    idx = idx + 1
  }
  let mut s = 0
  while s < k {
    a[idx] = chosen[s]
    idx = idx + 1
    s = s + 1
  }
  let mut r = start
  while idx < n {
    a[idx] = rest[r]
    idx = idx + 1
    r = r + 1
  }
  start + k
}

///|
/// The distinct elements of the run in order of first appearance.
pub fn[T : Hash + Eq] unique(a : ArrayView[T]) -> Array[T] {
  let seen : Map[T, Unit] = Map([])
  let out : Array[T] = []
  for x in a {
    if seen.get(x) is None {
      seen.set(x, ())
      out.push(x)
    }
  }
  out
}

///|
/// Every element that occurs more than once, repeated once for each occurrence
/// past the first, in the order the extra occurrences are met.
pub fn[T : Hash + Eq] duplicates(a : ArrayView[T]) -> Array[T] {
  let seen : Map[T, Unit] = Map([])
  let reported : Map[T, Unit] = Map([])
  let out : Array[T] = []
  for x in a {
    if seen.get(x) is Some(_) {
      if reported.get(x) is None {
        reported.set(x, ())
        out.push(x)
      }
    } else {
      seen.set(x, ())
    }
  }
  out
}

///|
/// Merges two ascending runs into one ascending run, keeping equal elements in
/// the order they had in the inputs (all of `a` before `b`'s equal ones).
pub fn[T : Compare] merge(a : ArrayView[T], b : ArrayView[T]) -> Array[T] {
  let out : Array[T] = []
  let mut i = 0
  let mut j = 0
  let n = a.length()
  let m = b.length()
  while i < n && j < m {
    if a[i].compare(b[j]) <= 0 {
      out.push(a[i])
      i = i + 1
    } else {
      out.push(b[j])
      j = j + 1
    }
  }
  while i < n {
    out.push(a[i])
    i = i + 1
  }
  while j < m {
    out.push(b[j])
    j = j + 1
  }
  out
}

///|
/// Merges two ascending runs in place, leaving `b` unchanged and `a` holding
/// the merged result.
pub fn[T : Compare] merge_in_place(a : Array[T], b : Array[T]) -> Unit {
  let left = a.copy()
  a.clear()
  let mut i = 0
  let mut j = 0
  let n = left.length()
  let m = b.length()
  while i < n && j < m {
    if left[i].compare(b[j]) <= 0 {
      a.push(left[i])
      i = i + 1
    } else {
      a.push(b[j])
      j = j + 1
    }
  }
  while i < n {
    a.push(left[i])
    i = i + 1
  }
  while j < m {
    a.push(b[j])
    j = j + 1
  }
}

///|
/// Merges `k` ascending runs into one ascending run with a heap of the runs'
/// current heads, in O(n log k). Equal elements are taken from the earlier run
/// first, so the merge is deterministic.
pub fn[T : Compare] k_way_merge(lists : ArrayView[ArrayView[T]]) -> Array[T] {
  let out : Array[T] = []
  let k = lists.length()
  if k == 0 {
    return out
  }
  let pos = Array::make(k, 0)
  let heap : Array[Int32] = []
  let mut i = 0
  while i < k {
    if lists[i].length() > 0 {
      heap.push(i)
    }
    i = i + 1
  }
  let cmp = fn(x : Int32, y : Int32) -> Int32 {
    let c = lists[x][pos[x]].compare(lists[y][pos[y]])
    if c != 0 {
      c
    } else {
      x.compare(y)
    }
  }
  let higher = fn(x : Int32, y : Int32) -> Int32 { cmp(y, x) }
  let mut h = heap.length() / 2 - 1
  while h >= 0 {
    sift_down_by(heap, h, heap.length(), higher)
    h = h - 1
  }
  while heap.length() > 0 {
    let li = heap[0]
    out.push(lists[li][pos[li]])
    pos[li] = pos[li] + 1
    if pos[li] >= lists[li].length() {
      let last = heap.pop().unwrap()
      if heap.length() > 0 {
        heap[0] = last
        sift_down_by(heap, 0, heap.length(), higher)
      }
    } else {
      sift_down_by(heap, 0, heap.length(), higher)
    }
  }
  out
}

///|
/// Running combination without an identity element: element `i` of the result
/// is `a[0] op a[1] op ... op a[i]`. The empty run yields an empty array.
pub fn[T] prefix_sum(a : ArrayView[T], op~ : (T, T) -> T) -> Array[T] {
  let out : Array[T] = []
  let n = a.length()
  if n == 0 {
    return out
  }
  let mut acc = a[0]
  out.push(acc)
  let mut i = 1
  while i < n {
    acc = op(acc, a[i])
    out.push(acc)
    i = i + 1
  }
  out
}

///|
/// Replaces every element but the first with the running combination up to it,
/// in place.
pub fn[T] scan_in_place(a : Array[T], op~ : (T, T) -> T) -> Unit {
  let n = a.length()
  let mut i = 1
  while i < n {
    a[i] = op(a[i - 1], a[i])
    i = i + 1
  }
}

///|
/// The first difference of adjacent elements: element 0 is kept, element `i`
/// is `op(a[i - 1], a[i])`. The empty run yields an empty array.
pub fn[T] adjacent_difference(a : ArrayView[T], op~ : (T, T) -> T) -> Array[T] {
  let out : Array[T] = []
  let n = a.length()
  if n == 0 {
    return out
  }
  out.push(a[0])
  let mut i = 1
  while i < n {
    out.push(op(a[i], a[i - 1]))
    i = i + 1
  }
  out
}

///|
/// The result of stepping two ordered runs side by side: an element of the
/// first run only, of the second only, or a pair of equal elements.
#derive(Eq, Debug)
pub(all) enum JoinEntry[A, B] {
  Left(A)
  Right(B)
  Both(A, B)
}

///|
pub extend JoinEntry with Eq::{equal, not_equal}

///|
pub extend JoinEntry with Debug::{to_repr}

///|

///|

///|
/// Walks two ordered runs together with an explicit comparator, yielding one
/// `JoinEntry` per step in the order the runs are consumed.
pub fn[A, B] merge_join_by(
  a : ArrayView[A],
  b : ArrayView[B],
  cmp~ : (A, B) -> Int32,
) -> Iter[JoinEntry[A, B]] {
  let mut i = 0
  let mut j = 0
  let n = a.length()
  let m = b.length()
  Iter::new(fn() {
    if i >= n && j >= m {
      return None
    }
    if i >= n {
      let entry = JoinEntry::Right(b[j])
      j = j + 1
      return Some(entry)
    }
    if j >= m {
      let entry = JoinEntry::Left(a[i])
      i = i + 1
      return Some(entry)
    }
    let c = cmp(a[i], b[j])
    if c < 0 {
      let entry = JoinEntry::Left(a[i])
      i = i + 1
      Some(entry)
    } else if c > 0 {
      let entry = JoinEntry::Right(b[j])
      j = j + 1
      Some(entry)
    } else {
      let entry = JoinEntry::Both(a[i], b[j])
      i = i + 1
      j = j + 1
      Some(entry)
    }
  })
}
