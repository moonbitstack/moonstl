///|
/// A handle to one node of an `ArenaTree`: the slot the node occupies and the
/// generation of that slot when the handle was handed out, so a handle to a
/// removed node reads as absent rather than reaching whoever took the slot.
#derive(Eq, Hash, Debug)
pub(all) struct TreeId {
  index : Int32
  generation : UInt32
}

///|
pub extend TreeId with Eq::{equal, not_equal}

///|
pub extend TreeId with Hash::{hash, hash_combine}

///|
pub extend TreeId with Debug::{to_repr}

///|
/// A tree whose nodes live in one arena and are reached by id: a node knows its
/// parent, its first and last child, and its two siblings, so every step of a
/// walk is a field read and no pointer chases the allocator. Children are kept
/// in insertion order, and `sort_children` reorders them by their own values.
///
/// ```mbt check
/// test {
///   let tree : @tree.ArenaTree[String] = @tree.ArenaTree::new()
///   let root = tree.add("root")
///   let a = tree.add_child(root, "a")
///   let _ = tree.add_child(root, "b")
///   let _ = tree.add_child(a, "a1")
///   assert_true(tree.length() == 4)
///   assert_true(tree.children(root).length() == 2)
///   assert_true(tree.descendants(root).to_array().length() == 3)
///   assert_true(tree.remove(a) == Some("a"))
///   assert_true(tree.length() == 2)
/// }
/// ```
pub struct ArenaTree[T] {
  values : Array[T?]
  generations : Array[UInt32]
  free : Array[Int32]
  parents : Array[Int32]
  first_child : Array[Int32]
  last_child : Array[Int32]
  previous : Array[Int32]
  next : Array[Int32]
  mut root : Int32
  mut len : Int32
}

///|
/// An empty tree.
pub fn[T] ArenaTree::new() -> ArenaTree[T] {
  {
    values: [],
    generations: [],
    free: [],
    parents: [],
    first_child: [],
    last_child: [],
    previous: [],
    next: [],
    root: -1,
    len: 0,
  }
}

///|
/// Stores a value in a fresh slot and returns the id of the unlinked node.
fn[T] ArenaTree::alloc(self : ArenaTree[T], value : T) -> Int32 {
  let slot = match self.free.pop() {
    Some(slot) => {
      self.values[slot] = Some(value)
      slot
    }
    None => {
      self.values.push(Some(value))
      self.generations.push(0U)
      self.parents.push(-1)
      self.first_child.push(-1)
      self.last_child.push(-1)
      self.previous.push(-1)
      self.next.push(-1)
      self.values.length() - 1
    }
  }
  self.parents[slot] = -1
  self.first_child[slot] = -1
  self.last_child[slot] = -1
  self.previous[slot] = -1
  self.next[slot] = -1
  self.len = self.len + 1
  slot
}

///|
fn[T] ArenaTree::alive(self : ArenaTree[T], id : TreeId) -> Bool {
  id.index >= 0 &&
  id.index < self.values.length() &&
  self.generations[id.index] == id.generation &&
  self.values[id.index] is Some(_)
}

///|
fn[T] ArenaTree::id_of(self : ArenaTree[T], slot : Int32) -> TreeId {
  { index: slot, generation: self.generations[slot], }
}

///|
/// Links `slot` as the last child of `parent`.
fn[T] ArenaTree::link_last(
  self : ArenaTree[T],
  parent : Int32,
  slot : Int32,
) -> Unit {
  self.parents[slot] = parent
  self.previous[slot] = self.last_child[parent]
  self.next[slot] = -1
  if self.last_child[parent] >= 0 {
    self.next[self.last_child[parent]] = slot
  } else {
    self.first_child[parent] = slot
  }
  self.last_child[parent] = slot
}

///|
/// Links `slot` as the first child of `parent`.
fn[T] ArenaTree::link_first(
  self : ArenaTree[T],
  parent : Int32,
  slot : Int32,
) -> Unit {
  self.parents[slot] = parent
  self.previous[slot] = -1
  self.next[slot] = self.first_child[parent]
  if self.first_child[parent] >= 0 {
    self.previous[self.first_child[parent]] = slot
  } else {
    self.last_child[parent] = slot
  }
  self.first_child[parent] = slot
}

