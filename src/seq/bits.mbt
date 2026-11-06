// The bit containers share one representation: an array of 64-bit words with
// the low bit of word 0 as bit 0.

///|
/// The word a bit lives in.
fn word_of(index : Int32) -> Int32 {
  index >> 6
}

///|
/// The mask of one bit inside its word.
fn bit_mask(index : Int32) -> UInt64 {
  let one : UInt64 = 1
  one << (index & 63)
}

///|
/// How many set bits the words hold below `limit`, a count of words.
fn popcount_upto(words : Array[UInt64], limit : Int32) -> Int32 {
  let mut total = 0
  let stop = if limit > words.length() { words.length() } else { limit }
  for i in 0..<stop {
    total = total + words[i].popcnt()
  }
  total
}

///|
/// A vector of bits with a length: bit `i` lives in word `i / 64` at bit
/// `i % 64`, and the bits past the length are always zero.
///
/// ```mbt check
/// test {
///   let bits : @seq.BitVec = @seq.BitVec::new()
///   bits.push(true)
///   bits.push(false)
///   bits.push(true)
///   @test.assert_eq(bits.length(), 3)
///   @test.assert_eq(bits.get(2), Some(true))
///   @test.assert_eq(bits.count_ones(), 2)
/// }
/// ```
pub struct BitVec {
  words : Array[UInt64]
  mut bits : Int32
}

///|
pub fn BitVec::new(capacity~ : Int32 = 0) -> BitVec {
  let words : Array[UInt64] = []
  if capacity > 0 {
    words.reserve_capacity(words_for(capacity))
  }
  { words, bits: 0, }
}

///|
pub fn BitVec::push(self : BitVec, value : Bool) -> Unit {
  if self.bits % 64 == 0 {
    self.words.push(0)
  }
  let word = word_of(self.bits)
  let mask = bit_mask(self.bits)
  if value {
    self.words[word] = self.words[word] | mask
  } else {
    self.words[word] = self.words[word] & (mask ^ 0xFFFFFFFFFFFFFFFF)
  }
  self.bits = self.bits + 1
}

///|
pub fn BitVec::pop(self : BitVec) -> Bool? {
  if self.bits == 0 {
    return None
  }
  self.bits = self.bits - 1
  let word = word_of(self.bits)
  let mask = bit_mask(self.bits)
  let value = (self.words[word] & mask) != 0
  if self.bits % 64 == 0 {
    let _ = self.words.pop()
  }
  Some(value)
}

///|
pub fn BitVec::get(self : BitVec, index : Int32) -> Bool? {
  if index < 0 || index >= self.bits {
    None
  } else {
    Some((self.words[word_of(index)] & bit_mask(index)) != 0)
  }
}

///|
pub fn BitVec::at(self : BitVec, index : Int32) -> Bool {
  match self.get(index) {
    Some(value) => value
    None => abort("moonstl: a bit index outside the vector")
  }
}

///|
/// Sets a bit that is already inside the length. Growing is `resize`, so a
/// write cannot silently change how long the vector is.
pub fn BitVec::set(self : BitVec, index : Int32, value : Bool) -> Unit {
  if index < 0 || index >= self.bits {
    abort("moonstl: a bit index outside the vector")
  }
  let word = word_of(index)
  let mask = bit_mask(index)
  if value {
    self.words[word] = self.words[word] | mask
  } else {
    self.words[word] = self.words[word] & (mask ^ 0xFFFFFFFFFFFFFFFF)
  }
}

///|
pub fn BitVec::length(self : BitVec) -> Int32 {
  self.bits
}

///|
pub fn BitVec::is_empty(self : BitVec) -> Bool {
  self.bits == 0
}

///|
pub fn BitVec::count_ones(self : BitVec) -> Int32 {
  popcount_upto(self.words, self.words.length())
}

///|
/// Grows with zeroes or cuts the length; the bits past the new length are
/// cleared, so a `count_ones` afterwards never counts them.
pub fn BitVec::resize(self : BitVec, length : Int32) -> Unit {
  if length < 0 {
    return
  }
  if length > self.bits {
    while self.words.length() < words_for(length) {
      self.words.push(0)
    }
    self.bits = length
    return
  }
  self.bits = length
  let keep = words_for(length)
  while self.words.length() > keep {
    let _ = self.words.pop()
  }
  if length % 64 != 0 {
    let mask = bit_mask(length) - 1
    self.words[keep - 1] = self.words[keep - 1] & mask
  }
}

///|
pub fn BitVec::iter(self : BitVec) -> Iter[Bool] {
  let mut cursor = 0
  Iter::new(() => {
    if cursor >= self.bits {
      None
    } else {
      let value = (self.words[word_of(cursor)] & bit_mask(cursor)) != 0
      cursor = cursor + 1
      Some(value)
    }
  })
}

