// The sequence matcher and the diff formats built on it, following the
// algorithm Python's difflib uses: an index of the elements of the second run, a
// longest-match search that extends around its seed, and the junk heuristics
// that keep a diff readable.

///|
/// What counts as junk, and whether the popular-element heuristic runs.
///
/// `autojunk` is difflib's defence against a diff of a run with hundreds of
/// identical lines: an element of a run of two hundred or more that appears in
/// more than one percent of it is treated as junk, because matching on it would
/// produce a diff no reader can use.
pub(all) struct SequenceMatcherOptions[T] {
  autojunk : Bool
  junk : (T) -> Bool
}

///|
/// The preset: the popular-element heuristic on, and nothing treated as junk.
pub fn[T] sequence_matcher_options() -> SequenceMatcherOptions[T] {
  { autojunk: true, junk: _ => false, }
}

///|
/// One block the two runs share: where it starts in each and how long it is.
#derive(Eq, Debug)
pub(all) struct Match {
  a_start : Int32
  b_start : Int32
  size : Int32
}

///|
pub extend Match with Eq::{equal, not_equal}

///|
pub extend Match with Debug::{to_repr}

///|
/// One step of a diff: what happened to `a[i1..i2]` and `b[j1..j2]`.
#derive(Eq, Debug)
pub(all) enum Opcode {
  Equal(a1~ : Int32, a2~ : Int32, b1~ : Int32, b2~ : Int32)
  Replace(a1~ : Int32, a2~ : Int32, b1~ : Int32, b2~ : Int32)
  Delete(a1~ : Int32, a2~ : Int32, b1~ : Int32, b2~ : Int32)
  Insert(a1~ : Int32, a2~ : Int32, b1~ : Int32, b2~ : Int32)
}

///|
pub extend Opcode with Eq::{equal, not_equal}

///|
pub extend Opcode with Debug::{to_repr}

///|
/// The tag as one word, the way difflib prints it.
pub fn Opcode::tag(self : Opcode) -> String {
  match self {
    Equal(..) => "equal"
    Replace(..) => "replace"
    Delete(..) => "delete"
    Insert(..) => "insert"
  }
}

///|
/// Where the block starts in the first sequence.
pub fn Opcode::a1(self : Opcode) -> Int32 {
  match self {
    Equal(a1~, ..) | Replace(a1~, ..) | Delete(a1~, ..) | Insert(a1~, ..) => a1
  }
}

///|
/// Where the block ends in the first sequence, exclusive.
pub fn Opcode::a2(self : Opcode) -> Int32 {
  match self {
    Equal(a2~, ..) | Replace(a2~, ..) | Delete(a2~, ..) | Insert(a2~, ..) => a2
  }
}

///|
/// Where the block starts in the second sequence.
pub fn Opcode::b1(self : Opcode) -> Int32 {
  match self {
    Equal(b1~, ..) | Replace(b1~, ..) | Delete(b1~, ..) | Insert(b1~, ..) => b1
  }
}

///|
/// Where the block ends in the second sequence, exclusive.
pub fn Opcode::b2(self : Opcode) -> Int32 {
  match self {
    Equal(b2~, ..) | Replace(b2~, ..) | Delete(b2~, ..) | Insert(b2~, ..) => b2
  }
}

///|
/// A matcher over two runs: it indexes the second one, finds the longest block
/// the two share, and reports the matching blocks and the steps between them.
///
/// ```mbt check
/// test {
///   let left : Array[Char] = "abcd".iter().to_array()
///   let right : Array[Char] = "bcde".iter().to_array()
///   let matcher : @text.SequenceMatcher[Char] = @text.SequenceMatcher::new(
///     left[:],
///     right[:],
///   )
///   @test.assert_eq(matcher.ratio() > 0.7, true)
///   let blocks = matcher.get_matching_blocks()
///   @test.assert_eq(blocks.length(), 2)
/// }
/// ```
pub struct SequenceMatcher[T] {
  a : Array[T]
  b : Array[T]
  options : SequenceMatcherOptions[T]
  mut b2j : Map[T, Array[Int32]]
  mut bjunk : Array[Bool]
  mut bpopular : Map[T, Unit]
}

