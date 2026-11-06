// Model tests: every structure in this package is driven against a plain array
// that is recomputed from scratch, so a wrong tree shows up as a mismatch rather
// than as a plausible-looking answer.

///|
priv struct TreeRng {
  mut state : UInt64
}

///|
fn TreeRng::below(self : TreeRng, bound : Int32) -> Int32 {
  self.state = self.state * 6364136223846793005 + 1442695040888963407
  let value = (self.state >> 33).to_uint().reinterpret_as_int()
  (value % bound).abs()
}

///|
test "disjoint set: components grow and merge" {
  let sets : @tree.DisjointSet = @tree.DisjointSet::new()
  for _ in 0..<10 {
    let _ = sets.add()
  }
  @test.assert_eq(sets.set_count(), 10)
  @test.assert_eq(sets.union(1, 2), true)
  @test.assert_eq(sets.union(2, 1), false)
  @test.assert_eq(sets.component_size(1), 2)
  @test.assert_eq(sets.connected(1, 2), true)
  @test.assert_eq(sets.connected(1, 3), false)
  let groups = sets.to_sets()
  @test.assert_eq(groups.length(), 9)
}

///|
test "disjoint set map: keys are interned" {
  let sets : @tree.DisjointSetMap[String] = @tree.DisjointSetMap::new()
  @test.assert_eq(sets.union("a", "b"), true)
  @test.assert_eq(sets.union("b", "c"), true)
  @test.assert_eq(sets.component_size("a"), 3)
  @test.assert_eq(sets.find("c"), sets.find("a"))
  @test.assert_eq(sets.set_count(), 1)
  @test.assert_eq(sets.length(), 3)
}

///|
test "segment tree: sum, point write and first crossing" {
  let rng : TreeRng = { state: 0x2545f4914f6cdd1d, }
  let values : Array[Int32] = []
  for _ in 0..<64 {
    values.push(rng.below(10))
  }
  let tree : @tree.SegmentTree[Int32] = @tree.SegmentTree::from_array(
    values[:],
    op=(a : Int32, b : Int32) => a + b,
    identity=0,
  )
  for start in [0, 5, 17, 60] {
    for size in [1, 3, 4, 20] {
      let end = if start + size > values.length() {
        values.length()
      } else {
        start + size
      }
      let mut expected = 0
      for i in start..<end {
        expected = expected + values[i]
      }
      @test.assert_eq(tree.query(start, end), expected)
    }
  }
  let _ = tree.set(10, 100)
  values[10] = 100
  @test.assert_eq(tree.query(0, values.length()), sum_of(values))
  let mut running = 0
  let mut crossing = -1
  for i in 0..<values.length() {
    running = running + values[i]
    if running >= 200 && crossing < 0 {
      crossing = i
    }
  }
  @test.assert_eq(
    tree.first_where(x => x >= 200),
    if crossing < 0 {
      None
    } else {
      Some(crossing)
    },
  )
}

///|
fn sum_of(values : Array[Int32]) -> Int32 {
  let mut total = 0
  for value in values {
    total = total + value
  }
  total
}

///|
test "lazy segment tree: range add against a recomputation" {
  let rng : TreeRng = { state: 0x9e3779b97f4a7c15, }
  let values : Array[Int32] = []
  for _ in 0..<32 {
    values.push(rng.below(5))
  }
  let tree : @tree.LazySegmentTree[Int32, Int32] = @tree.LazySegmentTree::from_array(
    values[:],
    op=(a : Int32, b : Int32) => a + b,
    identity=0,
    apply=(tag : Int32, value : Int32, span : Int32) => value + tag * span,
    compose=(older : Int32, newer : Int32) => older + newer,
    none=0,
  )
  for _ in 0..<50 {
    let start = rng.below(32)
    let end = start + rng.below(32 - start + 1)
    let tag = rng.below(5)
    tree.range_update(start, end, tag)
    for i in start..<end {
      values[i] = values[i] + tag
    }
  }
  for start in [0, 3, 10] {
    @test.assert_eq(tree.query(start, 32), sum_of(values[start:].to_owned()))
  }
}

///|
test "fenwick tree: prefix sums against a recomputation" {
  let rng : TreeRng = { state: 0xbf58476d1ce4e5b9, }
  let fenwick : @tree.Fenwick[Int32] = @tree.Fenwick::new(length=40)
  let values : Array[Int32] = []
  for _ in 0..<40 {
    values.push(0)
  }
  for _ in 0..<200 {
    let at = rng.below(40)
    let delta = rng.below(7)
    fenwick.add(at, delta)
    values[at] = values[at] + delta
    let end = rng.below(41)
    @test.assert_eq(fenwick.prefix_sum(end), sum_of(values[:end].to_owned()))
  }
  @test.assert_eq(fenwick.range_sum(5, 20), sum_of(values[5:20].to_owned()))
}

///|
test "interval tree: point queries match a linear scan" {
  let rng : TreeRng = { state: 0x94d049bb133111eb, }
  let tree : @tree.IntervalTree[Int32, Int32] = @tree.IntervalTree::new()
  let model : Array[(Int32, Int32)] = []
  for i in 0..<40 {
    let start = rng.below(50)
    let end = start + 1 + rng.below(10)
    let _ = tree.insert(start~, end~, i)
    model.push((start, end))
  }
  @test.assert_eq(tree.length(), 40)
  for point in 0..<60 {
    let mut expected = 0
    for range in model {
      if range.0 <= point && point < range.1 {
        expected = expected + 1
      }
    }
    @test.assert_eq(tree.query_point(point).length(), expected)
  }
  let keys = tree.iter().to_array()
  @test.assert_eq(keys.length(), 40)
}

