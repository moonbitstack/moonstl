///|
/// A small linear congruential generator, so every randomised test in this
/// package replays the same sequence on every backend.
priv struct Lcg {
  mut state : UInt64
}

///|
fn Lcg::new(seed : UInt64) -> Lcg {
  { state: seed, }
}

///|
fn Lcg::next(self : Lcg) -> UInt32 {
  self.state = self.state * 6364136223846793005 + 1442695040888963407
  (self.state >> 33).to_uint()
}

///|
fn Lcg::below(self : Lcg, bound : Int32) -> Int32 {
  (self.next().reinterpret_as_int() % bound).abs()
}

///|
test "index map: set keeps the first position" {
  let map : @map.IndexMap[String, Int32] = @map.IndexMap::new()
  @test.assert_eq(map.set("a", 1), None)
  @test.assert_eq(map.set("b", 2), None)
  @test.assert_eq(map.set("a", 3), Some(1))
  @test.assert_eq(map.get_index_of("a"), Some(0))
  @test.assert_eq(map.get("a"), Some(3))
  @test.assert_eq(map.length(), 2)
  @test.assert_eq(map.to_array(), [("a", 3), ("b", 2)])
}

///|
test "index map: swap remove moves the last entry" {
  let map : @map.IndexMap[Int32, Int32] = @map.IndexMap::new()
  for i in 0..<5 {
    let _ = map.set(i, i * 10)
  }
  @test.assert_eq(map.swap_remove(1), Some(10))
  @test.assert_eq(map.to_array(), [(0, 0), (4, 40), (2, 20), (3, 30)])
  @test.assert_eq(map.get_index_of(4), Some(1))
  @test.assert_eq(map.get(4), Some(40))
  @test.assert_eq(map.get(1), None)
}

///|
test "index map: shift remove closes the gap" {
  let map : @map.IndexMap[Int32, Int32] = @map.IndexMap::new()
  for i in 0..<5 {
    let _ = map.set(i, i)
  }
  @test.assert_eq(map.shift_remove(2), Some(2))
  @test.assert_eq(map.to_array(), [(0, 0), (1, 1), (3, 3), (4, 4)])
  @test.assert_eq(map.get_index_of(3), Some(2))
}

///|
test "index map: move, swap and sort renumber positions" {
  let map : @map.IndexMap[Int32, Int32] = @map.IndexMap::new()
  for i in 0..<4 {
    let _ = map.set(i, i)
  }
  map.move_index(0, 3)
  @test.assert_eq(map.to_array(), [(1, 1), (2, 2), (3, 3), (0, 0)])
  map.swap_indices(0, 1)
  @test.assert_eq(map.to_array(), [(2, 2), (1, 1), (3, 3), (0, 0)])
  map.sort_keys()
  @test.assert_eq(map.to_array(), [(0, 0), (1, 1), (2, 2), (3, 3)])
  @test.assert_eq(map.get_index_of(2), Some(2))
}

///|
test "index map: full, index and range" {
  let map : @map.IndexMap[String, Int32] = @map.IndexMap::new()
  let _ = map.set("x", 1)
  let _ = map.set("y", 2)
  let _ = map.set("z", 3)
  @test.assert_eq(map.get_full("y"), Some((1, "y", 2)))
  @test.assert_eq(map.range(start=1, len=5).to_array(), [("y", 2), ("z", 3)])
  @test.assert_eq(map.get_index(9), None)
  @test.assert_eq(map.insert_full("w", 4), (3, None))
  @test.assert_eq(map.insert_full("x", 9), (0, Some(1)))
}

///|
test "index map: retain, truncate, split off" {
  let map : @map.IndexMap[Int32, Int32] = @map.IndexMap::new()
  for i in 0..<10 {
    let _ = map.set(i, i)
  }
  map.retain((key, _) => key % 2 == 0)
  @test.assert_eq(map.length(), 5)
  @test.assert_eq(map.get_index_of(8), Some(4))
  let tail = map.split_off(2)
  @test.assert_eq(map.to_array(), [(0, 0), (2, 2)])
  @test.assert_eq(tail.to_array(), [(4, 4), (6, 6), (8, 8)])
  map.truncate(1)
  @test.assert_eq(map.to_array(), [(0, 0)])
}

