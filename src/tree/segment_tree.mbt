///|
/// The smallest power of two at least `n`, so leaves can be laid out at a fixed
/// offset.
fn segment_size(n : Int32) -> Int32 {
  let mut size = 1
  while size < n && size < 0x40000000 {
    size = size * 2
  }
  size
}

///|
/// A range aggregate over a fixed array: the leaves are the elements, an inner
/// node is `op` of its two children, and a query combines the O(log n) nodes
/// that cover a half-open range. The operation has to be associative, and
/// `identity` has to leave the other operand alone, which is what lets a query
/// start from nothing.
///
/// ```mbt check
/// test {
///   let tree : @tree.SegmentTree[Int32] = @tree.SegmentTree::from_array(
///     [3, 1, 4, 1, 5],
///     op=(a, b) => a + b,
///     identity=0,
///   )
///   assert_true(tree.query(0, 3) == 8)
///   assert_true(tree.query_all() == 14)
///   let _ = tree.set(1, 10)
///   assert_true(tree.query(0, 3) == 17)
///   assert_true(tree.first_where(x => x >= 17) == Some(2))
/// }
/// ```
pub struct SegmentTree[T] {
  op : (T, T) -> T
  identity : T
  size : Int32
  nodes : Array[T]
}

///|
/// A tree over `length` positions, every one of them `identity`.
pub fn[T] SegmentTree::new(
  length~ : Int32,
  op~ : (T, T) -> T,
  identity~ : T,
) -> SegmentTree[T] {
  let size = segment_size(if length < 1 { 1 } else { length })
  let nodes : Array[T] = []
  for _ in 0..<(2 * size) {
    nodes.push(identity)
  }
  { op, identity, size, nodes, }
}

///|
pub fn[T] SegmentTree::from_array(
  values : ArrayView[T],
  op~ : (T, T) -> T,
  identity~ : T,
) -> SegmentTree[T] {
  let tree : SegmentTree[T] = SegmentTree::new(
    length=values.length(),
    op~,
    identity~,
  )
  for i in 0..<values.length() {
    tree.nodes[tree.size + i] = values[i]
  }
  let mut i = tree.size - 1
  while i >= 1 {
    tree.nodes[i] = (tree.op)(tree.nodes[2 * i], tree.nodes[2 * i + 1])
    i = i - 1
  }
  tree
}

///|
pub fn[T] SegmentTree::length(self : SegmentTree[T]) -> Int32 {
  self.size
}

///|
pub fn[T] SegmentTree::get(self : SegmentTree[T], index : Int32) -> T? {
  if index < 0 || index >= self.size {
    None
  } else {
    Some(self.nodes[self.size + index])
  }
}

///|
pub fn[T] SegmentTree::set(
  self : SegmentTree[T],
  index : Int32,
  value : T,
) -> Bool {
  if index < 0 || index >= self.size {
    return false
  }
  let mut at = self.size + index
  self.nodes[at] = value
  while at > 1 {
    at = at / 2
    self.nodes[at] = (self.op)(self.nodes[2 * at], self.nodes[2 * at + 1])
  }
  true
}

///|
/// The aggregate over `[start, end)`, `identity` when the range is empty.
pub fn[T] SegmentTree::query(
  self : SegmentTree[T],
  start : Int32,
  end : Int32,
) -> T {
  let lo = if start < 0 { 0 } else { start }
  let hi = if end > self.size { self.size } else { end }
  if lo >= hi {
    return self.identity
  }
  let mut left = lo + self.size
  let mut right = hi + self.size
  let mut acc_left = self.identity
  let mut acc_right = self.identity
  while left < right {
    if left % 2 == 1 {
      acc_left = (self.op)(acc_left, self.nodes[left])
      left = left + 1
    }
    if right % 2 == 1 {
      right = right - 1
      acc_right = (self.op)(self.nodes[right], acc_right)
    }
    left = left / 2
    right = right / 2
  }
  (self.op)(acc_left, acc_right)
}

///|
pub fn[T] SegmentTree::query_all(self : SegmentTree[T]) -> T {
  self.nodes[1]
}

