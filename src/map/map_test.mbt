///|
test "multi map: values keep insertion order" {
  let map : @map.MultiMap[String, Int32] = @map.MultiMap::new()
  map.insert("b", 2)
  map.insert("a", 1)
  map.insert("b", 3)
  @test.assert_eq(map.get("b"), [2, 3])
  @test.assert_eq(map.get("missing"), [])
  @test.assert_eq(map.contains_entry("b", 3), true)
  @test.assert_eq(map.contains_entry("b", 4), false)
  @test.assert_eq(map.length(), 3)
  @test.assert_eq(map.key_count(), 2)
  @test.assert_eq(map.iter().to_array(), [("b", 2), ("b", 3), ("a", 1)])
}

///|
test "multi map: removing one value keeps the rest" {
  let map : @map.MultiMap[String, Int32] = @map.MultiMap::new()
  map.insert("a", 1)
  map.insert("a", 2)
  @test.assert_eq(map.remove_entry("a", 1), true)
  @test.assert_eq(map.get("a"), [2])
  @test.assert_eq(map.length(), 1)
  @test.assert_eq(map.remove_entry("a", 9), false)
  @test.assert_eq(map.remove("a"), [2])
  @test.assert_eq(map.is_empty(), true)
}

///|
test "multi map: copy does not share values" {
  let map : @map.MultiMap[Int32, Int32] = @map.MultiMap::new()
  map.insert(1, 1)
  let copy = map.copy()
  map.insert(1, 2)
  @test.assert_eq(copy.get(1), [1])
  @test.assert_eq(map.get(1), [1, 2])
}

///|
test "sorted multi map: sorted by key then value" {
  let map : @map.SortedMultiMap[Int32, String] = @map.SortedMultiMap::new()
  map.insert(2, "b")
  map.insert(1, "b")
  map.insert(1, "a")
  @test.assert_eq(map.to_array(), [(1, "a"), (1, "b"), (2, "b")])
  @test.assert_eq(map.range(start=1, end=1).to_array(), [(1, "a"), (1, "b")])
  @test.assert_eq(map.key_count(), 2)
  @test.assert_eq(map.pop_first(), Some((1, "a")))
  @test.assert_eq(map.pop_last(), Some((2, "b")))
  @test.assert_eq(map.length(), 1)
  @test.assert_eq(map.remove(1), ["b"])
  @test.assert_eq(map.is_empty(), true)
}

///|
test "bi map: both directions stay consistent" {
  let bimap : @map.BiMap[Int32, String] = @map.BiMap::new()
  let _ = bimap.set(1, "a")
  let _ = bimap.set(2, "b")
  @test.assert_eq(bimap.get(1), Some("a"))
  @test.assert_eq(bimap.get_key("b"), Some(2))
  @test.assert_eq(bimap.remove_key(1), Some((1, "a")))
  @test.assert_eq(bimap.get_key("a"), None)
  @test.assert_eq(bimap.remove_value("b"), Some((2, "b")))
  @test.assert_eq(bimap.is_empty(), true)
}

///|
test "bi map: a taken value is refused by set new" {
  let bimap : @map.BiMap[Int32, String] = @map.BiMap::new()
  let _ = bimap.set(1, "a")
  let refused = Ok(bimap.set_new(2, "a")) catch {
    @spec.Refused::DuplicateValue => Err(true)
    _ => Err(false)
  }
  @test.assert_eq(refused, Err(true))
  @test.assert_eq(bimap.length(), 1)
}

///|
test "counter: counts, total and the zero rule" {
  let counter : @map.Counter[String] = @map.Counter::new()
  @test.assert_eq(counter.incr("a"), 1)
  @test.assert_eq(counter.incr_by("a", 2), 3)
  @test.assert_eq(counter.incr("b"), 1)
  @test.assert_eq(counter.total(), 4L)
  @test.assert_eq(counter.decr_by("a", 3), 0)
  @test.assert_eq(counter.get("a"), 0)
  @test.assert_eq(counter.length(), 1)
}

///|
test "counter: most common puts the largest first" {
  let counter : @map.Counter[String] = @map.Counter::new()
  let _ = counter.incr_by("b", 2)
  let _ = counter.incr_by("a", 5)
  let _ = counter.incr_by("c", 2)
  @test.assert_eq(counter.most_common(n=2), [("a", 5), ("b", 2)])
  @test.assert_eq(counter.most_common(n=-1).length(), 3)
}

///|
test "counter: elements repeats each key" {
  let counter : @map.Counter[String] = @map.Counter::new()
  let _ = counter.incr_by("a", 2)
  let _ = counter.incr("b")
  @test.assert_eq(counter.elements().to_array(), ["a", "a", "b"])
}

///|
test "counter: add and subtract" {
  let a : @map.Counter[String] = @map.Counter::new()
  let b : @map.Counter[String] = @map.Counter::new()
  let _ = a.incr_by("x", 3)
  let _ = b.incr_by("x", 1)
  let _ = b.incr_by("y", 2)
  let sum = a.add(b)
  @test.assert_eq(sum.get("x"), 4)
  @test.assert_eq(sum.get("y"), 2)
  a.subtract_in_place(b)
  @test.assert_eq(a.get("x"), 2)
  @test.assert_eq(a.get("y"), 0)
}

