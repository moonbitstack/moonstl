// Randomized search trees. A treap keeps the search order in the keys and the
// heap order in a random priority, which is what keeps it balanced on average
// without any bookkeeping on the way back up.

///|
/// The next priority of a treap: splitmix64 over a counter, so the shape of a
/// tree is decided by the seed and replays exactly.
fn next_priority(seed : UInt64) -> UInt64 {
  let mut z = seed * 0x9e3779b97f4a7c15 + 0x9e3779b97f4a7c15
  z = (z ^ (z >> 30)) * 0xbf58476d1ce4e5b9
  z = (z ^ (z >> 27)) * 0x94d049bb133111eb
  z ^ (z >> 31)
}

///|
/// A search tree that also answers by position: every node carries the size of
/// its subtree, so `select` and `rank` walk one path instead of counting.
/// Duplicates are not stored. The shape is that of a treap, which is what keeps
/// the depth logarithmic without rebalancing after every insert.
///
/// ```mbt check
/// test {
///   let tree : @tree.OrderStatisticTree[Int32] = @tree.OrderStatisticTree::new()
///   for value in [5, 1, 9, 3] {
///     let _ = tree.insert(value)
///   }
///   assert_true(tree.select(0) == Some(1))
///   assert_true(tree.select(3) == Some(9))
///   assert_true(tree.rank(5) == 2)
///   assert_true(tree.count_range(2, 9) == 2)
/// }
/// ```
pub struct OrderStatisticTree[T] {
  cmp : (T, T) -> Int32
  keys : Array[T?]
  left : Array[Int32]
  right : Array[Int32]
  sizes : Array[Int32]
  priorities : Array[UInt64]
  mut root : Int32
  mut len : Int32
  mut seed : UInt64
}

///|
pub fn[T : Compare] OrderStatisticTree::new() -> OrderStatisticTree[T] {
  OrderStatisticTree::new_by(cmp=(a, b) => a.compare(b))
}

///|
pub fn[T] OrderStatisticTree::new_by(
  cmp~ : (T, T) -> Int32,
) -> OrderStatisticTree[T] {
  {
    cmp,
    keys: [],
    left: [],
    right: [],
    sizes: [],
    priorities: [],
    root: -1,
    len: 0,
    seed: 0x2545F4914F6CDD1DUL,
  }
}

///|
fn[T] OrderStatisticTree::key_at(
  self : OrderStatisticTree[T],
  node : Int32,
) -> T {
  match self.keys[node] {
    Some(key) => key
    None => abort("moonstl: an order-statistic node that holds nothing")
  }
}

///|
fn[T] OrderStatisticTree::size_of(
  self : OrderStatisticTree[T],
  node : Int32,
) -> Int32 {
  if node < 0 {
    0
  } else {
    self.sizes[node]
  }
}

///|
fn[T] OrderStatisticTree::refresh(
  self : OrderStatisticTree[T],
  node : Int32,
) -> Unit {
  self.sizes[node] = 1 +
    self.size_of(self.left[node]) +
    self.size_of(self.right[node])
}

///|
fn[T] OrderStatisticTree::alloc(self : OrderStatisticTree[T], key : T) -> Int32 {
  let node = self.keys.length()
  self.keys.push(Some(key))
  self.left.push(-1)
  self.right.push(-1)
  self.sizes.push(1)
  self.seed = next_priority(self.seed)
  self.priorities.push(self.seed)
  node
}

///|
fn[T] OrderStatisticTree::rotate_right(
  self : OrderStatisticTree[T],
  node : Int32,
) -> Int32 {
  let pivot = self.left[node]
  self.left[node] = self.right[pivot]
  self.right[pivot] = node
  self.refresh(node)
  self.refresh(pivot)
  pivot
}

///|
fn[T] OrderStatisticTree::rotate_left(
  self : OrderStatisticTree[T],
  node : Int32,
) -> Int32 {
  let pivot = self.right[node]
  self.right[node] = self.left[pivot]
  self.left[pivot] = node
  self.refresh(node)
  self.refresh(pivot)
  pivot
}

