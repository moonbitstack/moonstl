///|
/// Code-unit access shared by the matchers. Every scan here works on the
/// UTF-16 units `String::length` counts, so an index a caller gets back can be
/// handed to `StringView::exact_view` unchanged.
fn unit_at(view : StringView, index : Int32) -> UInt16 {
  view.unsafe_get(index)
}

///|
/// The unit at `index` widened to a key for the hash tables the matchers use.
fn key_at(view : StringView, index : Int32) -> Int32 {
  view.unsafe_get(index).to_int()
}

///|
/// Whether `unit` is the first half of a surrogate pair, which is the only
/// place an offset can fall that is not a character boundary.
fn is_high_surrogate(unit : UInt16) -> Bool {
  unit >= 0xD800 && unit <= 0xDBFF
}

///|
/// Whether `unit` is the second half of a surrogate pair.
fn is_low_surrogate(unit : UInt16) -> Bool {
  unit >= 0xDC00 && unit <= 0xDFFF
}

///|
/// Whether `offset` falls between the two halves of a surrogate pair in
/// `view`, which is the one position a slice or an edit may not cut at.
fn splits_pair(view : StringView, offset : Int32) -> Bool {
  offset > 0 &&
  offset < view.length() &&
  is_high_surrogate(view.unsafe_get(offset - 1)) &&
  is_low_surrogate(view.unsafe_get(offset))
}
