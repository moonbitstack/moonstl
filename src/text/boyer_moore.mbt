///|
/// One pattern matched with the Boyer-Moore scan: it compares the pattern from
/// its last character backwards and skips ahead with the bad-character and
/// good-suffix rules, so a mismatch usually costs less than one comparison per
/// text position. Worst case is still O(n), build is O(m + sigma).
///
/// ```mbt check
/// test {
///   let bm = @text.BoyerMoore::new("needle")
///   assert_eq(bm.search("a needle in a haystack"), Some(2))
///   assert_eq(bm.search("haystack"), None)
/// }
/// ```
pub struct BoyerMoore {
  pattern : String
  /// Last index in the pattern of each code unit it contains.
  bad : Map[Int32, Int32]
  good : Array[Int32]
}

///|
/// `good[j]` is how far to shift when the pattern's character at `j` mismatch,
/// derived from the longest suffix of the pattern that is also a prefix.
fn boyer_moore_good_suffix(pattern : StringView) -> Array[Int32] {
  let m = pattern.length()
  let good : Array[Int32] = Array::make(m, 0)
  if m == 0 {
    return good
  }
  let suff : Array[Int32] = Array::make(m, 0)
  suff[m - 1] = m
  let mut g = m - 1
  let mut f = 0
  let mut i = m - 2
  while i >= 0 {
    if i > g && suff[i + m - 1 - f] < i - g {
      suff[i] = suff[i + m - 1 - f]
    } else {
      if i < g {
        g = i
      }
      f = i
      while g >= 0 && unit_at(pattern, g) == unit_at(pattern, g + m - 1 - f) {
        g = g - 1
      }
      suff[i] = f - g
    }
    i = i - 1
  }
  for j in 0..<m {
    good[j] = m
  }
  let mut j = 0
  let mut i = m - 1
  while i >= 0 {
    if suff[i] == i + 1 {
      while j < m - 1 - i {
        good[j] = m - 1 - i
        j = j + 1
      }
    }
    i = i - 1
  }
  let mut i = 0
  while i < m - 1 {
    good[m - 1 - suff[i]] = m - 1 - i
    i = i + 1
  }
  good
}

///|
/// Build both shift tables in O(m + sigma), where sigma is the number of
/// distinct code units in the pattern.
pub fn BoyerMoore::new(pattern : StringView) -> BoyerMoore {
  let m = pattern.length()
  let bad : Map[Int32, Int32] = Map([])
  for i in 0..<m {
    bad.set(key_at(pattern, i), i)
  }
  BoyerMoore::{
    pattern: pattern.to_owned(),
    bad,
    good: boyer_moore_good_suffix(pattern),
  }
}

///|
/// A resumable Boyer-Moore scan; the alignment is the only state that has to
/// survive between occurrences.
priv struct BmScan {
  pattern : String
  bad : Map[Int32, Int32]
  good : Array[Int32]
  text : StringView
  mut shift : Int32
}

///|
fn BmScan::next_offset(self : BmScan) -> Int32? {
  let pattern = self.pattern[:]
  let m = pattern.length()
  let n = self.text.length()
  if m > n {
    return None
  }
  while self.shift + m <= n {
    let mut j = m - 1
    while j >= 0 && unit_at(self.text, self.shift + j) == unit_at(pattern, j) {
      j = j - 1
    }
    if j < 0 {
      let at = self.shift
      self.shift = at + 1
      return Some(at)
    }
    let bad_shift = match self.bad.get(key_at(self.text, self.shift + j)) {
      Some(i) => j - i
      None => j + 1
    }
    let mut step = if bad_shift > self.good[j] {
      bad_shift
    } else {
      self.good[j]
    }
    if step < 1 {
      step = 1
    }
    self.shift = self.shift + step
  }
  None
}

///|
/// The offset of the first occurrence, or `None`. An empty pattern is found at
/// offset 0.
pub fn BoyerMoore::search(self : BoyerMoore, text : StringView) -> Int32? {
  if self.good.length() == 0 {
    return Some(0)
  }
  let scan = BmScan::{
    pattern: self.pattern,
    bad: self.bad,
    good: self.good,
    text,
    shift: 0,
  }
  scan.next_offset()
}

///|
/// Every occurrence, overlapping ones included, in ascending order. An empty
/// pattern occurs at every offset from 0 to the text length.
pub fn BoyerMoore::search_all(
  self : BoyerMoore,
  text : StringView,
) -> Iter[Int32] {
  if self.good.length() == 0 {
    let scan = EmptyScan::{ pos: 0, end: text.length(), }
    return Iter::new(fn() { scan.next_offset() })
  }
  let scan = BmScan::{
    pattern: self.pattern,
    bad: self.bad,
    good: self.good,
    text,
    shift: 0,
  }
  Iter::new(fn() { scan.next_offset() })
}
