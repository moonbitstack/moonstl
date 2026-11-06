// Lazy adaptors. They take an `Iter` and return an `Iter`, and do no work
// beyond what the consumer pulls, except where the interface asks for
// buffering (`tee`, `cycle`, `group_by`, `zip_eq`).

///|
/// Splits a sequence into consecutive arrays of at most `size` elements; the
/// last one may be shorter. A non-positive size yields nothing.
pub fn[T] chunks(it : Iter[T], size : Int32) -> Iter[Array[T]] {
  let mut exhausted = false
  Iter::new(fn() {
    if exhausted || size <= 0 {
      return None
    }
    let chunk : Array[T] = []
    let mut i = 0
    while i < size {
      match it.next() {
        Some(x) => chunk.push(x)
        None => {
          exhausted = true
          break
        }
      }
      i = i + 1
    }
    if chunk.length() == 0 {
      None
    } else {
      Some(chunk)
    }
  })
}

///|
/// Splits a sequence into runs in which each adjacent pair satisfies `same`.
pub fn[T] chunk_by(it : Iter[T], same : (T, T) -> Bool) -> Iter[Array[T]] {
  let mut pending : T? = None
  let mut exhausted = false
  Iter::new(fn() {
    let first = match pending {
      Some(x) => {
        pending = None
        Some(x)
      }
      None => it.next()
    }
    match first {
      None => {
        exhausted = true
        None
      }
      Some(x) => {
        let group : Array[T] = [x]
        let mut last = x
        let mut running = !exhausted
        while running {
          match it.next() {
            Some(y) =>
              if same(last, y) {
                group.push(y)
                last = y
              } else {
                pending = Some(y)
                running = false
              }
            None => {
              exhausted = true
              running = false
            }
          }
        }
        Some(group)
      }
    }
  })
}

///|
/// Every window of `size` elements taken with wraparound, starting at each
/// index: `n` windows for a run of `n`. A non-positive size or an empty run
/// yields nothing. A window longer than the run repeats elements.
pub fn[T] windows_circular(a : ArrayView[T], size : Int32) -> Iter[Array[T]] {
  let n = a.length()
  let mut start = 0
  if n == 0 || size <= 0 {
    return Iter::empty()
  }
  Iter::new(fn() {
    if start >= n {
      return None
    }
    let window : Array[T] = []
    let mut i = 0
    while i < size {
      window.push(a[(start + i) % n])
      i = i + 1
    }
    start = start + 1
    Some(window)
  })
}

///|
/// Alternates elements of the two sequences, starting with the first, and
/// drains the longer one once the shorter ends.
pub fn[T] interleave(a : Iter[T], b : Iter[T]) -> Iter[T] {
  let mut turn_a = true
  let mut done_a = false
  let mut done_b = false
  Iter::new(fn() {
    if done_a && done_b {
      return None
    }
    if turn_a {
      turn_a = false
      match a.next() {
        Some(x) => Some(x)
        None => {
          done_a = true
          if done_b {
            None
          } else {
            b.next()
          }
        }
      }
    } else {
      turn_a = true
      match b.next() {
        Some(x) => Some(x)
        None => {
          done_b = true
          if done_a {
            None
          } else {
            a.next()
          }
        }
      }
    }
  })
}

///|
/// Alternates elements of the two sequences and stops as soon as either one is
/// exhausted, so the result has twice the shorter length.
pub fn[T] interleave_shortest(a : Iter[T], b : Iter[T]) -> Iter[T] {
  let mut pending_a : T? = None
  let mut pending_b : T? = None
  let mut phase = 0
  Iter::new(() => {
    if phase == 0 {
      let left = a.next()
      let right = b.next()
      match left {
        Some(value) => pending_a = Some(value)
        None => return None
      }
      match right {
        Some(value) => pending_b = Some(value)
        None => return None
      }
      phase = 1
    }
    if phase == 1 {
      phase = 2
      return pending_a
    }
    phase = 0
    pending_b
  })
}

///|
/// Pairs elements while both sequences have them, then pairs the leftovers of
/// the longer one with the corresponding fill value.
pub fn[A, B] zip_longest(
  a : Iter[A],
  b : Iter[B],
  fill~ : A,
  fill_b~ : B,
) -> Iter[(A, B)] {
  let mut done_a = false
  let mut done_b = false
  Iter::new(fn() {
    if done_a && done_b {
      return None
    }
    let x = if done_a {
      None
    } else {
      match a.next() {
        Some(v) => Some(v)
        None => {
          done_a = true
          None
        }
      }
    }
    let y = if done_b {
      None
    } else {
      match b.next() {
        Some(v) => Some(v)
        None => {
          done_b = true
          None
        }
      }
    }
    if x is None && y is None {
      return None
    }
    let xv = match x {
      Some(v) => v
      None => fill
    }
    let yv = match y {
      Some(v) => v
      None => fill_b
    }
    Some((xv, yv))
  })
}

