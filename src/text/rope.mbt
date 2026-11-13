// Text storage: a rope of chunks with the offsets prefix-summed beside them.
//
// The chunks are a plain array rather than a balanced tree: an edit rebuilds the
// prefix sums, which is O(chunks) rather than O(log n). What that buys is the
// whole surface in one file and no rebalancing to get wrong. A document that is
// edited a million times wants the tree; one that is read far more than it is
// written does not notice the difference, because the chunk count stays small.

///|
/// A rope keeps its text in chunks and remembers where each chunk starts, so an
/// offset can be found without flattening the whole document. Offsets are UTF-16
/// code units, as `String` counts them, and an edit that would split a surrogate
/// pair is refused.
///
/// ```mbt check
/// test {
///   let rope : @text.Rope = @text.Rope::from_string("hello world")
///   rope.insert(5, ",")
///   assert_true(rope.to_string() == "hello, world")
///   rope.edit(start=0, end=5, "goodbye")
///   assert_true(rope.to_string() == "goodbye, world")
///   assert_true(rope.length() == 14)
/// }
/// ```
pub struct Rope {
  chunks : Array[String]
  /// `starts[i]` is the offset of chunk `i`; the last entry is the total.
  mut starts : Array[Int32]
}

///|
/// An empty rope.
pub fn Rope::new() -> Rope {
  { chunks: [], starts: [0], }
}

///|
/// A rope holding `text` as one chunk.
pub fn Rope::from_string(text : StringView) -> Rope {
  let chunks : Array[String] = []
  if text.length() > 0 {
    chunks.push(text.to_owned())
  }
  { chunks, starts: [0, text.length()], }
}

///|
/// Rebuilds the prefix sums after the chunk list changed.
fn Rope::reindex(self : Rope) -> Unit {
  let starts : Array[Int32] = []
  let mut at = 0
  for chunk in self.chunks {
    starts.push(at)
    at = at + chunk.length()
  }
  starts.push(at)
  self.starts = starts
}

///|
/// The total length in code units.
pub fn Rope::length(self : Rope) -> Int32 {
  self.starts[self.starts.length() - 1]
}

///|
/// Whether the rope holds no text.
pub fn Rope::is_empty(self : Rope) -> Bool {
  self.length() == 0
}

///|
/// The index of the chunk that holds the code unit at `offset`, which is the
/// last chunk that starts at or before it.
fn Rope::chunk_of(self : Rope, offset : Int32) -> Int32 {
  let count = self.chunks.length()
  if count == 0 {
    return -1
  }
  let mut low = 0
  let mut high = count - 1
  while low < high {
    let mid = (low + high + 1) / 2
    if self.starts[mid] <= offset {
      low = mid
    } else {
      high = mid - 1
    }
  }
  low
}

///|
/// The character at `offset`, or `None` when the offset is past the end. An
/// offset in the middle of a surrogate pair yields the pair's low half, because
/// the rope has no way to name half a character.
pub fn Rope::char_at(self : Rope, offset : Int32) -> Char? {
  if offset < 0 || offset >= self.length() {
    return None
  }
  let at = self.chunk_of(offset)
  if at < 0 {
    return None
  }
  let inside = offset - self.starts[at]
  let chunk = self.chunks[at]
  chunk.get_char(inside)
}

///|
/// The text between two offsets, as a view that reads the chunks without
/// copying them.
pub fn Rope::slice(self : Rope, start~ : Int32, end~ : Int32) -> RopeView {
  let from = if start < 0 { 0 } else { start }
  let to = if end > self.length() { self.length() } else { end }
  if from >= to {
    return { rope: self.copy(), start: from, end: from, }
  }
  { rope: self.copy(), start: from, end: to, }
}

///|
/// Inserts text at `offset`, appending to the chunk that ends there so that
/// typing at the same place does not shatter the document into one chunk per
/// keystroke.
pub fn Rope::insert(self : Rope, offset : Int32, text : StringView) -> Unit {
  if text.length() == 0 {
    return
  }
  let at = if offset <= 0 { 0 } else { self.chunk_of(offset) }
  if self.chunks.length() == 0 {
    self.chunks.push(text.to_owned())
    self.reindex()
    return
  }
  let inside = offset - self.starts[at]
  let chunk = self.chunks[at]
  let boundary = inside == 0 || splits_pair(chunk[:], inside)
  if boundary && inside == 0 && at > 0 {
    // The offset sits between two chunks: grow the one before it.
    self.chunks[at - 1] = self.chunks[at - 1] + text.to_owned()
  } else {
    let head = chunk[:inside].to_owned()
    let tail = chunk[inside:].to_owned()
    self.chunks[at] = head + text.to_owned() + tail
  }
  self.reindex()
}

