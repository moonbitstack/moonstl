///|
/// What an insert does when the new range meets one that is already there.
#derive(Eq, Debug)
pub(all) enum Overlap {
  /// Cut the existing ranges back and take the space.
  Overwrite
  /// Raise `Refused::Overlap` and leave the map alone.
  Refuse
  /// Leave the existing ranges alone and drop the new one.
  KeepFirst
}

///|
pub extend Overlap with Eq::{equal, not_equal}

///|
pub extend Overlap with Debug::{to_repr}

///|
pub impl Show for Overlap with fn output(self, logger) {
  logger.write_string(
    match self {
      Overwrite => "overwrite"
      Refuse => "refuse"
      KeepFirst => "keep first"
    },
  )
}

///|
pub extend Overlap with Show::{to_string, output}

///|
/// A value that holds over a span of keys: the ranges are kept sorted, never
/// overlap each other, and two ranges that touch and hold the same value are
/// kept as one. A range is half-open — it covers `start` and stops before `end`
/// — so an insert that meets a neighbour at one endpoint does not collide with
/// it.
///
/// ```mbt check
/// test {
///   let map : @map.RangeMap[Int32, String] = @map.RangeMap::new()
///   map.insert(start=0, end=10, "low")
///   map.insert(start=10, end=20, "high")
///   @test.assert_eq(map.get(5), Some("low"))
///   @test.assert_eq(map.get(10), Some("high"))
///   @test.assert_eq(map.get(20), None)
///   @test.assert_eq(map.length(), 2)
/// }
/// ```
pub struct RangeMap[K, V] {
  /// Sorted by start; a triple is `(start, end, value)`.
  mut ranges : Array[(K, K, V)]
  overlap : Overlap
}

///|
pub fn[K, V] RangeMap::new(overlap~ : Overlap = Overwrite) -> RangeMap[K, V] {
  { ranges: [], overlap, }
}

///|
/// The first range whose start is not less than `key`.
fn[K : Compare, V] RangeMap::lower_pos(self : RangeMap[K, V], key : K) -> Int32 {
  let mut low = 0
  let mut high = self.ranges.length()
  while low < high {
    let mid = (low + high) / 2
    if self.ranges[mid].0.compare(key) < 0 {
      low = mid + 1
    } else {
      high = mid
    }
  }
  low
}

///|
/// The position of the range that covers `key`, or `None`.
fn[K : Compare, V] RangeMap::find(self : RangeMap[K, V], key : K) -> Int32? {
  let at = self.lower_pos(key)
  let candidate = if at < self.ranges.length() &&
    self.ranges[at].0.compare(key) == 0 {
    at
  } else if at > 0 {
    at - 1
  } else {
    return None
  }
  let (start, end, _) = self.ranges[candidate]
  if start.compare(key) <= 0 && key.compare(end) < 0 {
    Some(candidate)
  } else {
    None
  }
}

///|
pub fn[K : Compare, V] RangeMap::get(self : RangeMap[K, V], key : K) -> V? {
  match self.find(key) {
    Some(at) => Some(self.ranges[at].2)
    None => None
  }
}

///|
pub fn[K : Compare, V] RangeMap::get_range(
  self : RangeMap[K, V],
  key : K,
) -> (K, K, V)? {
  match self.find(key) {
    Some(at) => Some(self.ranges[at])
    None => None
  }
}

///|
/// Every range that meets `[start, end)`, in start order.
pub fn[K : Compare, V] RangeMap::overlapping(
  self : RangeMap[K, V],
  start~ : K,
  end~ : K,
) -> Array[(K, K, V)] {
  let found : Array[(K, K, V)] = []
  let from = if self.lower_pos(start) > 0 {
    self.lower_pos(start) - 1
  } else {
    0
  }
  for i in from..<self.ranges.length() {
    let (range_start, range_end, value) = self.ranges[i]
    if range_start.compare(end) >= 0 {
      break
    }
    if range_end.compare(start) > 0 {
      found.push((range_start, range_end, value))
    }
  }
  found
}

///|
/// Stores `value` over `[start, end)`, applying the overlap policy and folding
/// the result into its neighbours.
pub fn[K : Compare, V : Eq] RangeMap::insert(
  self : RangeMap[K, V],
  start~ : K,
  end~ : K,
  value : V,
) -> Unit raise @spec.Refused {
  if start.compare(end) >= 0 {
    return
  }
  let clash = self.overlapping(start~, end~)
  if clash.length() > 0 {
    match self.overlap {
      Refuse => raise @spec.Refused::Overlap
      KeepFirst => return
      Overwrite => ()
    }
  }
  // Keep the parts of the existing ranges that lie outside the new one.
  let kept : Array[(K, K, V)] = []
  for (range_start, range_end, held) in self.ranges {
    if range_end.compare(start) <= 0 || range_start.compare(end) >= 0 {
      kept.push((range_start, range_end, held))
      continue
    }
    if range_start.compare(start) < 0 {
      kept.push((range_start, start, held))
    }
    if range_end.compare(end) > 0 {
      kept.push((end, range_end, held))
    }
  }
  let at = {
    let mut low = 0
    let mut high = kept.length()
    while low < high {
      let mid = (low + high) / 2
      if kept[mid].0.compare(start) < 0 {
        low = mid + 1
      } else {
        high = mid
      }
    }
    low
  }
  kept.insert(at, (start, end, value))
  self.ranges = merge_adjacent(kept)
}

