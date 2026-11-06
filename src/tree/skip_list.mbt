///|
/// The shape of a skip list: how often a node is promoted to the next level, the
/// highest level it may reach, and the seed its coin flips come from. The
/// probability of 0.25 is what Redis uses, which keeps the level count low while
/// keeping the paths short.
#derive(Eq, Debug)
pub(all) struct SkipListOptions {
  probability : Double
  max_level : Int32
  seed : Int32
}

///|
pub extend SkipListOptions with Eq::{equal, not_equal}

///|
pub extend SkipListOptions with Debug::{to_repr}

///|
/// The preset: a quarter of the nodes climb to the next level, and thirty-two
/// levels cover 4^32 entries.
pub let skip_list_options : SkipListOptions = {
  probability: 0.25,
  max_level: 32,
  seed: @spec.hash_seed(),
}

///|
/// A probabilistic ordered set. A node takes part in one level with probability
/// `p` and in the next with `p` again, so a search skips most of the list at the
/// top and refines as it descends; every level also stores how many nodes it
/// spans, which is what makes `rank` and `select` a single descent. The shape is
/// drawn from the seed, so a run replays exactly.
///
/// ```mbt check
/// test {
///   let list : @tree.SkipList[Int32] = @tree.SkipList::new()
///   for value in [5, 1, 9, 3] {
///     let _ = list.insert(value)
///   }
///   assert_true(list.to_array() == [1, 3, 5, 9])
///   assert_true(list.rank(5) == 2)
///   assert_true(list.select(2) == Some(5))
/// }
/// ```
pub struct SkipList[T] {
  cmp : (T, T) -> Int32
  options : SkipListOptions
  /// Node 0 is the sentinel that heads every level; it holds no value.
  mut values : Array[T?]
  mut nexts : Array[Array[Int32]]
  mut spans : Array[Array[Int32]]
  mut len : Int32
  mut rng : UInt64
}

///|
pub fn[T : Compare] SkipList::new(
  skip_list_options~ : SkipListOptions = skip_list_options,
) -> SkipList[T] {
  SkipList::new_by(cmp=(a, b) => a.compare(b), skip_list_options~)
}

///|
pub fn[T] SkipList::new_by(
  cmp~ : (T, T) -> Int32,
  skip_list_options~ : SkipListOptions = skip_list_options,
) -> SkipList[T] {
  let levels = if skip_list_options.max_level < 1 {
    1
  } else {
    skip_list_options.max_level
  }
  let options : SkipListOptions = {
    probability: skip_list_options.probability,
    max_level: levels,
    seed: skip_list_options.seed,
  }
  let nexts : Array[Array[Int32]] = []
  let spans : Array[Array[Int32]] = []
  let head_next : Array[Int32] = []
  let head_span : Array[Int32] = []
  for _ in 0..<levels {
    head_next.push(-1)
    head_span.push(0)
  }
  nexts.push(head_next)
  spans.push(head_span)
  {
    cmp,
    options,
    values: [None],
    nexts,
    spans,
    len: 0,
    rng: options.seed.to_int64().reinterpret_as_uint64() | 1UL,
  }
}

///|
fn[T] SkipList::value_at(self : SkipList[T], node : Int32) -> T {
  match self.values[node] {
    Some(value) => value
    None => abort("moonstl: a skip-list node that holds nothing")
  }
}

///|
/// The number of levels this node takes part in, by coin flips.
fn[T] SkipList::draw_height(self : SkipList[T]) -> Int32 {
  let mut height = 1
  while height < self.options.max_level {
    self.rng = self.rng * 6364136223846793005UL + 1442695040888963407UL
    let sample = (self.rng >> 11).to_double() / 9007199254740992.0
    if sample < self.options.probability {
      height = height + 1
    } else {
      break
    }
  }
  height
}

///|
/// The last node before `key` at every level, and the rank of `key`.
fn[T] SkipList::locate(
  self : SkipList[T],
  key : T,
  previous : Array[Int32],
  ranks : Array[Int32],
) -> Int32 {
  let mut node = 0
  let mut rank = 0
  let mut level = self.nexts[0].length() - 1
  while level >= 0 {
    while self.nexts[node][level] >= 0 &&
          (self.cmp)(self.value_at(self.nexts[node][level]), key) < 0 {
      rank = rank + self.spans[node][level]
      node = self.nexts[node][level]
    }
    previous[level] = node
    ranks[level] = rank
    level = level - 1
  }
  rank
}

///|
/// Adds `value` and reports whether it was new.
pub fn[T] SkipList::insert(self : SkipList[T], value : T) -> Bool {
  let levels = self.nexts[0].length()
  let previous : Array[Int32] = []
  let ranks : Array[Int32] = []
  for _ in 0..<levels {
    previous.push(0)
    ranks.push(0)
  }
  let rank = self.locate(value, previous, ranks)
  let next_node = self.nexts[previous[0]][0]
  if next_node >= 0 && (self.cmp)(self.value_at(next_node), value) == 0 {
    return false
  }
  let height = self.draw_height()
  let node = self.values.length()
  self.values.push(Some(value))
  let node_next : Array[Int32] = []
  let node_span : Array[Int32] = []
  for _ in 0..<height {
    node_next.push(-1)
    node_span.push(0)
  }
  self.nexts.push(node_next)
  self.spans.push(node_span)
  for level in 0..<height {
    let holder = previous[level]
    node_next[level] = self.nexts[holder][level]
    // A level the sentinel has just grown has nothing after it, so the new node
    // ends that level and spans nothing; otherwise it takes over the part of the
    // holder's span that lies beyond it.
    node_span[level] = if self.nexts[holder][level] < 0 {
      0
    } else {
      self.spans[holder][level] - (rank - ranks[level])
    }
    self.nexts[holder][level] = node
    self.spans[holder][level] = rank - ranks[level] + 1
  }
  // The levels the new node does not reach still span it, so their steps grow
  // by one; leaving them alone is what makes a rank off by the depth of the
  // insertion.
  let mut level = height
  while level < levels {
    self.spans[previous[level]][level] = self.spans[previous[level]][level] + 1
    level = level + 1
  }
  self.len = self.len + 1
  true
}

