///|
/// The process-wide seed every hashed container starts from, drawn once from
/// the platform's entropy on first use. A program that builds no hash table
/// draws nothing.
///
/// A per-process seed makes the bucket layout, and with it the iteration order,
/// differ between runs, so a key set chosen to collide in one run does not
/// collide in the next. Pass `hash_seed=0`, or any fixed value, when a run has
/// to be reproducible.
///
/// ```mbt check
/// test {
///   let a = @spec.hash_seed()
///   let b = @spec.hash_seed()
///   @test.assert_eq(a, b)
/// }
/// ```
pub fn hash_seed() -> Int32 {
  match seed_state.value {
    Some(seed) => seed
    None => {
      let drawn : Result[Int32, Unit] = Ok(seed_from_entropy()) catch {
        _ => Err(())
      }
      match drawn {
        Ok(seed) => {
          seed_state.value = Some(seed)
          seed_state.random = true
          seed
        }
        Err(_) => {
          seed_state.value = Some(0)
          seed_state.random = false
          0
        }
      }
    }
  }
}

///|
/// Whether this platform gave real entropy to `hash_seed`. `false` means the
/// platform has no source — a wasm host without WASI — and every hashed
/// container runs from a seed of zero, which is still correct, only
/// predictable.
///
/// ```mbt check
/// test {
///   let _ = @spec.hash_seed()
///   let random = @spec.hash_seed_is_random()
///   @test.assert_eq(random, @spec.hash_seed_is_random())
/// }
/// ```
pub fn hash_seed_is_random() -> Bool {
  let _ = hash_seed()
  seed_state.random
}

///|
/// A seed derived from bytes the caller already holds, which is how a service
/// reproduces the layout of its tables across restarts: pass the same bytes and
/// every container lays out the same way.
///
/// ```mbt check
/// test {
///   @test.assert_eq(
///     @spec.hash_seed_from(b"moonstl"),
///     @spec.hash_seed_from(b"moonstl"),
///   )
///   @test.assert_not_eq(
///     @spec.hash_seed_from(b"moonstl"),
///     @spec.hash_seed_from(b"moonst"),
///   )
/// }
/// ```
pub fn hash_seed_from(bytes : BytesView) -> Int32 {
  // FNV-1a over the bytes, then the splitmix64 finalizer so that two similar
  // inputs land far apart, as a seed has to.
  let mut hash : UInt64 = 0xcbf29ce484222325
  for i in 0..<bytes.length() {
    hash = (hash ^ bytes[i].to_int().to_uint64()) * 0x100000001b3
  }
  let mixed = mix64(hash)
  let seed = (mixed >> 32).to_uint().reinterpret_as_int()
  if seed == 0 {
    1
  } else {
    seed
  }
}

///|
fn seed_from_entropy() -> Int32 raise {
  let bytes = @moonseed.bytes(32, @system.source)
  hash_seed_from(bytes[:])
}

///|
/// The finalizer splitmix64 uses, which spreads any input across all 64 bits.
fn mix64(value : UInt64) -> UInt64 {
  let mut z = value
  z = (z ^ (z >> 30)) * 0xbf58476d1ce4e5b9
  z = (z ^ (z >> 27)) * 0x94d049bb133111eb
  z ^ (z >> 31)
}

///|
priv struct SeedState {
  mut value : Int32?
  mut random : Bool
}

///|
let seed_state : SeedState = { value: None, random: false, }
