// Searching and order predicates over runs.
//
// Functions here leave the run alone; the two `insort` entry points are the
// exception and say `_in_place` in their names.

///|
/// The first index at which `value` could be inserted while keeping `a`
/// ascending: every element before the result is smaller than `value`.
///
/// `a` must already be sorted ascending. The result is in `0..=a.length()`.
pub fn[T : Compare] bisect_left(a : ArrayView[T], value : T) -> Int32 {
  bisect_left_by(a, value, cmp=fn(x, y) { x.compare(y) })
}

///|
/// The first index past every element equal to `value`: every element before
/// the result is less than or equal to `value`.
///
/// `a` must already be sorted ascending. The result is in `0..=a.length()`.
pub fn[T : Compare] bisect_right(a : ArrayView[T], value : T) -> Int32 {
  bisect_right_by(a, value, cmp=fn(x, y) { x.compare(y) })
}

///|
/// `bisect_left` with an explicit comparator, for an ordering the `Compare`
/// trait cannot express.
pub fn[T] bisect_left_by(
  a : ArrayView[T],
  value : T,
  cmp~ : (T, T) -> Int32,
) -> Int32 {
  let mut lo = 0
  let mut hi = a.length()
  while lo < hi {
    let mid = lo + (hi - lo) / 2
    if cmp(a[mid], value) < 0 {
      lo = mid + 1
    } else {
      hi = mid
    }
  }
  lo
}

///|
/// `bisect_right` with an explicit comparator, for an ordering the `Compare`
/// trait cannot express.
pub fn[T] bisect_right_by(
  a : ArrayView[T],
  value : T,
  cmp~ : (T, T) -> Int32,
) -> Int32 {
  let mut lo = 0
  let mut hi = a.length()
  while lo < hi {
    let mid = lo + (hi - lo) / 2
    if cmp(a[mid], value) <= 0 {
      lo = mid + 1
    } else {
      hi = mid
    }
  }
  lo
}

///|
/// The half-open range of elements equal to `value` in an ascending run,
/// as `(bisect_left, bisect_right)`.
pub fn[T : Compare] equal_range(a : ArrayView[T], value : T) -> (Int32, Int32) {
  (bisect_left(a, value), bisect_right(a, value))
}

///|
/// The first index for which `pred` is false, assuming every true element
/// precedes every false one. The result is in `0..=a.length()`.
pub fn[T] partition_point(a : ArrayView[T], pred : (T) -> Bool) -> Int32 {
  let mut lo = 0
  let mut hi = a.length()
  while lo < hi {
    let mid = lo + (hi - lo) / 2
    if pred(a[mid]) {
      lo = mid + 1
    } else {
      hi = mid
    }
  }
  lo
}

///|
/// Inserts `value` before any element equal to it, keeping `a` ascending.
pub fn[T : Compare] insort_left_in_place(a : Array[T], value : T) -> Unit {
  let at = bisect_left(a[:], value)
  a.insert(at, value)
}

///|
/// Inserts `value` after any element equal to it, keeping `a` ascending.
pub fn[T : Compare] insort_right_in_place(a : Array[T], value : T) -> Unit {
  let at = bisect_right(a[:], value)
  a.insert(at, value)
}

///|
/// The first pair of positions at which two runs differ.
///
/// Returns `None` when the runs are equal. When one run is a prefix of the
/// other, the difference is reported at the end of the shorter run, so both
/// components of the result are its length.
pub fn[T : Eq] mismatch(a : ArrayView[T], b : ArrayView[T]) -> (Int32, Int32)? {
  let n = if a.length() < b.length() { a.length() } else { b.length() }
  let mut i = 0
  while i < n {
    if a[i] != b[i] {
      return Some((i, i))
    }
    i = i + 1
  }
  if a.length() == b.length() {
    None
  } else {
    Some((n, n))
  }
}

///|
/// The first index at which `needle` occurs as a contiguous run inside
/// `haystack`, or `None`. An empty needle occurs at index 0.
pub fn[T : Eq] find_run(
  haystack : ArrayView[T],
  needle : ArrayView[T],
) -> Int32? {
  let n = haystack.length()
  let m = needle.length()
  if m == 0 {
    return Some(0)
  }
  if m > n {
    return None
  }
  let mut start = 0
  while start <= n - m {
    let mut j = 0
    while j < m && haystack[start + j] == needle[j] {
      j = j + 1
    }
    if j == m {
      return Some(start)
    }
    start = start + 1
  }
  None
}

///|
/// Whether every element satisfying `pred` comes before every element that
/// does not. An empty run is partitioned.
pub fn[T] is_partitioned(a : ArrayView[T], pred : (T) -> Bool) -> Bool {
  is_partitioned_until(a, pred) is None
}

///|
/// The first index at which the partitioning breaks: an element that satisfies
/// `pred` and follows one that does not, or `None` when the whole run is
/// partitioned. The result is therefore the partition point when it exists,
/// and `partition_point` alone cannot tell the two cases apart.
pub fn[T] is_partitioned_until(a : ArrayView[T], pred : (T) -> Bool) -> Int32? {
  let mut seen_false = false
  let mut i = 0
  while i < a.length() {
    if pred(a[i]) {
      if seen_false {
        return Some(i)
      }
    } else {
      seen_false = true
    }
    i = i + 1
  }
  None
}

///|
/// Whether the run reads the same forwards and backwards.
pub fn[T : Eq] is_palindrome(a : ArrayView[T]) -> Bool {
  let mut lo = 0
  let mut hi = a.length() - 1
  while lo < hi {
    if a[lo] != a[hi] {
      return false
    }
    lo = lo + 1
    hi = hi - 1
  }
  true
}

///|
/// Whether every element of the run is equal to every other. Empty and
/// single-element runs are equal by vacuity.
pub fn[T : Eq] all_equal(a : ArrayView[T]) -> Bool {
  let mut i = 1
  while i < a.length() {
    if a[i] != a[0] {
      return false
    }
    i = i + 1
  }
  true
}

///|
/// Whether all elements are distinct, using a hash set of the values seen.
pub fn[T : Hash + Eq] all_unique(a : ArrayView[T]) -> Bool {
  let seen : Map[T, Unit] = Map([])
  let mut i = 0
  while i < a.length() {
    if seen.get(a[i]) is Some(_) {
      return false
    }
    seen.set(a[i], ())
    i = i + 1
  }
  true
}

///|
/// Whether exactly one element satisfies `pred`. Stops at the second match.
pub fn[T] exactly_one(a : ArrayView[T], pred : (T) -> Bool) -> Bool {
  let mut found = false
  let mut i = 0
  while i < a.length() {
    if pred(a[i]) {
      if found {
        return false
      }
      found = true
    }
    i = i + 1
  }
  found
}

///|
/// Whether at most one element satisfies `pred`. Stops at the second match.
pub fn[T] at_most_one(a : ArrayView[T], pred : (T) -> Bool) -> Bool {
  let mut found = false
  let mut i = 0
  while i < a.length() {
    if pred(a[i]) {
      if found {
        return false
      }
      found = true
    }
    i = i + 1
  }
  true
}

///|
/// Restricts `value` to the closed interval `[min, max]`.
///
/// Core's numeric `clamp` covers the built-in number types only; this one
/// works for any ordered value, such as a date or a version. `min` must not
/// be greater than `max`.
pub fn[T : Compare] clamp(value : T, min~ : T, max~ : T) -> T {
  if value.compare(min) < 0 {
    min
  } else if value.compare(max) > 0 {
    max
  } else {
    value
  }
}