///|
fn[T] OrderStatisticTree::insert_at(
  self : OrderStatisticTree[T],
  node : Int32,
  key : T,
  added : Ref[Bool],
) -> Int32 {
  if node < 0 {
    added.val = true
    return self.alloc(key)
  }
  let order = (self.cmp)(key, self.key_at(node))
  if order == 0 {
    return node
  }
  if order < 0 {
    self.left[node] = self.insert_at(self.left[node], key, added)
    if self.priorities[self.left[node]] < self.priorities[node] {
      return self.rotate_right(node)
    }
  } else {
    self.right[node] = self.insert_at(self.right[node], key, added)
    if self.priorities[self.right[node]] < self.priorities[node] {
      return self.rotate_left(node)
    }
  }
  self.refresh(node)
  node
}

///|
pub fn[T] OrderStatisticTree::insert(
  self : OrderStatisticTree[T],
  key : T,
) -> Bool {
  let added : Ref[Bool] = Ref(false)
  self.root = self.insert_at(self.root, key, added)
  if added.val {
    self.len = self.len + 1
  }
  added.val
}

///|
fn[T] OrderStatisticTree::remove_at(
  self : OrderStatisticTree[T],
  node : Int32,
  key : T,
  removed : Ref[Bool],
) -> Int32 {
  if node < 0 {
    return -1
  }
  let order = (self.cmp)(key, self.key_at(node))
  if order < 0 {
    self.left[node] = self.remove_at(self.left[node], key, removed)
  } else if order > 0 {
    self.right[node] = self.remove_at(self.right[node], key, removed)
  } else {
    removed.val = true
    let merged = self.merge(self.left[node], self.right[node])
    return merged
  }
  self.refresh(node)
  node
}

///|
fn[T] OrderStatisticTree::merge(
  self : OrderStatisticTree[T],
  a : Int32,
  b : Int32,
) -> Int32 {
  if a < 0 {
    return b
  }
  if b < 0 {
    return a
  }
  if self.priorities[a] < self.priorities[b] {
    self.right[a] = self.merge(self.right[a], b)
    self.refresh(a)
    a
  } else {
    self.left[b] = self.merge(a, self.left[b])
    self.refresh(b)
    b
  }
}

///|
pub fn[T] OrderStatisticTree::remove(
  self : OrderStatisticTree[T],
  key : T,
) -> Bool {
  let removed : Ref[Bool] = Ref(false)
  self.root = self.remove_at(self.root, key, removed)
  if removed.val {
    self.len = self.len - 1
  }
  removed.val
}

///|
pub fn[T] OrderStatisticTree::contains(
  self : OrderStatisticTree[T],
  key : T,
) -> Bool {
  let mut node = self.root
  while node >= 0 {
    let order = (self.cmp)(key, self.key_at(node))
    if order == 0 {
      return true
    }
    node = if order < 0 { self.left[node] } else { self.right[node] }
  }
  false
}

///|
/// The element at position `index`, counting from zero.
pub fn[T] OrderStatisticTree::select(
  self : OrderStatisticTree[T],
  index : Int32,
) -> T? {
  if index < 0 || index >= self.len {
    return None
  }
  let mut node = self.root
  let mut remaining = index
  while node >= 0 {
    let left_size = self.size_of(self.left[node])
    if remaining < left_size {
      node = self.left[node]
    } else if remaining == left_size {
      return Some(self.key_at(node))
    } else {
      remaining = remaining - left_size - 1
      node = self.right[node]
    }
  }
  None
}

///|
/// The number of elements smaller than `key`.
pub fn[T] OrderStatisticTree::rank(
  self : OrderStatisticTree[T],
  key : T,
) -> Int32 {
  let mut node = self.root
  let mut count = 0
  while node >= 0 {
    let order = (self.cmp)(key, self.key_at(node))
    if order <= 0 {
      node = self.left[node]
    } else {
      count = count + self.size_of(self.left[node]) + 1
      node = self.right[node]
    }
  }
  count
}

///|
pub fn[T] OrderStatisticTree::count_less(
  self : OrderStatisticTree[T],
  key : T,
) -> Int32 {
  self.rank(key)
}

