///|
/// A heap of linked nodes: every node keeps its children in a list and a meld
/// only links two roots, so `insert` and `meld` are constant time and a pop pays
/// for the pairwise merging of the children it uncovers. Its `update` and
/// `remove_at` reach a node through a `HeapKey` and detach it without a search,
/// which is what a scheduler that cancels timers needs.
///
/// ```mbt check
/// test {
///   let heap : @heap.PairingHeap[Int32] = @heap.PairingHeap::new()
///   let a = heap.insert(5)
///   let b = heap.insert(2)
///   let _ = heap.insert(9)
///   assert_true(heap.peek() == Some(2))
///   assert_true(heap.update(a, 1))
///   assert_true(heap.peek() == Some(1))
///   assert_true(heap.remove_at(b) == Some(2))
///   assert_true(heap.pop() == Some(1))
/// }
/// ```
pub struct PairingHeap[T] {
  cmp : (T, T) -> Int32
  values : Array[T?]
  /// The first child of each node.
  children : Array[Int32]
  /// The next sibling of each node.
  siblings : Array[Int32]
  parents : Array[Int32]
  generations : Array[UInt32]
  free : Array[Int32]
  mut root : Int32
  mut len : Int32
}

///|
/// An empty heap popping from the `order` end, `Min` by default.
pub fn[T : Compare] PairingHeap::new(order~ : Order = Min) -> PairingHeap[T] {
  PairingHeap::new_by(cmp=order_comparator(order))
}

///|
/// An empty heap ordered by `cmp`, which reports the smaller of two elements as negative.
pub fn[T] PairingHeap::new_by(cmp~ : (T, T) -> Int32) -> PairingHeap[T] {
  {
    cmp,
    values: [],
    children: [],
    siblings: [],
    parents: [],
    generations: [],
    free: [],
    root: -1,
    len: 0,
  }
}

///|
fn[T] PairingHeap::value(self : PairingHeap[T], node : Int32) -> T {
  match self.values[node] {
    Some(value) => value
    None => abort("moonstl: a pairing heap node that holds nothing")
  }
}

///|
fn[T] PairingHeap::alloc(self : PairingHeap[T], value : T) -> Int32 {
  let node = match self.free.pop() {
    Some(node) => {
      self.values[node] = Some(value)
      node
    }
    None => {
      self.values.push(Some(value))
      self.children.push(-1)
      self.siblings.push(-1)
      self.parents.push(-1)
      self.generations.push(0U)
      self.values.length() - 1
    }
  }
  self.children[node] = -1
  self.siblings[node] = -1
  self.parents[node] = -1
  node
}

///|
/// Links two roots: the larger becomes the first child of the smaller.
fn[T] PairingHeap::meld(self : PairingHeap[T], a : Int32, b : Int32) -> Int32 {
  if a < 0 {
    return b
  }
  if b < 0 {
    return a
  }
  let take_b = (self.cmp)(self.value(b), self.value(a)) < 0
  let small = if take_b { b } else { a }
  let big = if take_b { a } else { b }
  self.parents[big] = small
  self.siblings[small] = -1
  self.parents[small] = -1
  self.siblings[big] = self.children[small]
  self.children[small] = big
  small
}

///|
/// Unlinks a node from whatever list holds it: the root, a child list's head, or
/// the middle of a sibling list.
fn[T] PairingHeap::detach(self : PairingHeap[T], node : Int32) -> Unit {
  let parent = self.parents[node]
  if parent < 0 {
    if self.root == node {
      self.root = -1
    }
    self.siblings[node] = -1
    return
  }
  if self.children[parent] == node {
    self.children[parent] = self.siblings[node]
  } else {
    let mut sibling = self.children[parent]
    while sibling >= 0 {
      if self.siblings[sibling] == node {
        self.siblings[sibling] = self.siblings[node]
        break
      }
      sibling = self.siblings[sibling]
    }
  }
  self.parents[node] = -1
  self.siblings[node] = -1
}

///|
/// Merges a sibling list of roots into one root: pair the children up left to
/// right, then meld the results right to left.
fn[T] PairingHeap::merge_pairs(self : PairingHeap[T], first : Int32) -> Int32 {
  let merged : Array[Int32] = []
  let mut current = first
  while current >= 0 {
    let a = current
    let b = self.siblings[a]
    if b < 0 {
      self.parents[a] = -1
      self.siblings[a] = -1
      merged.push(a)
      current = -1
    } else {
      let next = self.siblings[b]
      self.parents[a] = -1
      self.siblings[a] = -1
      self.parents[b] = -1
      self.siblings[b] = -1
      merged.push(self.meld(a, b))
      current = next
    }
  }
  let mut result = -1
  let mut i = merged.length() - 1
  while i >= 0 {
    result = self.meld(merged[i], result)
    i = i - 1
  }
  result
}

///|
/// Adds `value` and returns the handle that keeps naming it, whatever else the heap does.
pub fn[T] PairingHeap::insert(self : PairingHeap[T], value : T) -> HeapKey[T] {
  let node = self.alloc(value)
  self.root = self.meld(self.root, node)
  self.len = self.len + 1
  { index: node, generation: self.generations[node], }
}