///|
/// Folds a start-sorted run of ranges so that neighbours with equal values and
/// no gap between them become one range.
fn[K : Compare, V : Eq] merge_adjacent(
  ranges : Array[(K, K, V)],
) -> Array[(K, K, V)] {
  let merged : Array[(K, K, V)] = []
  for (start, end, value) in ranges {
    if merged.length() > 0 {
      let (last_start, last_end, last_value) = merged[merged.length() - 1]
      if last_end.compare(start) == 0 && last_value == value {
        merged[merged.length() - 1] = (last_start, end, last_value)
        continue
      }
    }
    merged.push((start, end, value))
  }
  merged
}

///|
/// Drops the part of every range that falls in `[start, end)`, splitting a range
/// that straddles it.
pub fn[K : Compare, V] RangeMap::remove(
  self : RangeMap[K, V],
  start~ : K,
  end~ : K,
) -> Unit {
  if start.compare(end) >= 0 {
    return
  }
  let kept : Array[(K, K, V)] = []
  for (range_start, range_end, value) in self.ranges {
    if range_end.compare(start) <= 0 || range_start.compare(end) >= 0 {
      kept.push((range_start, range_end, value))
      continue
    }
    if range_start.compare(start) < 0 {
      kept.push((range_start, start, value))
    }
    if range_end.compare(end) > 0 {
      kept.push((end, range_end, value))
    }
  }
  self.ranges = kept
}

///|
/// The ranges, in start order.
pub fn[K, V] RangeMap::ranges(self : RangeMap[K, V]) -> Iter[(K, K, V)] {
  let mut cursor = 0
  Iter::new(() => {
    if cursor >= self.ranges.length() {
      None
    } else {
      let range = self.ranges[cursor]
      cursor = cursor + 1
      Some(range)
    }
  })
}

///|
/// The spans no range covers, in start order.
pub fn[K, V] RangeMap::gaps(self : RangeMap[K, V]) -> Iter[(K, K)] {
  let mut cursor = 0
  Iter::new(() => {
    if cursor + 1 >= self.ranges.length() {
      None
    } else {
      let gap = (self.ranges[cursor].1, self.ranges[cursor + 1].0)
      cursor = cursor + 1
      Some(gap)
    }
  })
}

///|
pub fn[K, V] RangeMap::length(self : RangeMap[K, V]) -> Int32 {
  self.ranges.length()
}

///|
pub fn[K, V] RangeMap::is_empty(self : RangeMap[K, V]) -> Bool {
  self.ranges.length() == 0
}

///|
pub fn[K, V] RangeMap::clear(self : RangeMap[K, V]) -> Unit {
  self.ranges.clear()
}

///|
pub fn[K, V] RangeMap::copy(self : RangeMap[K, V]) -> RangeMap[K, V] {
  { ranges: self.ranges.copy(), overlap: self.overlap, }
}

///|
pub impl[K : Eq, V : Eq] Eq for RangeMap[K, V] with fn equal(self, other) {
  self.ranges == other.ranges
}

///|
pub extend RangeMap with Eq::{equal, not_equal}

///|
pub impl[K : Show, V : Show] Show for RangeMap[K, V] with fn output(
  self,
  logger,
) {
  logger.write_string("[")
  for i, range in self.ranges {
    if i > 0 {
      logger.write_string(", ")
    }
    logger.write_string("(")
    range.0.output(logger)
    logger.write_string("..")
    range.1.output(logger)
    logger.write_string(": ")
    range.2.output(logger)
    logger.write_string(")")
  }
  logger.write_string("]")
}

///|
pub extend RangeMap with Show::{to_string, output}

///|
/// A set of spans: the companion of `RangeMap` with no value to carry.
///
/// ```mbt check
/// test {
///   let set : @map.RangeSet[Int32] = @map.RangeSet::new()
///   set.insert(start=0, end=5)
///   set.insert(start=5, end=9)
///   @test.assert_eq(set.contains(7), true)
///   @test.assert_eq(set.contains(9), false)
///   @test.assert_eq(set.length(), 1)
/// }
/// ```
pub struct RangeSet[K] {
  mut ranges : Array[(K, K)]
  overlap : Overlap
}

///|
pub fn[K] RangeSet::new(overlap~ : Overlap = Overwrite) -> RangeSet[K] {
  { ranges: [], overlap, }
}

///|
fn[K : Compare] RangeSet::lower_pos(self : RangeSet[K], key : K) -> Int32 {
  let mut low = 0
  let mut high = self.ranges.length()
  while low < high {
    let mid = (low + high) / 2
    if self.ranges[mid].0.compare(key) < 0 {
      low = mid + 1
    } else {
      high = mid
    }
  }
  low
}

