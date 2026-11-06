// One file for the cases that do not belong to a single type's documentation:
// the edges of each container and a model test that drives them against a plain
// array.

///|
priv struct SeqRng {
  mut state : UInt64
}

///|
fn SeqRng::below(self : SeqRng, bound : Int32) -> Int32 {
  self.state = self.state * 6364136223846793005 + 1442695040888963407
  let value = (self.state >> 33).to_uint().reinterpret_as_int()
  (value % bound).abs()
}

///|
test "ring buffer: overwrite drops the oldest" {
  let buffer : @seq.RingBuffer[Int32] = @seq.RingBuffer::new(capacity=3)
  let _ = buffer.push_back(1)
  let _ = buffer.push_back(2)
  let _ = buffer.push_back(3)
  @test.assert_eq(buffer.is_full(), true)
  @test.assert_eq(buffer.push_back(4), Some(1))
  @test.assert_eq(buffer.to_array(), [2, 3, 4])
  @test.assert_eq(buffer.push_front(0), Some(4))
  @test.assert_eq(buffer.to_array(), [0, 2, 3])
}

///|
test "ring buffer: refuse keeps the buffer and hands the value back" {
  let buffer : @seq.RingBuffer[Int32] = @seq.RingBuffer::new(
    capacity=2,
    overflow=Refuse,
  )
  let _ = buffer.push_back(1)
  let _ = buffer.push_back(2)
  @test.assert_eq(buffer.push_back(3), Some(3))
  @test.assert_eq(buffer.to_array(), [1, 2])
  @test.assert_eq(buffer.push_front(0), Some(0))
  @test.assert_eq(buffer.to_array(), [1, 2])
}

///|
test "ring buffer: a capacity of zero is refused" {
  let refused : Result[Unit, Int32] = try {
    let buffer : @seq.RingBuffer[Int32] = @seq.RingBuffer::new(capacity=0)
    let _ = buffer
    Ok(())
  } catch {
    @spec.Refused::Capacity(got~) => Err(got)
    _ => Err(-1)
  }
  @test.assert_eq(refused, Err(0))
}

///|
test "ring buffer: views and linearize agree with the array" {
  let buffer : @seq.RingBuffer[Int32] = @seq.RingBuffer::new(capacity=5)
  for i in 0..<5 {
    let _ = buffer.push_back(i)
  }
  let _ = buffer.pop_front()
  let _ = buffer.pop_front()
  let _ = buffer.push_back(5)
  let _ = buffer.push_back(6)
  let (first, second) = buffer.as_views()
  @test.assert_eq(first.to_owned() + second.to_owned(), [2, 3, 4, 5, 6])
  buffer.linearize()
  let (whole, tail) = buffer.as_views()
  @test.assert_eq(whole.to_owned(), [2, 3, 4, 5, 6])
  @test.assert_eq(tail.length(), 0)
}

///|
test "slab: indices are reused" {
  let slab : @seq.Slab[String] = @seq.Slab::new()
  let first = slab.insert("a")
  let second = slab.insert("b")
  @test.assert_eq(first, 0)
  @test.assert_eq(second, 1)
  @test.assert_eq(slab.remove(first), Some("a"))
  let third = slab.insert("c")
  @test.assert_eq(third, 0)
  @test.assert_eq(slab.at(third), "c")
  @test.assert_eq(slab.length(), 2)
}

///|
test "slot map: a stale key reads as absent" {
  let map : @seq.SlotMap[String] = @seq.SlotMap::new()
  let first = map.insert("a")
  @test.assert_eq(map.remove(first), Some("a"))
  let second = map.insert("b")
  @test.assert_eq(map.get(first), None)
  @test.assert_eq(map.get(second), Some("b"))
  @test.assert_eq(map.contains(first), false)
  @test.assert_eq(map.length(), 1)
}

