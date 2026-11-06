// Ordering and selection. Nothing here is lazy; the only work that mutates a
// caller's run says `_in_place`.

///|
/// A sorted copy of the run, ascending.
pub fn[T : Compare] sorted(a : ArrayView[T]) -> Array[T] {
  let out = a.to_owned()
  out.sort()
  out
}

///|
/// A sorted copy of the run, ordered by `key` rather than by the element
/// itself. `key` is evaluated on every comparison, so keep it cheap.
pub fn[T, K : Compare] sorted_by_key(
  a : ArrayView[T],
  key~ : (T) -> K,
) -> Array[T] {
  let out = a.to_owned()
  out.sort_by(fn(x, y) { key(x).compare(key(y)) })
  out
}

///|
/// Arranges the run so that the element at position `k` is the one that would
/// be there if the whole run were sorted, with smaller elements before it and
/// larger ones after. Expected linear time.
///
/// An out-of-range `k` leaves the run unchanged.
pub fn[T : Compare] nth_element_in_place(a : Array[T], k : Int32) -> Unit {
  let n = a.length()
  if k < 0 || k >= n {
    return
  }
  let mut lo = 0
  let mut hi = n
  while hi - lo > 1 {
    let pivot = median_of_three(a, lo, hi)
    let (lt, gt) = partition_three(a, lo, hi, pivot)
    if k < lt {
      hi = lt
    } else if k >= gt {
      lo = gt
    } else {
      return
    }
  }
}

///|
/// Partially orders the run so that the first `k` elements are the `k`
/// smallest, in ascending order. The rest stays in the run in no particular
/// order. `k` is clamped to the run length.
pub fn[T : Compare] partial_sort_in_place(a : Array[T], k : Int32) -> Unit {
  let n = a.length()
  if k <= 0 {
    return
  }
  if k >= n {
    a.sort()
    return
  }
  let mut i = k / 2 - 1
  while i >= 0 {
    sift_down_by(a, i, k, fn(x, y) { x.compare(y) })
    i = i - 1
  }
  let mut j = k
  while j < n {
    if a[j].compare(a[0]) < 0 {
      a.swap(0, j)
      sift_down_by(a, 0, k, fn(x, y) { x.compare(y) })
    }
    j = j + 1
  }
  let mut end = k
  while end > 1 {
    a.swap(0, end - 1)
    end = end - 1
    sift_down_by(a, 0, end, fn(x, y) { x.compare(y) })
  }
}

///|
/// Sorts the half-open subrange `[start, end)` ascending and leaves the rest
/// of the run untouched. Bounds are clamped to the run.
pub fn[T : Compare] sort_subrange_in_place(
  a : Array[T],
  start~ : Int32,
  end~ : Int32,
) -> Unit {
  let n = a.length()
  let s = if start < 0 { 0 } else if start > n { n } else { start }
  let e = if end < s { s } else if end > n { n } else { end }
  if e - s <= 1 {
    return
  }
  let sub = a[s:e].to_owned()
  sub.sort()
  let mut i = s
  while i < e {
    a[i] = sub[i - s]
    i = i + 1
  }
}

///|
/// The `k` smallest elements, in ascending order. A negative or zero `k`
/// yields an empty array.
pub fn[T : Compare] k_smallest(k : Int32, a : ArrayView[T]) -> Array[T] {
  let n = a.length()
  if k <= 0 || n == 0 {
    return []
  }
  if k >= n {
    return sorted(a)
  }
  let heap : Array[T] = []
  let mut i = 0
  while i < k {
    heap.push(a[i])
    i = i + 1
  }
  let mut j = k / 2 - 1
  while j >= 0 {
    sift_down_by(heap, j, k, fn(x, y) { x.compare(y) })
    j = j - 1
  }
  let mut t = k
  while t < n {
    if a[t].compare(heap[0]) < 0 {
      heap[0] = a[t]
      sift_down_by(heap, 0, k, fn(x, y) { x.compare(y) })
    }
    t = t + 1
  }
  sort_heap_ascending(heap)
  heap
}

///|
/// The `k` largest elements, in descending order. A negative or zero `k`
/// yields an empty array.
pub fn[T : Compare] k_largest(k : Int32, a : ArrayView[T]) -> Array[T] {
  let n = a.length()
  if k <= 0 || n == 0 {
    return []
  }
  if k >= n {
    let out = sorted(a)
    out.rev_in_place()
    return out
  }
  let heap : Array[T] = []
  let mut i = 0
  while i < k {
    heap.push(a[i])
    i = i + 1
  }
  let mut j = k / 2 - 1
  while j >= 0 {
    sift_down_by(heap, j, k, fn(x, y) { y.compare(x) })
    j = j - 1
  }
  let mut t = k
  while t < n {
    if a[t].compare(heap[0]) > 0 {
      heap[0] = a[t]
      sift_down_by(heap, 0, k, fn(x, y) { y.compare(x) })
    }
    t = t + 1
  }
  let mut end = k
  while end > 1 {
    heap.swap(0, end - 1)
    end = end - 1
    sift_down_by(heap, 0, end, fn(x, y) { y.compare(x) })
  }
  heap
}

