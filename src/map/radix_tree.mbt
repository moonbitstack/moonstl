///|
/// The characters of a key, so that a prefix walk never pays for a substring.
fn radix_chars(text : StringView) -> Array[Char] {
  text.to_owned().iter().to_array()
}

///|
/// How many leading characters two keys share.
fn radix_common(a : Array[Char], b : Array[Char]) -> Int32 {
  let limit = if a.length() < b.length() { a.length() } else { b.length() }
  let mut i = 0
  while i < limit && a[i] == b[i] {
    i = i + 1
  }
  i
}

///|
/// The characters from `start` on, as a key of its own.
fn radix_slice(chars : Array[Char], start : Int32) -> Array[Char] {
  let tail : Array[Char] = []
  for i in start..<chars.length() {
    tail.push(chars[i])
  }
  tail
}

///|
/// A key made of characters, ready to be printed.
fn radix_text(chars : ArrayView[Char]) -> String {
  String::from_iter(chars.iter())
}

///|
/// A trie with its chains of single-child nodes collapsed into one edge per
/// label: a lookup compares whole labels instead of single characters, which is
/// what keeps a tree over long shared prefixes shallow. The surface is the
/// `Trie` surface, plus the queries that only make sense over a compressed tree:
/// the keys that are prefixes of a given key, a count of the keys under a
/// prefix, and a scan of that subtree.
///
/// ```mbt check
/// test {
///   let tree : @map.RadixTree[Int32] = @map.RadixTree::new()
///   @test.assert_eq(tree.insert("car", 1), None)
///   @test.assert_eq(tree.insert("cart", 2), None)
///   @test.assert_eq(tree.insert("cat", 3), None)
///   @test.assert_eq(tree.get("cart"), Some(2))
///   @test.assert_eq(tree.get_ancestor_keys("cartoon"), ["car", "cart"])
///   @test.assert_eq(tree.prefix_count("ca"), 3)
/// }
/// ```
pub struct RadixTree[T] {
  /// The label of the edge that leads to each node from its parent.
  labels : Array[Array[Char]]
  /// The children of each node, keyed by the first character of their label.
  children : Array[Map[Char, Int32]]
  values : Array[T?]
  mut entries : Int32
}

///|
pub fn[T] RadixTree::new() -> RadixTree[T] {
  { labels: [[]], children: [Map([])], values: [None], entries: 0, }
}

///|
fn[T] RadixTree::add_node(
  self : RadixTree[T],
  label : Array[Char],
  value : T?,
) -> Int32 {
  let node = self.labels.length()
  self.labels.push(label)
  self.children.push(Map([]))
  self.values.push(value)
  node
}

///|
/// Stores `value` under `key` and returns what the key held before.
pub fn[T] RadixTree::insert(
  self : RadixTree[T],
  key : StringView,
  value : T,
) -> T? {
  let chars = radix_chars(key)
  let mut node = 0
  let mut rest = chars
  while true {
    if rest.length() == 0 {
      let old = self.values[node]
      self.values[node] = Some(value)
      if old is None {
        self.entries = self.entries + 1
      }
      return old
    }
    let first = rest[0]
    match self.children[node].get(first) {
      None => {
        let leaf = self.add_node(rest, Some(value))
        self.children[node].set(first, leaf)
        self.entries = self.entries + 1
        return None
      }
      Some(child) => {
        let label = self.labels[child]
        let common = radix_common(label, rest)
        if common == label.length() {
          node = child
          rest = radix_slice(rest, common)
          continue
        }
        let mid = self.add_node(radix_slice(label, 0), None)
        let mid_label : Array[Char] = []
        for i in 0..<common {
          mid_label.push(label[i])
        }
        self.labels[mid] = mid_label
        self.values[mid] = None
        self.children[node].set(first, mid)
        let tail = radix_slice(label, common)
        self.labels[child] = tail
        self.children[mid].set(tail[0], child)
        if rest.length() == common {
          self.values[mid] = Some(value)
          self.entries = self.entries + 1
        } else {
          let leftover = radix_slice(rest, common)
          let leaf = self.add_node(leftover, Some(value))
          self.children[mid].set(leftover[0], leaf)
          self.entries = self.entries + 1
        }
        return None
      }
    }
  }
  None
}

///|
/// The node a key leads to, with how much of the key the labels consumed.
fn[T] RadixTree::walk(
  self : RadixTree[T],
  chars : Array[Char],
) -> (Int32, Int32) {
  let mut node = 0
  let mut at = 0
  while at < chars.length() {
    match self.children[node].get(chars[at]) {
      None => return (node, at)
      Some(child) => {
        let label = self.labels[child]
        let common = radix_common(label, radix_slice(chars, at))
        if common != label.length() {
          return (node, at)
        }
        node = child
        at = at + common
      }
    }
  }
  (node, at)
}

///|
pub fn[T] RadixTree::get(self : RadixTree[T], key : StringView) -> T? {
  let chars = radix_chars(key)
  let (node, at) = self.walk(chars)
  if at == chars.length() {
    self.values[node]
  } else {
    None
  }
}

///|
pub fn[T] RadixTree::contains(self : RadixTree[T], key : StringView) -> Bool {
  self.get(key) is Some(_)
}

///|
pub fn[T] RadixTree::contains_prefix(
  self : RadixTree[T],
  prefix : StringView,
) -> Bool {
  let chars = radix_chars(prefix)
  let (node, at) = self.walk(chars)
  if at == prefix.length() {
    true
  } else {
    let _ = node
    false
  }
}