///|
/// Pairs the two sequences element by element and raises
/// `@spec.Refused::Incompatible` when their lengths differ.
///
/// Both sequences are read in full when this function is called, because the
/// check has to happen before the first pair is produced; it therefore requires
/// finite inputs.
pub fn[A, B] zip_eq(
  a : Iter[A],
  b : Iter[B],
) -> Iter[(A, B)] raise @spec.Refused {
  let left = a.to_array()
  let right = b.to_array()
  if left.length() != right.length() {
    raise @spec.Refused::Incompatible
  }
  let mut i = 0
  Iter::new(fn() {
    if i >= left.length() {
      return None
    }
    let pair = (left[i], right[i])
    i = i + 1
    Some(pair)
  })
}

///|
/// Yields elements while `pred` holds, and also yields the first element for
/// which it fails, then stops.
pub fn[T] take_while_inclusive(it : Iter[T], pred : (T) -> Bool) -> Iter[T] {
  let mut done = false
  Iter::new(fn() {
    if done {
      return None
    }
    match it.next() {
      None => None
      Some(x) =>
        if pred(x) {
          Some(x)
        } else {
          done = true
          Some(x)
        }
    }
  })
}

///|
/// Groups consecutive elements that share a key, yielding each key with its
/// run. Equal keys that are not adjacent form separate groups, as in
/// `itertools.groupby`.
pub fn[T, K : Eq] group_by(
  it : Iter[T],
  key~ : (T) -> K,
) -> Iter[(K, Array[T])] {
  let mut pending : T? = None
  Iter::new(fn() {
    let first = match pending {
      Some(x) => {
        pending = None
        Some(x)
      }
      None => it.next()
    }
    match first {
      None => None
      Some(x) => {
        let k = key(x)
        let group : Array[T] = [x]
        let mut running = true
        while running {
          match it.next() {
            Some(y) =>
              if key(y) == k {
                group.push(y)
              } else {
                pending = Some(y)
                running = false
              }
            None => running = false
          }
        }
        Some((k, group))
      }
    }
  })
}

///|
/// An iterator over the same elements that keeps up to `n` elements of
/// lookahead buffered, so that a source with side effects is read ahead. The
/// yielded sequence is unchanged.
pub fn[T] peek_nth(it : Iter[T], n : Int32) -> Iter[T] {
  let buf : Array[T] = []
  let mut pos = 0
  let mut exhausted = false
  let lookahead = if n < 0 { 0 } else { n + 1 }
  Iter::new(fn() {
    while buf.length() < pos + lookahead && !exhausted {
      match it.next() {
        Some(x) => buf.push(x)
        None => exhausted = true
      }
    }
    if pos < buf.length() {
      let x = buf[pos]
      pos = pos + 1
      if pos >= 1024 && pos * 2 >= buf.length() {
        let rest = buf[pos:].to_owned()
        buf.clear()
        let mut i = 0
        while i < rest.length() {
          buf.push(rest[i])
          i = i + 1
        }
        pos = 0
      }
      Some(x)
    } else {
      None
    }
  })
}

///|
/// Splits a sequence into two independent iterators over the same elements.
/// Elements are buffered until both iterators have passed them, so the memory
/// is proportional to how far the two consumers drift apart.
pub fn[T] tee(it : Iter[T]) -> (Iter[T], Iter[T]) {
  let buf : Array[T] = []
  let mut pos_a = 0
  let mut pos_b = 0
  let mut exhausted = false
  let source = it
  let first = Iter::new(fn() {
    if pos_a < buf.length() {
      let x = buf[pos_a]
      pos_a = pos_a + 1
      Some(x)
    } else if exhausted {
      None
    } else {
      match source.next() {
        Some(x) => {
          buf.push(x)
          pos_a = pos_a + 1
          Some(x)
        }
        None => {
          exhausted = true
          None
        }
      }
    }
  })
  let second = Iter::new(fn() {
    if pos_b < buf.length() {
      let x = buf[pos_b]
      pos_b = pos_b + 1
      Some(x)
    } else if exhausted {
      None
    } else {
      match source.next() {
        Some(x) => {
          buf.push(x)
          pos_b = pos_b + 1
          Some(x)
        }
        None => {
          exhausted = true
          None
        }
      }
    }
  })
  (first, second)
}