///|
/// The positions of the first smallest and the first largest element, or
/// `None` for an empty run.
pub fn[T : Compare] min_max_element(a : ArrayView[T]) -> (Int32, Int32)? {
  let n = a.length()
  if n == 0 {
    return None
  }
  let mut min_i = 0
  let mut max_i = 0
  let mut i = 1
  while i < n {
    if a[i].compare(a[min_i]) < 0 {
      min_i = i
    }
    if a[i].compare(a[max_i]) > 0 {
      max_i = i
    }
    i = i + 1
  }
  Some((min_i, max_i))
}

///|
/// Every element equal to the smallest, in their original order.
pub fn[T : Compare] min_set(a : ArrayView[T]) -> Array[T] {
  let out : Array[T] = []
  let n = a.length()
  if n == 0 {
    return out
  }
  let mut best = 0
  let mut i = 1
  while i < n {
    if a[i].compare(a[best]) < 0 {
      best = i
    }
    i = i + 1
  }
  let mut j = 0
  while j < n {
    if a[j].compare(a[best]) == 0 {
      out.push(a[j])
    }
    j = j + 1
  }
  out
}

///|
/// Every element equal to the largest, in their original order.
pub fn[T : Compare] max_set(a : ArrayView[T]) -> Array[T] {
  let out : Array[T] = []
  let n = a.length()
  if n == 0 {
    return out
  }
  let mut best = 0
  let mut i = 1
  while i < n {
    if a[i].compare(a[best]) > 0 {
      best = i
    }
    i = i + 1
  }
  let mut j = 0
  while j < n {
    if a[j].compare(a[best]) == 0 {
      out.push(a[j])
    }
    j = j + 1
  }
  out
}

///|
/// The smallest and largest elements of a sequence, or `None` when it is
/// empty.
pub fn[T : Compare] min_max(it : Iter[T]) -> (T, T)? {
  match it.next() {
    None => None
    Some(first) => {
      let mut lo = first
      let mut hi = first
      for x in it {
        if x.compare(lo) < 0 {
          lo = x
        }
        if x.compare(hi) > 0 {
          hi = x
        }
      }
      Some((lo, hi))
    }
  }
}

///|
/// The position of the first smallest element, or `None` when empty.
pub fn[T : Compare] position_min(a : ArrayView[T]) -> Int32? {
  let n = a.length()
  if n == 0 {
    return None
  }
  let mut best = 0
  let mut i = 1
  while i < n {
    if a[i].compare(a[best]) < 0 {
      best = i
    }
    i = i + 1
  }
  Some(best)
}

///|
/// The position of the first largest element, or `None` when empty.
pub fn[T : Compare] position_max(a : ArrayView[T]) -> Int32? {
  let n = a.length()
  if n == 0 {
    return None
  }
  let mut best = 0
  let mut i = 1
  while i < n {
    if a[i].compare(a[best]) > 0 {
      best = i
    }
    i = i + 1
  }
  Some(best)
}

///|
/// Both extremum positions in one pass, or `None` when empty.
pub fn[T : Compare] position_min_max(a : ArrayView[T]) -> (Int32, Int32)? {
  min_max_element(a)
}

///|
/// Rearranges the run into the next lexicographic permutation, returning
/// `false` and wrapping around to the ascending order when the run is already
/// the largest permutation.
pub fn[T : Compare] next_permutation_in_place(a : Array[T]) -> Bool {
  let n = a.length()
  if n < 2 {
    return false
  }
  let mut i = n - 2
  while i >= 0 && a[i].compare(a[i + 1]) >= 0 {
    i = i - 1
  }
  if i < 0 {
    reverse_range(a, 0, n)
    return false
  }
  let mut j = n - 1
  while a[j].compare(a[i]) <= 0 {
    j = j - 1
  }
  a.swap(i, j)
  reverse_range(a, i + 1, n)
  true
}

///|
/// Rearranges the run into the previous lexicographic permutation, returning
/// `false` and wrapping around to the descending order when the run is already
/// the smallest permutation.
pub fn[T : Compare] prev_permutation_in_place(a : Array[T]) -> Bool {
  let n = a.length()
  if n < 2 {
    return false
  }
  let mut i = n - 2
  while i >= 0 && a[i].compare(a[i + 1]) <= 0 {
    i = i - 1
  }
  if i < 0 {
    reverse_range(a, 0, n)
    return false
  }
  let mut j = n - 1
  while a[j].compare(a[i]) >= 0 {
    j = j - 1
  }
  a.swap(i, j)
  reverse_range(a, i + 1, n)
  true
}

///|
/// Rearranges the run so that the element that was at position `i` moves to
/// position `order[i]`.
///
/// `order` must be a permutation of `0..a.length()`. When it is not, or when
/// its length differs from the run's, the run is left unchanged. The
/// rearrangement uses cycle following, so it needs no second copy of the run.
pub fn[T] apply_permutation_in_place(
  a : Array[T],
  order : ArrayView[Int32],
) -> Unit {
  let n = a.length()
  if order.length() != n {
    return
  }
  let visited = Array::make(n, false)
  let mut i = 0
  while i < n {
    let target = order[i]
    if target < 0 || target >= n || visited[target] {
      return
    }
    visited[target] = true
    i = i + 1
  }
  let done = Array::make(n, false)
  let mut start = 0
  while start < n {
    if !done[start] {
      let mut cur = start
      let mut carry = a[start]
      while true {
        let next = order[cur]
        let saved = a[next]
        a[next] = carry
        done[next] = true
        carry = saved
        cur = next
        if next == start {
          break
        }
      }
    }
    start = start + 1
  }
}
