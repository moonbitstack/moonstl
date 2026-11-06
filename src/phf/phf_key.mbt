///|
/// The byte encoding a key is hashed from.
///
/// A perfect hash table can only be probed with the exact encoding it was built
/// from, so `String` and `StringView` share one encoding on purpose: a table
/// generated for string keys answers both. Every implementation has to be
/// deterministic and independent of the backend, because `PhfBuilder::build_source`
/// output is compared byte for byte across machines.
pub(open) trait PhfKey {
  fn to_bytes(Self) -> Bytes
}

///|
/// The UTF-16 code units of a string in little-endian order. `String` and
/// `StringView` share the encoding, so a table built from one answers the other,
/// and it does not depend on the backend's idea of an `Int`.
fn utf16_bytes(view : StringView) -> Bytes {
  let out = FixedArray::make(view.length() * 2, b'\x00')
  for i in 0..<view.length() {
    let unit = view[i]
    out[2 * i] = (unit & 0xFF).to_int().to_byte()
    out[2 * i + 1] = (unit >> 8).to_int().to_byte()
  }
  Bytes::from_array(out[:])
}

///|
pub impl PhfKey for String with fn to_bytes(self) {
  utf16_bytes(self[:])
}

///|
pub impl PhfKey for StringView with fn to_bytes(self) {
  utf16_bytes(self)
}

///|
/// The low 32 bits little-endian, sign-extended to 64 so the encoding does not
/// depend on whether `Int` is 32 bits (wasm) or 64 bits (native).
pub impl PhfKey for Int32 with fn to_bytes(self) {
  self.to_int64().reinterpret_as_uint64().to_le_bytes()
}

///|
/// The bits of the value in little-endian byte order.
pub impl PhfKey for Int64 with fn to_bytes(self) {
  self.reinterpret_as_uint64().to_le_bytes()
}

///|
/// The bits of the value in little-endian byte order.
pub impl PhfKey for UInt64 with fn to_bytes(self) {
  self.to_le_bytes()
}
