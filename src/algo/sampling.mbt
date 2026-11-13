// Sampling from a stream of unknown length. The draw is a pure function of the
// elements and the seed, so a test — or a service replaying a log — gets the
// same sample twice.

///|
/// The generator behind `reservoir_sample`: SplitMix64, the stream the module
/// already mixes seeds with. Its state is one word, so a sample can be resumed
/// or reproduced from a number alone, and it needs no platform entropy.
priv struct SampleRng {
  mut state : UInt64
}

///|
fn SampleRng::new(seed : UInt64) -> SampleRng {
  { state: seed, }
}

///|
fn SampleRng::next(self : SampleRng) -> UInt64 {
  self.state = self.state + 0x9e3779b97f4a7c15
  let mut z = self.state
  z = (z ^ (z >> 30)) * 0xbf58476d1ce4e5b9
  z = (z ^ (z >> 27)) * 0x94d049bb133111eb
  z ^ (z >> 31)
}

///|
/// A value in `0 ..< bound`, each equally likely. The top of the word is
/// rejected rather than folded, so the modulo that follows sees a multiple of
/// `bound` and cannot favour the low residues.
fn SampleRng::below(self : SampleRng, bound : UInt64) -> UInt64 {
  if bound <= 1 {
    return 0
  }
  let limit = 0xFFFFFFFFFFFFFFFFUL - 0xFFFFFFFFFFFFFFFFUL % bound
  let mut z = self.next()
  while z >= limit {
    z = self.next()
  }
  z % bound
}

///|
/// Draws `k` elements from the sequence, each element ending up in the result
/// with probability `k / n` — reservoir sampling, so the length of the
/// sequence need not be known in advance and the sequence is read once.
///
/// The result keeps the drawn elements in the order they were read: the first
/// `k` fill the reservoir as they arrive, and a later element replaces one of
/// them at a position drawn uniformly. `k` at or above the length returns every
/// element in order; a `k` of zero or less returns nothing.
///
/// The draw is a function of the stream and `seed`, and of nothing else, so the
/// same seed gives the same sample. Pass one whenever a run has to be
/// reproducible; without it the process-wide seed is used, which differs
/// between runs.
///
/// ```mbt check
/// test {
///   let run : Array[Int32] = [10, 20, 30, 40, 50]
///   let all = @algo.reservoir_sample(run.iter(), k=9, seed=1UL)
///   assert_eq(all, [10, 20, 30, 40, 50])
///   let one = @algo.reservoir_sample(run.iter(), k=2, seed=1UL)
///   assert_eq(one.length(), 2)
///   assert_eq(one, @algo.reservoir_sample(run.iter(), k=2, seed=1UL))
/// }
/// ```
pub fn[T] reservoir_sample(
  it : Iter[T],
  k~ : Int32,
  seed? : UInt64,
) -> Array[T] {
  let out : Array[T] = []
  if k <= 0 {
    return out
  }
  let start = match seed {
    Some(s) => s
    None => @spec.hash_seed().reinterpret_as_uint().to_uint64()
  }
  let rng = SampleRng::new(start)
  let mut seen = 0
  for x in it {
    if out.length() < k {
      out.push(x)
    } else {
      let slot = rng.below((seen + 1).to_uint64())
      if slot < k.reinterpret_as_uint().to_uint64() {
        out[slot.to_int()] = x
      }
    }
    seen = seen + 1
  }
  out
}