///|
test "default map: the factory runs once per key" {
  let mut calls = 0
  let map : @map.DefaultMap[String, Int32] = @map.DefaultMap::new(factory=key => {
    calls = calls + 1
    key.length()
  })
  @test.assert_eq(map.get_or_init("abcd"), 4)
  @test.assert_eq(map.get_or_init("abcd"), 4)
  @test.assert_eq(calls, 1)
  @test.assert_eq(map.contains("abcd"), true)
  @test.assert_eq(map.remove("abcd"), Some(4))
  @test.assert_eq(map.is_empty(), true)
}

///|
test "chain map: the child shadows without touching the parent" {
  let base : Map[String, Int32] = Map([])
  base.set("a", 1)
  base.set("b", 2)
  let chain : @map.ChainMap[String, Int32] = @map.ChainMap::new([base])
  let child = chain.new_child()
  child.set("a", 10)
  @test.assert_eq(child.get("a"), Some(10))
  @test.assert_eq(child.get("b"), Some(2))
  @test.assert_eq(chain.get("a"), Some(1))
  @test.assert_eq(child.length(), 2)
  @test.assert_eq(child.iter().to_array(), [("a", 10), ("b", 2)])
  let flattened = child.flatten()
  @test.assert_eq(flattened.get("a"), Some(10))
  @test.assert_eq(child.parent().unwrap().get("a"), Some(1))
}

///|
test "flat map: sorted insertion, index and range" {
  let map : @map.FlatMap[Int32, String] = @map.FlatMap::new()
  let _ = map.set(3, "c")
  let _ = map.set(1, "a")
  let _ = map.set(2, "b")
  @test.assert_eq(map.keys().to_array(), [1, 2, 3])
  @test.assert_eq(map.index_of(2), Ok(1))
  @test.assert_eq(map.index_of(9), Err(3))
  @test.assert_eq(map.get_index(2), Some((3, "c")))
  @test.assert_eq(map.range(start=1, end=2).to_array(), [(1, "a"), (2, "b")])
  @test.assert_eq(map.remove(2), Some("b"))
  @test.assert_eq(map.length(), 2)
  @test.assert_eq(map.first(), Some((1, "a")))
  @test.assert_eq(map.pop_last(), Some((3, "c")))
}

///|
test "flat map: from array keeps the last duplicate" {
  let map : @map.FlatMap[Int32, String] = @map.FlatMap::from_array([
    (2, "first"),
    (1, "one"),
    (2, "second"),
  ])
  @test.assert_eq(map.iter().to_array(), [(1, "one"), (2, "second")])
}

///|
test "flat set: insert reports what happened" {
  let set : @map.FlatSet[Int32] = @map.FlatSet::new()
  @test.assert_eq(set.insert(5), true)
  @test.assert_eq(set.insert(5), false)
  @test.assert_eq(set.insert(1), true)
  @test.assert_eq(set.to_array(), [1, 5])
  @test.assert_eq(set.range(start=0, end=4).to_array(), [1])
  @test.assert_eq(set.remove(5), true)
  @test.assert_eq(set.pop_first(), Some(1))
  @test.assert_eq(set.is_empty(), true)
}

///|
test "flat multi map: repeats are kept in order" {
  let map : @map.FlatMultiMap[Int32, String] = @map.FlatMultiMap::new()
  map.insert(1, "b")
  map.insert(1, "a")
  map.insert(2, "c")
  @test.assert_eq(map.to_array(), [(1, "a"), (1, "b"), (2, "c")])
  @test.assert_eq(map.count(1), 2)
  @test.assert_eq(map.key_count(), 2)
  @test.assert_eq(map.remove_entry(1, "b"), true)
  @test.assert_eq(map.get(1), ["a"])
  @test.assert_eq(map.remove(2), ["c"])
}

///|
test "range map: overwrite splits the range it lands on" {
  let map : @map.RangeMap[Int32, String] = @map.RangeMap::new()
  map.insert(start=0, end=10, "low")
  map.insert(start=4, end=6, "mid")
  @test.assert_eq(map.ranges().to_array(), [
    (0, 4, "low"),
    (4, 6, "mid"),
    (6, 10, "low"),
  ])
  @test.assert_eq(map.get(4), Some("mid"))
  @test.assert_eq(map.get(6), Some("low"))
  @test.assert_eq(map.get_range(10), None)
}

///|
test "range map: adjacent ranges with equal values fold" {
  let map : @map.RangeMap[Int32, String] = @map.RangeMap::new()
  map.insert(start=0, end=5, "a")
  map.insert(start=5, end=9, "a")
  @test.assert_eq(map.length(), 1)
  @test.assert_eq(map.ranges().to_array(), [(0, 9, "a")])
}