///|
/// The number of elements in `[start, end)`, both ends compared by the tree's
/// own comparator.
pub fn[T] OrderStatisticTree::count_range(
  self : OrderStatisticTree[T],
  start : T,
  end : T,
) -> Int32 {
  let below_start = self.rank(start)
  let below_end = self.rank(end)
  if below_end < below_start {
    0
  } else {
    below_end - below_start
  }
}

///|
pub fn[T] OrderStatisticTree::first(self : OrderStatisticTree[T]) -> T? {
  if self.root < 0 {
    return None
  }
  let mut node = self.root
  while self.left[node] >= 0 {
    node = self.left[node]
  }
  Some(self.key_at(node))
}

///|
pub fn[T] OrderStatisticTree::last(self : OrderStatisticTree[T]) -> T? {
  if self.root < 0 {
    return None
  }
  let mut node = self.root
  while self.right[node] >= 0 {
    node = self.right[node]
  }
  Some(self.key_at(node))
}

///|
fn[T] OrderStatisticTree::collect(
  self : OrderStatisticTree[T],
  node : Int32,
  out : Array[T],
) -> Unit {
  if node < 0 {
    return
  }
  self.collect(self.left[node], out)
  out.push(self.key_at(node))
  self.collect(self.right[node], out)
}

///|
pub fn[T] OrderStatisticTree::iter(self : OrderStatisticTree[T]) -> Iter[T] {
  let out : Array[T] = []
  self.collect(self.root, out)
  let mut cursor = 0
  Iter::new(() => {
    if cursor >= out.length() {
      None
    } else {
      let value = out[cursor]
      cursor = cursor + 1
      Some(value)
    }
  })
}

///|
pub fn[T] OrderStatisticTree::range(
  self : OrderStatisticTree[T],
  start : T,
  end : T,
) -> Iter[T] {
  let out : Array[T] = []
  for value in self.iter() {
    if (self.cmp)(value, start) >= 0 && (self.cmp)(value, end) < 0 {
      out.push(value)
    }
  }
  let mut cursor = 0
  Iter::new(() => {
    if cursor >= out.length() {
      None
    } else {
      let value = out[cursor]
      cursor = cursor + 1
      Some(value)
    }
  })
}

///|
pub fn[T] OrderStatisticTree::length(self : OrderStatisticTree[T]) -> Int32 {
  self.len
}

///|
pub fn[T] OrderStatisticTree::is_empty(self : OrderStatisticTree[T]) -> Bool {
  self.len == 0
}

///|
pub fn[T] OrderStatisticTree::clear(self : OrderStatisticTree[T]) -> Unit {
  self.keys.clear()
  self.left.clear()
  self.right.clear()
  self.sizes.clear()
  self.priorities.clear()
  self.root = -1
  self.len = 0
}

///|
pub fn[T] OrderStatisticTree::to_array(
  self : OrderStatisticTree[T],
) -> Array[T] {
  let out : Array[T] = []
  self.collect(self.root, out)
  out
}

///|
pub fn[T] OrderStatisticTree::copy(
  self : OrderStatisticTree[T],
) -> OrderStatisticTree[T] {
  {
    cmp: self.cmp,
    keys: self.keys.copy(),
    left: self.left.copy(),
    right: self.right.copy(),
    sizes: self.sizes.copy(),
    priorities: self.priorities.copy(),
    root: self.root,
    len: self.len,
    seed: self.seed,
  }
}

///|
/// A map held as a treap: the keys are kept in order, each node carries a random
/// priority that keeps the tree balanced, and `split` and `merge` cut and join
/// in one path. `range` walks the keys in order between two bounds.
///
/// ```mbt check
/// test {
///   let tree : @tree.Treap[Int32, String] = @tree.Treap::new()
///   let _ = tree.set(2, "b")
///   let _ = tree.set(1, "a")
///   let _ = tree.set(3, "c")
///   assert_true(tree.get(2) == Some("b"))
///   assert_true(tree.to_array() == [(1, "a"), (2, "b"), (3, "c")])
///   assert_true(tree.remove(2) == Some("b"))
/// }
/// ```
pub struct Treap[K, V] {
  cmp : (K, K) -> Int32
  keys : Array[K?]
  values : Array[V?]
  left : Array[Int32]
  right : Array[Int32]
  priorities : Array[UInt64]
  mut root : Int32
  mut len : Int32
  mut seed : UInt64
}

