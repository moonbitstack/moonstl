///|
/// Many patterns matched in one pass: a trie whose nodes also carry failure
/// links, so the text is read once and every occurrence is reported as soon as
/// its last code unit is read. Overlapping matches all appear, including
/// suffixes of longer ones, which the output chain walks without visiting nodes
/// that match nothing. Build is O(total pattern length), search O(n + matches).
///
/// Matches come out in text order of their last code unit, longest first among
/// those that end at the same place. A zero-length pattern is reported at every
/// offset, before the matches ending at that offset.
///
/// ```mbt check
/// test {
///   let ac = @text.AhoCorasick::new(["he", "she", "his", "hers"])
///   @test.assert_eq(ac.search_all("ushers").to_array(), [(1, 1), (0, 2), (3, 2)])
///   assert_true(ac.is_match("ushers"))
///   assert_false(ac.is_match("us"))
/// }
/// ```
pub struct AhoCorasick {
  /// Length of each pattern, so an occurrence's offset can be recovered from
  /// the position its last code unit was read at.
  lengths : Array[Int32]
  /// Trie edges, keyed by `(node, code unit)`; this is the transition table a
  /// search uses, so a node with many children is never scanned.
  next : Map[(Int32, Int32), Int32]
  /// The same edges grouped by their source node, which only `build` needs.
  children : Array[Array[(Int32, Int32)]]
  /// Failure link: the longest proper suffix of the node's string that is also
  /// a prefix of some pattern.
  fail : Array[Int32]
  /// Head of the list of pattern indices ending at a node, or -1.
  out_head : Array[Int32]
  /// Tail of that list, so matches come out in the order the patterns were
  /// added.
  out_tail : Array[Int32]
  /// Next pattern index in the same node's list, or -1.
  out_next : Array[Int32]
  /// Nearest failure ancestor with output, or -1.
  dict : Array[Int32]
  mut built : Bool
}

///|
/// Build an automaton for `patterns`, in the order they appear in the array:
/// the index `search_all` reports is the index in this array.
pub fn AhoCorasick::new(patterns : Array[StringView]) -> AhoCorasick {
  let ac = AhoCorasick::{
    lengths: [],
    next: Map([]),
    children: [[]],
    fail: [0],
    out_head: [-1],
    out_tail: [-1],
    out_next: [],
    dict: [-1],
    built: false,
  }
  for pattern in patterns {
    ac.add(pattern) |> ignore
  }
  ac.build()
  ac
}

///|
fn AhoCorasick::push_node(self : AhoCorasick) -> Int32 {
  self.children.push([])
  self.fail.push(0)
  self.out_head.push(-1)
  self.out_tail.push(-1)
  self.dict.push(-1)
  self.children.length() - 1
}

///|
/// Add one pattern and return its index, which is what `search_all` reports.
/// Patterns may be added between searches; the links are rebuilt lazily.
pub fn AhoCorasick::add(self : AhoCorasick, pattern : StringView) -> Int32 {
  let index = self.lengths.length()
  self.lengths.push(pattern.length())
  let mut node = 0
  for i in 0..<pattern.length() {
    let code = key_at(pattern, i)
    let child = match self.next.get((node, code)) {
      Some(child) => child
      None => {
        let child = self.push_node()
        self.next.set((node, code), child)
        self.children[node].push((code, child))
        child
      }
    }
    node = child
  }
  self.out_next.push(-1)
  if self.out_head[node] < 0 {
    self.out_head[node] = index
  } else {
    self.out_next[self.out_tail[node]] = index
  }
  self.out_tail[node] = index
  self.built = false
  index
}

///|
/// Fill in the failure and output links in O(nodes + edges). Calling it twice
/// is harmless; a search calls it when a pattern was added after the last
/// build.
pub fn AhoCorasick::build(self : AhoCorasick) -> Unit {
  let count = self.children.length()
  for node in 0..<count {
    self.fail[node] = 0
    self.dict[node] = -1
  }
  let queue : Array[Int32] = []
  for edge in self.children[0] {
    queue.push(edge.1)
  }
  let mut head = 0
  while head < queue.length() {
    let node = queue[head]
    head = head + 1
    for edge in self.children[node] {
      let code = edge.0
      let child = edge.1
      let mut parent = self.fail[node]
      let mut target = -1
      let mut searching = true
      while searching {
        match self.next.get((parent, code)) {
          Some(found) => {
            if found != child {
              target = found
            }
            searching = false
          }
          None =>
            if parent == 0 {
              searching = false
            } else {
              parent = self.fail[parent]
            }
        }
      }
      self.fail[child] = if target < 0 { 0 } else { target }
      self.dict[child] = if self.out_head[self.fail[child]] >= 0 {
        self.fail[child]
      } else {
        self.dict[self.fail[child]]
      }
      queue.push(child)
    }
  }
  self.built = true
}

///|
/// The scan state of `search_all`: one text position, the trie node reached,
/// and the output list currently being drained.
priv struct AcScan {
  ac : AhoCorasick
  text : StringView
  mut pos : Int32
  mut state : Int32
  mut out_node : Int32
  mut out_last : Int32
  mut at_root : Bool
}

///|
fn AcScan::next_match(self : AcScan) -> (Int32, Int32)? {
  let n = self.text.length()
  while true {
    if self.out_node >= 0 {
      let pattern = if self.out_last < 0 {
        self.ac.out_head[self.out_node]
      } else {
        self.ac.out_next[self.out_last]
      }
      if pattern >= 0 {
        self.out_last = pattern
        return Some((pattern, self.pos - self.ac.lengths[pattern]))
      }
      self.out_node = self.ac.dict[self.out_node]
      self.out_last = -1
      continue
    }
    if !self.at_root {
      self.at_root = true
      if self.ac.out_head[0] >= 0 {
        self.out_node = 0
        continue
      }
    }
    if self.pos >= n {
      return None
    }
    let code = key_at(self.text, self.pos)
    self.pos = self.pos + 1
    while true {
      match self.ac.next.get((self.state, code)) {
        Some(child) => {
          self.state = child
          break
        }
        None =>
          if self.state == 0 {
            break
          } else {
            self.state = self.ac.fail[self.state]
          }
      }
    }
    self.at_root = false
    self.out_node = if self.ac.out_head[self.state] >= 0 {
      self.state
    } else {
      self.ac.dict[self.state]
    }
    self.out_last = -1
  }
  None
}

///|
/// Every `(pattern index, offset)` the automaton finds, as a lazy iterator that
/// reads the text once. The index is the one `add` returned.
pub fn AhoCorasick::search_all(
  self : AhoCorasick,
  text : StringView,
) -> Iter[(Int32, Int32)] {
  if !self.built {
    self.build()
  }
  let scan = AcScan::{
    ac: self,
    text,
    pos: 0,
    state: 0,
    out_node: -1,
    out_last: -1,
    at_root: false,
  }
  Iter::new(fn() { scan.next_match() })
}

///|
/// Whether any pattern occurs in `text`, stopping at the first one found.
pub fn AhoCorasick::is_match(self : AhoCorasick, text : StringView) -> Bool {
  if !self.built {
    self.build()
  }
  let n = text.length()
  let mut state = 0
  for i in 0..<n {
    let code = key_at(text, i)
    while true {
      match self.next.get((state, code)) {
        Some(child) => {
          state = child
          break
        }
        None => if state == 0 { break } else { state = self.fail[state] }
      }
    }
    if self.out_head[state] >= 0 || self.dict[state] >= 0 {
      return true
    }
  }
  false
}
