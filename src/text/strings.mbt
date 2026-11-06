// String algorithms over UTF-16 code units, the indices `String` uses.

///|
/// The Z array of `text`: `z[i]` is the length of the longest run starting at
/// `i` that is also a prefix of the text. It is the linear-time answer to "where
/// does this prefix repeat", and it is what makes the suffix array's first
/// ranking pass unnecessary.
///
/// ```mbt check
/// test {
///   @test.assert_eq(@text.z_function("aabxaab"), [7, 1, 0, 0, 3, 1, 0])
/// }
/// ```
pub fn z_function(text : StringView) -> Array[Int32] {
  let n = text.length()
  let z : Array[Int32] = []
  for _ in 0..<n {
    z.push(0)
  }
  if n > 0 {
    z[0] = n
  }
  let mut left = 0
  let mut right = 0
  for i in 1..<n {
    let mut length = 0
    if i < right {
      let reused = z[i - left]
      let room = right - i
      length = if reused < room { reused } else { room }
    }
    while i + length < n && unit_at(text, length) == unit_at(text, i + length) {
      length = length + 1
    }
    z[i] = length
    if i + length > right {
      left = i
      right = i + length
    }
  }
  z
}

///|
/// The longest palindromic substring, as a half-open range. Manacher's scan
/// keeps the palindrome around each centre, so the whole text costs one pass.
///
/// ```mbt check
/// test {
///   @test.assert_eq(@text.longest_palindrome("forgeeksskeegfor"), (3, 13))
///   @test.assert_eq(@text.longest_palindrome("abc"), (0, 1))
/// }
/// ```
pub fn longest_palindrome(text : StringView) -> (Int32, Int32) {
  let n = text.length()
  if n == 0 {
    return (0, 0)
  }
  // The odd-length centres first: radius in code units around `i`.
  let odd : Array[Int32] = []
  let even : Array[Int32] = []
  for _ in 0..<n {
    odd.push(0)
    even.push(0)
  }
  let mut left = 0
  let mut right = -1
  for i in 0..<n {
    let mut radius = if i > right {
      1
    } else {
      let mirror = left + right - i
      let bound = right - i + 1
      if odd[mirror] < bound {
        odd[mirror]
      } else {
        bound
      }
    }
    while i - radius >= 0 &&
          i + radius < n &&
          unit_at(text, i - radius) == unit_at(text, i + radius) {
      radius = radius + 1
    }
    odd[i] = radius
    if i + radius - 1 > right {
      left = i - radius + 1
      right = i + radius - 1
    }
  }
  left = 0
  right = -1
  for i in 0..<n {
    let mut radius = if i > right {
      0
    } else {
      let mirror = left + right - i + 1
      let bound = right - i + 1
      if even[mirror] < bound {
        even[mirror]
      } else {
        bound
      }
    }
    while i - radius - 1 >= 0 &&
          i + radius < n &&
          unit_at(text, i - radius - 1) == unit_at(text, i + radius) {
      radius = radius + 1
    }
    even[i] = radius
    if i + radius - 1 > right {
      left = i - radius
      right = i + radius - 1
    }
  }
  let mut best_start = 0
  let mut best_length = 1
  for i in 0..<n {
    let length = 2 * odd[i] - 1
    if length > best_length {
      best_length = length
      best_start = i - odd[i] + 1
    }
    if even[i] > 0 {
      let length = 2 * even[i]
      if length > best_length {
        best_length = length
        best_start = i - even[i]
      }
    }
  }
  (best_start, best_start + best_length)
}

///|
/// The suffixes of a text in sorted order, built by doubling: after round `k`
/// every suffix is ranked by its first `2^k` units, and a round ranks the pairs
/// of ranks it already has. Two rounds of comparison sort per doubling give
/// O(n log^2 n), which is what a text of any ordinary size needs.
///
/// ```mbt check
/// test {
///   let array : @text.SuffixArray = @text.SuffixArray::new("banana")
///   @test.assert_eq(array.search("ana"), [1, 3])
///   @test.assert_eq(array.length(), 6)
/// }
/// ```
pub struct SuffixArray {
  text_ : String
  order : Array[Int32]
  ranks : Array[Int32]
}