///|
/// Adds `text` at the end; the same as inserting at `length`.
pub fn Rope::append(self : Rope, text : StringView) -> Unit {
  self.insert(self.length(), text)
}

///|
/// Removes `[start, end)`.
pub fn Rope::remove(self : Rope, start~ : Int32, end~ : Int32) -> Unit {
  let from = if start < 0 { 0 } else { start }
  let to = if end > self.length() { self.length() } else { end }
  if from >= to {
    return
  }
  let first = self.chunk_of(from)
  let last = self.chunk_of(to - 1)
  let head = self.chunks[first][:from - self.starts[first]].to_owned()
  let tail = self.chunks[last][to - self.starts[last]:].to_owned()
  let replacement = head + tail
  let kept : Array[String] = []
  for i in 0..<first {
    kept.push(self.chunks[i])
  }
  if replacement.length() > 0 {
    kept.push(replacement)
  }
  let mut i = last + 1
  while i < self.chunks.length() {
    kept.push(self.chunks[i])
    i = i + 1
  }
  if false {
    let i = 0
    kept.push(self.chunks[i])
  }
  self.chunks.clear()
  for chunk in kept {
    self.chunks.push(chunk)
  }
  self.reindex()
}

///|
/// Replaces `[start, end)` with `text`, which is what an editor does on every
/// keystroke and paste.
pub fn Rope::edit(
  self : Rope,
  start~ : Int32,
  end~ : Int32,
  text : StringView,
) -> Unit {
  self.remove(start~, end~)
  self.insert(start, text)
}

///|
/// The offsets at which each line starts, plus one past the end.
pub fn Rope::line_starts(self : Rope) -> Array[Int32] {
  let out : Array[Int32] = [0]
  let mut offset = 0
  for chunk in self.chunks {
    for i in 0..<chunk.length() {
      if chunk.unsafe_get(i) == 0x000A {
        out.push(offset + i + 1)
      }
    }
    offset = offset + chunk.length()
  }
  out
}

///|
/// The number of lines, which is one more than the number of line breaks.
pub fn Rope::line_count(self : Rope) -> Int32 {
  self.line_starts().length()
}

///|
/// The line a code unit belongs to.
pub fn Rope::line_at(self : Rope, offset : Int32) -> Int32 {
  let starts = self.line_starts()
  let mut low = 0
  let mut high = starts.length() - 1
  while low < high {
    let mid = (low + high + 1) / 2
    if starts[mid] <= offset {
      low = mid
    } else {
      high = mid - 1
    }
  }
  low
}

///|
/// The offset a line starts at.
pub fn Rope::line_start(self : Rope, line : Int32) -> Int32 {
  let starts = self.line_starts()
  if line < 0 {
    0
  } else if line >= starts.length() {
    self.length()
  } else {
    starts[line]
  }
}

///|
/// The number of characters rather than code units, which differs when the text
/// carries surrogate pairs.
pub fn Rope::char_length(self : Rope) -> Int32 {
  let mut total = 0
  for chunk in self.chunks {
    total = total + chunk.iter().count()
  }
  total
}

///|
/// The characters in order, one per code point rather than per code unit.
pub fn Rope::chars(self : Rope) -> Iter[Char] {
  let units = self.to_string()
  units.iter()
}

///|
/// The chunks as views, which is what a matcher walks when it does not need the
/// text flattened.
pub fn Rope::chunks(self : Rope) -> Iter[StringView] {
  let snapshot = self.copy()
  let mut cursor = 0
  Iter::new(() => {
    if cursor >= snapshot.chunks.length() {
      None
    } else {
      let chunk = snapshot.chunks[cursor][:]
      cursor = cursor + 1
      Some(chunk)
    }
  })
}

///|
/// The lines, without their line breaks.
pub fn Rope::lines(self : Rope) -> Iter[StringView] {
  let text = self.to_string()
  let starts = self.line_starts()
  let mut cursor = 0
  Iter::new(() => {
    if cursor >= starts.length() {
      None
    } else {
      let from = starts[cursor]
      let to = if cursor + 1 < starts.length() {
        starts[cursor + 1]
      } else {
        text.length()
      }
      cursor = cursor + 1
      // The break itself is not part of the line.
      let end = if to > from && text.unsafe_get(to - 1) == 0x000A {
        to - 1
      } else {
        to
      }
      Some(text[:][from:end])
    }
  })
}

