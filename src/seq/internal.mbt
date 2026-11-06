///|
/// Rejects a capacity the caller cannot mean: zero or less for a container that
/// allocates on demand, or a ceiling below the data already stored.
fn require_capacity(capacity : Int32) -> Unit raise @spec.Refused {
  if capacity <= 0 {
    raise @spec.Refused::Capacity(got=capacity)
  }
}

///|
/// Rounds `value` up to the next multiple of 64, saturating rather than
/// overflowing, so a huge bit capacity is refused later instead of wrapping.
fn words_for(bits : Int32) -> Int32 {
  if bits <= 0 {
    0
  } else if bits > 0x7FFFFFF - 64 {
    0x7FFFFFFF
  } else {
    (bits + 63) / 64
  }
}

///|
/// The smallest storage size that can hold `needed` elements while doubling,
/// clamped to a ceiling. Used by every container that grows on demand.
fn grown_size(current : Int32, needed : Int32, ceiling : Int32) -> Int32 {
  let doubled = if current > ceiling / 2 { ceiling } else { current * 2 }
  let target = if doubled < needed { needed } else { doubled }
  if target > ceiling {
    ceiling
  } else {
    target
  }
}

///|
fn[T : Debug] debug_items(items : Array[T]) -> Array[Repr] {
  let out : Array[Repr] = []
  for value in items {
    out.push(Debug::to_repr(value))
  }
  out
}

///|
fn[T : Show] show_items(items : Array[T], logger : &Logger) -> Unit {
  for i, value in items {
    if i > 0 {
      logger.write_string(", ")
    }
    Show::output(value, logger)
  }
}