///|
/// The longest stored key that is a prefix of `text`, with its value.
pub fn[T] RadixTree::longest_prefix(
  self : RadixTree[T],
  text : StringView,
) -> (String, T)? {
  let chars = radix_chars(text)
  let mut node = 0
  let mut at = 0
  let mut best : (String, T)? = None
  match self.values[0] {
    Some(value) => best = Some(("", value))
    None => ()
  }
  while at < chars.length() {
    match self.children[node].get(chars[at]) {
      None => break
      Some(child) => {
        let label = self.labels[child]
        let common = radix_common(label, radix_slice(chars, at))
        if common != label.length() {
          break
        }
        node = child
        at = at + common
        match self.values[node] {
          Some(value) => best = Some((radix_text(chars[:at]), value))
          None => ()
        }
      }
    }
  }
  best
}

///|
/// The stored keys that are prefixes of `key`, shortest first.
pub fn[T] RadixTree::get_ancestor_keys(
  self : RadixTree[T],
  key : StringView,
) -> Array[String] {
  let chars = radix_chars(key)
  let found : Array[String] = []
  if self.values[0] is Some(_) {
    found.push("")
  }
  let mut node = 0
  let mut at = 0
  while at < chars.length() {
    guard self.children[node].get(chars[at]) is Some(child) else { break }
    let label = self.labels[child]
    let common = radix_common(label, radix_slice(chars, at))
    if common != label.length() {
      break
    }
    node = child
    at = at + common
    if self.values[node] is Some(_) {
      found.push(radix_text(chars[:at]))
    }
  }
  found
}

///|
/// Drops the value under `key`, and the nodes the removal left empty.
pub fn[T] RadixTree::remove(self : RadixTree[T], key : StringView) -> T? {
  let chars = radix_chars(key)
  let (node, at) = self.walk(chars)
  if at != chars.length() {
    return None
  }
  let old = self.values[node]
  if old is Some(_) {
    self.values[node] = None
    self.entries = self.entries - 1
  }
  old
}

///|
fn[T] RadixTree::collect(
  self : RadixTree[T],
  node : Int32,
  prefix : String,
  into : Array[(String, T)],
) -> Unit {
  match self.values[node] {
    Some(value) => into.push((prefix, value))
    None => ()
  }
  let children : Array[(Char, Int32)] = []
  for (ch, child) in self.children[node].iter() {
    children.push((ch, child))
  }
  children.sort_by((a, b) => a.0.compare(b.0))
  for (_, child) in children {
    self.collect(child, prefix + radix_text(self.labels[child][:]), into)
  }
}

///|
/// The keys under `prefix`, in character order.
pub fn[T] RadixTree::iter_prefix(
  self : RadixTree[T],
  prefix : StringView,
) -> Iter[(String, T)] {
  let chars = radix_chars(prefix)
  let (node, at) = self.walk(chars)
  let found : Array[(String, T)] = []
  if at == chars.length() {
    self.collect(node, prefix.to_owned(), found)
  }
  let mut cursor = 0
  Iter::new(() => {
    if cursor >= found.length() {
      None
    } else {
      let entry = found[cursor]
      cursor = cursor + 1
      Some(entry)
    }
  })
}

///|
pub fn[T] RadixTree::keys_with_prefix(
  self : RadixTree[T],
  prefix : StringView,
) -> Array[String] {
  let found : Array[String] = []
  for (key, _) in self.iter_prefix(prefix) {
    found.push(key)
  }
  found
}

///|
/// How many stored keys start with `prefix`.
pub fn[T] RadixTree::prefix_count(
  self : RadixTree[T],
  prefix : StringView,
) -> Int32 {
  let chars = radix_chars(prefix)
  let (node, at) = self.walk(chars)
  if at != chars.length() {
    return 0
  }
  self.count_under(node)
}

///|
fn[T] RadixTree::count_under(self : RadixTree[T], node : Int32) -> Int32 {
  let mut count = match self.values[node] {
    Some(_) => 1
    None => 0
  }
  for (_, child) in self.children[node].iter() {
    count = count + self.count_under(child)
  }
  count
}

///|
pub fn[T] RadixTree::iter(self : RadixTree[T]) -> Iter[(String, T)] {
  self.iter_prefix("")
}

///|
pub fn[T] RadixTree::to_array(self : RadixTree[T]) -> Array[(String, T)] {
  let found : Array[(String, T)] = []
  self.collect(0, "", found)
  found
}

///|
pub fn[T] RadixTree::length(self : RadixTree[T]) -> Int32 {
  self.entries
}

///|
pub fn[T] RadixTree::is_empty(self : RadixTree[T]) -> Bool {
  self.entries == 0
}

///|
pub fn[T] RadixTree::clear(self : RadixTree[T]) -> Unit {
  self.labels.clear()
  self.labels.push([])
  self.children.clear()
  self.children.push(Map([]))
  self.values.clear()
  self.values.push(None)
  self.entries = 0
}

///|
pub fn[T] RadixTree::copy(self : RadixTree[T]) -> RadixTree[T] {
  let labels : Array[Array[Char]] = []
  for label in self.labels {
    labels.push(label.copy())
  }
  let children : Array[Map[Char, Int32]] = []
  for node in self.children {
    let copy : Map[Char, Int32] = Map([])
    for (ch, child) in node.iter() {
      copy.set(ch, child)
    }
    children.push(copy)
  }
  { labels, children, values: self.values.copy(), entries: self.entries, }
}

///|
pub impl[T : Show] Show for RadixTree[T] with fn output(self, logger) {
  logger.write_string("{")
  let mut first = true
  for (key, value) in self.iter() {
    if !first {
      logger.write_string(", ")
    }
    first = false
    logger.write_string(key)
    logger.write_string(": ")
    value.output(logger)
  }
  logger.write_string("}")
}

///|
pub extend RadixTree with Show::{to_string, output}