///|
/// The first position whose prefix aggregate satisfies `predicate`, or `None`.
/// The descent relies on the predicate holding for a prefix once it holds for a
/// smaller one, which is what makes a segment tree able to answer "where does
/// this threshold get crossed" in O(log n).
pub fn[T] SegmentTree::first_where(
  self : SegmentTree[T],
  predicate : (T) -> Bool,
) -> Int32? {
  let mut acc = self.identity
  if !predicate((self.op)(acc, self.nodes[1])) {
    return None
  }
  let mut node = 1
  while node < self.size {
    let left = 2 * node
    let with_left = (self.op)(acc, self.nodes[left])
    if predicate(with_left) {
      node = left
    } else {
      acc = with_left
      node = left + 1
    }
  }
  Some(node - self.size)
}

///|
pub fn[T] SegmentTree::to_array(self : SegmentTree[T]) -> Array[T] {
  let out : Array[T] = []
  for i in 0..<self.size {
    out.push(self.nodes[self.size + i])
  }
  out
}

///|
pub fn[T] SegmentTree::copy(self : SegmentTree[T]) -> SegmentTree[T] {
  {
    op: self.op,
    identity: self.identity,
    size: self.size,
    nodes: self.nodes.copy(),
  }
}

///|
/// A segment tree that also accepts a range update: a tag is applied to a whole
/// cover of a range and pushed down only when a later query or a partial update
/// has to look inside. `apply` says what a tag does to an aggregate, `compose`
/// merges an older tag into a newer one, and `none` is the tag that does
/// nothing.
///
/// ```mbt check
/// test {
///   let tree : @tree.LazySegmentTree[Int32, Int32] = @tree.LazySegmentTree::from_array(
///     [1, 1, 1, 1],
///     op=(a, b) => a + b,
///     identity=0,
///     apply=(tag, value, span) => value + tag * span,
///     compose=(older, newer) => older + newer,
///     none=0,
///   )
///   tree.range_update(1, 3, 5)
///   assert_true(tree.query(0, 4) == 14)
///   assert_true(tree.query(1, 2) == 6)
/// }
/// ```
pub struct LazySegmentTree[T, F] {
  op : (T, T) -> T
  identity : T
  apply : (F, T, Int32) -> T
  compose : (F, F) -> F
  none : F
  size : Int32
  nodes : Array[T]
  tags : Array[F]
}

///|
pub fn[T, F] LazySegmentTree::new(
  length~ : Int32,
  op~ : (T, T) -> T,
  identity~ : T,
  apply~ : (F, T, Int32) -> T,
  compose~ : (F, F) -> F,
  none~ : F,
) -> LazySegmentTree[T, F] {
  let size = segment_size(if length < 1 { 1 } else { length })
  let nodes : Array[T] = []
  let tags : Array[F] = []
  for _ in 0..<(2 * size) {
    nodes.push(identity)
    tags.push(none)
  }
  { op, identity, apply, compose, none, size, nodes, tags, }
}

///|
pub fn[T, F] LazySegmentTree::from_array(
  values : ArrayView[T],
  op~ : (T, T) -> T,
  identity~ : T,
  apply~ : (F, T, Int32) -> T,
  compose~ : (F, F) -> F,
  none~ : F,
) -> LazySegmentTree[T, F] {
  let tree : LazySegmentTree[T, F] = LazySegmentTree::new(
    length=values.length(),
    op~,
    identity~,
    apply~,
    compose~,
    none~,
  )
  for i in 0..<values.length() {
    tree.nodes[tree.size + i] = values[i]
  }
  let mut i = tree.size - 1
  while i >= 1 {
    tree.nodes[i] = (tree.op)(tree.nodes[2 * i], tree.nodes[2 * i + 1])
    i = i - 1
  }
  tree
}

///|
/// How many elements the subtree rooted at `node` covers, which is what a tag
/// has to know to update an aggregate that is not length-independent.
fn[T, F] LazySegmentTree::span_of(
  self : LazySegmentTree[T, F],
  node : Int32,
) -> Int32 {
  let mut span = self.size
  let mut at = node
  while at > 1 {
    span = span / 2
    at = at / 2
  }
  span
}

