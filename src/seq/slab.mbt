///|
/// A handle to a slot of a `SlotMap` or a `DenseSlotMap`. The index says which
/// slot, the generation says which occupant of that slot: a slot that is freed
/// and reused raises its generation, so a key handed out earlier can never reach
/// the new occupant. The type parameter exists only to stop a key of one map
/// from being passed to another; it carries no value.
#warnings("-unused_type_variable")
#derive(Eq, Hash, Debug)
pub(all) struct SlotKey[T] {
  index : Int32
  generation : UInt32
}

///|
pub extend SlotKey with Eq::{equal, not_equal}

///|
pub extend SlotKey with Hash::{hash, hash_combine}

///|
pub extend SlotKey with Debug::{to_repr}

///|
pub impl[T] Show for SlotKey[T] with fn output(self, logger) {
  logger.write_string(
    "SlotKey(\{self.index}, \{self.generation.to_int64().to_string()})",
  )
}

///|
pub extend SlotKey with Show::{to_string, output}

///|
pub impl[T] ToJson for SlotKey[T] with fn to_json(self) {
  Json::array([
    Json::number(self.index.to_double()),
    Json::number(self.generation.to_double()),
  ])
}

///|
pub extend SlotKey with ToJson::{to_json}

///|
pub impl[T] FromJson for SlotKey[T] with fn from_json(json, path) {
  guard json is Json::Array(items) && items.length() == 2 else {
    raise JsonDecodeError((path, "SlotKey: expected a pair"))
  }
  let index : Int32 = FromJson::from_json(items[0], path)
  let generation : Int64 = FromJson::from_json(items[1], path)
  { index, generation: generation.reinterpret_as_uint64().to_uint(), }
}

///|
pub extend SlotKey with FromJson::{from_json}

///|
/// An index-addressed store that reuses the indices it frees. An index carries
/// no generation, so a caller that keeps one past a `remove` and a later
/// `insert` reaches the new occupant: that is the trade a `Slab` makes for
/// handing out plain integers, and the reason `SlotMap` exists beside it.
pub struct Slab[T] {
  values : Array[T?]
  free : Array[Int32]
  mut len : Int32
}

///|
pub fn[T] Slab::new(capacity~ : Int32 = 0) -> Slab[T] {
  let values : Array[T?] = []
  if capacity > 0 {
    values.reserve_capacity(capacity)
  }
  { values, free: [], len: 0, }
}

///|
/// Stores `value` in the lowest free index, or at the end, and returns the index.
pub fn[T] Slab::insert(self : Slab[T], value : T) -> Int32 {
  match self.free.pop() {
    Some(index) => {
      self.values[index] = Some(value)
      self.len = self.len + 1
      index
    }
    None => {
      self.values.push(Some(value))
      self.len = self.len + 1
      self.values.length() - 1
    }
  }
}

///|
pub fn[T] Slab::get(self : Slab[T], index : Int32) -> T? {
  match self.values.get(index) {
    Some(value) => value
    None => None
  }
}

///|
pub fn[T] Slab::at(self : Slab[T], index : Int32) -> T {
  match self.get(index) {
    Some(value) => value
    None => abort("moonstl: a slab index that holds nothing")
  }
}

///|
pub fn[T] Slab::set(self : Slab[T], index : Int32, value : T) -> Bool {
  match self.get(index) {
    Some(_) => {
      self.values[index] = Some(value)
      true
    }
    None => false
  }
}

///|
pub fn[T] Slab::remove(self : Slab[T], index : Int32) -> T? {
  match self.get(index) {
    Some(value) => {
      self.values[index] = None
      self.free.push(index)
      self.len = self.len - 1
      Some(value)
    }
    None => None
  }
}

///|
pub fn[T] Slab::contains(self : Slab[T], index : Int32) -> Bool {
  self.get(index) is Some(_)
}

///|
pub fn[T] Slab::length(self : Slab[T]) -> Int32 {
  self.len
}

///|
/// The number of indices ever handed out, live or free.
pub fn[T] Slab::capacity(self : Slab[T]) -> Int32 {
  self.values.length()
}

///|
pub fn[T] Slab::is_empty(self : Slab[T]) -> Bool {
  self.len == 0
}

///|
pub fn[T] Slab::iter(self : Slab[T]) -> Iter[T] {
  let mut cursor = 0
  Iter::new(() => {
    while cursor < self.values.length() {
      match self.values[cursor] {
        Some(value) => {
          cursor = cursor + 1
          return Some(value)
        }
        None => cursor = cursor + 1
      }
    }
    None
  })
}

///|
pub fn[T] Slab::keys(self : Slab[T]) -> Iter[Int32] {
  let mut cursor = 0
  Iter::new(() => {
    while cursor < self.values.length() {
      if self.values[cursor] is Some(_) {
        let index = cursor
        cursor = cursor + 1
        return Some(index)
      }
      cursor = cursor + 1
    }
    None
  })
}