///|
pub fn[K : Compare, V] Treap::new() -> Treap[K, V] {
  Treap::new_by(cmp=(a, b) => a.compare(b))
}

///|
pub fn[K, V] Treap::new_by(cmp~ : (K, K) -> Int32) -> Treap[K, V] {
  {
    cmp,
    keys: [],
    values: [],
    left: [],
    right: [],
    priorities: [],
    root: -1,
    len: 0,
    seed: 0x9E3779B97F4A7C15UL,
  }
}

///|
fn[K, V] Treap::key_at(self : Treap[K, V], node : Int32) -> K {
  match self.keys[node] {
    Some(key) => key
    None => abort("moonstl: a treap node that holds nothing")
  }
}

///|
fn[K, V] Treap::value_at(self : Treap[K, V], node : Int32) -> V {
  match self.values[node] {
    Some(value) => value
    None => abort("moonstl: a treap node that holds nothing")
  }
}

///|
fn[K, V] Treap::alloc(self : Treap[K, V], key : K, value : V) -> Int32 {
  let node = self.keys.length()
  self.keys.push(Some(key))
  self.values.push(Some(value))
  self.left.push(-1)
  self.right.push(-1)
  self.seed = next_priority(self.seed)
  self.priorities.push(self.seed)
  node
}

///|
fn[K, V] Treap::rotate_right(self : Treap[K, V], node : Int32) -> Int32 {
  let pivot = self.left[node]
  self.left[node] = self.right[pivot]
  self.right[pivot] = node
  pivot
}

///|
fn[K, V] Treap::rotate_left(self : Treap[K, V], node : Int32) -> Int32 {
  let pivot = self.right[node]
  self.right[node] = self.left[pivot]
  self.left[pivot] = node
  pivot
}

///|
fn[K, V] Treap::set_at(
  self : Treap[K, V],
  node : Int32,
  key : K,
  value : V,
  old : Ref[V?],
) -> Int32 {
  if node < 0 {
    return self.alloc(key, value)
  }
  let order = (self.cmp)(key, self.key_at(node))
  if order == 0 {
    old.val = self.values[node]
    self.values[node] = Some(value)
    return node
  }
  if order < 0 {
    self.left[node] = self.set_at(self.left[node], key, value, old)
    if self.priorities[self.left[node]] < self.priorities[node] {
      return self.rotate_right(node)
    }
  } else {
    self.right[node] = self.set_at(self.right[node], key, value, old)
    if self.priorities[self.right[node]] < self.priorities[node] {
      return self.rotate_left(node)
    }
  }
  node
}

///|
pub fn[K, V] Treap::set(self : Treap[K, V], key : K, value : V) -> V? {
  let old : Ref[V?] = Ref(None)
  self.root = self.set_at(self.root, key, value, old)
  if old.val is None {
    self.len = self.len + 1
  }
  old.val
}

///|
pub fn[K, V] Treap::get(self : Treap[K, V], key : K) -> V? {
  let mut node = self.root
  while node >= 0 {
    let order = (self.cmp)(key, self.key_at(node))
    if order == 0 {
      return self.values[node]
    }
    node = if order < 0 { self.left[node] } else { self.right[node] }
  }
  None
}

///|
pub fn[K, V] Treap::contains(self : Treap[K, V], key : K) -> Bool {
  self.get(key) is Some(_)
}

///|
fn[K, V] Treap::join(self : Treap[K, V], a : Int32, b : Int32) -> Int32 {
  if a < 0 {
    return b
  }
  if b < 0 {
    return a
  }
  if self.priorities[a] < self.priorities[b] {
    self.right[a] = self.join(self.right[a], b)
    a
  } else {
    self.left[b] = self.join(a, self.left[b])
    b
  }
}

