///|
/// One pattern matched with the Knuth-Morris-Pratt scan: O(n + m) time with a
/// worst-case guarantee, because the failure table never lets the text pointer
/// move backwards. Offsets are UTF-16 code units, the indices `String` uses.
///
/// ```mbt check
/// test {
///   let kmp = @text.Kmp::new("ab")
///   assert_eq(kmp.search("cababc"), Some(1))
///   assert_eq(kmp.search_all("abab").to_array(), [0, 2])
/// }
/// ```
pub struct Kmp {
  pattern : String
  fail : Array[Int32]
}

///|
/// The longest proper prefix-suffix table: `fail[i]` is the length of the
/// longest prefix of the pattern that is also a suffix of `pattern[0..=i]`.
fn kmp_failure(pattern : StringView) -> Array[Int32] {
  let m = pattern.length()
  let fail : Array[Int32] = Array::make(m, 0)
  let mut k = 0
  for i in 1..<m {
    let c = unit_at(pattern, i)
    while k > 0 && c != unit_at(pattern, k) {
      k = fail[k - 1]
    }
    if c == unit_at(pattern, k) {
      k = k + 1
    }
    fail[i] = k
  }
  fail
}

///|
/// Build the failure table of `pattern` in O(m). The pattern is copied, so the
/// caller's view may be a window into a rope that is edited afterwards.
pub fn Kmp::new(pattern : StringView) -> Kmp {
  Kmp::{ pattern: pattern.to_owned(), fail: kmp_failure(pattern), }
}

///|
/// The offset of the first occurrence of the pattern in `text`, or `None`.
/// An empty pattern is found at offset 0, as `String::find` reports it.
pub fn Kmp::search(self : Kmp, text : StringView) -> Int32? {
  let m = self.fail.length()
  let n = text.length()
  if m == 0 {
    return Some(0)
  }
  let mut k = 0
  for i in 0..<n {
    let c = unit_at(text, i)
    while k > 0 && c != unit_at(self.pattern[:], k) {
      k = self.fail[k - 1]
    }
    if c == unit_at(self.pattern[:], k) {
      k = k + 1
    }
    if k == m {
      return Some(i - m + 1)
    }
  }
  None
}

///|
/// The state a lazy `search_all` carries: the text is walked once, and each
/// step resumes from the failure-table position the previous step stopped at.
priv struct KmpScan {
  pattern : String
  fail : Array[Int32]
  text : StringView
  mut pos : Int32
  mut matched : Int32
}

///|
fn KmpScan::next_offset(self : KmpScan) -> Int32? {
  let m = self.fail.length()
  let n = self.text.length()
  let pattern = self.pattern[:]
  while self.pos < n {
    let c = unit_at(self.text, self.pos)
    self.pos = self.pos + 1
    while self.matched > 0 && c != unit_at(pattern, self.matched) {
      self.matched = self.fail[self.matched - 1]
    }
    if c == unit_at(pattern, self.matched) {
      self.matched = self.matched + 1
    }
    if self.matched == m {
      self.matched = self.fail[m - 1]
      return Some(self.pos - m)
    }
  }
  None
}

///|
/// Counts through the `n + 1` offsets an empty pattern occurs at.
priv struct EmptyScan {
  mut pos : Int32
  end : Int32
}

///|
fn EmptyScan::next_offset(self : EmptyScan) -> Int32? {
  if self.pos > self.end {
    return None
  }
  let at = self.pos
  self.pos = self.pos + 1
  Some(at)
}

///|
/// Every occurrence of the pattern, overlapping ones included, in ascending
/// order. An empty pattern occurs at every offset from 0 to the text length.
pub fn Kmp::search_all(self : Kmp, text : StringView) -> Iter[Int32] {
  if self.fail.length() == 0 {
    let scan = EmptyScan::{ pos: 0, end: text.length(), }
    return Iter::new(fn() { scan.next_offset() })
  }
  let scan = KmpScan::{
    pattern: self.pattern,
    fail: self.fail,
    text,
    pos: 0,
    matched: 0,
  }
  Iter::new(fn() { scan.next_offset() })
}