///|
pub fn[T] Slab::clear(self : Slab[T]) -> Unit {
  self.values.clear()
  self.free.clear()
  self.len = 0
}

///|
pub fn[T] Slab::copy(self : Slab[T]) -> Slab[T] {
  { values: self.values.copy(), free: self.free.copy(), len: self.len, }
}

///|
/// A store whose handles stay valid only while their slot keeps its occupant:
/// every slot carries a generation, a key carries the generation it was handed
/// out under, and a freed slot raises its generation when it is reused. A stale
/// key therefore reads as absent instead of reaching a stranger.
pub struct SlotMap[T] {
  values : Array[T?]
  generations : Array[UInt32]
  free : Array[Int32]
  mut len : Int32
}

///|
pub fn[T] SlotMap::new(capacity~ : Int32 = 0) -> SlotMap[T] {
  let values : Array[T?] = []
  let generations : Array[UInt32] = []
  if capacity > 0 {
    values.reserve_capacity(capacity)
    generations.reserve_capacity(capacity)
  }
  { values, generations, free: [], len: 0, }
}

///|
pub fn[T] SlotMap::insert(self : SlotMap[T], value : T) -> SlotKey[T] {
  match self.free.pop() {
    Some(index) => {
      self.values[index] = Some(value)
      self.len = self.len + 1
      { index, generation: self.generations[index], }
    }
    None => {
      self.values.push(Some(value))
      self.generations.push(0U)
      self.len = self.len + 1
      { index: self.values.length() - 1, generation: 0U, }
    }
  }
}

///|
pub fn[T] SlotMap::get(self : SlotMap[T], key : SlotKey[T]) -> T? {
  if key.index < 0 || key.index >= self.values.length() {
    return None
  }
  if self.generations[key.index] != key.generation {
    return None
  }
  self.values[key.index]
}

///|
pub fn[T] SlotMap::at(self : SlotMap[T], key : SlotKey[T]) -> T {
  match self.get(key) {
    Some(value) => value
    None => abort("moonstl: a slot key that holds nothing")
  }
}

///|
pub fn[T] SlotMap::set(self : SlotMap[T], key : SlotKey[T], value : T) -> Bool {
  match self.get(key) {
    Some(_) => {
      self.values[key.index] = Some(value)
      true
    }
    None => false
  }
}

///|
pub fn[T] SlotMap::remove(self : SlotMap[T], key : SlotKey[T]) -> T? {
  match self.get(key) {
    Some(value) => {
      self.values[key.index] = None
      self.generations[key.index] = self.generations[key.index] + 1U
      self.free.push(key.index)
      self.len = self.len - 1
      Some(value)
    }
    None => None
  }
}

///|
pub fn[T] SlotMap::contains(self : SlotMap[T], key : SlotKey[T]) -> Bool {
  self.get(key) is Some(_)
}

///|
pub fn[T] SlotMap::length(self : SlotMap[T]) -> Int32 {
  self.len
}

///|
pub fn[T] SlotMap::capacity(self : SlotMap[T]) -> Int32 {
  self.values.length()
}

///|
pub fn[T] SlotMap::is_empty(self : SlotMap[T]) -> Bool {
  self.len == 0
}

///|
pub fn[T] SlotMap::keys(self : SlotMap[T]) -> Iter[SlotKey[T]] {
  let mut cursor = 0
  Iter::new(() => {
    while cursor < self.values.length() {
      if self.values[cursor] is Some(_) {
        let key : SlotKey[T] = {
          index: cursor,
          generation: self.generations[cursor],
        }
        cursor = cursor + 1
        return Some(key)
      }
      cursor = cursor + 1
    }
    None
  })
}

///|
pub fn[T] SlotMap::iter(self : SlotMap[T]) -> Iter[T] {
  let mut cursor = 0
  Iter::new(() => {
    while cursor < self.values.length() {
      match self.values[cursor] {
        Some(value) => {
          cursor = cursor + 1
          return Some(value)
        }
        None => cursor = cursor + 1
      }
    }
    None
  })
}

///|
pub fn[T] SlotMap::iter2(self : SlotMap[T]) -> Iter2[SlotKey[T], T] {
  let keys = self.keys()
  Iter2::new(() => {
    match keys.next() {
      Some(key) => Some((key, self.at(key)))
      None => None
    }
  })
}

///|
pub fn[T] SlotMap::retain(
  self : SlotMap[T],
  f : (SlotKey[T], T) -> Bool,
) -> Unit {
  for key in self.keys() {
    let value = self.at(key)
    if !f(key, value) {
      let _ = self.remove(key)
    }
  }
}