///|
/// A matcher over the two sequences; `options` decides what is junk and, for text, which lines or characters count as such.
pub fn[T : Hash + Eq] SequenceMatcher::new(
  a : ArrayView[T],
  b : ArrayView[T],
  options~ : SequenceMatcherOptions[T] = sequence_matcher_options(),
) -> SequenceMatcher[T] {
  let first : Array[T] = a.to_owned()
  let second : Array[T] = b.to_owned()
  let matcher : SequenceMatcher[T] = {
    a: first,
    b: second,
    options,
    b2j: Map([]),
    bjunk: [],
    bpopular: Map([]),
  }
  matcher.index_b()
  matcher
}

///|
/// Builds the element index and applies the junk heuristics: an element the
/// caller calls junk, and, when `autojunk` is on, one that appears in more than
/// one percent of a run of two hundred or more.
fn[T : Hash + Eq] SequenceMatcher::index_b(self : SequenceMatcher[T]) -> Unit {
  let junk : Array[Bool] = []
  for _ in 0..<self.b.length() {
    junk.push(false)
  }
  let positions : Map[T, Array[Int32]] = Map([])
  for i in 0..<self.b.length() {
    let element = self.b[i]
    if (self.options.junk)(element) {
      junk[i] = true
    } else {
      match positions.get(element) {
        Some(list) => list.push(i)
        None => positions.set(element, [i])
      }
    }
  }
  if self.options.autojunk && self.b.length() >= 200 {
    let threshold = self.b.length() / 100 + 1
    let popular : Map[T, Unit] = Map([])
    for (element, list) in positions.iter() {
      if list.length() > threshold {
        popular.set(element, ())
      }
    }
    for i in 0..<self.b.length() {
      if popular.contains(self.b[i]) {
        junk[i] = true
      }
    }
    for element in popular.keys() {
      positions.remove(element)
    }
  }
  self.b2j = positions
  self.bjunk = junk
  self.bpopular = Map([])
}

///|
/// The longest block shared by `a[alo..ahi]` and `b[blo..bhi]`, as
/// `(a_start, b_start, size)`. The search takes each element of the first run
/// that occurs in the second, walks the positions it holds, and extends the
/// match in both directions, so the result is the same block difflib reports.
pub fn[T : Hash + Eq] SequenceMatcher::find_longest_match(
  self : SequenceMatcher[T],
  alo : Int32,
  ahi : Int32,
  blo : Int32,
  bhi : Int32,
) -> Match {
  let mut best_i = alo
  let mut best_j = blo
  let mut best_size = 0
  let mut j2len : Map[Int32, Int32] = Map([])
  for i in alo..<ahi {
    let element = self.a[i]
    let next : Map[Int32, Int32] = Map([])
    match self.b2j.get(element) {
      Some(positions) =>
        for j in positions {
          if j < blo {
            continue
          }
          if j >= bhi {
            break
          }
          let length = match j2len.get(j - 1) {
            Some(previous) => previous + 1
            None => 1
          }
          next.set(j, length)
          if length > best_size {
            best_i = i + 1 - length
            best_j = j + 1 - length
            best_size = length
          }
        }
      None => ()
    }
    j2len = next
  }
  // Extend over junk at both ends, which is what makes two runs that differ
  // only in blank lines report one match instead of three.
  while best_i > alo && best_j > blo && self.bjunk[best_j - 1] {
    best_i = best_i - 1
    best_j = best_j - 1
    best_size = best_size + 1
  }
  while best_i + best_size < ahi &&
        best_j + best_size < bhi &&
        self.bjunk[best_j + best_size] {
    best_size = best_size + 1
  }
  { a_start: best_i, b_start: best_j, size: best_size, }
}

