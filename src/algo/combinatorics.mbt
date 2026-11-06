///|
/// The k-permutations of a run, in the order Python's `itertools.permutations`
/// produces them: the positions advance like an odometer, so the first element
/// changes slowest.
///
/// ```mbt check
/// test {
///   let permutations : @algo.Permutations[Int32] = @algo.Permutations::new(
///     [1, 2, 3],
///     length=2,
///   )
///   @test.assert_eq(permutations.iter().to_array(), [
///     [1, 2],
///     [1, 3],
///     [2, 1],
///     [2, 3],
///     [3, 1],
///     [3, 2],
///   ])
/// }
/// ```
pub struct Permutations[T] {
  pool : Array[T]
  /// One entry per pool position, reordered as the odometer turns.
  indices : Array[Int32]
  /// How many swaps are left in each of the first `size` positions.
  cycles : Array[Int32]
  size : Int32
  mut started : Bool
  mut done : Bool
}

///|
/// `length` shorter than the pool gives k-permutations; leaving it out gives
/// every arrangement of the whole pool.
pub fn[T] Permutations::new(
  pool : ArrayView[T],
  length? : Int32,
) -> Permutations[T] {
  let items = pool.to_owned()
  let n = items.length()
  let k = match length {
    Some(k) => if k < 0 { 0 } else if k > n { n } else { k }
    None => n
  }
  let indices : Array[Int32] = []
  for i in 0..<n {
    indices.push(i)
  }
  let cycles : Array[Int32] = []
  for i in 0..<k {
    cycles.push(n - i)
  }
  { pool: items, indices, cycles, size: k, started: false, done: false, }
}

///|
/// The next arrangement, or `None` when they are exhausted.
pub fn[T] Permutations::next(self : Permutations[T]) -> Array[T]? {
  if self.done {
    return None
  }
  let n = self.pool.length()
  let k = self.size
  if !self.started {
    self.started = true
    if k == 0 {
      self.done = true
      return Some([])
    }
    let first : Array[T] = []
    for i in 0..<k {
      first.push(self.pool[self.indices[i]])
    }
    return Some(first)
  }
  let mut i = k - 1
  while i >= 0 {
    self.cycles[i] = self.cycles[i] - 1
    if self.cycles[i] == 0 {
      let head = self.indices[i]
      for j in i..<(n - 1) {
        self.indices[j] = self.indices[j + 1]
      }
      self.indices[n - 1] = head
      self.cycles[i] = n - i
    } else {
      let j = self.cycles[i]
      let swap = self.indices[i]
      self.indices[i] = self.indices[n - j]
      self.indices[n - j] = swap
      let result : Array[T] = []
      for index in 0..<k {
        result.push(self.pool[self.indices[index]])
      }
      return Some(result)
    }
    i = i - 1
  }
  self.done = true
  None
}

///|
pub fn[T] Permutations::iter(self : Permutations[T]) -> Iter[Array[T]] {
  Iter::new(() => self.next())
}

///|
/// The k-element subsets, in lexicographic order of positions.
///
/// ```mbt check
/// test {
///   let combinations : @algo.Combinations[Int32] = @algo.Combinations::new(
///     [1, 2, 3, 4],
///     k=2,
///   )
///   @test.assert_eq(combinations.iter().to_array(), [
///     [1, 2],
///     [1, 3],
///     [1, 4],
///     [2, 3],
///     [2, 4],
///     [3, 4],
///   ])
/// }
/// ```
pub struct Combinations[T] {
  pool : Array[T]
  indices : Array[Int32]
  mut started : Bool
  mut done : Bool
}

///|
pub fn[T] Combinations::new(pool : ArrayView[T], k~ : Int32) -> Combinations[T] {
  let items = pool.to_owned()
  let indices : Array[Int32] = []
  for i in 0..<k {
    indices.push(i)
  }
  { pool: items, indices, started: false, done: k < 0 || k > items.length(), }
}

///|
pub fn[T] Combinations::next(self : Combinations[T]) -> Array[T]? {
  if self.done {
    return None
  }
  let n = self.pool.length()
  let k = self.indices.length()
  if !self.started {
    self.started = true
    if k == 0 {
      self.done = true
      return Some([])
    }
    let first : Array[T] = []
    for index in self.indices {
      first.push(self.pool[index])
    }
    return Some(first)
  }
  let mut i = k - 1
  while i >= 0 && self.indices[i] == i + n - k {
    i = i - 1
  }
  if i < 0 {
    self.done = true
    return None
  }
  self.indices[i] = self.indices[i] + 1
  for j in (i + 1)..<k {
    self.indices[j] = self.indices[j - 1] + 1
  }
  let result : Array[T] = []
  for index in self.indices {
    result.push(self.pool[index])
  }
  Some(result)
}

///|
pub fn[T] Combinations::iter(self : Combinations[T]) -> Iter[Array[T]] {
  Iter::new(() => self.next())
}

///|
/// The k-element selections that may repeat an element, in lexicographic order
/// of positions.
///
/// ```mbt check
/// test {
///   let with_repeats : @algo.CombinationsWithReplacement[Int32] = @algo.CombinationsWithReplacement::new(
///     [1, 2],
///     k=2,
///   )
///   @test.assert_eq(with_repeats.iter().to_array(), [[1, 1], [1, 2], [2, 2]])
/// }
/// ```
pub struct CombinationsWithReplacement[T] {
  pool : Array[T]
  indices : Array[Int32]
  mut started : Bool
  mut done : Bool
}

///|
pub fn[T] CombinationsWithReplacement::new(
  pool : ArrayView[T],
  k~ : Int32,
) -> CombinationsWithReplacement[T] {
  let items = pool.to_owned()
  let indices : Array[Int32] = []
  for _ in 0..<k {
    indices.push(0)
  }
  { pool: items, indices, started: false, done: k < 0 || items.length() == 0, }
}