///|
/// Repeats a sequence forever. The elements are buffered on the first pass, so
/// the source must be finite; an empty source yields an empty iterator.
pub fn[T] cycle(it : Iter[T]) -> Iter[T] {
  let items : Array[T] = []
  let mut loaded = false
  let mut pos = 0
  Iter::new(fn() {
    if !loaded {
      loaded = true
      let mut running = true
      while running {
        match it.next() {
          Some(x) => items.push(x)
          None => running = false
        }
      }
    }
    if items.length() == 0 {
      None
    } else {
      let x = items[pos]
      pos = (pos + 1) % items.length()
      Some(x)
    }
  })
}

///|
/// The unbounded sequence `n, n+1, n+2, ...`.
pub fn count(n : Int32) -> Iter[Int32] {
  let mut next_value = n
  Iter::new(fn() {
    let x = next_value
    next_value = next_value + 1
    Some(x)
  })
}

///|
/// Yields the source elements, then pads with `f(i)` where `i` is the position
/// in the output, until the output has at least `n` elements.
pub fn[T] pad_using(it : Iter[T], n : Int32, f : (Int32) -> T) -> Iter[T] {
  let mut i = 0
  let mut exhausted = false
  Iter::new(fn() {
    if !exhausted {
      match it.next() {
        Some(x) => {
          i = i + 1
          return Some(x)
        }
        None => exhausted = true
      }
    }
    if i < n {
      let x = f(i)
      i = i + 1
      Some(x)
    } else {
      None
    }
  })
}

///|
/// Running combination: yields `acc` after folding each source element into it,
/// starting from `init`. Unlike core's `accumulate`, no initial value is
/// yielded, so an empty source yields nothing.
pub fn[A, B] scan(it : Iter[A], init~ : B, f : (B, A) -> B) -> Iter[B] {
  let mut acc = init
  Iter::new(fn() {
    match it.next() {
      None => None
      Some(x) => {
        acc = f(acc, x)
        Some(acc)
      }
    }
  })
}

///|
/// Folds the elements pairwise with `f`, or `None` when the sequence is empty.
pub fn[T] fold_first(it : Iter[T], f : (T, T) -> T) -> T? {
  match it.next() {
    None => None
    Some(first) => {
      let mut acc = first
      for x in it {
        acc = f(acc, x)
      }
      Some(acc)
    }
  }
}

///|
/// Folds while `f` returns `Ok`, and returns the value carried by the first
/// `Err`, or the final accumulator when the source ends.
pub fn[A, B] fold_while(
  it : Iter[A],
  init~ : B,
  f : (B, A) -> Result[B, B],
) -> B {
  let mut acc = init
  for x in it {
    match f(acc, x) {
      Ok(next) => acc = next
      Err(stop) => return stop
    }
  }
  acc
}

///|
/// Combines adjacent pairs level by level, keeping the shape of a balanced
/// reduction tree, and returns the final value. The empty sequence yields
/// `None`.
pub fn[T] tree_reduce(it : Iter[T], f : (T, T) -> T) -> T? {
  let mut level = it.to_array()
  if level.length() == 0 {
    return None
  }
  while level.length() > 1 {
    let next : Array[T] = []
    let mut i = 0
    while i + 1 < level.length() {
      next.push(f(level[i], level[i + 1]))
      i = i + 2
    }
    if i < level.length() {
      next.push(level[i])
    }
    level = next
  }
  Some(level[0])
}

///|
/// Where an element sits in a sequence that is being consumed.
#derive(Eq, Debug)
pub(all) enum Position {
  /// The sequence has exactly one element.
  Only
  /// The first of several elements.
  First
  /// Neither the first nor the last of several elements.
  Middle
  /// The last of several elements.
  Last
}

///|
pub extend Position with Eq::{equal, not_equal}

///|
pub extend Position with Debug::{to_repr}

///|

///|

///|
/// Pairs each element with its position, using one element of lookahead so the
/// last element can be recognised.
pub fn[T] with_position(it : Iter[T]) -> Iter[(Position, T)] {
  let mut pending : T? = None
  let mut started = false
  Iter::new(fn() {
    let current = match pending {
      Some(x) => {
        pending = None
        Some(x)
      }
      None => it.next()
    }
    match current {
      None => None
      Some(x) => {
        let nxt = it.next()
        let pos = if nxt is None {
          if started {
            Position::Last
          } else {
            Position::Only
          }
        } else if started {
          Position::Middle
        } else {
          Position::First
        }
        pending = nxt
        started = true
        Some((pos, x))
      }
    }
  })
}