///|
/// The matching blocks, in order, ending with the empty block at the end of
/// both runs that difflib appends.
pub fn[T : Hash + Eq] SequenceMatcher::get_matching_blocks(
  self : SequenceMatcher[T],
) -> Array[Match] {
  let blocks : Array[Match] = []
  let queue : Array[(Int32, Int32, Int32, Int32)] = [
    (0, self.a.length(), 0, self.b.length()),
  ]
  while queue.length() > 0 {
    let (alo, ahi, blo, bhi) = queue.pop().unwrap()
    let found = self.find_longest_match(alo, ahi, blo, bhi)
    let (i, j, size) = (found.a_start, found.b_start, found.size)
    if size > 0 {
      blocks.push(found)
      if alo < i && blo < j {
        queue.push((alo, i, blo, j))
      }
      if i + size < ahi && j + size < bhi {
        queue.push((i + size, ahi, j + size, bhi))
      }
    }
  }
  blocks.sort_by((left, right) => {
    let order = left.a_start.compare(right.a_start)
    if order != 0 {
      order
    } else {
      left.b_start.compare(right.b_start)
    }
  })
  let merged : Array[Match] = []
  for block in blocks {
    if merged.length() > 0 {
      let last = merged[merged.length() - 1]
      if last.a_start + last.size == block.a_start &&
        last.b_start + last.size == block.b_start {
        merged[merged.length() - 1] = {
          a_start: last.a_start,
          b_start: last.b_start,
          size: last.size + block.size,
        }
        continue
      }
    }
    merged.push(block)
  }
  merged.push({ a_start: self.a.length(), b_start: self.b.length(), size: 0, })
  merged
}

///|
/// The steps a diff is made of: one per gap between the matching blocks.
pub fn[T : Hash + Eq] SequenceMatcher::get_opcodes(
  self : SequenceMatcher[T],
) -> Array[Opcode] {
  let opcodes : Array[Opcode] = []
  let mut i = 0
  let mut j = 0
  for block in self.get_matching_blocks() {
    let (ai, bj, size) = (block.a_start, block.b_start, block.size)
    let tag = if i < ai && j < bj {
      Some(Replace(a1=i, a2=ai, b1=j, b2=bj))
    } else if i < ai {
      Some(Delete(a1=i, a2=ai, b1=j, b2=bj))
    } else if j < bj {
      Some(Insert(a1=i, a2=ai, b1=j, b2=bj))
    } else {
      None
    }
    match tag {
      Some(opcode) => opcodes.push(opcode)
      None => ()
    }
    if size > 0 {
      opcodes.push(Equal(a1=ai, a2=ai + size, b1=bj, b2=bj + size))
    }
    i = ai + size
    j = bj + size
  }
  opcodes
}

///|
/// Twice the number of matched elements over the total, which is one when the
/// runs are equal and zero when they share nothing.
pub fn[T : Hash + Eq] SequenceMatcher::ratio(
  self : SequenceMatcher[T],
) -> Double {
  let mut matches = 0
  for block in self.get_matching_blocks() {
    matches = matches + block.size
  }
  let total = self.a.length() + self.b.length()
  if total == 0 {
    1.0
  } else {
    2.0 * matches.to_double() / total.to_double()
  }
}

///|
/// An upper bound on the ratio that costs one pass: the elements of the first
/// run that the second one holds at all.
pub fn[T : Hash + Eq] SequenceMatcher::quick_ratio(
  self : SequenceMatcher[T],
) -> Double {
  let available : Map[T, Int32] = Map([])
  for element in self.b {
    match available.get(element) {
      Some(count) => available.set(element, count + 1)
      None => available.set(element, 1)
    }
  }
  let mut matches = 0
  for element in self.a {
    match available.get(element) {
      Some(count) =>
        if count > 0 {
          matches = matches + 1
          available.set(element, count - 1)
        }
      None => ()
    }
  }
  let total = self.a.length() + self.b.length()
  if total == 0 {
    1.0
  } else {
    2.0 * matches.to_double() / total.to_double()
  }
}