///|
test "index map: update and set default" {
  let map : @map.IndexMap[String, Int32] = @map.IndexMap::new()
  @test.assert_eq(map.update("a", v => v + 1), false)
  @test.assert_eq(map.set_default("a", 1), 1)
  @test.assert_eq(map.set_default("a", 5), 1)
  @test.assert_eq(map.update("a", v => v + 1), true)
  @test.assert_eq(map.get("a"), Some(2))
}

///|
test "index map: equality ignores history but not order" {
  let a : @map.IndexMap[Int32, Int32] = @map.IndexMap::new()
  let b : @map.IndexMap[Int32, Int32] = @map.IndexMap::new()
  let _ = a.set(1, 1)
  let _ = a.set(2, 2)
  let _ = b.set(2, 2)
  let _ = b.set(1, 1)
  @test.assert_eq(a == a.copy(), true)
  @test.assert_eq(a == b, false)
}

///|
test "index map: copy is independent" {
  let a : @map.IndexMap[Int32, Int32] = @map.IndexMap::new()
  let _ = a.set(1, 1)
  let b = a.copy()
  let _ = b.set(2, 2)
  @test.assert_eq(a.length(), 1)
  @test.assert_eq(b.length(), 2)
  @test.assert_eq(a.get(2), None)
}

///|
test "index map: json round trip" {
  let map : @map.IndexMap[String, Int32] = @map.IndexMap::new()
  let _ = map.set("a", 1)
  let _ = map.set("b", 2)
  let back : @map.IndexMap[String, Int32] = @json.from_json(map.to_json())
  @test.assert_eq(back.to_array(), [("a", 1), ("b", 2)])
}

///|
test "index map: many keys survive growth and deletion" {
  let map : @map.IndexMap[Int32, Int32] = @map.IndexMap::new()
  for i in 0..<600 {
    let _ = map.set(i, i)
  }
  @test.assert_eq(map.length(), 600)
  for i in 0..<600 {
    if i % 3 == 0 {
      @test.assert_eq(map.remove(i), Some(i))
    }
  }
  for i in 0..<600 {
    @test.assert_eq(map.contains(i), i % 3 != 0)
  }
  @test.assert_eq(map.length(), 400)
}

///|
test "index map: randomised model" {
  let rng = Lcg::new(0x9e3779b97f4a7c15)
  let map : @map.IndexMap[Int32, Int32] = @map.IndexMap::new()
  let model : Array[(Int32, Int32)] = []
  for step in 0..<4000 {
    let key = rng.below(64)
    match rng.below(3) {
      0 => {
        let value = rng.next().reinterpret_as_int()
        let old = map.set(key, value)
        let mut seen = -1
        for i in 0..<model.length() {
          if model[i].0 == key {
            seen = i
          }
        }
        if seen >= 0 {
          let previous = model[seen].1
          model[seen] = (key, value)
          @test.assert_eq(old, Some(previous))
        } else {
          model.push((key, value))
          @test.assert_eq(old, None)
        }
      }
      1 => {
        let old = map.remove(key)
        let mut seen = -1
        for i in 0..<model.length() {
          if model[i].0 == key {
            seen = i
          }
        }
        if seen >= 0 {
          @test.assert_eq(old, Some(model[seen].1))
          let last = model.length() - 1
          model[seen] = model[last]
          let _ = model.pop()
        } else {
          @test.assert_eq(old, None)
        }
      }
      _ => @test.assert_eq(map.get(key), model_find(model, key))
    }
    if step % 97 == 0 {
      @test.assert_eq(map.length(), model.length())
      for i in 0..<model.length() {
        @test.assert_eq(map.get_index(i), Some(model[i]))
      }
    }
  }
}

///|
fn model_find(model : Array[(Int32, Int32)], key : Int32) -> Int32? {
  for entry in model {
    if entry.0 == key {
      return Some(entry.1)
    }
  }
  None
}
