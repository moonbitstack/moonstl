///|
/// A node of a `LinkedList`. The list owns every node it links; a node is
/// created by `push_back`/`push_front`/`insert_at` and is never constructed by a
/// caller, which is why the type carries no public constructor.
pub struct LinkedListNode[T] {
  value : T
  mut prev : LinkedListNode[T]?
  mut next : LinkedListNode[T]?
}

///|
/// A doubly linked list: splicing one list onto another and splitting a list in
/// two are constant time, because neither moves an element — they only relink
/// nodes. Indexing walks, which is the price of that.
///
/// ```mbt check
/// test {
///   let list : @seq.LinkedList[Int32] = @seq.LinkedList::new()
///   list.push_back(1)
///   list.push_back(2)
///   list.push_front(0)
///   @test.assert_eq(list.to_array(), [0, 1, 2])
///   @test.assert_eq(list.pop_front(), Some(0))
///   @test.assert_eq(list.length(), 2)
/// }
/// ```
pub struct LinkedList[T] {
  mut head : LinkedListNode[T]?
  mut tail : LinkedListNode[T]?
  mut len : Int32
}

///|
pub fn[T] LinkedList::new() -> LinkedList[T] {
  { head: None, tail: None, len: 0, }
}

///|
pub fn[T] LinkedList::push_back(self : LinkedList[T], value : T) -> Unit {
  let node : LinkedListNode[T] = { value, prev: self.tail, next: None, }
  match self.tail {
    Some(tail) => tail.next = Some(node)
    None => self.head = Some(node)
  }
  self.tail = Some(node)
  self.len = self.len + 1
}

///|
pub fn[T] LinkedList::push_front(self : LinkedList[T], value : T) -> Unit {
  let node : LinkedListNode[T] = { value, prev: None, next: self.head, }
  match self.head {
    Some(head) => head.prev = Some(node)
    None => self.tail = Some(node)
  }
  self.head = Some(node)
  self.len = self.len + 1
}

///|
pub fn[T] LinkedList::pop_front(self : LinkedList[T]) -> T? {
  match self.head {
    Some(node) => {
      self.head = node.next
      match node.next {
        Some(next) => next.prev = None
        None => self.tail = None
      }
      self.len = self.len - 1
      node.next = None
      Some(node.value)
    }
    None => None
  }
}

///|
pub fn[T] LinkedList::pop_back(self : LinkedList[T]) -> T? {
  match self.tail {
    Some(node) => {
      self.tail = node.prev
      match node.prev {
        Some(prev) => prev.next = None
        None => self.head = None
      }
      self.len = self.len - 1
      node.prev = None
      Some(node.value)
    }
    None => None
  }
}

///|
pub fn[T] LinkedList::front(self : LinkedList[T]) -> T? {
  match self.head {
    Some(node) => Some(node.value)
    None => None
  }
}

///|
pub fn[T] LinkedList::back(self : LinkedList[T]) -> T? {
  match self.tail {
    Some(node) => Some(node.value)
    None => None
  }
}

///|
pub fn[T] LinkedList::get(self : LinkedList[T], index : Int32) -> T? {
  match self.node_at(index) {
    Some(node) => Some(node.value)
    None => None
  }
}

///|
fn[T] LinkedList::node_at(
  self : LinkedList[T],
  index : Int32,
) -> LinkedListNode[T]? {
  if index < 0 || index >= self.len {
    return None
  }
  let mut node = self.head
  let mut at = 0
  while at < index {
    match node {
      Some(current) => {
        node = current.next
        at = at + 1
      }
      None => return None
    }
  }
  node
}