///|
/// The cheapest of the three ratios, which only looks at the two lengths.
pub fn[T] SequenceMatcher::real_quick_ratio(
  self : SequenceMatcher[T],
) -> Double {
  let total = self.a.length() + self.b.length()
  if total == 0 {
    1.0
  } else {
    2.0 *
    (if self.a.length() < self.b.length() {
      self.a.length()
    } else {
      self.b.length()
    }).to_double() /
    total.to_double()
  }
}

///|
/// Whether a line carries nothing a reader would miss: a blank line or a line
/// that is only a comment marker, which is difflib's `IS_LINE_JUNK`.
pub fn is_line_junk(line : StringView) -> Bool {
  let trimmed = line.to_owned().trim()
  trimmed.length() == 0 || trimmed == "#"
}

///|
/// Whether a character is junk in a character diff: whitespace, which difflib
/// treats as noise when it diffs text rather than lines.
pub fn is_character_junk(ch : Char) -> Bool {
  // Space, tab, carriage return, vertical tab, form feed and newline, by code
  // point so the source holds no control characters.
  let code = ch.to_int()
  code == 32 ||
  code == 9 ||
  code == 10 ||
  code == 11 ||
  code == 12 ||
  code == 13
}

///|
/// The lines of a text, without their breaks, which is what the diff formats
/// take.
pub fn lines_of(text : StringView) -> Array[StringView] {
  let out : Array[StringView] = []
  let mut start = 0
  for i in 0..<text.length() {
    if text.unsafe_get(i) == 0x000A {
      out.push(text[start:i])
      start = i + 1
    }
  }
  if start < text.length() {
    out.push(text[start:])
  }
  out
}

///|
/// A unified diff: the two file headers, then each hunk with `n` lines of
/// context, the way `diff -u` and difflib's `unified_diff` write it.
pub fn unified_diff(
  a : StringView,
  b : StringView,
  fromfile~ : StringView = "",
  tofile~ : StringView = "",
  n~ : Int32 = 3,
) -> String {
  let left = lines_of(a)
  let right = lines_of(b)
  let matcher : SequenceMatcher[StringView] = SequenceMatcher::new(
    left[:],
    right[:],
  )
  let opcodes = matcher.get_opcodes()
  let out = StringBuilder()
  out.write_string("--- \{fromfile}\n")
  out.write_string("+++ \{tofile}\n")
  let mut group : Array[Opcode] = []
  let groups : Array[Array[Opcode]] = []
  for opcode in opcodes {
    if opcode.tag() == "equal" && opcode.a2() - opcode.a1() > 2 * n {
      group.push(
        Equal(
          a1=opcode.a1(),
          a2=opcode.a1() + n,
          b1=opcode.b1(),
          b2=opcode.b1() + n,
        ),
      )
      groups.push(group)
      group = []
      group.push(
        Equal(
          a1=opcode.a2() - n,
          a2=opcode.a2(),
          b1=opcode.b2() - n,
          b2=opcode.b2(),
        ),
      )
    } else {
      group.push(opcode)
    }
  }
  if group.length() > 0 && !(group.length() == 1 && group[0].tag() == "equal") {
    groups.push(group)
  }
  let mut first = true
  for items in groups {
    if items.length() == 0 {
      continue
    }
    let head = items[0]
    let tail = items[items.length() - 1]
    if first && head.tag() == "equal" {
      first = false
    }
    out.write_string(
      "@@ -\{head.a1() + 1},\{tail.a2() - head.a1()} +\{head.b1() + 1},\{tail.b2() - head.b1()} @@\n",
    )
    for opcode in items {
      match opcode.tag() {
        "equal" =>
          for i in opcode.a1()..<opcode.a2() {
            out.write_string(" ")
            out.write_string(left[i].to_owned())
            out.write_string("\n")
          }
        "delete" =>
          for i in opcode.a1()..<opcode.a2() {
            out.write_string("-")
            out.write_string(left[i].to_owned())
            out.write_string("\n")
          }
        "insert" =>
          for j in opcode.b1()..<opcode.b2() {
            out.write_string("+")
            out.write_string(right[j].to_owned())
            out.write_string("\n")
          }
        _ => {
          for i in opcode.a1()..<opcode.a2() {
            out.write_string("-")
            out.write_string(left[i].to_owned())
            out.write_string("\n")
          }
          for j in opcode.b1()..<opcode.b2() {
            out.write_string("+")
            out.write_string(right[j].to_owned())
            out.write_string("\n")
          }
        }
      }
    }
  }
  out.to_string()
}