///|
/// The element the order puts first, or `None` when the heap is empty.
pub fn[T] PairingHeap::peek(self : PairingHeap[T]) -> T? {
  if self.root < 0 {
    None
  } else {
    self.values[self.root]
  }
}

///|
/// Removes and returns the element the order puts first, or `None` when the heap is empty.
pub fn[T] PairingHeap::pop(self : PairingHeap[T]) -> T? {
  if self.root < 0 {
    return None
  }
  let node = self.root
  let value = self.values[node]
  let children = self.children[node]
  self.release_without_children(node)
  self.root = self.merge_pairs(children)
  self.len = self.len - 1
  value
}

///|
/// Frees a node that is already out of the structure, leaving its children to
/// the caller.
fn[T] PairingHeap::release_without_children(
  self : PairingHeap[T],
  node : Int32,
) -> Unit {
  self.values[node] = None
  self.children[node] = -1
  self.siblings[node] = -1
  self.parents[node] = -1
  self.generations[node] = self.generations[node] + 1U
  self.free.push(node)
}

///|
fn[T] PairingHeap::locate(self : PairingHeap[T], key : HeapKey[T]) -> Int32? {
  if key.index < 0 || key.index >= self.values.length() {
    return None
  }
  if self.generations[key.index] != key.generation ||
    self.values[key.index] is None {
    return None
  }
  Some(key.index)
}

///|
/// The value behind `key`, or `None` when the handle no longer names an entry.
pub fn[T] PairingHeap::get(self : PairingHeap[T], key : HeapKey[T]) -> T? {
  match self.locate(key) {
    Some(node) => self.values[node]
    None => None
  }
}

///|
/// Whether `key` still names an entry.
pub fn[T] PairingHeap::contains(
  self : PairingHeap[T],
  key : HeapKey[T],
) -> Bool {
  self.locate(key) is Some(_)
}

///|
/// Detaches the node and melds its subtree back, which keeps the rest of the
/// heap valid.
fn[T] PairingHeap::lift_out(self : PairingHeap[T], node : Int32) -> T {
  let value = self.value(node)
  let children = self.children[node]
  let is_root = self.parents[node] < 0 && self.root == node
  self.detach(node)
  self.release_without_children(node)
  let subtree = self.merge_pairs(children)
  self.root = self.meld(self.root, subtree)
  self.len = self.len - 1
  let _ = is_root
  value
}

///|
/// Replaces the value behind `key` and puts the entry back where the new value belongs; reports whether the handle named an entry at all.
pub fn[T] PairingHeap::update(
  self : PairingHeap[T],
  key : HeapKey[T],
  value : T,
) -> Bool {
  match self.locate(key) {
    Some(node) => {
      let _ = self.lift_out(node)
      let fresh = self.alloc(value)
      self.root = self.meld(self.root, fresh)
      self.len = self.len + 1
      // The handle now names the new node, so a caller can keep using it.
      self.generations[fresh] = key.generation
      true
    }
    None => false
  }
}

///|
/// Removes the entry `key` names and returns its value, leaving the rest of the heap ordered.
pub fn[T] PairingHeap::remove_at(self : PairingHeap[T], key : HeapKey[T]) -> T? {
  match self.locate(key) {
    Some(node) => Some(self.lift_out(node))
    None => None
  }
}

///|
/// How many entries the heap holds.
pub fn[T] PairingHeap::length(self : PairingHeap[T]) -> Int32 {
  self.len
}

///|
/// Whether the heap holds no entry.
pub fn[T] PairingHeap::is_empty(self : PairingHeap[T]) -> Bool {
  self.len == 0
}

///|
/// Removes every entry; the handles issued before it name nothing afterwards.
pub fn[T] PairingHeap::clear(self : PairingHeap[T]) -> Unit {
  self.values.clear()
  self.children.clear()
  self.siblings.clear()
  self.parents.clear()
  self.generations.clear()
  self.free.clear()
  self.root = -1
  self.len = 0
}

///|
/// The values in slot order, which is not the order they pop in.
pub fn[T] PairingHeap::to_array(self : PairingHeap[T]) -> Array[T] {
  let out : Array[T] = []
  for value in self.values {
    if value is Some(value) {
      out.push(value)
    }
  }
  out
}

///|
/// Empties the heap and returns its values in pop order.
pub fn[T] PairingHeap::into_sorted_array(self : PairingHeap[T]) -> Array[T] {
  let out : Array[T] = []
  while self.len > 0 {
    match self.pop() {
      Some(value) => out.push(value)
      None => break
    }
  }
  out
}

///|
/// Takes every entry of `other` into this heap and empties `other`; the handles issued by the other heap do not carry over.
pub fn[T] PairingHeap::merge(
  self : PairingHeap[T],
  other : PairingHeap[T],
) -> Unit {
  // Each heap allocates its nodes in its own array, so the root lists cannot be
  // joined without one heap reaching into the other's storage. The entries are
  // reinserted instead, which costs O(n) rather than the constant time a shared
  // node pool would allow.
  for value in other.to_array() {
    let _ = self.insert(value)
  }
  other.clear()
}
