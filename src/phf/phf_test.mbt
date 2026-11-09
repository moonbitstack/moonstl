// Perfect hash tables hold no order and no collisions, so the tests are the two
// questions a table has to answer exactly: every key it was given, and no key it
// was not.

///|
fn build_string_table(
  size : Int32,
) -> @phf.PhfMap[String, Int32] raise @spec.Refused {
  let builder : @phf.PhfBuilder[String, Int32] = @phf.PhfBuilder::new()
  for i in 0..<size {
    builder.entry("key-\{i}", i)
  }
  builder.build()
}

///|
test "phf map: every key of every size is found" {
  for size in [0, 1, 2, 3, 8, 64, 500] {
    let table = build_string_table(size)
    @test.assert_eq(table.length(), size)
    for i in 0..<size {
      @test.assert_eq(table.get("key-\{i}"), Some(i))
      @test.assert_eq(table.contains("key-\{i}"), true)
    }
    for i in size..<(size + 50) {
      @test.assert_eq(table.get("absent-\{i}"), None)
    }
  }
}

///|
test "phf map: the three build strategies agree on their answers" {
  for build in [@phf.Search, @phf.Quick, @phf.Minimal] {
    let builder : @phf.PhfBuilder[String, Int32] = @phf.PhfBuilder::new(phf_options={
      build,
      seed: 0,
    })
    for i in 0..<200 {
      builder.entry("k\{i}", i)
    }
    let table = builder.build()
    for i in 0..<200 {
      @test.assert_eq(table.get("k\{i}"), Some(i))
    }
    @test.assert_eq(table.get("nope"), None)
  }
}

///|
test "phf map: integer keys are encoded without the backend's width" {
  let builder : @phf.PhfBuilder[Int32, String] = @phf.PhfBuilder::new()
  builder.entry(-1, "minus one")
  builder.entry(0, "zero")
  builder.entry(1024, "kilobyte")
  let table = builder.build()
  @test.assert_eq(table.get(0), Some("zero"))
  @test.assert_eq(table.get(-1), Some("minus one"))
  @test.assert_eq(table.get(1024), Some("kilobyte"))
  @test.assert_eq(table.get(7), None)
}

///|
test "phf map: a duplicate key is refused" {
  let builder : @phf.PhfBuilder[String, Int32] = @phf.PhfBuilder::new()
  builder.entry("a", 1)
  let refused = try {
    builder.entry("a", 2)
    Ok(())
  } catch {
    @spec.Refused::DuplicateValue => Err(true)
    _ => Err(false)
  }
  @test.assert_eq(refused, Err(true))
  @test.assert_eq(builder.length(), 1)
}

///|
test "phf map: a layout that does not describe the keys is refused" {
  let table = build_string_table(8)
  let layout = table.layout()
  // The same layout with a different key set must not be trusted.
  let entries : Array[(String, Int32)] = []
  for i in 0..<8 {
    entries.push(("other-\{i}", i))
  }
  let refused = try {
    let wrong : @phf.PhfMap[String, Int32] = @phf.PhfMap::from_layout(
      layout, entries,
    )
    let _ = wrong
    Ok(())
  } catch {
    @spec.Refused::Incompatible => Err(true)
    _ => Err(false)
  }
  @test.assert_eq(refused, Err(true))
}

///|
test "phf map: the layout round-trips through the generated source" {
  let builder : @phf.PhfBuilder[String, Int32] = @phf.PhfBuilder::new()
  for i in 0..<16 {
    builder.entry("g\{i}", i * i)
  }
  let first = builder.build_source(name="squares")
  let second = builder.build_source(name="squares")
  @test.assert_eq(first, second)
  @test.assert_eq(first.length() > 0, true)
}

///|
test "phf set and ordered variants" {
  let builder : @phf.PhfBuilder[String, Unit] = @phf.PhfBuilder::new()
  for word in ["alpha", "beta", "gamma"] {
    builder.entry(word, ())
  }
  let set = builder.build_set()
  @test.assert_eq(set.contains("beta"), true)
  @test.assert_eq(set.contains("delta"), false)
  @test.assert_eq(set.length(), 3)

  let ordered : @phf.PhfBuilder[String, Int32] = @phf.PhfBuilder::new()
  ordered.entry("c", 3)
  ordered.entry("a", 1)
  ordered.entry("b", 2)
  let map = ordered.build_ordered()
  @test.assert_eq(map.index("c"), Some(0))
  @test.assert_eq(map.index("a"), Some(1))
  @test.assert_eq(map.index("b"), Some(2))
  @test.assert_eq(map.get("b"), Some(2))
  @test.assert_eq(map.get_index(0), Some(("c", 3)))
}

///|
test "each table rebuilds from a layout and the entries it was built from" {
  let entries = [("loop", 1), ("while", 2), ("for", 3), ("match", 4)]
  let keys = entries.map(entry => entry.0)
  let builder : @phf.PhfBuilder[String, Int32] = @phf.PhfBuilder::new()
  for entry in entries {
    builder.entry(entry.0, entry.1)
  }
  let layout = builder.build().layout()
  let map = @phf.PhfOrderedMap::from_layout(layout, entries)
  let set = @phf.PhfSet::from_layout(layout, keys)
  let ordered = @phf.PhfOrderedSet::from_layout(layout, keys)
  for i, entry in entries {
    @test.assert_eq(map.index(entry.0), Some(i))
    @test.assert_eq(map.get(entry.0), Some(entry.1))
    @test.assert_eq(set.contains(entry.0), true)
    @test.assert_eq(ordered.index(entry.0), Some(i))
  }
  @test.assert_eq(map.index("if"), None)
  @test.assert_eq(set.contains("if"), false)
  @test.assert_eq(ordered.index("if"), None)
}

///|
test "a layout that cannot hold the entries is refused" {
  let builder : @phf.PhfBuilder[String, Unit] = @phf.PhfBuilder::new()
  builder.entry("x", ())
  builder.entry("y", ())
  let layout = builder.build().layout()
  fn refused(keys : Array[String]) -> Bool {
    try {
      ignore(@phf.PhfSet::from_layout(layout, keys))
      false
    } catch {
      _ => true
    }
  }
  @test.assert_eq(refused(["x", "y"]), false)
  @test.assert_eq(refused(["x", "y", "z"]), true)
  @test.assert_eq(refused(["x", "x"]), true)
}