///|
/// A context diff: the same idea as the unified one, with the older `***` and
/// `---` hunk headers and the `!` marker for a replaced line.
pub fn context_diff(
  a : StringView,
  b : StringView,
  fromfile~ : StringView = "",
  tofile~ : StringView = "",
  n~ : Int32 = 3,
) -> String {
  let left = lines_of(a)
  let right = lines_of(b)
  let matcher : SequenceMatcher[StringView] = SequenceMatcher::new(
    left[:],
    right[:],
  )
  let opcodes = matcher.get_opcodes()
  let out = StringBuilder()
  out.write_string("*** \{fromfile}\n")
  out.write_string("--- \{tofile}\n")
  let mut prefix : Array[Opcode] = []
  let mut changed : Array[Opcode] = []
  let mut first = true
  for opcode in opcodes {
    if opcode.tag() == "equal" && opcode.a2() - opcode.a1() > 2 * n {
      let head = Equal(
        a1=opcode.a1(),
        a2=opcode.a1() + n,
        b1=opcode.b1(),
        b2=opcode.b1() + n,
      )
      let tail = Equal(
        a1=opcode.a2() - n,
        a2=opcode.a2(),
        b1=opcode.b2() - n,
        b2=opcode.b2(),
      )
      if changed.length() > 0 || prefix.length() > 0 {
        emit_context_hunk(out, prefix, changed, head, left, right, first)
        first = false
      }
      prefix = [tail]
      changed = []
    } else if opcode.tag() == "equal" {
      prefix.push(opcode)
    } else {
      changed.push(opcode)
    }
  }
  if changed.length() > 0 {
    emit_context_hunk(
      out,
      prefix,
      changed,
      Equal(a1=0, a2=0, b1=0, b2=0),
      left,
      right,
      first,
    )
  }
  out.to_string()
}

///|
/// Writes one context hunk: the `***` range with the old lines, then the `---`
/// range with the new ones.
fn emit_context_hunk(
  out : StringBuilder,
  prefix : Array[Opcode],
  changed : Array[Opcode],
  suffix : Opcode,
  left : Array[StringView],
  right : Array[StringView],
  first : Bool,
) -> Unit {
  let mut a_start = -1
  let mut a_end = -1
  let mut b_start = -1
  let mut b_end = -1
  for opcode in prefix {
    if a_start < 0 {
      a_start = opcode.a1()
      b_start = opcode.b1()
    }
    a_end = opcode.a2()
    b_end = opcode.b2()
  }
  for opcode in changed {
    if a_start < 0 {
      a_start = opcode.a1()
      b_start = opcode.b1()
    }
    a_end = opcode.a2()
    b_end = opcode.b2()
  }
  if suffix.a2() > 0 {
    if a_start < 0 {
      a_start = suffix.a1()
      b_start = suffix.b1()
    }
    a_end = suffix.a2()
    b_end = suffix.b2()
  }
  if a_start < 0 {
    return
  }
  let _ = first
  out.write_string("*** \{a_start + 1},\{a_end} ****\n")
  for opcode in prefix {
    for i in opcode.a1()..<opcode.a2() {
      out.write_string("  \{left[i].to_owned()}\n")
    }
  }
  for opcode in changed {
    let marker = if opcode.tag() == "delete" { "- " } else { "! " }
    for i in opcode.a1()..<opcode.a2() {
      out.write_string("\{marker}\{left[i].to_owned()}\n")
    }
  }
  if suffix.a2() > 0 {
    for i in suffix.a1()..<suffix.a2() {
      out.write_string("  \{left[i].to_owned()}\n")
    }
  }
  out.write_string("--- \{b_start + 1},\{b_end} ----\n")
  for opcode in prefix {
    for j in opcode.b1()..<opcode.b2() {
      out.write_string("  \{right[j].to_owned()}\n")
    }
  }
  for opcode in changed {
    let marker = if opcode.tag() == "insert" { "+ " } else { "! " }
    for j in opcode.b1()..<opcode.b2() {
      out.write_string("\{marker}\{right[j].to_owned()}\n")
    }
  }
  if suffix.b2() > 0 {
    for j in suffix.b1()..<suffix.b2() {
      out.write_string("  \{right[j].to_owned()}\n")
    }
  }
}

