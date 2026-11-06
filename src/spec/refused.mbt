///|
/// The only error this module raises. Input that cannot be used — a capacity
/// that cannot hold the data, a rate outside its range, an arity that is not a
/// tree — is refused here; a lookup that simply finds nothing returns `None`
/// instead, and an out-of-range index aborts as `Array` does.
#derive(Eq, Debug)
pub(all) suberror Refused {
  /// A capacity of zero or less, or below what the input needs.
  Capacity(got~ : Int32)
  /// A rate outside `(0, 1)`.
  Probability(got~ : Double)
  /// A branching factor below 2.
  Arity(got~ : Int32)
  /// A sketch precision outside its documented range.
  Precision(got~ : Int32)
  /// A bijection was given a value that is already the image of another key.
  DuplicateValue
  /// A monotone heap was given a key below the last one it popped.
  NonMonotone(got~ : UInt64, limit~ : UInt64)
  /// A fixed capacity was given more elements than it holds.
  TooMany(limit~ : Int32)
  /// Two sketches of different shape were asked to combine.
  Incompatible
  /// A range was inserted where the overlap policy forbids it.
  Overlap
}

///|
pub extend Refused with Eq::{equal, not_equal}

///|
pub extend Refused with Debug::{to_repr}

///|
pub impl Show for Refused with fn output(self, logger) {
  match self {
    Capacity(got~) => logger.write_string("capacity \{got}")
    Probability(got~) => logger.write_string("probability \{got}")
    Arity(got~) => logger.write_string("arity \{got}")
    Precision(got~) => logger.write_string("precision \{got}")
    DuplicateValue => logger.write_string("duplicate value")
    NonMonotone(got~, limit~) =>
      logger.write_string("key \{got} is below the last popped \{limit}")
    TooMany(limit~) => logger.write_string("more than \{limit} elements")
    Incompatible => logger.write_string("incompatible shapes")
    Overlap => logger.write_string("overlapping range")
  }
}

///|
pub extend Refused with Show::{to_string, output}