///|
pub fn[T] CombinationsWithReplacement::next(
  self : CombinationsWithReplacement[T],
) -> Array[T]? {
  if self.done {
    return None
  }
  let k = self.indices.length()
  if !self.started {
    self.started = true
    if k == 0 {
      self.done = true
      return Some([])
    }
    let first : Array[T] = []
    for index in self.indices {
      first.push(self.pool[index])
    }
    return Some(first)
  }
  let mut i = k - 1
  while i >= 0 && self.indices[i] == self.pool.length() - 1 {
    i = i - 1
  }
  if i < 0 {
    self.done = true
    return None
  }
  let next = self.indices[i] + 1
  for j in i..<k {
    self.indices[j] = next
  }
  let result : Array[T] = []
  for index in self.indices {
    result.push(self.pool[index])
  }
  Some(result)
}

///|
pub fn[T] CombinationsWithReplacement::iter(
  self : CombinationsWithReplacement[T],
) -> Iter[Array[T]] {
  Iter::new(() => self.next())
}

///|
/// The cartesian product of several runs, rightmost pool varying fastest, the
/// order `itertools.product` uses.
///
/// ```mbt check
/// test {
///   let pools : Array[ArrayView[Int32]] = [[1, 2][:], [3, 4][:]]
///   let product : @algo.Product[Int32] = @algo.Product::new(pools)
///   @test.assert_eq(product.iter().to_array(), [[1, 3], [1, 4], [2, 3], [2, 4]])
/// }
/// ```
pub struct Product[T] {
  pools : Array[Array[T]]
  digits : Array[Int32]
  mut started : Bool
  mut done : Bool
}

///|
pub fn[T] Product::new(pools : ArrayView[ArrayView[T]]) -> Product[T] {
  let copied : Array[Array[T]] = []
  let digits : Array[Int32] = []
  let mut empty = false
  for pool in pools {
    let items = pool.to_owned()
    if items.length() == 0 {
      empty = true
    }
    copied.push(items)
    digits.push(0)
  }
  { pools: copied, digits, started: false, done: empty, }
}

///|
pub fn[T] Product::next(self : Product[T]) -> Array[T]? {
  if self.done {
    return None
  }
  if !self.started {
    self.started = true
    let first : Array[T] = []
    for i, pool in self.pools {
      first.push(pool[self.digits[i]])
    }
    return Some(first)
  }
  let mut i = self.digits.length() - 1
  while i >= 0 {
    self.digits[i] = self.digits[i] + 1
    if self.digits[i] < self.pools[i].length() {
      let result : Array[T] = []
      for j, pool in self.pools {
        result.push(pool[self.digits[j]])
      }
      return Some(result)
    }
    self.digits[i] = 0
    i = i - 1
  }
  self.done = true
  None
}

///|
pub fn[T] Product::iter(self : Product[T]) -> Iter[Array[T]] {
  Iter::new(() => self.next())
}

///|
/// Every subset, shortest first: the order
/// `chain.from_iterable(combinations(s, r) for r in range(len(s) + 1))` gives.
///
/// ```mbt check
/// test {
///   let powerset : @algo.Powerset[Int32] = @algo.Powerset::new([1, 2])
///   @test.assert_eq(powerset.iter().to_array(), [[], [1], [2], [1, 2]])
/// }
/// ```
pub struct Powerset[T] {
  mut inner : Combinations[T]
  pool : Array[T]
  mut size : Int32
}

///|
pub fn[T] Powerset::new(pool : ArrayView[T]) -> Powerset[T] {
  let items = pool.to_owned()
  { inner: Combinations::new(items[:], k=0), pool: items, size: 0, }
}

///|
pub fn[T] Powerset::next(self : Powerset[T]) -> Array[T]? {
  while true {
    match self.inner.next() {
      Some(subset) => return Some(subset)
      None => {
        self.size = self.size + 1
        if self.size > self.pool.length() {
          return None
        }
        self.inner = Combinations::new(self.pool[:], k=self.size)
      }
    }
  }
  None
}

///|
pub fn[T] Powerset::iter(self : Powerset[T]) -> Iter[Array[T]] {
  Iter::new(() => self.next())
}

///|
/// The reflected binary code over `bits` positions: consecutive words differ in
/// exactly one bit, and the first is all zeroes.
///
/// ```mbt check
/// test {
///   let code : @algo.GrayCode = @algo.GrayCode::new(2)
///   @test.assert_eq(code.iter().take(4).to_array(), [
///     [false, false],
///     [false, true],
///     [true, true],
///     [true, false],
///   ])
/// }
/// ```
pub struct GrayCode {
  bits : Int32
  mut step : Int32
  mut done : Bool
}

///|
pub fn GrayCode::new(bits : Int32) -> GrayCode {
  { bits: if bits < 0 { 0 } else { bits }, step: 0, done: false, }
}

///|
pub fn GrayCode::next(self : GrayCode) -> Array[Bool]? {
  if self.done {
    return None
  }
  if self.bits >= 31 {
    self.done = true
    return None
  }
  let total = 1 << self.bits
  if self.step >= total {
    self.done = true
    return None
  }
  let word = self.step ^ (self.step >> 1)
  let result : Array[Bool] = []
  for i in 0..<self.bits {
    let bit = (word >> (self.bits - 1 - i)) & 1
    result.push(bit == 1)
  }
  self.step = self.step + 1
  Some(result)
}

///|
pub fn GrayCode::iter(self : GrayCode) -> Iter[Array[Bool]] {
  Iter::new(() => self.next())
}