///|
pub fn[K : Compare] RangeSet::contains(self : RangeSet[K], key : K) -> Bool {
  let at = self.lower_pos(key)
  let candidate = if at < self.ranges.length() &&
    self.ranges[at].0.compare(key) == 0 {
    at
  } else if at > 0 {
    at - 1
  } else {
    return false
  }
  let (start, end) = self.ranges[candidate]
  start.compare(key) <= 0 && key.compare(end) < 0
}

///|
pub fn[K : Compare] RangeSet::insert(
  self : RangeSet[K],
  start~ : K,
  end~ : K,
) -> Unit raise @spec.Refused {
  if start.compare(end) >= 0 {
    return
  }
  let clash = self.overlapping(start~, end~)
  if clash.length() > 0 {
    match self.overlap {
      Refuse => raise @spec.Refused::Overlap
      KeepFirst => return
      Overwrite => ()
    }
  }
  let kept : Array[(K, K)] = []
  for (range_start, range_end) in self.ranges {
    if range_end.compare(start) <= 0 || range_start.compare(end) >= 0 {
      kept.push((range_start, range_end))
      continue
    }
    if range_start.compare(start) < 0 {
      kept.push((range_start, start))
    }
    if range_end.compare(end) > 0 {
      kept.push((end, range_end))
    }
  }
  let at = {
    let mut low = 0
    let mut high = kept.length()
    while low < high {
      let mid = (low + high) / 2
      if kept[mid].0.compare(start) < 0 {
        low = mid + 1
      } else {
        high = mid
      }
    }
    low
  }
  kept.insert(at, (start, end))
  let merged : Array[(K, K)] = []
  for range in kept {
    if merged.length() > 0 &&
      merged[merged.length() - 1].1.compare(range.0) == 0 {
      let (last_start, _) = merged[merged.length() - 1]
      merged[merged.length() - 1] = (last_start, range.1)
    } else {
      merged.push(range)
    }
  }
  self.ranges = merged
}

///|
pub fn[K : Compare] RangeSet::overlapping(
  self : RangeSet[K],
  start~ : K,
  end~ : K,
) -> Array[(K, K)] {
  let found : Array[(K, K)] = []
  let from = if self.lower_pos(start) > 0 {
    self.lower_pos(start) - 1
  } else {
    0
  }
  for i in from..<self.ranges.length() {
    let (range_start, range_end) = self.ranges[i]
    if range_start.compare(end) >= 0 {
      break
    }
    if range_end.compare(start) > 0 {
      found.push((range_start, range_end))
    }
  }
  found
}

///|
pub fn[K : Compare] RangeSet::remove(
  self : RangeSet[K],
  start~ : K,
  end~ : K,
) -> Unit {
  if start.compare(end) >= 0 {
    return
  }
  let kept : Array[(K, K)] = []
  for (range_start, range_end) in self.ranges {
    if range_end.compare(start) <= 0 || range_start.compare(end) >= 0 {
      kept.push((range_start, range_end))
      continue
    }
    if range_start.compare(start) < 0 {
      kept.push((range_start, start))
    }
    if range_end.compare(end) > 0 {
      kept.push((end, range_end))
    }
  }
  self.ranges = kept
}

///|
pub fn[K] RangeSet::ranges(self : RangeSet[K]) -> Iter[(K, K)] {
  let mut cursor = 0
  Iter::new(() => {
    if cursor >= self.ranges.length() {
      None
    } else {
      let range = self.ranges[cursor]
      cursor = cursor + 1
      Some(range)
    }
  })
}

///|
pub fn[K] RangeSet::gaps(self : RangeSet[K]) -> Iter[(K, K)] {
  let mut cursor = 0
  Iter::new(() => {
    if cursor + 1 >= self.ranges.length() {
      None
    } else {
      let gap = (self.ranges[cursor].1, self.ranges[cursor + 1].0)
      cursor = cursor + 1
      Some(gap)
    }
  })
}

///|
pub fn[K] RangeSet::length(self : RangeSet[K]) -> Int32 {
  self.ranges.length()
}

///|
pub fn[K] RangeSet::is_empty(self : RangeSet[K]) -> Bool {
  self.ranges.length() == 0
}

///|
pub fn[K] RangeSet::clear(self : RangeSet[K]) -> Unit {
  self.ranges.clear()
}

///|
pub fn[K] RangeSet::copy(self : RangeSet[K]) -> RangeSet[K] {
  { ranges: self.ranges.copy(), overlap: self.overlap, }
}

///|
pub impl[K : Eq] Eq for RangeSet[K] with fn equal(self, other) {
  self.ranges == other.ranges
}

///|
pub extend RangeSet with Eq::{equal, not_equal}

///|
pub impl[K : Show] Show for RangeSet[K] with fn output(self, logger) {
  logger.write_string("[")
  for i, range in self.ranges {
    if i > 0 {
      logger.write_string(", ")
    }
    logger.write_string("(")
    range.0.output(logger)
    logger.write_string("..")
    range.1.output(logger)
    logger.write_string(")")
  }
  logger.write_string("]")
}

///|
pub extend RangeSet with Show::{to_string, output}
