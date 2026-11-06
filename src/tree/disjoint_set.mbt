///|
/// Union-find over `0 ..< n`: every set is a tree whose root carries its size,
/// and `find` halves the path on the way up so repeated queries flatten the
/// structure without a second pass. Union by size keeps the trees shallow, which
/// together with path halving makes the amortised cost of an operation inverse
/// Ackermann — effectively constant.
///
/// ```mbt check
/// test {
///   let sets : @tree.DisjointSet = @tree.DisjointSet::new()
///   let a = sets.add()
///   let b = sets.add()
///   let c = sets.add()
///   assert_true(sets.union(a, b))
///   assert_true(sets.connected(a, b))
///   assert_true(!sets.connected(a, c))
///   assert_true(sets.set_count() == 2)
/// }
/// ```
pub struct DisjointSet {
  parents : Array[Int32]
  sizes : Array[Int32]
  mut sets : Int32
}

///|
pub fn DisjointSet::new() -> DisjointSet {
  { parents: [], sizes: [], sets: 0, }
}

///|
/// Adds a singleton set and returns its index.
pub fn DisjointSet::add(self : DisjointSet) -> Int32 {
  let index = self.parents.length()
  self.parents.push(index)
  self.sizes.push(1)
  self.sets = self.sets + 1
  index
}

///|
/// The representative of the set that holds `element`, with the path halved on
/// the way.
pub fn DisjointSet::find(self : DisjointSet, element : Int32) -> Int32 {
  if element < 0 || element >= self.parents.length() {
    return -1
  }
  let mut at = element
  while self.parents[at] != at {
    let grandparent = self.parents[self.parents[at]]
    self.parents[at] = grandparent
    at = grandparent
  }
  at
}

///|
/// Joins the sets of two elements and reports whether they were apart.
pub fn DisjointSet::union(self : DisjointSet, a : Int32, b : Int32) -> Bool {
  let root_a = self.find(a)
  let root_b = self.find(b)
  if root_a < 0 || root_b < 0 || root_a == root_b {
    return false
  }
  let (small, big) = if self.sizes[root_a] < self.sizes[root_b] {
    (root_a, root_b)
  } else {
    (root_b, root_a)
  }
  self.parents[small] = big
  self.sizes[big] = self.sizes[big] + self.sizes[small]
  self.sets = self.sets - 1
  true
}

///|
pub fn DisjointSet::connected(self : DisjointSet, a : Int32, b : Int32) -> Bool {
  let root_a = self.find(a)
  root_a >= 0 && root_a == self.find(b)
}

///|
/// The size of the set that holds `element`.
pub fn DisjointSet::component_size(
  self : DisjointSet,
  element : Int32,
) -> Int32 {
  let root = self.find(element)
  if root < 0 {
    0
  } else {
    self.sizes[root]
  }
}

///|
/// The size of the set whose representative is `root`, which is what a caller
/// that already holds a root avoids a second `find` with.
pub fn DisjointSet::set_size(self : DisjointSet, root : Int32) -> Int32 {
  if root < 0 || root >= self.sizes.length() {
    0
  } else {
    self.sizes[root]
  }
}

///|
pub fn DisjointSet::set_count(self : DisjointSet) -> Int32 {
  self.sets
}

///|
/// The number of elements, not of sets.
pub fn DisjointSet::length(self : DisjointSet) -> Int32 {
  self.parents.length()
}

///|
/// Every set as the array of its members, representatives first.
pub fn DisjointSet::to_sets(self : DisjointSet) -> Array[Array[Int32]] {
  let by_root : Map[Int32, Int32] = Map([])
  let sets : Array[Array[Int32]] = []
  for element in 0..<self.parents.length() {
    let root = self.find(element)
    match by_root.get(root) {
      Some(at) => sets[at].push(element)
      None => {
        by_root.set(root, sets.length())
        sets.push([element])
      }
    }
  }
  sets
}

///|
/// Union-find over keys of any type: the key is interned to an index on first
/// use, and the union-find runs on the indices.
///
/// ```mbt check
/// test {
///   let sets : @tree.DisjointSetMap[String] = @tree.DisjointSetMap::new()
///   assert_true(sets.union("a", "b"))
///   assert_true(sets.connected("a", "b"))
///   assert_true(!sets.connected("a", "c"))
/// }
/// ```
pub struct DisjointSetMap[K] {
  indices : Map[K, Int32]
  sets : DisjointSet
  keys : Array[K]
}

///|
pub fn[K : Hash + Eq] DisjointSetMap::new() -> DisjointSetMap[K] {
  { indices: Map([]), sets: DisjointSet::new(), keys: [], }
}

///|
/// The index of a key, adding it as a singleton the first time it is seen.
pub fn[K : Hash + Eq] DisjointSetMap::intern(
  self : DisjointSetMap[K],
  key : K,
) -> Int32 {
  match self.indices.get(key) {
    Some(index) => index
    None => {
      let index = self.sets.add()
      self.indices.set(key, index)
      self.keys.push(key)
      index
    }
  }
}

///|
pub fn[K : Hash + Eq] DisjointSetMap::union(
  self : DisjointSetMap[K],
  a : K,
  b : K,
) -> Bool {
  let left = self.intern(a)
  let right = self.intern(b)
  self.sets.union(left, right)
}

///|
pub fn[K : Hash + Eq] DisjointSetMap::connected(
  self : DisjointSetMap[K],
  a : K,
  b : K,
) -> Bool {
  let left = self.intern(a)
  let right = self.intern(b)
  self.sets.connected(left, right)
}

///|
pub fn[K : Hash + Eq] DisjointSetMap::find(
  self : DisjointSetMap[K],
  key : K,
) -> K? {
  match self.indices.get(key) {
    Some(index) => {
      let root = self.sets.find(index)
      self.keys.get(root)
    }
    None => None
  }
}

///|
/// The size of the set that holds `key`, zero when the key was never seen.
pub fn[K : Hash + Eq] DisjointSetMap::component_size(
  self : DisjointSetMap[K],
  key : K,
) -> Int32 {
  match self.indices.get(key) {
    Some(index) => self.sets.component_size(index)
    None => 0
  }
}

///|
pub fn[K] DisjointSetMap::set_count(self : DisjointSetMap[K]) -> Int32 {
  self.sets.set_count()
}

///|
pub fn[K] DisjointSetMap::length(self : DisjointSetMap[K]) -> Int32 {
  self.keys.length()
}

///|
/// Every set as the array of its members.
pub fn[K] DisjointSetMap::to_sets(self : DisjointSetMap[K]) -> Array[Array[K]] {
  let groups = self.sets.to_sets()
  let out : Array[Array[K]] = []
  for group in groups {
    let members : Array[K] = []
    for index in group {
      members.push(self.keys[index])
    }
    out.push(members)
  }
  out
}