///|
pub fn[T] SkipList::contains(self : SkipList[T], value : T) -> Bool {
  let levels = self.nexts[0].length()
  let previous : Array[Int32] = []
  let ranks : Array[Int32] = []
  for _ in 0..<levels {
    previous.push(0)
    ranks.push(0)
  }
  let _ = self.locate(value, previous, ranks)
  let next_node = self.nexts[previous[0]][0]
  next_node >= 0 && (self.cmp)(self.value_at(next_node), value) == 0
}

///|
pub fn[T] SkipList::remove(self : SkipList[T], value : T) -> Bool {
  let levels = self.nexts[0].length()
  let previous : Array[Int32] = []
  let ranks : Array[Int32] = []
  for _ in 0..<levels {
    previous.push(0)
    ranks.push(0)
  }
  let _ = self.locate(value, previous, ranks)
  let target = self.nexts[previous[0]][0]
  if target < 0 || (self.cmp)(self.value_at(target), value) != 0 {
    return false
  }
  let height = self.nexts[target].length()
  for level in 0..<height {
    let holder = previous[level]
    self.nexts[holder][level] = self.nexts[target][level]
    self.spans[holder][level] = self.spans[holder][level] +
      self.spans[target][level] -
      1
  }
  // The levels the removed node never reached still spanned it, so they lose
  // one step each, for the same reason the insert adds one.
  let levels_total = self.nexts[0].length()
  let mut level = height
  while level < levels_total {
    self.spans[previous[level]][level] = self.spans[previous[level]][level] - 1
    level = level + 1
  }
  self.values[target] = None
  self.len = self.len - 1
  true
}

///|
/// The number of elements smaller than `value`.
pub fn[T] SkipList::rank(self : SkipList[T], value : T) -> Int32 {
  let levels = self.nexts[0].length()
  let previous : Array[Int32] = []
  let ranks : Array[Int32] = []
  for _ in 0..<levels {
    previous.push(0)
    ranks.push(0)
  }
  self.locate(value, previous, ranks)
}

///|
/// The element at position `index`, counting from zero.
pub fn[T] SkipList::select(self : SkipList[T], index : Int32) -> T? {
  if index < 0 || index >= self.len {
    return None
  }
  let mut node = 0
  let mut remaining = index + 1
  let mut level = self.nexts[0].length() - 1
  while level >= 0 {
    while self.nexts[node][level] >= 0 && self.spans[node][level] <= remaining {
      remaining = remaining - self.spans[node][level]
      node = self.nexts[node][level]
    }
    level = level - 1
  }
  if remaining == 0 {
    self.values[node]
  } else {
    None
  }
}

///|
pub fn[T] SkipList::first(self : SkipList[T]) -> T? {
  self.values[self.nexts[0][0]]
}

///|
pub fn[T] SkipList::last(self : SkipList[T]) -> T? {
  if self.len == 0 {
    return None
  }
  let mut node = 0
  let mut level = self.nexts[0].length() - 1
  while level >= 0 {
    while self.nexts[node][level] >= 0 {
      node = self.nexts[node][level]
    }
    level = level - 1
  }
  self.values[node]
}

///|
/// The elements between `start` and `end`, both included by the list's own
/// comparator.
pub fn[T] SkipList::range(self : SkipList[T], start : T, end : T) -> Iter[T] {
  let out : Array[T] = []
  for value in self.iter() {
    if (self.cmp)(value, start) >= 0 && (self.cmp)(value, end) <= 0 {
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
pub fn[T] SkipList::iter(self : SkipList[T]) -> Iter[T] {
  let mut node = self.nexts[0][0]
  Iter::new(() => {
    let current = node
    if current < 0 {
      None
    } else {
      node = self.nexts[current][0]
      self.values[current]
    }
  })
}

///|
pub fn[T] SkipList::to_array(self : SkipList[T]) -> Array[T] {
  let out : Array[T] = []
  for value in self.iter() {
    out.push(value)
  }
  out
}

///|
pub fn[T] SkipList::length(self : SkipList[T]) -> Int32 {
  self.len
}

///|
pub fn[T] SkipList::is_empty(self : SkipList[T]) -> Bool {
  self.len == 0
}

///|
pub fn[T] SkipList::clear(self : SkipList[T]) -> Unit {
  let levels = self.nexts[0].length()
  for level in 0..<levels {
    self.nexts[0][level] = -1
    self.spans[0][level] = 0
  }
  self.values = [None]
  self.nexts = [self.nexts[0]]
  self.spans = [self.spans[0]]
  self.len = 0
}
