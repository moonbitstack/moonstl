// Every heap in the package against the same model: a plain array kept sorted,
// driven by a fixed-seed generator so the sequence replays on every backend.

///|
priv struct HeapRng {
  mut state : UInt64
}

///|
fn HeapRng::below(self : HeapRng, bound : Int32) -> Int32 {
  self.state = self.state * 6364136223846793005 + 1442695040888963407
  let value = (self.state >> 33).to_uint().reinterpret_as_int()
  (value % bound).abs()
}

///|
test "dary heap: every arity pops in order" {
  for arity in [2, 3, 4, 8] {
    let heap : @heap.DaryHeap[Int32] = @heap.DaryHeap::new(arity~)
    let rng : HeapRng = { state: 0x2545f4914f6cdd1d, }
    let model : Array[Int32] = []
    for _ in 0..<200 {
      let value = rng.below(1000)
      heap.push(value)
      model.push(value)
    }
    model.sort()
    @test.assert_eq(heap.into_sorted_array(), model)
  }
}

///|
test "dary heap: a refused arity" {
  let refused = try {
    let heap : @heap.DaryHeap[Int32] = @heap.DaryHeap::new(arity=1)
    let _ = heap
    Ok(())
  } catch {
    @spec.Refused::Arity(got~) => Err(got)
    _ => Err(-1)
  }
  @test.assert_eq(refused, Err(1))
}

///|
test "dary heap: replace and push pop keep the ceiling" {
  let heap : @heap.DaryHeap[Int32] = @heap.DaryHeap::new(order=Max)
  for value in [3, 9, 5] {
    heap.push(value)
  }
  @test.assert_eq(heap.replace(7), Some(9))
  @test.assert_eq(heap.push_pop(1), Some(7))
  @test.assert_eq(heap.to_array().length(), 3)
}

///|
test "index heap: update and remove keep the order" {
  let heap : @heap.IndexHeap[Int32] = @heap.IndexHeap::new()
  let keys : Array[@heap.HeapKey[Int32]] = []
  for value in [50, 20, 80, 10, 60] {
    keys.push(heap.insert(value))
  }
  @test.assert_eq(heap.pop(), Some(10))
  @test.assert_eq(heap.update(keys[0], 5), true)
  @test.assert_eq(heap.peek(), Some(5))
  @test.assert_eq(heap.remove_at(keys[2]), Some(80))
  @test.assert_eq(heap.into_sorted_array(), [5, 20, 60])
  @test.assert_eq(heap.update(keys[2], 1), false)
}

///|
test "index heap: randomised against a sorted model" {
  let rng : HeapRng = { state: 0x9e3779b97f4a7c15, }
  let heap : @heap.IndexHeap[Int32] = @heap.IndexHeap::new()
  let keys : Array[@heap.HeapKey[Int32]] = []
  let model : Array[Int32] = []
  for _ in 0..<300 {
    if keys.length() > 0 && rng.below(3) == 0 {
      let at = rng.below(keys.length())
      let key = keys[at]
      let value = heap.get(key).unwrap()
      let expected = model.search_by(x => x == value).unwrap()
      @test.assert_eq(heap.remove_at(key), Some(value))
      let _ = model.remove(expected)
      let _ = keys.remove(at)
    } else {
      let value = rng.below(500)
      keys.push(heap.insert(value))
      model.push(value)
    }
  }
  model.sort()
  @test.assert_eq(heap.into_sorted_array(), model)
}

///|
test "pairing heap: pops in order and honours removal" {
  let rng : HeapRng = { state: 0xdeadbeefcafebabe, }
  let heap : @heap.PairingHeap[Int32] = @heap.PairingHeap::new()
  let keys : Array[@heap.HeapKey[Int32]] = []
  let model : Array[Int32] = []
  for _ in 0..<200 {
    let value = rng.below(400)
    keys.push(heap.insert(value))
    model.push(value)
  }
  // Remove a few by handle before popping the rest.
  for _ in 0..<20 {
    let at = rng.below(keys.length())
    let key = keys[at]
    let value = heap.remove_at(key).unwrap()
    let expected = model.search_by(x => x == value).unwrap()
    let _ = model.remove(expected)
    let _ = keys.remove(at)
  }
  model.sort()
  @test.assert_eq(heap.into_sorted_array(), model)
}