///|
/// Unlinks `slot` from its parent, keeping its own children.
fn[T] ArenaTree::unlink_node(self : ArenaTree[T], slot : Int32) -> Unit {
  let parent = self.parents[slot]
  if parent >= 0 {
    if self.first_child[parent] == slot {
      self.first_child[parent] = self.next[slot]
    }
    if self.last_child[parent] == slot {
      self.last_child[parent] = self.previous[slot]
    }
  } else if self.root == slot {
    self.root = self.next[slot]
  }
  if self.previous[slot] >= 0 {
    self.next[self.previous[slot]] = self.next[slot]
  }
  if self.next[slot] >= 0 {
    self.previous[self.next[slot]] = self.previous[slot]
  }
  self.parents[slot] = -1
  self.previous[slot] = -1
  self.next[slot] = -1
}

///|
/// Adds a detached node, which becomes a root of its own.
pub fn[T] ArenaTree::add(self : ArenaTree[T], value : T) -> TreeId {
  let slot = self.alloc(value)
  if self.root < 0 {
    self.root = slot
  } else {
    // Roots are linked as a sibling list of their own.
    let mut last = self.root
    while self.next[last] >= 0 {
      last = self.next[last]
    }
    self.next[last] = slot
    self.previous[slot] = last
  }
  self.id_of(slot)
}

///|
/// Adds a child at the end of `parent`'s children and returns its id; a parent that is no longer in the tree yields the null id.
pub fn[T] ArenaTree::add_child(
  self : ArenaTree[T],
  parent : TreeId,
  value : T,
) -> TreeId {
  if !self.alive(parent) {
    return { index: -1, generation: 0U, }
  }
  let slot = self.alloc(value)
  self.link_last(parent.index, slot)
  self.id_of(slot)
}

///|
/// Adds a child at the front of `parent`'s children and returns its id; a parent that is no longer in the tree yields the null id.
pub fn[T] ArenaTree::prepend_child(
  self : ArenaTree[T],
  parent : TreeId,
  value : T,
) -> TreeId {
  if !self.alive(parent) {
    return { index: -1, generation: 0U, }
  }
  let slot = self.alloc(value)
  self.link_first(parent.index, slot)
  self.id_of(slot)
}

///|
/// Adds a sibling just after `sibling` and returns its id; a sibling that is no longer in the tree yields the null id.
pub fn[T] ArenaTree::insert_after(
  self : ArenaTree[T],
  sibling : TreeId,
  value : T,
) -> TreeId {
  if !self.alive(sibling) {
    return { index: -1, generation: 0U, }
  }
  let slot = self.alloc(value)
  let at = sibling.index
  let parent = self.parents[at]
  self.parents[slot] = parent
  self.previous[slot] = at
  self.next[slot] = self.next[at]
  if self.next[at] >= 0 {
    self.previous[self.next[at]] = slot
  } else if parent >= 0 {
    self.last_child[parent] = slot
  }
  self.next[at] = slot
  self.id_of(slot)
}

///|
/// Adds a sibling just before `sibling` and returns its id; a sibling that is no longer in the tree yields the null id.
pub fn[T] ArenaTree::insert_before(
  self : ArenaTree[T],
  sibling : TreeId,
  value : T,
) -> TreeId {
  if !self.alive(sibling) {
    return { index: -1, generation: 0U, }
  }
  let slot = self.alloc(value)
  let at = sibling.index
  let parent = self.parents[at]
  self.parents[slot] = parent
  self.next[slot] = at
  self.previous[slot] = self.previous[at]
  if self.previous[at] >= 0 {
    self.next[self.previous[at]] = slot
  } else if parent >= 0 {
    self.first_child[parent] = slot
  } else if self.root == at {
    self.root = slot
  }
  self.previous[at] = slot
  self.id_of(slot)
}

///|
/// The value behind `id`, or `None` when the id names nothing.
pub fn[T] ArenaTree::get(self : ArenaTree[T], id : TreeId) -> T? {
  if self.alive(id) {
    self.values[id.index]
  } else {
    None
  }
}

///|
/// Replaces the value behind `id` and reports whether the id named a node.
pub fn[T] ArenaTree::set(self : ArenaTree[T], id : TreeId, value : T) -> Bool {
  if self.alive(id) {
    self.values[id.index] = Some(value)
    true
  } else {
    false
  }
}

///|
/// Whether `id` names a node.
pub fn[T] ArenaTree::contains(self : ArenaTree[T], id : TreeId) -> Bool {
  self.alive(id)
}

///|
/// The parent of `id`, or `None` when it is the root or names nothing.
pub fn[T] ArenaTree::parent(self : ArenaTree[T], id : TreeId) -> TreeId? {
  if !self.alive(id) || self.parents[id.index] < 0 {
    None
  } else {
    Some(self.id_of(self.parents[id.index]))
  }
}