///|
test "slot map: iteration and retain" {
  let map : @seq.SlotMap[Int32] = @seq.SlotMap::new()
  for i in 0..<6 {
    let _ = map.insert(i)
  }
  map.retain((_, value) => value % 2 == 0)
  @test.assert_eq(map.iter().to_array(), [0, 2, 4])
  @test.assert_eq(map.length(), 3)
  let keys = map.keys().to_array()
  @test.assert_eq(keys.length(), 3)
  @test.assert_eq(map.at(keys[0]), 0)
}

///|
test "dense slot map: iteration follows insertion order" {
  let map : @seq.DenseSlotMap[Int32] = @seq.DenseSlotMap::new()
  let a = map.insert(1)
  let b = map.insert(2)
  let c = map.insert(3)
  @test.assert_eq(map.to_array(), [1, 2, 3])
  @test.assert_eq(map.remove(a), Some(1))
  @test.assert_eq(map.to_array(), [3, 2])
  @test.assert_eq(map.get(b), Some(2))
  @test.assert_eq(map.get(c), Some(3))
  @test.assert_eq(map.get(a), None)
}

///|
test "secondary map: a key outside the owner is refused" {
  let side : @seq.SecondaryMap[Int32] = @seq.SecondaryMap::new()
  side.resize(slots=2)
  let inside : @seq.SlotKey[Int32] = { index: 1, generation: 0U, }
  side.set(inside, 7)
  @test.assert_eq(side.get(inside), Some(7))
  let outside : @seq.SlotKey[Int32] = { index: 5, generation: 0U, }
  let refused = Ok(side.set(outside, 9)) catch {
    @spec.Refused::Capacity(got~) => Err(got)
    _ => Err(-1)
  }
  @test.assert_eq(refused, Err(5))
  @test.assert_eq(side.length(), 1)
}

///|
test "bit vec: bits and words agree" {
  let bits : @seq.BitVec = @seq.BitVec::new()
  for i in 0..<130 {
    bits.push(i % 3 == 0)
  }
  @test.assert_eq(bits.length(), 130)
  @test.assert_eq(bits.blocks().length(), 3)
  let mut counted = 0
  for value in bits.iter() {
    if value {
      counted = counted + 1
    }
  }
  @test.assert_eq(counted, bits.count_ones())
  bits.resize(100)
  @test.assert_eq(bits.length(), 100)
  @test.assert_eq(bits.blocks().length(), 2)
  @test.assert_eq(bits.count_ones(), 34)
}

///|
test "bit set: rank and select are inverse" {
  let set : @seq.BitSet = @seq.BitSet::new()
  for i in [1, 5, 64, 65, 200] {
    let _ = set.insert(i)
  }
  @test.assert_eq(set.length(), 5)
  @test.assert_eq(set.to_array(), [1, 5, 64, 65, 200])
  for i, value in set.to_array() {
    @test.assert_eq(set.rank(value), i)
    @test.assert_eq(set.rank(value + 1), i + 1)
    @test.assert_eq(set.select(i), Some(value))
  }
  @test.assert_eq(set.select(5), None)
  @test.assert_eq(set.rank(0), 0)
}

///|
test "bit set: the set operations" {
  let a : @seq.BitSet = @seq.BitSet::new()
  let b : @seq.BitSet = @seq.BitSet::new()
  for i in [1, 2, 3, 70] {
    let _ = a.insert(i)
  }
  for i in [3, 4, 70] {
    let _ = b.insert(i)
  }
  @test.assert_eq(a.union(b).to_array(), [1, 2, 3, 4, 70])
  @test.assert_eq(a.intersection(b).to_array(), [3, 70])
  @test.assert_eq(a.difference(b).to_array(), [1, 2])
  @test.assert_eq(a.symmetric_difference(b).to_array(), [1, 2, 4])
  @test.assert_eq(a.is_subset(a.union(b)), true)
  @test.assert_eq(b.is_subset(a), false)
  @test.assert_eq(@seq.BitSet::new().is_disjoint(a), true)
  let lowered = a.copy()
  lowered.intersection_in_place(b)
  @test.assert_eq(lowered.to_array(), [3, 70])
}