///|
test "interval tree: a removed interval stops answering" {
  let tree : @tree.IntervalTree[Int32, String] = @tree.IntervalTree::new()
  let first = tree.insert(start=0, end=10, "a")
  let second = tree.insert(start=2, end=4, "b")
  @test.assert_eq(tree.remove(first), Some((0, 10, "a")))
  @test.assert_eq(tree.get(first), None)
  @test.assert_eq(tree.get(second), Some((2, 4, "b")))
  @test.assert_eq(tree.query_point(3).length(), 1)
  @test.assert_eq(tree.query_overlap(start=0, end=3).length(), 1)
}

///|
test "order statistic tree: select and rank against a sorted model" {
  let rng : TreeRng = { state: 0xdeadbeefcafebabe, }
  let tree : @tree.OrderStatisticTree[Int32] = @tree.OrderStatisticTree::new()
  let model : Array[Int32] = []
  for _ in 0..<200 {
    let value = rng.below(300)
    if tree.insert(value) {
      model.push(value)
    }
  }
  model.sort()
  @test.assert_eq(tree.length(), model.length())
  @test.assert_eq(tree.to_array(), model)
  for i in 0..<model.length() {
    @test.assert_eq(tree.select(i), Some(model[i]))
    @test.assert_eq(tree.rank(model[i]), i)
  }
  @test.assert_eq(tree.select(model.length()), None)
  @test.assert_eq(tree.first(), model.get(0))
  @test.assert_eq(tree.last(), model.get(model.length() - 1))
}

///|
test "order statistic tree: removal keeps the counts honest" {
  let tree : @tree.OrderStatisticTree[Int32] = @tree.OrderStatisticTree::new()
  for value in [4, 2, 6, 1, 3, 5, 7] {
    let _ = tree.insert(value)
  }
  @test.assert_eq(tree.remove(4), true)
  @test.assert_eq(tree.remove(4), false)
  @test.assert_eq(tree.to_array(), [1, 2, 3, 5, 6, 7])
  @test.assert_eq(tree.select(3), Some(5))
  @test.assert_eq(tree.count_range(2, 6), 3)
}

///|
test "skip list: the whole surface against a sorted model" {
  let rng : TreeRng = { state: 0x2545f4914f6cdd1d, }
  let list : @tree.SkipList[Int32] = @tree.SkipList::new()
  let model : Array[Int32] = []
  for _ in 0..<300 {
    let value = rng.below(400)
    if list.insert(value) {
      model.push(value)
    }
  }
  model.sort()
  @test.assert_eq(list.to_array(), model)
  for i in 0..<model.length() {
    @test.assert_eq(list.select(i), Some(model[i]))
    @test.assert_eq(list.rank(model[i]), i)
  }
  for value in model {
    if rng.below(4) == 0 {
      @test.assert_eq(list.remove(value), true)
    }
  }
  @test.assert_eq(list.first(), list.select(0))
}

///|
test "treap: set, remove and range" {
  let rng : TreeRng = { state: 0x9e3779b97f4a7c15, }
  let tree : @tree.Treap[Int32, Int32] = @tree.Treap::new()
  let model : Map[Int32, Int32] = Map([])
  for _ in 0..<200 {
    let key = rng.below(100)
    let value = rng.below(1000)
    let old = tree.set(key, value)
    @test.assert_eq(old, model.get(key))
    model.set(key, value)
  }
  @test.assert_eq(tree.length(), model.length())
  for (key, value) in model.iter() {
    @test.assert_eq(tree.get(key), Some(value))
  }
  let ordered = tree.to_array()
  for i in 1..<ordered.length() {
    @test.assert_eq(ordered[i - 1].0 < ordered[i].0, true)
  }
  let (lower, upper) = tree.split(50)
  for (key, _) in lower.iter() {
    @test.assert_eq(key < 50, true)
  }
  for (key, _) in upper.iter() {
    @test.assert_eq(key >= 50, true)
  }
}

///|
test "arena tree: links and walks" {
  let tree : @tree.ArenaTree[Int32] = @tree.ArenaTree::new()
  let root = tree.add(0)
  let first = tree.add_child(root, 1)
  let second = tree.add_child(root, 2)
  let deep = tree.add_child(first, 3)
  @test.assert_eq(tree.children(root).length(), 2)
  @test.assert_eq(tree.parent(deep).unwrap(), first)
  @test.assert_eq(tree.next_sibling(first).unwrap(), second)
  @test.assert_eq(tree.previous_sibling(second).unwrap(), first)
  @test.assert_eq(tree.descendants(root).to_array().length(), 3)
  @test.assert_eq(tree.ancestors(deep).to_array().length(), 2)
  @test.assert_eq(tree.preorder(root).to_array().length(), 4)
  @test.assert_eq(tree.postorder(root).to_array().length(), 4)
  @test.assert_eq(tree.set(deep, 30), true)
  @test.assert_eq(tree.get(deep), Some(30))
  tree.sort_children(root, (a, b) => b.compare(a))
  @test.assert_eq(tree.get(tree.children(root)[0]).unwrap(), 2)
}

///|
test "arena tree: detach leaves two trees" {
  let tree : @tree.ArenaTree[Int32] = @tree.ArenaTree::new()
  let root = tree.add(0)
  let branch = tree.add_child(root, 1)
  let _ = tree.add_child(branch, 2)
  let _ = tree.add_child(root, 3)
  let subtree = tree.detach(branch).unwrap()
  @test.assert_eq(subtree.length(), 2)
  @test.assert_eq(tree.length(), 2)
  @test.assert_eq(tree.contains(branch), false)
  @test.assert_eq(subtree.length(), 2)
}