///|
/// The words themselves, so a caller can hash or compare a run of bits without
/// walking them one at a time.
pub fn BitVec::blocks(self : BitVec) -> ArrayView[UInt64] {
  self.words[:]
}

///|
pub fn BitVec::clear(self : BitVec) -> Unit {
  self.words.clear()
  self.bits = 0
}

///|
pub fn BitVec::copy(self : BitVec) -> BitVec {
  { words: self.words.copy(), bits: self.bits, }
}

///|
pub impl Eq for BitVec with fn equal(self, other) {
  self.bits == other.bits && self.words == other.words
}

///|
pub extend BitVec with Eq::{equal, not_equal}

///|
pub impl Show for BitVec with fn output(self, logger) {
  logger.write_string("BitVec[")
  for i, value in self.iter() {
    if i > 0 {
      logger.write_string(", ")
    }
    logger.write_string(if value { "1" } else { "0" })
  }
  logger.write_string("]")
}

///|
pub extend BitVec with Show::{to_string, output}

///|
/// A set of non-negative integers stored as bits: membership is a bit test, and
/// the set operations run word by word. `length` counts the elements, not the
/// range, because the range has no ceiling.
///
/// ```mbt check
/// test {
///   let set : @seq.BitSet = @seq.BitSet::new()
///   @test.assert_eq(set.insert(3), true)
///   @test.assert_eq(set.insert(3), false)
///   @test.assert_eq(set.contains(3), true)
///   @test.assert_eq(set.length(), 1)
///   @test.assert_eq(set.select(0), Some(3))
///   @test.assert_eq(set.rank(4), 1)
/// }
/// ```
pub struct BitSet {
  words : Array[UInt64]
}

///|
pub fn BitSet::new(capacity~ : Int32 = 0) -> BitSet {
  let words : Array[UInt64] = []
  if capacity > 0 {
    words.reserve_capacity(words_for(capacity))
  }
  { words, }
}

///|
fn BitSet::grow(self : BitSet, index : Int32) -> Unit {
  let needed = words_for(index + 1)
  while self.words.length() < needed {
    self.words.push(0)
  }
}

///|
/// Adds `index` and reports whether it was new.
pub fn BitSet::insert(self : BitSet, index : Int32) -> Bool {
  if index < 0 {
    return false
  }
  self.grow(index)
  let word = word_of(index)
  let mask = bit_mask(index)
  if (self.words[word] & mask) != 0 {
    false
  } else {
    self.words[word] = self.words[word] | mask
    true
  }
}

///|
pub fn BitSet::remove(self : BitSet, index : Int32) -> Bool {
  if index < 0 || word_of(index) >= self.words.length() {
    return false
  }
  let word = word_of(index)
  let mask = bit_mask(index)
  if (self.words[word] & mask) == 0 {
    false
  } else {
    self.words[word] = self.words[word] & (mask ^ 0xFFFFFFFFFFFFFFFF)
    true
  }
}

///|
pub fn BitSet::contains(self : BitSet, index : Int32) -> Bool {
  if index < 0 || word_of(index) >= self.words.length() {
    false
  } else {
    (self.words[word_of(index)] & bit_mask(index)) != 0
  }
}

///|
/// How many elements are smaller than `index`, which is the position a `select`
/// would report and the count of set bits in `[0, index)`.
pub fn BitSet::rank(self : BitSet, index : Int32) -> Int32 {
  if index <= 0 {
    return 0
  }
  let word = word_of(index)
  let mut count = popcount_upto(self.words, word)
  if word < self.words.length() && (index & 63) != 0 {
    let mask = bit_mask(index) - 1
    count = count + (self.words[word] & mask).popcnt()
  }
  count
}

///|
/// The element at position `n` in increasing order, or `None` when the set holds
/// no such position.
pub fn BitSet::select(self : BitSet, n : Int32) -> Int32? {
  if n < 0 {
    return None
  }
  let mut remaining = n
  let mut word = 0
  while word < self.words.length() {
    let count = self.words[word].popcnt()
    if remaining < count {
      let mut bit = 0
      while bit < 64 {
        if (self.words[word] & bit_mask(bit)) != 0 {
          if remaining == 0 {
            return Some((word << 6) + bit)
          }
          remaining = remaining - 1
        }
        bit = bit + 1
      }
    }
    remaining = remaining - count
    word = word + 1
  }
  None
}

///|
/// The number of elements, not the span they cover.
pub fn BitSet::length(self : BitSet) -> Int32 {
  popcount_upto(self.words, self.words.length())
}

///|
pub fn BitSet::is_empty(self : BitSet) -> Bool {
  for word in self.words {
    if word != 0 {
      return false
    }
  }
  true
}