///|
pub fn[T] SlotMap::clear(self : SlotMap[T]) -> Unit {
  self.values.clear()
  self.generations.clear()
  self.free.clear()
  self.len = 0
}

///|
pub fn[T] SlotMap::copy(self : SlotMap[T]) -> SlotMap[T] {
  {
    values: self.values.copy(),
    generations: self.generations.copy(),
    free: self.free.copy(),
    len: self.len,
  }
}

///|
/// A slot map that also keeps the entries in a dense array, so iteration follows
/// insertion order and a removal moves the last entry into the hole. The keys are
/// the same `SlotKey`s a `SlotMap` hands out; what changes is that the entries
/// are contiguous while they live, which is what a caller who walks the whole
/// container wants.
pub struct DenseSlotMap[T] {
  values : Array[T?]
  generations : Array[UInt32]
  /// The slot of each dense position.
  dense : Array[Int32]
  /// The dense position of each slot, `-1` when the slot is empty.
  positions : Array[Int32]
  free : Array[Int32]
  mut len : Int32
}

///|
pub fn[T] DenseSlotMap::new(capacity~ : Int32 = 0) -> DenseSlotMap[T] {
  let values : Array[T?] = []
  let generations : Array[UInt32] = []
  let positions : Array[Int32] = []
  if capacity > 0 {
    values.reserve_capacity(capacity)
    generations.reserve_capacity(capacity)
    positions.reserve_capacity(capacity)
  }
  { values, generations, dense: [], positions, free: [], len: 0, }
}

///|
pub fn[T] DenseSlotMap::insert(self : DenseSlotMap[T], value : T) -> SlotKey[T] {
  let slot = match self.free.pop() {
    Some(slot) => {
      self.values[slot] = Some(value)
      slot
    }
    None => {
      self.values.push(Some(value))
      self.generations.push(0U)
      self.positions.push(-1)
      self.values.length() - 1
    }
  }
  self.positions[slot] = self.dense.length()
  self.dense.push(slot)
  self.len = self.len + 1
  { index: slot, generation: self.generations[slot], }
}

///|
pub fn[T] DenseSlotMap::get(self : DenseSlotMap[T], key : SlotKey[T]) -> T? {
  if key.index < 0 || key.index >= self.values.length() {
    return None
  }
  if self.generations[key.index] != key.generation {
    return None
  }
  self.values[key.index]
}

///|
pub fn[T] DenseSlotMap::at(self : DenseSlotMap[T], key : SlotKey[T]) -> T {
  match self.get(key) {
    Some(value) => value
    None => abort("moonstl: a slot key that holds nothing")
  }
}

///|
pub fn[T] DenseSlotMap::set(
  self : DenseSlotMap[T],
  key : SlotKey[T],
  value : T,
) -> Bool {
  match self.get(key) {
    Some(_) => {
      self.values[key.index] = Some(value)
      true
    }
    None => false
  }
}

///|
pub fn[T] DenseSlotMap::remove(self : DenseSlotMap[T], key : SlotKey[T]) -> T? {
  match self.get(key) {
    Some(value) => {
      let slot = key.index
      let position = self.positions[slot]
      let last = self.dense.length() - 1
      if position != last {
        let moved = self.dense[last]
        self.dense[position] = moved
        self.positions[moved] = position
      }
      let _ = self.dense.pop()
      self.positions[slot] = -1
      self.values[slot] = None
      self.generations[slot] = self.generations[slot] + 1U
      self.free.push(slot)
      self.len = self.len - 1
      Some(value)
    }
    None => None
  }
}

///|
pub fn[T] DenseSlotMap::contains(
  self : DenseSlotMap[T],
  key : SlotKey[T],
) -> Bool {
  self.get(key) is Some(_)
}

///|
pub fn[T] DenseSlotMap::length(self : DenseSlotMap[T]) -> Int32 {
  self.len
}

///|
pub fn[T] DenseSlotMap::capacity(self : DenseSlotMap[T]) -> Int32 {
  self.values.length()
}

///|
pub fn[T] DenseSlotMap::is_empty(self : DenseSlotMap[T]) -> Bool {
  self.len == 0
}

///|
/// The entries in insertion order.
pub fn[T] DenseSlotMap::iter(self : DenseSlotMap[T]) -> Iter[T] {
  let mut cursor = 0
  Iter::new(() => {
    if cursor >= self.dense.length() {
      None
    } else {
      let slot = self.dense[cursor]
      cursor = cursor + 1
      self.values[slot]
    }
  })
}

///|
pub fn[T] DenseSlotMap::keys(self : DenseSlotMap[T]) -> Iter[SlotKey[T]] {
  let mut cursor = 0
  Iter::new(() => {
    if cursor >= self.dense.length() {
      None
    } else {
      let slot = self.dense[cursor]
      cursor = cursor + 1
      let key : SlotKey[T] = {
        index: slot,
        generation: self.generations[slot],
      }
      Some(key)
    }
  })
}

