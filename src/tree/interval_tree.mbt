///|
/// A handle to one interval of an `IntervalTree`. Like a slot key, it carries
/// the generation of the slot it was handed out for, so a handle to a removed
/// interval reads as absent instead of reaching a later one.
#warnings("-unused_type_variable")
#derive(Eq, Hash, Debug)
pub(all) struct IntervalKey[K] {
  index : Int32
  generation : UInt32
}

///|
pub extend IntervalKey with Eq::{equal, not_equal}

///|
pub extend IntervalKey with Hash::{hash, hash_combine}

///|
pub extend IntervalKey with Debug::{to_repr}

///|
/// Intervals over a key type, kept sorted by start with a running maximum of the
/// ends. That prefix maximum is what a point query walks back through: once a
/// prefix can no longer reach the point, no interval before it can either, so
/// the scan stops. Intervals are half-open, `[start, end)`.
///
/// ```mbt check
/// test {
///   let tree : @tree.IntervalTree[Int32, String] = @tree.IntervalTree::new()
///   let _ = tree.insert(start=0, end=10, "a")
///   let _ = tree.insert(start=5, end=15, "b")
///   assert_true(tree.query_point(7).length() == 2)
///   assert_true(tree.query_point(12).length() == 1)
///   assert_true(tree.query_point(20).length() == 0)
/// }
/// ```
pub struct IntervalTree[K, V] {
  cmp : (K, K) -> Int32
  starts : Array[K?]
  ends : Array[K?]
  values : Array[V?]
  generations : Array[UInt32]
  free : Array[Int32]
  /// The slots, sorted by start and then by end.
  order : Array[Int32]
  /// `max_ends[i]` is the largest end among `order[0..=i]`.
  mut max_ends : Array[K?]
  mut len : Int32
}

///|
pub fn[K : Compare, V] IntervalTree::new() -> IntervalTree[K, V] {
  IntervalTree::new_by(cmp=(a, b) => a.compare(b))
}

///|
pub fn[K, V] IntervalTree::new_by(cmp~ : (K, K) -> Int32) -> IntervalTree[K, V] {
  {
    cmp,
    starts: [],
    ends: [],
    values: [],
    generations: [],
    free: [],
    order: [],
    max_ends: [],
    len: 0,
  }
}

///|
fn[K, V] IntervalTree::start_at(self : IntervalTree[K, V], index : Int32) -> K {
  match self.starts[index] {
    Some(value) => value
    None => abort("moonstl: an interval slot that holds nothing")
  }
}

///|
fn[K, V] IntervalTree::end_at(self : IntervalTree[K, V], index : Int32) -> K {
  match self.ends[index] {
    Some(value) => value
    None => abort("moonstl: an interval slot that holds nothing")
  }
}

///|
/// Recomputes the running maximum of the ends after the order changed.
fn[K, V] IntervalTree::refresh_max(self : IntervalTree[K, V]) -> Unit {
  let out : Array[K?] = []
  let mut best : K? = None
  for slot in self.order {
    let end = self.end_at(slot)
    best = match best {
      Some(current) =>
        if (self.cmp)(end, current) > 0 {
          Some(end)
        } else {
          Some(current)
        }
      None => Some(end)
    }
    out.push(best)
  }
  self.max_ends = out
}

///|
/// Where a new interval belongs: after every interval that starts earlier, or
/// starts at the same point and ends earlier or at the same point.
fn[K, V] IntervalTree::position_of(
  self : IntervalTree[K, V],
  start : K,
  end : K,
) -> Int32 {
  let mut low = 0
  let mut high = self.order.length()
  while low < high {
    let mid = (low + high) / 2
    let slot = self.order[mid]
    let order = {
      let by_start = (self.cmp)(self.start_at(slot), start)
      if by_start != 0 {
        by_start
      } else {
        (self.cmp)(self.end_at(slot), end)
      }
    }
    if order <= 0 {
      low = mid + 1
    } else {
      high = mid
    }
  }
  low
}

///|
pub fn[K, V] IntervalTree::insert(
  self : IntervalTree[K, V],
  start~ : K,
  end~ : K,
  value : V,
) -> IntervalKey[K] {
  let slot = match self.free.pop() {
    Some(slot) => {
      self.starts[slot] = Some(start)
      self.ends[slot] = Some(end)
      self.values[slot] = Some(value)
      slot
    }
    None => {
      self.starts.push(Some(start))
      self.ends.push(Some(end))
      self.values.push(Some(value))
      self.generations.push(0U)
      self.starts.length() - 1
    }
  }
  let at = self.position_of(start, end)
  self.order.insert(at, slot)
  self.refresh_max()
  self.len = self.len + 1
  { index: slot, generation: self.generations[slot], }
}