///|
/// The `ndiff` form: every line of either file, marked with `- `, `+ ` or `  `.
pub fn ndiff(a : StringView, b : StringView) -> String {
  let left = lines_of(a)
  let right = lines_of(b)
  let matcher : SequenceMatcher[StringView] = SequenceMatcher::new(
    left[:],
    right[:],
  )
  let out = StringBuilder()
  for opcode in matcher.get_opcodes() {
    match opcode.tag() {
      "equal" =>
        for i in opcode.a1()..<opcode.a2() {
          out.write_string("  \{left[i].to_owned()}\n")
        }
      "delete" =>
        for i in opcode.a1()..<opcode.a2() {
          out.write_string("- \{left[i].to_owned()}\n")
        }
      "insert" =>
        for j in opcode.b1()..<opcode.b2() {
          out.write_string("+ \{right[j].to_owned()}\n")
        }
      _ => {
        for i in opcode.a1()..<opcode.a2() {
          out.write_string("- \{left[i].to_owned()}\n")
        }
        for j in opcode.b1()..<opcode.b2() {
          out.write_string("+ \{right[j].to_owned()}\n")
        }
      }
    }
  }
  out.to_string()
}

///|
/// The lines of a diff with their markers removed, which is how a diff is turned
/// back into the text it describes.
pub fn restore(diff : StringView) -> String {
  let out = StringBuilder()
  for line in lines_of(diff) {
    if line.length() >= 2 {
      let first = line.unsafe_get(0)
      if first == 0x0020 || first == 0x002D || first == 0x002B {
        out.write_string(line[2:].to_owned())
        out.write_string("\n")
      }
    }
  }
  out.to_string()
}

///|
/// The `n` strings of `possibilities` closest to `word`, each scoring at least
/// `cutoff` with the two runs read as character sequences.
pub fn get_close_matches(
  word : StringView,
  possibilities : ArrayView[StringView],
  n~ : Int32 = 3,
  cutoff~ : Double = 0.6,
) -> Array[StringView] {
  let target : Array[Char] = word.to_owned().iter().to_array()
  let scored : Array[(Double, Int32, StringView)] = []
  for i, candidate in possibilities {
    let chars : Array[Char] = candidate.to_owned().iter().to_array()
    let matcher : SequenceMatcher[Char] = SequenceMatcher::new(
      target[:],
      chars[:],
    )
    let score = matcher.ratio()
    if score >= cutoff {
      scored.push((score, i, candidate))
    }
  }
  scored.sort_by((a, b) => {
    let order = b.0.compare(a.0)
    if order != 0 {
      order
    } else {
      a.1.compare(b.1)
    }
  })
  let out : Array[StringView] = []
  let limit = if n < 0 {
    0
  } else if n > scored.length() {
    scored.length()
  } else {
    n
  }
  for i in 0..<limit {
    out.push(scored[i].2)
  }
  out
}