///|
test "sparse set: dense order and removal by swap" {
  let set : @seq.SparseSet[Int32] = @seq.SparseSet::new()
  for i in 0..<5 {
    let _ = set.insert(i * 10)
  }
  @test.assert_eq(set.remove(10), true)
  @test.assert_eq(set.to_array(), [0, 40, 20, 30])
  @test.assert_eq(set.contains(10), false)
  @test.assert_eq(set.get_index(20), Some(2))
  @test.assert_eq(set.remove(99), false)
}

///|
test "gap buffer: randomised model" {
  let rng : SeqRng = { state: 0x2545f4914f6cdd1d, }
  let buffer : @seq.GapBuffer[Int32] = @seq.GapBuffer::new()
  let model : Array[Int32] = []
  for step in 0..<2000 {
    let size = model.length()
    if rng.below(2) == 0 {
      let at = if size == 0 { 0 } else { rng.below(size + 1) }
      let value = rng.below(100)
      buffer.insert(at, value)
      model.insert(at, value)
    } else if size > 0 {
      let at = rng.below(size)
      @test.assert_eq(buffer.remove(at), Some(model[at]))
      let _ = model.remove(at)
    }
    if step % 37 == 0 {
      @test.assert_eq(buffer.length(), model.length())
      @test.assert_eq(buffer.to_array(), model)
    }
  }
}

///|
test "linked list: splice moves the nodes" {
  let left : @seq.LinkedList[Int32] = @seq.LinkedList::new()
  let right : @seq.LinkedList[Int32] = @seq.LinkedList::new()
  left.push_back(1)
  left.push_back(2)
  right.push_back(3)
  right.push_back(4)
  left.splice(right)
  @test.assert_eq(left.to_array(), [1, 2, 3, 4])
  @test.assert_eq(left.length(), 4)
  @test.assert_eq(right.is_empty(), true)
  @test.assert_eq(left.back(), Some(4))
  @test.assert_eq(left.pop_back(), Some(4))
  @test.assert_eq(left.to_array(), [1, 2, 3])
}

///|
test "linked list: split, insert and remove" {
  let list : @seq.LinkedList[Int32] = @seq.LinkedList::new()
  for i in 0..<6 {
    list.push_back(i)
  }
  let tail = list.split_off(3)
  @test.assert_eq(list.to_array(), [0, 1, 2])
  @test.assert_eq(tail.to_array(), [3, 4, 5])
  list.insert_at(1, 9)
  @test.assert_eq(list.to_array(), [0, 9, 1, 2])
  @test.assert_eq(list.remove_at(1), Some(9))
  @test.assert_eq(list.to_array(), [0, 1, 2])
  @test.assert_eq(list.rev_iter().to_array(), [2, 1, 0])
  list.clear()
  @test.assert_eq(list.is_empty(), true)
}

///|
test "linked list: randomised model" {
  let rng : SeqRng = { state: 0x9e3779b97f4a7c15, }
  let list : @seq.LinkedList[Int32] = @seq.LinkedList::new()
  let model : Array[Int32] = []
  for step in 0..<2000 {
    let size = model.length()
    match rng.below(4) {
      0 => {
        let value = rng.below(100)
        list.push_back(value)
        model.push(value)
      }
      1 => {
        let value = rng.below(100)
        list.push_front(value)
        model.insert(0, value)
      }
      2 => {
        @test.assert_eq(
          list.pop_front(),
          if size == 0 {
            None
          } else {
            Some(model[0])
          },
        )
        if size > 0 {
          let _ = model.remove(0)
        }
      }
      _ => {
        let at = if size == 0 { 0 } else { rng.below(size) }
        let value = rng.below(100)
        list.insert_at(at, value)
        model.insert(at, value)
      }
    }
    if step % 41 == 0 {
      @test.assert_eq(list.to_array(), model)
      @test.assert_eq(list.length(), model.length())
    }
  }
}