///|
pub fn SuffixArray::new(text : StringView) -> SuffixArray {
  let n = text.length()
  let order : Array[Int32] = []
  let ranks : Array[Int32] = []
  for i in 0..<n {
    order.push(i)
    ranks.push(unit_at(text, i).to_int())
  }
  let mut step = 1
  while step < n {
    let key : Array[(Int32, Int32)] = []
    for i in 0..<n {
      let second = if i + step < n { ranks[i + step] + 1 } else { 0 }
      key.push((ranks[i] + 1, second))
    }
    order.sort_by((a, b) => {
      let first = key[a].0.compare(key[b].0)
      if first != 0 {
        first
      } else {
        key[a].1.compare(key[b].1)
      }
    })
    let fresh : Array[Int32] = []
    for _ in 0..<n {
      fresh.push(0)
    }
    let mut rank = 0
    for i in 0..<n {
      if i > 0 {
        let previous = order[i - 1]
        let current = order[i]
        let differs = key[previous].0 != key[current].0 ||
          key[previous].1 != key[current].1
        if differs {
          rank = rank + 1
        }
      }
      fresh[order[i]] = rank
    }
    for i in 0..<n {
      ranks[i] = fresh[i]
    }
    step = step * 2
  }
  { text_: text.to_owned(), order, ranks, }
}

///|
/// The Kasai LCP array: `lcp[i]` is how many units suffix `order[i]` shares with
/// suffix `order[i - 1]`. It costs one pass because a suffix and its neighbour
/// never lose more than one unit of common prefix as the start moves forward.
pub fn SuffixArray::lcp_array(self : SuffixArray) -> Array[Int32] {
  let n = self.order.length()
  let lcp : Array[Int32] = []
  for _ in 0..<n {
    lcp.push(0)
  }
  if n == 0 {
    return lcp
  }
  let position : Array[Int32] = []
  for _ in 0..<n {
    position.push(0)
  }
  for i in 0..<n {
    position[self.order[i]] = i
  }
  let mut common = 0
  for start in 0..<n {
    let at = position[start]
    if at == 0 {
      common = 0
      continue
    }
    let other = self.order[at - 1]
    while start + common < n &&
          other + common < n &&
          unit_at(self.text_[:], start + common) ==
          unit_at(self.text_[:], other + common) {
      common = common + 1
    }
    lcp[at] = common
    if common > 0 {
      common = common - 1
    }
  }
  lcp
}

///|
/// Every occurrence of `pattern`, in increasing order. The suffixes that start
/// with the pattern are contiguous in the sorted order, so the search is two
/// binary searches and a scan.
pub fn SuffixArray::search(
  self : SuffixArray,
  pattern : StringView,
) -> Array[Int32] {
  let found : Array[Int32] = []
  let n = self.order.length()
  let m = pattern.length()
  if m == 0 || m > n {
    return found
  }
  let mut low = 0
  let mut high = n
  while low < high {
    let mid = (low + high) / 2
    if self.compare_prefix(self.order[mid], pattern) < 0 {
      low = mid + 1
    } else {
      high = mid
    }
  }
  let mut at = low
  while at < n && self.compare_prefix(self.order[at], pattern) == 0 {
    found.push(self.order[at])
    at = at + 1
  }
  found.sort()
  found
}

///|
/// Compares the prefix of suffix `start` with `pattern`, which is what the
/// binary searches order by.
fn SuffixArray::compare_prefix(
  self : SuffixArray,
  start : Int32,
  pattern : StringView,
) -> Int32 {
  let n = self.text_.length()
  let m = pattern.length()
  let mut i = 0
  while i < m {
    if start + i >= n {
      return -1
    }
    let left = unit_at(self.text_[:], start + i)
    let right = unit_at(pattern, i)
    if left < right {
      return -1
    }
    if left > right {
      return 1
    }
    i = i + 1
  }
  0
}

///|
pub fn SuffixArray::length(self : SuffixArray) -> Int32 {
  self.order.length()
}

///|
pub fn SuffixArray::text(self : SuffixArray) -> String {
  self.text_
}

///|
/// The sorted starting offsets of the suffixes.
pub fn SuffixArray::to_array(self : SuffixArray) -> Array[Int32] {
  self.order.copy()
}

///|
/// A suffix automaton: every substring of the text is a path from the start
/// state, and each state remembers how many times the substring it stands for
/// occurs. The build is one pass and the state count is at most twice the text
/// length, which is what makes "how often does this appear" a lookup.
///
/// ```mbt check
/// test {
///   let automaton : @text.SuffixAutomaton = @text.SuffixAutomaton::new("banana")
///   @test.assert_eq(automaton.contains("ana"), true)
///   @test.assert_eq(automaton.count_occurrences("ana"), 2)
///   @test.assert_eq(automaton.contains("band"), false)
/// }
/// ```
pub struct SuffixAutomaton {
  text_ : String
  next : Map[(Int32, Int32), Int32]
  link : Array[Int32]
  length : Array[Int32]
  occurrences : Array[Int32]
  mut last : Int32
}