///|
pub fn[T] DenseSlotMap::iter2(self : DenseSlotMap[T]) -> Iter2[SlotKey[T], T] {
  let mut cursor = 0
  Iter2::new(() => {
    if cursor >= self.dense.length() {
      None
    } else {
      let slot = self.dense[cursor]
      cursor = cursor + 1
      let key : SlotKey[T] = {
        index: slot,
        generation: self.generations[slot],
      }
      match self.values[slot] {
        Some(value) => Some((key, value))
        None => None
      }
    }
  })
}

///|
pub fn[T] DenseSlotMap::to_array(self : DenseSlotMap[T]) -> Array[T] {
  let out : Array[T] = []
  for value in self.iter() {
    out.push(value)
  }
  out
}

///|
pub fn[T] DenseSlotMap::clear(self : DenseSlotMap[T]) -> Unit {
  self.values.clear()
  self.generations.clear()
  self.dense.clear()
  self.positions.clear()
  self.free.clear()
  self.len = 0
}

///|
pub fn[T] DenseSlotMap::copy(self : DenseSlotMap[T]) -> DenseSlotMap[T] {
  {
    values: self.values.copy(),
    generations: self.generations.copy(),
    dense: self.dense.copy(),
    positions: self.positions.copy(),
    free: self.free.copy(),
    len: self.len,
  }
}

///|
/// A side table keyed by the slots of another map: it holds a value per slot and
/// never invents a slot of its own. `resize` tells it how many slots the owner
/// has; a key outside that range is refused, which is how a side table stays in
/// step with the store it describes instead of quietly growing past it.
pub struct SecondaryMap[T] {
  values : Array[T?]
  mut slots : Int32
}

///|
pub fn[T] SecondaryMap::new() -> SecondaryMap[T] {
  { values: [], slots: 0, }
}

///|
/// Tells the side table how many slots the owning map has.
pub fn[T] SecondaryMap::resize(
  self : SecondaryMap[T],
  slots~ : Int32,
) -> Unit raise @spec.Refused {
  if slots < 0 {
    raise @spec.Refused::Capacity(got=slots)
  }
  while self.values.length() < slots {
    self.values.push(None)
  }
  self.slots = slots
}

///|
pub fn[T] SecondaryMap::get(self : SecondaryMap[T], key : SlotKey[T]) -> T? {
  if key.index < 0 || key.index >= self.slots {
    return None
  }
  self.values[key.index]
}

///|
pub fn[T] SecondaryMap::at(self : SecondaryMap[T], key : SlotKey[T]) -> T {
  match self.get(key) {
    Some(value) => value
    None => abort("moonstl: a secondary map slot that holds nothing")
  }
}

///|
pub fn[T] SecondaryMap::set(
  self : SecondaryMap[T],
  key : SlotKey[T],
  value : T,
) -> Unit raise @spec.Refused {
  if key.index < 0 || key.index >= self.slots {
    raise @spec.Refused::Capacity(got=key.index)
  }
  self.values[key.index] = Some(value)
}

///|
pub fn[T] SecondaryMap::remove(self : SecondaryMap[T], key : SlotKey[T]) -> T? {
  match self.get(key) {
    Some(value) => {
      self.values[key.index] = None
      Some(value)
    }
    None => None
  }
}

///|
pub fn[T] SecondaryMap::contains(
  self : SecondaryMap[T],
  key : SlotKey[T],
) -> Bool {
  self.get(key) is Some(_)
}

///|
pub fn[T] SecondaryMap::length(self : SecondaryMap[T]) -> Int32 {
  let mut count = 0
  for value in self.values {
    if value is Some(_) {
      count = count + 1
    }
  }
  count
}

///|
pub fn[T] SecondaryMap::is_empty(self : SecondaryMap[T]) -> Bool {
  self.length() == 0
}

///|
/// The values that are held, in slot order.
pub fn[T] SecondaryMap::iter(self : SecondaryMap[T]) -> Iter[T] {
  let mut cursor = 0
  Iter::new(() => {
    while cursor < self.slots {
      match self.values[cursor] {
        Some(value) => {
          cursor = cursor + 1
          return Some(value)
        }
        None => cursor = cursor + 1
      }
    }
    None
  })
}

///|
pub fn[T] SecondaryMap::clear(self : SecondaryMap[T]) -> Unit {
  for i in 0..<self.values.length() {
    self.values[i] = None
  }
}

///|
pub fn[T] SecondaryMap::copy(self : SecondaryMap[T]) -> SecondaryMap[T] {
  { values: self.values.copy(), slots: self.slots, }
}