///|
test "range map: refuse and keep first" {
  let refusing : @map.RangeMap[Int32, String] = @map.RangeMap::new(
    overlap=Refuse,
  )
  refusing.insert(start=0, end=10, "a")
  let refused = Ok(refusing.insert(start=5, end=6, "b")) catch {
    @spec.Refused::Overlap => Err(true)
    _ => Err(false)
  }
  @test.assert_eq(refused, Err(true))
  @test.assert_eq(refusing.length(), 1)
  let keeping : @map.RangeMap[Int32, String] = @map.RangeMap::new(
    overlap=KeepFirst,
  )
  keeping.insert(start=0, end=10, "a")
  keeping.insert(start=5, end=6, "b")
  @test.assert_eq(keeping.get(5), Some("a"))
}

///|
test "range map: removal splits and gaps appear" {
  let map : @map.RangeMap[Int32, String] = @map.RangeMap::new()
  map.insert(start=0, end=10, "a")
  map.remove(start=4, end=6)
  @test.assert_eq(map.ranges().to_array(), [(0, 4, "a"), (6, 10, "a")])
  @test.assert_eq(map.gaps().to_array(), [(4, 6)])
}

///|
test "range set: overlapping spans merge" {
  let set : @map.RangeSet[Int32] = @map.RangeSet::new()
  set.insert(start=0, end=5)
  set.insert(start=5, end=9)
  @test.assert_eq(set.ranges().to_array(), [(0, 9)])
  @test.assert_eq(set.contains(8), true)
  @test.assert_eq(set.contains(9), false)
  @test.assert_eq(set.overlapping(start=4, end=6).length(), 1)
  set.remove(start=4, end=6)
  @test.assert_eq(set.ranges().to_array(), [(0, 4), (6, 9)])
}

///|
test "trie: prefix queries" {
  let trie : @map.Trie[Int32] = @map.Trie::new()
  let _ = trie.insert("car", 1)
  let _ = trie.insert("cart", 2)
  let _ = trie.insert("dog", 3)
  @test.assert_eq(trie.length(), 3)
  @test.assert_eq(trie.contains_prefix("ca"), true)
  @test.assert_eq(trie.contains_prefix("cat"), false)
  @test.assert_eq(trie.contains_prefix("cow"), false)
  @test.assert_eq(trie.keys_with_prefix("car"), ["car", "cart"])
  @test.assert_eq(trie.longest_prefix("cartoon"), Some(("cart", 2)))
  @test.assert_eq(trie.to_array(), [("car", 1), ("cart", 2), ("dog", 3)])
  @test.assert_eq(trie.remove("car"), Some(1))
  @test.assert_eq(trie.get("car"), None)
  @test.assert_eq(trie.get("cart"), Some(2))
  @test.assert_eq(trie.length(), 2)
}

///|
test "trie: copy is independent" {
  let trie : @map.Trie[Int32] = @map.Trie::new()
  let _ = trie.insert("a", 1)
  let copy = trie.copy()
  let _ = copy.insert("b", 2)
  @test.assert_eq(trie.length(), 1)
  @test.assert_eq(copy.length(), 2)
}

///|
test "radix tree: labels split and join" {
  let tree : @map.RadixTree[Int32] = @map.RadixTree::new()
  let _ = tree.insert("car", 1)
  let _ = tree.insert("cat", 2)
  let _ = tree.insert("cart", 3)
  @test.assert_eq(tree.get("car"), Some(1))
  @test.assert_eq(tree.get("ca"), None)
  @test.assert_eq(tree.to_array(), [("car", 1), ("cart", 3), ("cat", 2)])
  @test.assert_eq(tree.prefix_count("ca"), 3)
  @test.assert_eq(tree.prefix_count("cart"), 1)
  @test.assert_eq(tree.get_ancestor_keys("cart"), ["car", "cart"])
  @test.assert_eq(tree.get_ancestor_keys("carpet"), ["car"])
  @test.assert_eq(tree.longest_prefix("cartoon"), Some(("cart", 3)))
  @test.assert_eq(tree.iter_prefix("car").to_array(), [("car", 1), ("cart", 3)])
}

///|
test "radix tree: removing a value keeps the paths" {
  let tree : @map.RadixTree[Int32] = @map.RadixTree::new()
  let _ = tree.insert("a", 1)
  let _ = tree.insert("ab", 2)
  @test.assert_eq(tree.remove("a"), Some(1))
  @test.assert_eq(tree.length(), 1)
  @test.assert_eq(tree.get("ab"), Some(2))
  @test.assert_eq(tree.remove("abc"), None)
}

///|
test "index set: set algebra" {
  let a : @map.IndexSet[Int32] = @map.IndexSet::from_array([1, 2, 3, 4])
  let b : @map.IndexSet[Int32] = @map.IndexSet::from_array([3, 4, 5])
  @test.assert_eq(a.intersection(b).to_array(), [3, 4])
  @test.assert_eq(a.difference(b).to_array(), [1, 2])
  @test.assert_eq(a.union(b).to_array(), [1, 2, 3, 4, 5])
  @test.assert_eq(a.symmetric_difference(b).to_array(), [1, 2, 5])
  @test.assert_eq(a.is_subset(a.union(b)), true)
  @test.assert_eq(a.is_disjoint(b), false)
  @test.assert_eq(a.is_disjoint(@map.IndexSet::from_array([9])), true)
}