///|
fn[T, F] LazySegmentTree::push_down(
  self : LazySegmentTree[T, F],
  node : Int32,
) -> Unit {
  let tag = self.tags[node]
  if node < self.size {
    self.tags[2 * node] = (self.compose)(self.tags[2 * node], tag)
    self.tags[2 * node + 1] = (self.compose)(self.tags[2 * node + 1], tag)
    self.nodes[2 * node] = (self.apply)(
      tag,
      self.nodes[2 * node],
      self.span_of(node * 2),
    )
    self.nodes[2 * node + 1] = (self.apply)(
      tag,
      self.nodes[2 * node + 1],
      self.span_of(node * 2 + 1),
    )
  }
  self.tags[node] = self.none
}

///|
fn[T, F] LazySegmentTree::update_range(
  self : LazySegmentTree[T, F],
  node : Int32,
  node_start : Int32,
  node_end : Int32,
  start : Int32,
  end : Int32,
  tag : F,
) -> Unit {
  if end <= node_start || node_end <= start {
    return
  }
  if start <= node_start && node_end <= end {
    self.nodes[node] = (self.apply)(
      tag,
      self.nodes[node],
      node_end - node_start,
    )
    self.tags[node] = (self.compose)(self.tags[node], tag)
    return
  }
  self.push_down(node)
  let mid = (node_start + node_end) / 2
  self.update_range(2 * node, node_start, mid, start, end, tag)
  self.update_range(2 * node + 1, mid, node_end, start, end, tag)
  self.nodes[node] = (self.op)(self.nodes[2 * node], self.nodes[2 * node + 1])
}

///|
pub fn[T, F] LazySegmentTree::range_update(
  self : LazySegmentTree[T, F],
  start : Int32,
  end : Int32,
  tag : F,
) -> Unit {
  let lo = if start < 0 { 0 } else { start }
  let hi = if end > self.size { self.size } else { end }
  if lo < hi {
    self.update_range(1, 0, self.size, lo, hi, tag)
  }
}

///|
fn[T, F] LazySegmentTree::collect(
  self : LazySegmentTree[T, F],
  node : Int32,
  node_start : Int32,
  node_end : Int32,
  start : Int32,
  end : Int32,
  acc : T,
) -> T {
  if end <= node_start || node_end <= start {
    return acc
  }
  if start <= node_start && node_end <= end {
    return (self.op)(acc, self.nodes[node])
  }
  self.push_down(node)
  let mid = (node_start + node_end) / 2
  let left = self.collect(2 * node, node_start, mid, start, end, acc)
  self.collect(2 * node + 1, mid, node_end, start, end, left)
}

///|
pub fn[T, F] LazySegmentTree::query(
  self : LazySegmentTree[T, F],
  start : Int32,
  end : Int32,
) -> T {
  let lo = if start < 0 { 0 } else { start }
  let hi = if end > self.size { self.size } else { end }
  if lo >= hi {
    return self.identity
  }
  self.collect(1, 0, self.size, lo, hi, self.identity)
}

///|
pub fn[T, F] LazySegmentTree::get(
  self : LazySegmentTree[T, F],
  index : Int32,
) -> T? {
  if index < 0 || index >= self.size {
    None
  } else {
    Some(self.query(index, index + 1))
  }
}

///|
pub fn[T, F] LazySegmentTree::set(
  self : LazySegmentTree[T, F],
  index : Int32,
  value : T,
) -> Bool {
  if index < 0 || index >= self.size {
    return false
  }
  self.update_range(1, 0, self.size, index, index + 1, self.none)
  let mut at = self.size + index
  self.nodes[at] = value
  while at > 1 {
    at = at / 2
    self.push_down(at)
    self.nodes[at] = (self.op)(self.nodes[2 * at], self.nodes[2 * at + 1])
  }
  true
}

