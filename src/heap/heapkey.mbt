///|
/// Which end of the order a heap pops from.
///
/// `Min` pops the element that compares smallest and is what Python's `heapq`
/// and Java's `PriorityQueue` do; `Max` pops the largest and is what C++ and
/// core's `PriorityQueue` do. The two are one comparator apart, so the
/// direction is a value rather than a second type.
#derive(Eq, Debug)
pub(all) enum Order {
  Min
  Max
}

///|
pub extend Order with Eq::{equal, not_equal}

///|
pub extend Order with @moonbitlang/core/debug.Debug::{to_repr}

///|

///|

///|
pub impl Show for Order with fn output(self, logger) {
  match self {
    Min => logger.write_string("Min")
    Max => logger.write_string("Max")
  }
}

///|
pub extend Order with Show::{to_string, output}

///|
/// A stable handle to one entry of an addressable heap.
///
/// `index` names the entry's slot and `generation` the state that slot was in
/// when the handle was issued. A slot is reused after its entry is removed and
/// the generation is then bumped, so a handle kept past a removal names nothing
/// and every method taking one reports a miss instead of reaching the element
/// that took the slot. The type parameter names the element type the handle came
/// from, which keeps a handle from one heap type from being passed to another;
/// it holds no data.
#warnings("-unused_type_variable")
pub(all) struct HeapKey[T] {
  index : Int32
  generation : UInt32
}

///|
/// Two handles are equal when they name the same slot in the same generation.
pub impl[T] Eq for HeapKey[T] with fn equal(self, other) {
  self.index == other.index && self.generation == other.generation
}

///|
pub extend HeapKey with Eq::{equal, not_equal}

///|
pub impl[T] Hash for HeapKey[T] with fn hash_combine(self, hasher) {
  hasher.combine(self.index)
  hasher.combine(self.generation)
}

///|
pub extend HeapKey with Hash::{hash, hash_combine}

///|
pub impl[T] Show for HeapKey[T] with fn output(self, logger) {
  logger.write_string("HeapKey(\{self.index}, \{self.generation})")
}

///|
pub extend HeapKey with Show::{to_string, output}

///|
/// The JSON form is an object of the two fields, so a key can be stored in a
/// side table between runs; the element type is not part of it.
pub impl[T] ToJson for HeapKey[T] with fn to_json(self) {
  Json::object({
    "index": Json::number(self.index.to_double()),
    "generation": Json::number(self.generation.to_double()),
  })
}

///|
pub extend HeapKey with ToJson::{to_json}

///|
pub impl[T] FromJson for HeapKey[T] with fn from_json(json, path) {
  guard json is Object(fields) else {
    raise JsonDecodeError((path, "HeapKey::from_json: expected an object"))
  }
  let index = match fields.get("index") {
    Some(value) => decode_i32(value, path, "index")
    None => raise JsonDecodeError((path, "HeapKey::from_json: missing index"))
  }
  let generation = match fields.get("generation") {
    Some(value) => decode_u32(value, path, "generation")
    None =>
      raise JsonDecodeError((path, "HeapKey::from_json: missing generation"))
  }
  { index, generation, }
}

///|
pub extend HeapKey with FromJson::{from_json}

///|
/// Reads one `Int32` field of a serialised key, rejecting a value that would
/// wrap.
fn decode_i32(
  json : Json,
  path : @json.JsonPath,
  field : String,
) -> Int32 raise @json.JsonDecodeError {
  guard json is Number(value, ..) else {
    raise JsonDecodeError((path, "HeapKey: \{field} is not a number"))
  }
  if value > 2147483647.0 || value < -2147483648.0 {
    raise JsonDecodeError((path, "HeapKey: \{field} is out of range"))
  }
  value.to_int()
}

///|
/// Reads one `UInt32` field of a serialised key, rejecting a value that would
/// wrap.
fn decode_u32(
  json : Json,
  path : @json.JsonPath,
  field : String,
) -> UInt32 raise @json.JsonDecodeError {
  guard json is Number(value, ..) else {
    raise JsonDecodeError((path, "HeapKey: \{field} is not a number"))
  }
  if value < 0.0 || value > 4294967295.0 {
    raise JsonDecodeError((path, "HeapKey: \{field} is out of range"))
  }
  value.to_uint()
}