///|
fn[K, V] Treap::remove_at(
  self : Treap[K, V],
  node : Int32,
  key : K,
  removed : Ref[V?],
) -> Int32 {
  if node < 0 {
    return -1
  }
  let order = (self.cmp)(key, self.key_at(node))
  if order < 0 {
    self.left[node] = self.remove_at(self.left[node], key, removed)
    node
  } else if order > 0 {
    self.right[node] = self.remove_at(self.right[node], key, removed)
    node
  } else {
    removed.val = self.values[node]
    self.join(self.left[node], self.right[node])
  }
}

///|
pub fn[K, V] Treap::remove(self : Treap[K, V], key : K) -> V? {
  let removed : Ref[V?] = Ref(None)
  self.root = self.remove_at(self.root, key, removed)
  if removed.val is Some(_) {
    self.len = self.len - 1
  }
  removed.val
}

///|
/// Splits the tree at `key` into the part below it and the part at or above it.
pub fn[K, V] Treap::split(
  self : Treap[K, V],
  key : K,
) -> (Treap[K, V], Treap[K, V]) {
  let lower : Treap[K, V] = Treap::new_by(cmp=self.cmp)
  let upper : Treap[K, V] = Treap::new_by(cmp=self.cmp)
  for (held, value) in self.iter() {
    if (self.cmp)(held, key) < 0 {
      let _ = lower.set(held, value)
    } else {
      let _ = upper.set(held, value)
    }
  }
  (lower, upper)
}

///|
/// Joins two trees whose key ranges do not interleave.
pub fn[K, V] Treap::merge(self : Treap[K, V], other : Treap[K, V]) -> Unit {
  for (key, value) in other.iter() {
    let _ = self.set(key, value)
  }
}

///|
fn[K, V] Treap::collect(
  self : Treap[K, V],
  node : Int32,
  out : Array[(K, V)],
) -> Unit {
  if node < 0 {
    return
  }
  self.collect(self.left[node], out)
  out.push((self.key_at(node), self.value_at(node)))
  self.collect(self.right[node], out)
}

///|
pub fn[K, V] Treap::to_array(self : Treap[K, V]) -> Array[(K, V)] {
  let out : Array[(K, V)] = []
  self.collect(self.root, out)
  out
}

///|
pub fn[K, V] Treap::iter(self : Treap[K, V]) -> Iter[(K, V)] {
  let out = self.to_array()
  let mut cursor = 0
  Iter::new(() => {
    if cursor >= out.length() {
      None
    } else {
      let entry = out[cursor]
      cursor = cursor + 1
      Some(entry)
    }
  })
}

///|
pub fn[K, V] Treap::range(
  self : Treap[K, V],
  start : K,
  end : K,
) -> Iter[(K, V)] {
  let out : Array[(K, V)] = []
  for entry in self.iter() {
    if (self.cmp)(entry.0, start) >= 0 && (self.cmp)(entry.0, end) < 0 {
      out.push(entry)
    }
  }
  let mut cursor = 0
  Iter::new(() => {
    if cursor >= out.length() {
      None
    } else {
      let entry = out[cursor]
      cursor = cursor + 1
      Some(entry)
    }
  })
}

///|
pub fn[K, V] Treap::first(self : Treap[K, V]) -> (K, V)? {
  if self.root < 0 {
    return None
  }
  let mut node = self.root
  while self.left[node] >= 0 {
    node = self.left[node]
  }
  Some((self.key_at(node), self.value_at(node)))
}

///|
pub fn[K, V] Treap::last(self : Treap[K, V]) -> (K, V)? {
  if self.root < 0 {
    return None
  }
  let mut node = self.root
  while self.right[node] >= 0 {
    node = self.right[node]
  }
  Some((self.key_at(node), self.value_at(node)))
}

///|
pub fn[K, V] Treap::length(self : Treap[K, V]) -> Int32 {
  self.len
}

///|
pub fn[K, V] Treap::is_empty(self : Treap[K, V]) -> Bool {
  self.len == 0
}

///|
pub fn[K, V] Treap::clear(self : Treap[K, V]) -> Unit {
  self.keys.clear()
  self.values.clear()
  self.left.clear()
  self.right.clear()
  self.priorities.clear()
  self.root = -1
  self.len = 0
}
