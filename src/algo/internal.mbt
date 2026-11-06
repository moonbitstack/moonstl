// Private helpers shared by the algorithm groups.

///|
/// Binary-heap sift-down over `[start, end)` in `a`, keeping the heap ordered
/// so that a parent compares greater than or equal to its children under
/// `cmp`. `cmp` therefore selects a max-heap or a min-heap.
fn[T] sift_down_by(
  a : Array[T],
  start : Int32,
  end : Int32,
  cmp : (T, T) -> Int32,
) -> Unit {
  let mut i = start
  while true {
    let left = 2 * i + 1
    let right = left + 1
    let mut top = i
    if left < end && cmp(a[left], a[top]) > 0 {
      top = left
    }
    if right < end && cmp(a[right], a[top]) > 0 {
      top = right
    }
    if top == i {
      break
    }
    a.swap(i, top)
    i = top
  }
}

///|
/// Heapsorts a max-heap into ascending order.
fn[T : Compare] sort_heap_ascending(a : Array[T]) -> Unit {
  let mut end = a.length()
  while end > 1 {
    a.swap(0, end - 1)
    end = end - 1
    sift_down_by(a, 0, end, fn(x, y) { x.compare(y) })
  }
}

///|
/// Reverses `a[lo:hi]` in place.
fn[T] reverse_range(a : Array[T], lo : Int32, hi : Int32) -> Unit {
  let mut i = lo
  let mut j = hi - 1
  while i < j {
    a.swap(i, j)
    i = i + 1
    j = j - 1
  }
}

///|
/// A pivot value for quicksort-style partitioning: the median of the first,
/// middle and last element of `a[lo:hi]`. Median-of-three keeps already
/// ordered runs from degenerating to quadratic time.
fn[T : Compare] median_of_three(a : Array[T], lo : Int32, hi : Int32) -> T {
  let mid = lo + (hi - lo) / 2
  let x = a[lo]
  let y = a[mid]
  let z = a[hi - 1]
  if x.compare(y) < 0 {
    if y.compare(z) < 0 {
      y
    } else if x.compare(z) < 0 {
      z
    } else {
      x
    }
  } else if x.compare(z) < 0 {
    x
  } else if y.compare(z) < 0 {
    z
  } else {
    y
  }
}

///|
/// Dutch-national-flag partition of `a[lo:hi]` around `pivot`: returns the
/// half-open range holding the elements equal to it, with smaller elements
/// before and larger ones after.
fn[T : Compare] partition_three(
  a : Array[T],
  lo : Int32,
  hi : Int32,
  pivot : T,
) -> (Int32, Int32) {
  let mut lt = lo
  let mut i = lo
  let mut gt = hi
  while i < gt {
    let c = a[i].compare(pivot)
    if c < 0 {
      a.swap(lt, i)
      lt = lt + 1
      i = i + 1
    } else if c > 0 {
      gt = gt - 1
      a.swap(i, gt)
    } else {
      i = i + 1
    }
  }
  (lt, gt)
}