///|
/// A Fenwick tree: `tree[i]` holds the sum of the `i & -i` elements that end at
/// `i`, so a prefix sum reads one path to zero and an update writes one path to
/// the end. Both are O(log n) with small constants, which is why it beats a
/// segment tree for sums that only ever grow at a point.
///
/// ```mbt check
/// test {
///   let fenwick : @tree.Fenwick[Int32] = @tree.Fenwick::new(length=5)
///   fenwick.add(0, 3)
///   fenwick.add(2, 4)
///   assert_true(fenwick.prefix_sum(3) == 7)
///   assert_true(fenwick.range_sum(1, 3) == 4)
///   let _ = fenwick.set(0, 10)
///   assert_true(fenwick.get(0) == Some(10))
///   assert_true(fenwick.lower_bound(5) == Some(0))
/// }
/// ```
pub struct Fenwick[T] {
  tree : Array[T]
  values : Array[T]
  length_ : Int32
}

///|
pub fn[T : Default] Fenwick::new(length~ : Int32) -> Fenwick[T] {
  let size = if length < 0 { 0 } else { length }
  let tree : Array[T] = []
  let values : Array[T] = []
  for _ in 0..<size {
    tree.push(Default::default())
    values.push(Default::default())
  }
  { tree, values, length_: size, }
}

///|
pub fn[T : Add + Sub + Default] Fenwick::from_array(
  values : ArrayView[T],
) -> Fenwick[T] {
  let fenwick : Fenwick[T] = Fenwick::new(length=values.length())
  for i in 0..<values.length() {
    let _ = fenwick.set(i, values[i])
  }
  fenwick
}

///|
pub fn[T : Add] Fenwick::add(
  self : Fenwick[T],
  index : Int32,
  delta : T,
) -> Unit {
  if index < 0 || index >= self.length_ {
    return
  }
  self.values[index] = self.values[index] + delta
  let mut at = index + 1
  while at <= self.length_ {
    self.tree[at - 1] = self.tree[at - 1] + delta
    at = at + (at & -at)
  }
}

///|
/// The sum of the first `end` elements.
pub fn[T : Add + Default] Fenwick::prefix_sum(
  self : Fenwick[T],
  end : Int32,
) -> T {
  let stop = if end > self.length_ {
    self.length_
  } else if end < 0 {
    0
  } else {
    end
  }
  let mut acc = Default::default()
  let mut at = stop
  while at > 0 {
    acc = acc + self.tree[at - 1]
    at = at - (at & -at)
  }
  acc
}

///|
/// The sum of `[start, end)`.
pub fn[T : Add + Sub + Default] Fenwick::range_sum(
  self : Fenwick[T],
  start : Int32,
  end : Int32,
) -> T {
  self.prefix_sum(end) - self.prefix_sum(start)
}

///|
pub fn[T] Fenwick::get(self : Fenwick[T], index : Int32) -> T? {
  if index < 0 || index >= self.length_ {
    None
  } else {
    Some(self.values[index])
  }
}

///|
pub fn[T : Add + Sub] Fenwick::set(
  self : Fenwick[T],
  index : Int32,
  value : T,
) -> Bool {
  match self.get(index) {
    Some(old) => {
      self.add(index, value - old)
      true
    }
    None => false
  }
}

///|
pub fn[T] Fenwick::length(self : Fenwick[T]) -> Int32 {
  self.length_
}

///|
/// The first index whose prefix sum is strictly greater than `target`, which is
/// how a Fenwick tree answers "where does this weight get spent" while every
/// value stays non-negative. `None` when the whole tree does not reach it.
pub fn[T : Sub + Compare] Fenwick::lower_bound(
  self : Fenwick[T],
  target : T,
) -> Int32? {
  let mut position = 0
  let mut remaining = target
  let mut step = 1
  while step * 2 <= self.length_ {
    step = step * 2
  }
  let mut span = step
  while span > 0 {
    let next = position + span
    if next <= self.length_ && self.tree[next - 1] <= remaining {
      remaining = remaining - self.tree[next - 1]
      position = next
    }
    span = span / 2
  }
  if position >= self.length_ {
    None
  } else {
    Some(position)
  }
}