///|
pub fn[T] LinkedList::insert_at(
  self : LinkedList[T],
  index : Int32,
  value : T,
) -> Unit {
  if index <= 0 {
    self.push_front(value)
    return
  }
  if index >= self.len {
    self.push_back(value)
    return
  }
  match self.node_at(index) {
    Some(after) => {
      let node : LinkedListNode[T] = {
        value,
        prev: after.prev,
        next: Some(after),
      }
      match after.prev {
        Some(before) => before.next = Some(node)
        None => self.head = Some(node)
      }
      after.prev = Some(node)
      self.len = self.len + 1
    }
    None => self.push_back(value)
  }
}

///|
pub fn[T] LinkedList::remove_at(self : LinkedList[T], index : Int32) -> T? {
  match self.node_at(index) {
    Some(node) => {
      match node.prev {
        Some(prev) => prev.next = node.next
        None => self.head = node.next
      }
      match node.next {
        Some(next) => next.prev = node.prev
        None => self.tail = node.prev
      }
      node.prev = None
      node.next = None
      self.len = self.len - 1
      Some(node.value)
    }
    None => None
  }
}

///|
/// Links `other` onto the end of this list. `other` is left empty, and no
/// element is copied or moved: only four pointers change.
pub fn[T] LinkedList::splice(
  self : LinkedList[T],
  other : LinkedList[T],
) -> Unit {
  if other.len == 0 {
    return
  }
  match self.tail {
    Some(tail) => {
      tail.next = other.head
      match other.head {
        Some(head) => head.prev = Some(tail)
        None => ()
      }
    }
    None => self.head = other.head
  }
  self.tail = other.tail
  self.len = self.len + other.len
  other.head = None
  other.tail = None
  other.len = 0
}

///|
/// The same as `splice`: the name a reader of `Deque` already knows.
pub fn[T] LinkedList::append(
  self : LinkedList[T],
  other : LinkedList[T],
) -> Unit {
  self.splice(other)
}

///|
/// Cuts the list at `index` and returns the tail. The two halves share no node;
/// only the link at the cut changes.
pub fn[T] LinkedList::split_off(
  self : LinkedList[T],
  index : Int32,
) -> LinkedList[T] {
  if index <= 0 {
    let whole : LinkedList[T] = {
      head: self.head,
      tail: self.tail,
      len: self.len,
    }
    self.head = None
    self.tail = None
    self.len = 0
    return whole
  }
  if index >= self.len {
    return LinkedList::new()
  }
  match self.node_at(index) {
    Some(cut) => {
      let before = cut.prev
      match before {
        Some(prev) => prev.next = None
        None => ()
      }
      cut.prev = None
      let tail : LinkedList[T] = {
        head: Some(cut),
        tail: self.tail,
        len: self.len - index,
      }
      self.tail = before
      self.len = index
      tail
    }
    None => LinkedList::new()
  }
}

///|
pub fn[T] LinkedList::length(self : LinkedList[T]) -> Int32 {
  self.len
}

///|
pub fn[T] LinkedList::is_empty(self : LinkedList[T]) -> Bool {
  self.len == 0
}

///|
pub fn[T] LinkedList::iter(self : LinkedList[T]) -> Iter[T] {
  let mut node = self.head
  Iter::new(() => {
    match node {
      Some(current) => {
        node = current.next
        Some(current.value)
      }
      None => None
    }
  })
}

///|
pub fn[T] LinkedList::rev_iter(self : LinkedList[T]) -> Iter[T] {
  let mut node = self.tail
  Iter::new(() => {
    match node {
      Some(current) => {
        node = current.prev
        Some(current.value)
      }
      None => None
    }
  })
}

///|
pub fn[T] LinkedList::to_array(self : LinkedList[T]) -> Array[T] {
  let out : Array[T] = []
  for value in self.iter() {
    out.push(value)
  }
  out
}

///|
pub fn[T] LinkedList::clear(self : LinkedList[T]) -> Unit {
  let mut node = self.head
  while node is Some(current) {
    let next = current.next
    current.prev = None
    current.next = None
    node = next
  }
  self.head = None
  self.tail = None
  self.len = 0
}