///|
/// The elements in increasing order.
pub fn BitSet::iter(self : BitSet) -> Iter[Int32] {
  let mut word = 0
  let mut bit = 0
  Iter::new(() => {
    while word < self.words.length() {
      while bit < 64 {
        if (self.words[word] & bit_mask(bit)) != 0 {
          let index = (word << 6) + bit
          bit = bit + 1
          return Some(index)
        }
        bit = bit + 1
      }
      word = word + 1
      bit = 0
    }
    None
  })
}

///|
pub fn BitSet::to_array(self : BitSet) -> Array[Int32] {
  let out : Array[Int32] = []
  for index in self.iter() {
    out.push(index)
  }
  out
}

///|
pub fn BitSet::union(self : BitSet, other : BitSet) -> BitSet {
  let result : BitSet = { words: [], }
  for i in 0..<self.words.length() {
    result.words.push(self.words[i])
  }
  for i in 0..<other.words.length() {
    if i < result.words.length() {
      result.words[i] = result.words[i] | other.words[i]
    } else {
      result.words.push(other.words[i])
    }
  }
  result
}

///|
pub fn BitSet::intersection(self : BitSet, other : BitSet) -> BitSet {
  let result : BitSet = { words: [], }
  for i in 0..<self.words.length() {
    if i < other.words.length() {
      result.words.push(self.words[i] & other.words[i])
    } else {
      result.words.push(0)
    }
  }
  result
}

///|
pub fn BitSet::difference(self : BitSet, other : BitSet) -> BitSet {
  let result : BitSet = { words: [], }
  for i in 0..<self.words.length() {
    if i < other.words.length() {
      result.words.push(self.words[i] & (other.words[i] ^ 0xFFFFFFFFFFFFFFFF))
    } else {
      result.words.push(self.words[i])
    }
  }
  result
}

///|
pub fn BitSet::symmetric_difference(self : BitSet, other : BitSet) -> BitSet {
  let result : BitSet = { words: [], }
  let width = if self.words.length() > other.words.length() {
    self.words.length()
  } else {
    other.words.length()
  }
  for i in 0..<width {
    let left = if i < self.words.length() { self.words[i] } else { 0 }
    let right = if i < other.words.length() { other.words[i] } else { 0 }
    result.words.push(left ^ right)
  }
  result
}

///|
pub fn BitSet::union_in_place(self : BitSet, other : BitSet) -> Unit {
  for i in 0..<other.words.length() {
    if i < self.words.length() {
      self.words[i] = self.words[i] | other.words[i]
    } else {
      self.words.push(other.words[i])
    }
  }
}

///|
pub fn BitSet::intersection_in_place(self : BitSet, other : BitSet) -> Unit {
  for i in 0..<self.words.length() {
    if i < other.words.length() {
      self.words[i] = self.words[i] & other.words[i]
    } else {
      self.words[i] = 0
    }
  }
}

///|
pub fn BitSet::difference_in_place(self : BitSet, other : BitSet) -> Unit {
  for i in 0..<self.words.length() {
    if i < other.words.length() {
      self.words[i] = self.words[i] & (other.words[i] ^ 0xFFFFFFFFFFFFFFFF)
    }
  }
}

///|
pub fn BitSet::is_subset(self : BitSet, other : BitSet) -> Bool {
  for i in 0..<self.words.length() {
    let held = if i < other.words.length() { other.words[i] } else { 0 }
    if (self.words[i] & (held ^ 0xFFFFFFFFFFFFFFFF)) != 0 {
      return false
    }
  }
  true
}

///|
pub fn BitSet::is_superset(self : BitSet, other : BitSet) -> Bool {
  other.is_subset(self)
}

///|
pub fn BitSet::is_disjoint(self : BitSet, other : BitSet) -> Bool {
  let width = if self.words.length() < other.words.length() {
    self.words.length()
  } else {
    other.words.length()
  }
  for i in 0..<width {
    if (self.words[i] & other.words[i]) != 0 {
      return false
    }
  }
  true
}

///|
pub fn BitSet::clear(self : BitSet) -> Unit {
  self.words.clear()
}

///|
pub fn BitSet::copy(self : BitSet) -> BitSet {
  { words: self.words.copy(), }
}

///|
pub impl Eq for BitSet with fn equal(self, other) {
  self.words == other.words
}

///|
pub extend BitSet with Eq::{equal, not_equal}

///|
pub impl Show for BitSet with fn output(self, logger) {
  logger.write_string("BitSet{")
  for i, index in self.iter() {
    if i > 0 {
      logger.write_string(", ")
    }
    logger.write_string(index.to_string())
  }
  logger.write_string("}")
}

///|
pub extend BitSet with Show::{to_string, output}
