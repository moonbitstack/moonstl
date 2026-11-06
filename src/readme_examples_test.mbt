// The examples in README.md, kept here so that a change to an interface breaks
// the build instead of the documentation.

///|
test "readme: index map" {
  let map : @map.IndexMap[String, Int32] = @map.IndexMap::new()
  let _ = map.set("a", 1)
  let _ = map.set("b", 2)
  @test.assert_eq(map.get_index(1), Some(("b", 2)))
  @test.assert_eq(map.get_index_of("a"), Some(0))
}

///|
test "readme: order and position" {
  let map : @map.IndexMap[Int32, String] = @map.IndexMap::new()
  let _ = map.set(3, "three")
  let _ = map.set(1, "one")
  @test.assert_eq(map.keys().to_array(), [3, 1])
  map.sort_keys()
  @test.assert_eq(map.keys().to_array(), [1, 3])
  let _ = map.swap_remove(1)
  @test.assert_eq(map.to_array(), [(3, "three")])
}

///|
test "readme: lru cache" {
  let cache : @cache.LruCache[String, Int32] = @cache.LruCache::new(capacity=2)
  let _ = cache.set("a", 1)
  let _ = cache.set("b", 2)
  let _ = cache.get("a")
  @test.assert_eq(cache.set("c", 3), Some(("b", 2)))
  @test.assert_eq(cache.stats().hit_rate(), 1.0)
}

///|
test "readme: algorithms" {
  let run : Array[Int32] = [5, 1, 4, 2]
  @test.assert_eq(@algo.bisect_left(@algo.sorted(run[:]), 4), 2)
  @algo.nth_element_in_place(run, 1)
  @test.assert_eq(run[1], 2)
  @test.assert_eq(@algo.chunks(run.iter(), 2).to_array().length(), 2)
}

///|
test "readme: combinatorics" {
  let pairs : @algo.Permutations[Int32] = @algo.Permutations::new(
    [1, 2, 3],
    length=2,
  )
  @test.assert_eq(pairs.iter().to_array(), [
    [1, 2],
    [1, 3],
    [2, 1],
    [2, 3],
    [3, 1],
    [3, 2],
  ])
}

///|
test "readme: refusal" {
  let built : Result[Unit, Int32] = try {
    let cache : @cache.LruCache[String, Int32] = @cache.LruCache::new(
      capacity=0,
    )
    let _ = cache
    Ok(())
  } catch {
    @spec.Refused::Capacity(got~) => Err(got)
    _ => Err(-1)
  }
  @test.assert_eq(built, Err(0))
}
