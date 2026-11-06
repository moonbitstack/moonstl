///| Little-endian byte plumbing shared by the six sketch formats.
///
/// Every format starts with a four-byte magic and a version byte, so a buffer
/// written by a different sketch, or by a later layout, is refused instead of
/// being misread as garbage.

///|
/// The layout version written after every magic. It is bumped when a field
/// changes, which turns an older buffer into a refusal rather than a
/// reinterpretation.
const FORMAT_VERSION : Int32 = 1

///|
/// The four magic values, spelled as megabytes of ASCII in the order the
/// little-endian writer emits them: `MBLF`, `MCKF`, `MCMS`, `MHLL`, `MTHS`,
/// `MTDG`.
const MAGIC_BLOOM : UInt32 = 0x464C424D

///|
const MAGIC_CUCKOO : UInt32 = 0x464B434D

///|
const MAGIC_COUNT_MIN : UInt32 = 0x534D434D

///|
const MAGIC_HYPERLOGLOG : UInt32 = 0x4C4C484D

///|
const MAGIC_THETA : UInt32 = 0x5348544D

///|
const MAGIC_TDIGEST : UInt32 = 0x4744544D

///|
/// The error a decoder raises for a buffer it cannot accept: one that ends in
/// the middle of a field, carries a foreign magic, or holds counts that do not
/// fit the payload. `Refused` has no buffer-specific case, and every sketch
/// format is opaque to the caller, so `Incompatible` is the closest fit.
fn[A] decode_failure() -> A raise @spec.Refused {
  raise @spec.Refused::Incompatible
}

///|
/// A growable little-endian byte sink.
priv struct Writer {
  data : Array[Byte]
}

///|
fn Writer::new() -> Writer {
  { data: [], }
}

///|
fn Writer::write_byte(self : Writer, value : Int32) -> Unit {
  self.data.push((value & 0xFF).to_byte())
}

///|
fn Writer::write_u32(self : Writer, value : UInt32) -> Unit {
  self.write_byte(value.reinterpret_as_int())
  self.write_byte((value >> 8).reinterpret_as_int())
  self.write_byte((value >> 16).reinterpret_as_int())
  self.write_byte((value >> 24).reinterpret_as_int())
}

///|
fn Writer::write_u64(self : Writer, value : UInt64) -> Unit {
  let mut shift = 0
  while shift < 64 {
    self.write_byte(((value >> shift) & 0xFFUL).to_uint().reinterpret_as_int())
    shift = shift + 8
  }
}

///|
fn Writer::write_i64(self : Writer, value : Int64) -> Unit {
  self.write_u64(value.reinterpret_as_uint64())
}

///|
fn Writer::write_double(self : Writer, value : Double) -> Unit {
  self.write_u64(value.reinterpret_as_uint64())
}

///|
fn Writer::to_bytes(self : Writer) -> Bytes {
  Bytes::from_array(self.data[:])
}

///|
/// A bounds-checked little-endian byte source. Every read either returns a
/// complete field or raises, so no partially decoded sketch is ever built.
priv struct Reader {
  view : BytesView
  mut pos : Int32
}

///|
fn Reader::new(view : BytesView) -> Reader {
  { view, pos: 0, }
}

///|
fn Reader::remaining(self : Reader) -> Int32 {
  self.view.length() - self.pos
}

///|
fn Reader::read_byte(self : Reader) -> Int32 raise @spec.Refused {
  if self.remaining() < 1 {
    decode_failure()
  }
  let value = self.view[self.pos]
  self.pos = self.pos + 1
  value.to_int()
}

///|
fn Reader::read_u32(self : Reader) -> UInt32 raise @spec.Refused {
  let b0 = self.read_byte().reinterpret_as_uint()
  let b1 = self.read_byte().reinterpret_as_uint()
  let b2 = self.read_byte().reinterpret_as_uint()
  let b3 = self.read_byte().reinterpret_as_uint()
  b0 | (b1 << 8) | (b2 << 16) | (b3 << 24)
}

///|
fn Reader::read_u64(self : Reader) -> UInt64 raise @spec.Refused {
  let low = self.read_u32().to_uint64()
  let high = self.read_u32().to_uint64()
  low | (high << 32)
}

///|
fn Reader::read_i64(self : Reader) -> Int64 raise @spec.Refused {
  self.read_u64().reinterpret_as_int64()
}

///|
fn Reader::read_double(self : Reader) -> Double raise @spec.Refused {
  self.read_u64().reinterpret_as_double()
}

///|
/// Reads a count and checks it against the bytes left, so a corrupt length
/// cannot make the decoder allocate a table larger than its own buffer.
fn Reader::read_count(
  self : Reader,
  element_bytes : Int32,
) -> Int32 raise @spec.Refused {
  let raw = self.read_u32().reinterpret_as_int()
  if raw < 0 || raw > self.remaining() / element_bytes {
    decode_failure()
  }
  raw
}

///|
/// Writes the magic and the layout version, which every format starts with.
fn Writer::write_header(self : Writer, magic : UInt32) -> Unit {
  self.write_u32(magic)
  self.write_byte(FORMAT_VERSION)
}

///|
/// Checks the magic and the layout version of a buffer.
fn Reader::read_header(
  self : Reader,
  magic : UInt32,
) -> Unit raise @spec.Refused {
  if self.read_u32() != magic {
    decode_failure()
  }
  if self.read_byte() != FORMAT_VERSION {
    decode_failure()
  }
}

///|
/// A decoder rejects trailing bytes: a buffer that carries more than the
/// format defines came from somewhere other than `encode`.
fn Reader::expect_end(self : Reader) -> Unit raise @spec.Refused {
  if self.remaining() != 0 {
    decode_failure()
  }
}

///|
/// A 32-bit hash widened to 64 bits without sign extension.
fn widen(value : Int32) -> UInt64 {
  (value.to_int64() & 0xFFFFFFFFL).reinterpret_as_uint64()
}

///|
/// The 64-bit hash of one item under a sketch's seed: two passes of the core
/// hasher under different seeds, concatenated. 64 bits are what a sketch needs
/// to carry a bucket index and a rank in one word.
fn[T : Hash] hash_with_seed(item : T, seed : Int32) -> UInt64 {
  let low = Hasher(seed~)
  low.combine(item)
  let high = Hasher(seed=seed ^ 0x5BD1E995)
  high.combine(item)
  widen(low.finalize()) | (widen(high.finalize()) << 32)
}

///|
/// The SplitMix64 finalizer. It spreads the bits of a hash that a sketch
/// derives from another one: a second bucket index, a layer position, or the
/// next step of a kick sequence.
fn mix64(value : UInt64) -> UInt64 {
  let mut z = value + 0x9E3779B97F4A7C15UL
  z = (z ^ (z >> 30)) * 0xBF58476D1CE4E5B9UL
  z = (z ^ (z >> 27)) * 0x94D049BB133111EBUL
  z ^ (z >> 31)
}