///|
test "pairing heap: update moves an entry" {
  let heap : @heap.PairingHeap[Int32] = @heap.PairingHeap::new()
  let a = heap.insert(10)
  let _ = heap.insert(20)
  let _ = heap.insert(30)
  @test.assert_eq(heap.update(a, 5), true)
  @test.assert_eq(heap.peek(), Some(5))
  @test.assert_eq(heap.length(), 3)
  @test.assert_eq(heap.update(a, 6), true)
  @test.assert_eq(heap.into_sorted_array(), [6, 20, 30])
}

///|
test "fibonacci heap: pops in order" {
  let rng : HeapRng = { state: 0x2545f4914f6cdd1d, }
  let heap : @heap.FibonacciHeap[Int32] = @heap.FibonacciHeap::new()
  let model : Array[Int32] = []
  for _ in 0..<300 {
    let value = rng.below(1000)
    let _ = heap.insert(value)
    model.push(value)
  }
  model.sort()
  @test.assert_eq(heap.into_sorted_array(), model)
}

///|
test "fibonacci heap: decrease key and removal" {
  let heap : @heap.FibonacciHeap[Int32] = @heap.FibonacciHeap::new()
  let a = heap.insert(40)
  let b = heap.insert(20)
  let _ = heap.insert(30)
  @test.assert_eq(heap.decrease_key(a, 5), true)
  @test.assert_eq(heap.decrease_key(a, 9), false)
  @test.assert_eq(heap.peek(), Some(5))
  @test.assert_eq(heap.remove_at(b), Some(20))
  @test.assert_eq(heap.into_sorted_array(), [5, 30])
}

///|
test "fibonacci heap: merging two heaps keeps every entry" {
  let left : @heap.FibonacciHeap[Int32] = @heap.FibonacciHeap::new()
  let right : @heap.FibonacciHeap[Int32] = @heap.FibonacciHeap::new()
  for value in [4, 1, 7] {
    let _ = left.insert(value)
  }
  for value in [3, 9, 2] {
    let _ = right.insert(value)
  }
  left.merge(right)
  @test.assert_eq(left.length(), 6)
  @test.assert_eq(right.length(), 0)
  @test.assert_eq(left.into_sorted_array(), [1, 2, 3, 4, 7, 9])
}

///|
test "min max heap: both ends against a sorted model" {
  let rng : HeapRng = { state: 0xbf58476d1ce4e5b9, }
  let heap : @heap.MinMaxHeap[Int32] = @heap.MinMaxHeap::new()
  let model : Array[Int32] = []
  for _ in 0..<200 {
    let value = rng.below(1000)
    heap.push(value)
    model.push(value)
  }
  model.sort()
  let mut low = 0
  let mut high = model.length() - 1
  let mut take_low = true
  while low <= high {
    if take_low {
      @test.assert_eq(heap.pop_min(), Some(model[low]))
      low = low + 1
    } else {
      @test.assert_eq(heap.pop_max(), Some(model[high]))
      high = high - 1
    }
    take_low = !take_low
  }
  @test.assert_eq(heap.is_empty(), true)
}

///|
test "radix heap: monotone keys pop in order" {
  let rng : HeapRng = { state: 0x94d049bb133111eb, }
  let heap : @heap.RadixHeap[Int32] = @heap.RadixHeap::new()
  let model : Array[(UInt64, Int32)] = []
  let mut key : UInt64 = 0UL
  for i in 0..<200 {
    key = key + rng.below(50).to_uint64()
    heap.push(key, i)
    model.push((key, i))
  }
  model.sort_by((a, b) => a.0.compare(b.0))
  let mut at = 0
  while !heap.is_empty() {
    let popped = heap.pop_min().unwrap()
    @test.assert_eq(popped.0, model[at].0)
    at = at + 1
  }
}

///|
test "radix heap: a key below the last pop is refused" {
  let heap : @heap.RadixHeap[Int32] = @heap.RadixHeap::new()
  heap.push(10UL, 1)
  heap.push(20UL, 2)
  @test.assert_eq(heap.pop_min().unwrap().0, 10UL)
  let refused = try {
    heap.push(5UL, 3)
    Ok(())
  } catch {
    @spec.Refused::NonMonotone(got~, limit~) => Err((got, limit))
    _ => Err((0UL, 0UL))
  }
  @test.assert_eq(refused, Err((5UL, 10UL)))
  heap.push(11UL, 4)
  @test.assert_eq(heap.length(), 2)
}