///|
/// The first child of `id`, or `None` when it has none.
pub fn[T] ArenaTree::first_child(self : ArenaTree[T], id : TreeId) -> TreeId? {
  if !self.alive(id) || self.first_child[id.index] < 0 {
    None
  } else {
    Some(self.id_of(self.first_child[id.index]))
  }
}

///|
/// The sibling after `id`, or `None` when it is the last child.
pub fn[T] ArenaTree::next_sibling(self : ArenaTree[T], id : TreeId) -> TreeId? {
  if !self.alive(id) || self.next[id.index] < 0 {
    None
  } else {
    Some(self.id_of(self.next[id.index]))
  }
}

///|
/// The sibling before `id`, or `None` when it is the first child.
pub fn[T] ArenaTree::previous_sibling(
  self : ArenaTree[T],
  id : TreeId,
) -> TreeId? {
  if !self.alive(id) || self.previous[id.index] < 0 {
    None
  } else {
    Some(self.id_of(self.previous[id.index]))
  }
}

///|
/// The ids of the children, in order.
pub fn[T] ArenaTree::children(
  self : ArenaTree[T],
  id : TreeId,
) -> Array[TreeId] {
  let out : Array[TreeId] = []
  if !self.alive(id) {
    return out
  }
  let mut at = self.first_child[id.index]
  while at >= 0 {
    out.push(self.id_of(at))
    at = self.next[at]
  }
  out
}

///|
/// The siblings of a node, the node itself included, in order.
pub fn[T] ArenaTree::siblings(
  self : ArenaTree[T],
  id : TreeId,
) -> Array[TreeId] {
  let out : Array[TreeId] = []
  if !self.alive(id) {
    return out
  }
  let parent = self.parents[id.index]
  if parent >= 0 {
    return self.children(self.id_of(parent))
  }
  let mut at = self.root
  while at >= 0 {
    out.push(self.id_of(at))
    at = self.next[at]
  }
  out
}

///|
/// The root first, then each ancestor up to it.
pub fn[T] ArenaTree::ancestors(
  self : ArenaTree[T],
  id : TreeId,
) -> Iter[TreeId] {
  let path : Array[TreeId] = []
  if self.alive(id) {
    let mut at = self.parents[id.index]
    while at >= 0 {
      path.push(self.id_of(at))
      at = self.parents[at]
    }
  }
  let mut cursor = 0
  Iter::new(() => {
    if cursor >= path.length() {
      None
    } else {
      let value = path[cursor]
      cursor = cursor + 1
      Some(value)
    }
  })
}

///|
/// The children of a node, and their children, depth first and left to right.
pub fn[T] ArenaTree::descendants(
  self : ArenaTree[T],
  id : TreeId,
) -> Iter[TreeId] {
  let collected = self.preorder_below(id, false)
  let mut cursor = 0
  Iter::new(() => {
    if cursor >= collected.length() {
      None
    } else {
      let value = collected[cursor]
      cursor = cursor + 1
      Some(value)
    }
  })
}

///|
fn[T] ArenaTree::preorder_below(
  self : ArenaTree[T],
  id : TreeId,
  include_self : Bool,
) -> Array[TreeId] {
  let out : Array[TreeId] = []
  if !self.alive(id) {
    return out
  }
  let stack : Array[Int32] = []
  if include_self {
    stack.push(id.index)
  } else {
    let mut at = self.first_child[id.index]
    let children : Array[Int32] = []
    while at >= 0 {
      children.push(at)
      at = self.next[at]
    }
    let mut i = children.length() - 1
    while i >= 0 {
      stack.push(children[i])
      i = i - 1
    }
  }
  while stack.length() > 0 {
    let slot = stack.pop().unwrap()
    out.push(self.id_of(slot))
    let children : Array[Int32] = []
    let mut at = self.first_child[slot]
    while at >= 0 {
      children.push(at)
      at = self.next[at]
    }
    let mut i = children.length() - 1
    while i >= 0 {
      stack.push(children[i])
      i = i - 1
    }
  }
  out
}

///|
/// The whole tree in preorder, the node itself first.
pub fn[T] ArenaTree::preorder(self : ArenaTree[T], id : TreeId) -> Iter[TreeId] {
  let collected = self.preorder_below(id, true)
  let mut cursor = 0
  Iter::new(() => {
    if cursor >= collected.length() {
      None
    } else {
      let value = collected[cursor]
      cursor = cursor + 1
      Some(value)
    }
  })
}

