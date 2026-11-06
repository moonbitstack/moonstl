///|
/// A map keyed by `String` that shares the storage of keys with a common
/// prefix: the walk to a key costs one step per character, whatever else is
/// stored.
///
/// ```mbt check
/// test {
///   let trie : @map.Trie[Int32] = @map.Trie::new()
///   @test.assert_eq(trie.insert("car", 1), None)
///   @test.assert_eq(trie.insert("cart", 2), None)
///   @test.assert_eq(trie.get("car"), Some(1))
///   @test.assert_eq(trie.keys_with_prefix("ca"), ["car", "cart"])
///   @test.assert_eq(trie.longest_prefix("cartoon"), Some(("cart", 2)))
/// }
/// ```
pub struct Trie[T] {
  /// One entry per node: the children of the node, keyed by the next character.
  children : Array[Map[Char, Int32]]
  /// The value of each node, `None` when no key ends there.
  values : Array[T?]
  mut entries : Int32
}

///|
pub fn[T] Trie::new() -> Trie[T] {
  { children: [Map([])], values: [None], entries: 0, }
}

///|
fn[T] Trie::child(self : Trie[T], node : Int32, ch : Char) -> Int32? {
  self.children[node].get(ch)
}

///|
fn[T] Trie::child_or_new(self : Trie[T], node : Int32, ch : Char) -> Int32 {
  match self.children[node].get(ch) {
    Some(child) => child
    None => {
      let child = self.children.length()
      self.children.push(Map([]))
      self.values.push(None)
      self.children[node].set(ch, child)
      child
    }
  }
}

///|
/// Stores `value` under `key` and returns the value the key held before.
pub fn[T] Trie::insert(self : Trie[T], key : StringView, value : T) -> T? {
  let mut node = 0
  for ch in key.to_owned().iter() {
    node = self.child_or_new(node, ch)
  }
  let old = self.values[node]
  self.values[node] = Some(value)
  if old is None {
    self.entries = self.entries + 1
  }
  old
}

///|
fn[T] Trie::walk(self : Trie[T], key : StringView) -> Int32? {
  let mut node = 0
  for ch in key.to_owned().iter() {
    guard self.child(node, ch) is Some(child) else { return None }
    node = child
  }
  Some(node)
}

///|
pub fn[T] Trie::get(self : Trie[T], key : StringView) -> T? {
  match self.walk(key) {
    Some(node) => self.values[node]
    None => None
  }
}

///|
pub fn[T] Trie::contains(self : Trie[T], key : StringView) -> Bool {
  self.get(key) is Some(_)
}

///|
/// Whether any key stored here starts with `prefix`.
pub fn[T] Trie::contains_prefix(self : Trie[T], prefix : StringView) -> Bool {
  self.walk(prefix) is Some(_)
}

///|
/// Drops the value under `key` and returns it. The nodes stay, so a later
/// insert of a key with the same prefix does not walk the string again.
pub fn[T] Trie::remove(self : Trie[T], key : StringView) -> T? {
  match self.walk(key) {
    Some(node) => {
      let old = self.values[node]
      if old is Some(_) {
        self.values[node] = None
        self.entries = self.entries - 1
      }
      old
    }
    None => None
  }
}

///|
/// The longest key stored here that is a prefix of `text`, with its value.
pub fn[T] Trie::longest_prefix(
  self : Trie[T],
  text : StringView,
) -> (String, T)? {
  let mut node = 0
  let mut best : (String, T)? = None
  match self.values[0] {
    Some(value) => best = Some(("", value))
    None => ()
  }
  let mut seen = ""
  for ch in text.to_owned().iter() {
    guard self.child(node, ch) is Some(child) else { break }
    node = child
    seen = seen + ch.to_string()
    match self.values[node] {
      Some(value) => best = Some((seen, value))
      None => ()
    }
  }
  best
}

///|
fn[T] Trie::collect(
  self : Trie[T],
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
  for (ch, child) in children {
    self.collect(child, prefix + ch.to_string(), into)
  }
}

///|
/// The keys starting with `prefix`, in character order.
pub fn[T] Trie::keys_with_prefix(
  self : Trie[T],
  prefix : StringView,
) -> Array[String] {
  match self.walk(prefix) {
    Some(node) => {
      let found : Array[(String, T)] = []
      self.collect(node, prefix.to_owned(), found)
      found.map(entry => entry.0)
    }
    None => []
  }
}

///|
/// Every pair, in key order.
pub fn[T] Trie::iter(self : Trie[T]) -> Iter[(String, T)] {
  let found : Array[(String, T)] = []
  self.collect(0, "", found)
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
pub fn[T] Trie::to_array(self : Trie[T]) -> Array[(String, T)] {
  let found : Array[(String, T)] = []
  self.collect(0, "", found)
  found
}

///|
/// The number of keys that carry a value.
pub fn[T] Trie::length(self : Trie[T]) -> Int32 {
  self.entries
}

///|
pub fn[T] Trie::is_empty(self : Trie[T]) -> Bool {
  self.entries == 0
}

///|
pub fn[T] Trie::clear(self : Trie[T]) -> Unit {
  self.children.clear()
  self.children.push(Map([]))
  self.values.clear()
  self.values.push(None)
  self.entries = 0
}

///|
pub fn[T] Trie::copy(self : Trie[T]) -> Trie[T] {
  let children : Array[Map[Char, Int32]] = []
  for node in self.children {
    let copy : Map[Char, Int32] = Map([])
    for (ch, child) in node.iter() {
      copy.set(ch, child)
    }
    children.push(copy)
  }
  { children, values: self.values.copy(), entries: self.entries, }
}

///|
pub impl[T : Show] Show for Trie[T] with fn output(self, logger) {
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
pub extend Trie with Show::{to_string, output}
