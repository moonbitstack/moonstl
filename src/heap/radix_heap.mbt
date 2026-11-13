///|
/// How many bits a number needs, which is the bucket an offset falls in.
fn bit_length(value : UInt64) -> Int32 {
  let mut width = 0
  let mut rest = value
  while rest != 0 {
    rest = rest >> 1
    width = width + 1
  }
  width
}

///|
/// A monotone heap over `UInt64` keys: the key of a pushed entry may not be
/// smaller than the key of the last one popped. Under that rule a pop costs
/// O(log C) where C is the width of the key space, and it never compares two
/// keys of different buckets — the bucket a key falls in already says which is
/// smaller. That is what makes it a step faster than a comparison heap on
/// integer keys, and why a key below the last pop is refused rather than
/// reordered.
///
/// ```mbt check
/// test {
///   let heap : @heap.RadixHeap[String] = @heap.RadixHeap::new()
///   heap.push(5UL, "five")
///   heap.push(1UL, "one")
///   heap.push(9UL, "nine")
///   assert_true(heap.pop_min() == Some((1UL, "one")))
///   assert_true(heap.pop_min() == Some((5UL, "five")))
/// }
/// ```
pub struct RadixHeap[T] {
  buckets : Array[Array[(UInt64, T)]]
  mut last : UInt64
  mut len : Int32
}

///|
/// An empty monotone heap, with no last key to be monotone against yet.
pub fn[T] RadixHeap::new() -> RadixHeap[T] {
  let buckets : Array[Array[(UInt64, T)]] = []
  for _ in 0..<65 {
    buckets.push([])
  }
  { buckets, last: 0UL, len: 0, }
}

///|
fn[T] RadixHeap::bucket_of(self : RadixHeap[T], key : UInt64) -> Int32 {
  bit_length(key ^ self.last)
}

///|
/// Adds an entry whose key is not below the last key popped.
pub fn[T] RadixHeap::push(
  self : RadixHeap[T],
  key : UInt64,
  value : T,
) -> Unit raise @spec.Refused {
  if self.len > 0 && key < self.last {
    raise @spec.Refused::NonMonotone(got=key, limit=self.last)
  }
  let bucket = self.bucket_of(key)
  self.buckets[bucket].push((key, value))
  self.len = self.len + 1
}

///|
/// The key the next pop would return, or `None` when the heap is empty.
pub fn[T] RadixHeap::peek_key(self : RadixHeap[T]) -> UInt64? {
  match self.peek_entry() {
    Some(entry) => Some(entry.0)
    None => None
  }
}

///|
fn[T] RadixHeap::peek_entry(self : RadixHeap[T]) -> (UInt64, T)? {
  if self.len == 0 {
    return None
  }
  let mut bucket = 0
  while bucket < self.buckets.length() && self.buckets[bucket].length() == 0 {
    bucket = bucket + 1
  }
  if bucket >= self.buckets.length() {
    return None
  }
  if bucket == 0 {
    return Some(self.buckets[0][self.buckets[0].length() - 1])
  }
  // The smallest key of the first non-empty bucket becomes the new last, and
  // the rest of that bucket is spread over the lower ones.
  let mut smallest = self.buckets[bucket][0].0
  for entry in self.buckets[bucket] {
    if entry.0 < smallest {
      smallest = entry.0
    }
  }
  self.last = smallest
  let moved = self.buckets[bucket]
  self.buckets[bucket] = []
  for entry in moved {
    let target = self.bucket_of(entry.0)
    self.buckets[target].push(entry)
  }
  Some(self.buckets[0][self.buckets[0].length() - 1])
}

///|
/// Removes and returns the smallest key with its value, or `None` when the heap is empty; the key becomes the floor the next insert must not go below.
pub fn[T] RadixHeap::pop_min(self : RadixHeap[T]) -> (UInt64, T)? {
  match self.peek_entry() {
    Some(entry) => {
      let _ = self.buckets[0].pop()
      self.last = entry.0
      self.len = self.len - 1
      Some(entry)
    }
    None => None
  }
}

///|
/// How many entries the heap holds.
pub fn[T] RadixHeap::length(self : RadixHeap[T]) -> Int32 {
  self.len
}

///|
/// Whether the heap holds no entry.
pub fn[T] RadixHeap::is_empty(self : RadixHeap[T]) -> Bool {
  self.len == 0
}

///|
/// Removes every entry and forgets the last key it popped.
pub fn[T] RadixHeap::clear(self : RadixHeap[T]) -> Unit {
  for i in 0..<self.buckets.length() {
    self.buckets[i] = []
  }
  self.last = 0UL
  self.len = 0
}