///|
/// The subtree in postorder: every child before its parent.
pub fn[T] ArenaTree::postorder(
  self : ArenaTree[T],
  id : TreeId,
) -> Iter[TreeId] {
  let ordered = self.preorder_below(id, true)
  let reversed : Array[TreeId] = []
  let mut i = ordered.length() - 1
  while i >= 0 {
    reversed.push(ordered[i])
    i = i - 1
  }
  let mut cursor = 0
  Iter::new(() => {
    if cursor >= reversed.length() {
      None
    } else {
      let value = reversed[cursor]
      cursor = cursor + 1
      Some(value)
    }
  })
}

///|
/// Reorders the children of `id` by their own values, keeping the links intact.
pub fn[T] ArenaTree::sort_children(
  self : ArenaTree[T],
  id : TreeId,
  cmp : (T, T) -> Int32,
) -> Unit {
  let children = self.children(id)
  if children.length() < 2 {
    return
  }
  children.sort_by((a, b) => {
    let left = self.values[a.index].unwrap()
    let right = self.values[b.index].unwrap()
    cmp(left, right)
  })
  let parent = id.index
  self.first_child[parent] = -1
  self.last_child[parent] = -1
  for child in children {
    self.parents[child.index] = -1
    self.previous[child.index] = -1
    self.next[child.index] = -1
  }
  for child in children {
    self.link_last(parent, child.index)
  }
}

///|
/// Removes the node and everything below it, returning the value that was on it.
pub fn[T] ArenaTree::remove(self : ArenaTree[T], id : TreeId) -> T? {
  if !self.alive(id) {
    return None
  }
  let value = self.values[id.index]
  let doomed = self.preorder_below(id, true)
  self.unlink_node(id.index)
  for node in doomed {
    self.values[node.index] = None
    self.generations[node.index] = self.generations[node.index] + 1U
    self.parents[node.index] = -1
    self.first_child[node.index] = -1
    self.last_child[node.index] = -1
    self.previous[node.index] = -1
    self.next[node.index] = -1
    self.free.push(node.index)
    self.len = self.len - 1
  }
  value
}

///|
/// Cuts a subtree loose and returns it as a tree of its own. The copy owns its
/// nodes, so the ids of the returned tree are its own; the original keeps its
/// ids. The cost is the size of the subtree, because the nodes are rebuilt.
pub fn[T] ArenaTree::detach(self : ArenaTree[T], id : TreeId) -> ArenaTree[T]? {
  if !self.alive(id) {
    return None
  }
  let source : ArenaTree[T] = self.copy()
  let extracted : ArenaTree[T] = ArenaTree::new()
  let root_value = source.values[id.index].unwrap()
  let new_root : TreeId = extracted.add(root_value)
  // Copy the subtree level by level, so every new node knows its new parent.
  let pairs : Array[(TreeId, TreeId)] = [(id, new_root)]
  let mut cursor = 0
  while cursor < pairs.length() {
    let (old_parent, new_parent) = pairs[cursor]
    cursor = cursor + 1
    for child in source.children(old_parent) {
      let value = source.values[child.index].unwrap()
      let created = extracted.add_child(new_parent, value)
      pairs.push((child, created))
    }
  }
  let _ = self.remove(id)
  Some(extracted)
}

///|
/// The number of nodes.
pub fn[T] ArenaTree::length(self : ArenaTree[T]) -> Int32 {
  self.len
}

///|
/// Whether the tree holds no node.
pub fn[T] ArenaTree::is_empty(self : ArenaTree[T]) -> Bool {
  self.len == 0
}

///|
/// Removes every node; the ids issued before it name nothing afterwards.
pub fn[T] ArenaTree::clear(self : ArenaTree[T]) -> Unit {
  self.values.clear()
  self.generations.clear()
  self.free.clear()
  self.parents.clear()
  self.first_child.clear()
  self.last_child.clear()
  self.previous.clear()
  self.next.clear()
  self.root = -1
  self.len = 0
}

///|
/// A copy that owns its arrays: an edit to either tree leaves the other alone, and an id names the same node in both.
pub fn[T] ArenaTree::copy(self : ArenaTree[T]) -> ArenaTree[T] {
  {
    values: self.values.copy(),
    generations: self.generations.copy(),
    free: self.free.copy(),
    parents: self.parents.copy(),
    first_child: self.first_child.copy(),
    last_child: self.last_child.copy(),
    previous: self.previous.copy(),
    next: self.next.copy(),
    root: self.root,
    len: self.len,
  }
}