///|
/// The whole text, flattened into one string.
pub fn Rope::to_string(self : Rope) -> String {
  let out = StringBuilder()
  for chunk in self.chunks {
    out.write_string(chunk)
  }
  out.to_string()
}

///|
/// Writes the text into `out` chunk by chunk, without flattening it first.
pub fn Rope::write_to(self : Rope, out : StringBuilder) -> Unit {
  for chunk in self.chunks {
    out.write_string(chunk)
  }
}

///|
/// Cuts the rope at `offset` and returns the tail.
pub fn Rope::split_off(self : Rope, offset : Int32) -> Rope {
  let tail = self.slice(start=offset, end=self.length())
  let tail_rope = tail.to_rope()
  self.remove(start=offset, end=self.length())
  tail_rope
}

///|
/// A copy that owns its chunks: an edit to either rope leaves the other alone.
pub fn Rope::copy(self : Rope) -> Rope {
  { chunks: self.chunks.copy(), starts: self.starts.copy(), }
}

///|
/// Removes all text, leaving an empty rope.
pub fn Rope::clear(self : Rope) -> Unit {
  self.chunks.clear()
  self.starts = [0]
}

///|
/// A window into a rope. It holds its own copy of the rope's chunk list, so an
/// edit to the rope does not move the text under the window.
///
/// ```mbt check
/// test {
///   let rope : @text.Rope = @text.Rope::from_string("abcdef")
///   let window = rope.slice(start=2, end=4)
///   assert_true(window.to_string() == "cd")
///   assert_true(window.length() == 2)
/// }
/// ```
pub struct RopeView {
  rope : Rope
  start : Int32
  end : Int32
}

///|
/// How many UTF-16 code units the view covers.
pub fn RopeView::length(self : RopeView) -> Int32 {
  self.end - self.start
}

///|
/// How many characters the view covers, which is fewer than the code units when the text carries surrogate pairs.
pub fn RopeView::char_length(self : RopeView) -> Int32 {
  self.to_string().iter().count()
}

///|
/// A view of the part from `start` up to `end`, clamped to what this view already covers.
pub fn RopeView::slice(
  self : RopeView,
  start~ : Int32,
  end~ : Int32,
) -> RopeView {
  let from = self.start + (if start < 0 { 0 } else { start })
  let to = self.start + (if end > self.length() { self.length() } else { end })
  { rope: self.rope, start: from, end: to, }
}

///|
/// The part of the text the view covers, as a new string.
pub fn RopeView::to_string(self : RopeView) -> String {
  let out = StringBuilder()
  let mut offset = 0
  for chunk in self.rope.chunks {
    let chunk_start = offset
    let chunk_end = offset + chunk.length()
    offset = chunk_end
    if chunk_end <= self.start || chunk_start >= self.end {
      continue
    }
    let from = if self.start > chunk_start {
      self.start - chunk_start
    } else {
      0
    }
    let to = if self.end < chunk_end {
      self.end - chunk_start
    } else {
      chunk.length()
    }
    out.write_string(chunk[from:to].to_owned())
  }
  out.to_string()
}

///|
/// The characters the view covers, in order.
pub fn RopeView::chars(self : RopeView) -> Iter[Char] {
  self.to_string().iter()
}

///|
/// The lines the view covers, without their line breaks.
pub fn RopeView::lines(self : RopeView) -> Iter[StringView] {
  self.to_rope().lines()
}

///|
/// The window as a rope of its own.
pub fn RopeView::to_rope(self : RopeView) -> Rope {
  Rope::from_string(self.to_string()[:])
}

///|
/// Builds a rope by appending, which is what a reader or a parser wants: one
/// chunk per append, and one reindex at the end.
///
/// ```mbt check
/// test {
///   let builder : @text.RopeBuilder = @text.RopeBuilder::new()
///   builder.append("one ")
///   builder.append("two")
///   let rope = builder.finish()
///   assert_true(rope.to_string() == "one two")
/// }
/// ```
pub struct RopeBuilder {
  chunks : Array[String]
}

///|
/// An empty builder.
pub fn RopeBuilder::new() -> RopeBuilder {
  { chunks: [], }
}

///|
/// Adds text to the end of what the builder has gathered.
pub fn RopeBuilder::append(self : RopeBuilder, text : StringView) -> Unit {
  if text.length() > 0 {
    self.chunks.push(text.to_owned())
  }
}

///|
/// The rope the builder has gathered.
pub fn RopeBuilder::finish(self : RopeBuilder) -> Rope {
  let rope : Rope = { chunks: self.chunks.copy(), starts: [0], }
  rope.reindex()
  rope
}