///|
fn[K, V] IntervalTree::locate(
  self : IntervalTree[K, V],
  key : IntervalKey[K],
) -> Bool {
  key.index >= 0 &&
  key.index < self.starts.length() &&
  self.generations[key.index] == key.generation &&
  self.values[key.index] is Some(_)
}

///|
pub fn[K, V] IntervalTree::get(
  self : IntervalTree[K, V],
  key : IntervalKey[K],
) -> (K, K, V)? {
  if !self.locate(key) {
    return None
  }
  let value = self.values[key.index].unwrap()
  Some((self.start_at(key.index), self.end_at(key.index), value))
}

///|
pub fn[K, V] IntervalTree::remove(
  self : IntervalTree[K, V],
  key : IntervalKey[K],
) -> (K, K, V)? {
  if !self.locate(key) {
    return None
  }
  let slot = key.index
  let found = Some(
    (self.start_at(slot), self.end_at(slot), self.values[slot].unwrap()),
  )
  let mut at = -1
  for i in 0..<self.order.length() {
    if self.order[i] == slot {
      at = i
      break
    }
  }
  if at >= 0 {
    let _ = self.order.remove(at)
  }
  self.starts[slot] = None
  self.ends[slot] = None
  self.values[slot] = None
  self.generations[slot] = self.generations[slot] + 1U
  self.free.push(slot)
  self.len = self.len - 1
  self.refresh_max()
  found
}

///|
/// Every interval that covers `point`.
pub fn[K, V] IntervalTree::query_point(
  self : IntervalTree[K, V],
  point : K,
) -> Array[(K, K, V)] {
  let found : Array[(K, K, V)] = []
  let mut at = self.order.length() - 1
  while at >= 0 {
    match self.max_ends[at] {
      Some(reach) => if (self.cmp)(reach, point) <= 0 { break }
      None => break
    }
    let slot = self.order[at]
    if (self.cmp)(self.start_at(slot), point) <= 0 &&
      (self.cmp)(self.end_at(slot), point) > 0 {
      found.push(
        (self.start_at(slot), self.end_at(slot), self.values[slot].unwrap()),
      )
    }
    at = at - 1
  }
  found
}

///|
/// Every interval that meets `[start, end)`.
pub fn[K, V] IntervalTree::query_overlap(
  self : IntervalTree[K, V],
  start~ : K,
  end~ : K,
) -> Array[(K, K, V)] {
  let found : Array[(K, K, V)] = []
  for slot in self.order {
    if (self.cmp)(self.start_at(slot), end) >= 0 {
      break
    }
    if (self.cmp)(self.end_at(slot), start) > 0 {
      found.push(
        (self.start_at(slot), self.end_at(slot), self.values[slot].unwrap()),
      )
    }
  }
  found
}

///|
/// The intervals in start order.
pub fn[K, V] IntervalTree::iter(self : IntervalTree[K, V]) -> Iter[(K, K, V)] {
  let mut cursor = 0
  Iter::new(() => {
    if cursor >= self.order.length() {
      None
    } else {
      let slot = self.order[cursor]
      cursor = cursor + 1
      Some((self.start_at(slot), self.end_at(slot), self.values[slot].unwrap()))
    }
  })
}

///|
pub fn[K, V] IntervalTree::length(self : IntervalTree[K, V]) -> Int32 {
  self.len
}

///|
pub fn[K, V] IntervalTree::is_empty(self : IntervalTree[K, V]) -> Bool {
  self.len == 0
}

///|
pub fn[K, V] IntervalTree::clear(self : IntervalTree[K, V]) -> Unit {
  self.starts.clear()
  self.ends.clear()
  self.values.clear()
  self.generations.clear()
  self.free.clear()
  self.order.clear()
  self.max_ends.clear()
  self.len = 0
}

///|
pub fn[K, V] IntervalTree::copy(
  self : IntervalTree[K, V],
) -> IntervalTree[K, V] {
  {
    cmp: self.cmp,
    starts: self.starts.copy(),
    ends: self.ends.copy(),
    values: self.values.copy(),
    generations: self.generations.copy(),
    free: self.free.copy(),
    order: self.order.copy(),
    max_ends: self.max_ends.copy(),
    len: self.len,
  }
}