///|
pub fn SuffixAutomaton::new(text : StringView) -> SuffixAutomaton {
  let automaton : SuffixAutomaton = {
    text_: text.to_owned(),
    next: Map([]),
    link: [-1],
    length: [0],
    occurrences: [0],
    last: 0,
  }
  let n = text.length()
  for i in 0..<n {
    automaton.push_unit(unit_at(text, i).to_int())
  }
  automaton.count_all()
  automaton
}

///|
/// Adds one code unit to the automaton, splitting a state when the new path
/// would otherwise merge two different end positions.
fn SuffixAutomaton::push_unit(self : SuffixAutomaton, code : Int32) -> Unit {
  let current = self.length.length()
  self.length.push(self.length[self.last] + 1)
  self.link.push(-1)
  self.occurrences.push(1)
  let mut p = self.last
  while p >= 0 && !self.next.contains((p, code)) {
    self.next.set((p, code), current)
    p = self.link[p]
  }
  if p < 0 {
    self.link[current] = 0
  } else {
    let target = self.next.get((p, code)).unwrap()
    if self.length[p] + 1 == self.length[target] {
      self.link[current] = target
    } else {
      let clone = self.length.length()
      self.length.push(self.length[p] + 1)
      self.link.push(self.link[target])
      self.occurrences.push(0)
      let moves : Array[(Int32, Int32)] = []
      for ((state, held), to) in self.next.iter() {
        if state == target {
          moves.push((held, to))
        }
      }
      for (held, to) in moves {
        self.next.set((clone, held), to)
      }
      while p >= 0 {
        match self.next.get((p, code)) {
          Some(to) =>
            if to == target {
              self.next.set((p, code), clone)
              p = self.link[p]
            } else {
              p = -1
            }
          None => p = -1
        }
      }
      self.link[target] = clone
      self.link[current] = clone
    }
  }
  self.last = current
}

///|
/// Propagates the occurrence counts from the longest states down, which is what
/// turns the count of "how many paths end here" into "how many times the
/// substring occurs".
fn SuffixAutomaton::count_all(self : SuffixAutomaton) -> Unit {
  let order : Array[Int32] = []
  for state in 0..<self.length.length() {
    order.push(state)
  }
  order.sort_by((a, b) => self.length[b].compare(self.length[a]))
  for state in order {
    let parent = self.link[state]
    if parent >= 0 {
      self.occurrences[parent] = self.occurrences[parent] +
        self.occurrences[state]
    }
  }
}

///|
/// The state a substring leads to, or `None` when it is not a substring.
fn SuffixAutomaton::walk(
  self : SuffixAutomaton,
  pattern : StringView,
) -> Int32? {
  let mut state = 0
  for i in 0..<pattern.length() {
    let code = unit_at(pattern, i).to_int()
    match self.next.get((state, code)) {
      Some(to) => state = to
      None => return None
    }
  }
  Some(state)
}

///|
pub fn SuffixAutomaton::contains(
  self : SuffixAutomaton,
  pattern : StringView,
) -> Bool {
  self.walk(pattern) is Some(_)
}

///|
pub fn SuffixAutomaton::count_occurrences(
  self : SuffixAutomaton,
  pattern : StringView,
) -> Int32 {
  match self.walk(pattern) {
    Some(state) => self.occurrences[state]
    None => 0
  }
}

///|
pub fn SuffixAutomaton::length(self : SuffixAutomaton) -> Int32 {
  self.text_.length()
}

///|
pub fn SuffixAutomaton::text(self : SuffixAutomaton) -> String {
  self.text_
}

///|
/// The longest substring of `other` that also occurs in this automaton, as a
/// half-open range in `other`. One pass over `other`, following the automaton
/// and falling back along the suffix links when a step is missing.
pub fn SuffixAutomaton::longest_common_substring(
  self : SuffixAutomaton,
  other : StringView,
) -> (Int32, Int32) {
  let mut state = 0
  let mut length = 0
  let mut best_start = 0
  let mut best_length = 0
  for i in 0..<other.length() {
    let code = unit_at(other, i).to_int()
    while state != 0 && !self.next.contains((state, code)) {
      state = self.link[state]
      length = self.length[state]
    }
    match self.next.get((state, code)) {
      Some(to) => {
        state = to
        length = length + 1
      }
      None => {
        state = 0
        length = 0
      }
    }
    if length > best_length {
      best_length = length
      best_start = i + 1 - length
    }
  }
  (best_start, best_start + best_length)
}
