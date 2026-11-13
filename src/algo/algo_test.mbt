///|
/// A fixed pseudo-random sequence, so every randomised case here replays the
/// same way on every backend.
priv struct AlgoRng {
  mut state : UInt64
}

///|
fn AlgoRng::new(seed : UInt64) -> AlgoRng {
  { state: seed, }
}

///|
fn AlgoRng::below(self : AlgoRng, bound : Int32) -> Int32 {
  self.state = self.state * 6364136223846793005 + 1442695040888963407
  let value = (self.state >> 33).to_uint().reinterpret_as_int()
  (value % bound).abs()
}

///|
test "bisect: matches a linear scan on every position" {
  let rng = AlgoRng::new(0x2545f4914f6cdd1d)
  let values : Array[Int32] = []
  let mut next = 0
  for _ in 0..<200 {
    next = next + rng.below(3)
    values.push(next)
  }
  for probe in 0..<(next + 2) {
    let mut left = 0
    while left < values.length() && values[left] < probe {
      left = left + 1
    }
    let mut right = 0
    while right < values.length() && values[right] <= probe {
      right = right + 1
    }
    @test.assert_eq(@algo.bisect_left(values[:], probe), left)
    @test.assert_eq(@algo.bisect_right(values[:], probe), right)
    @test.assert_eq(@algo.equal_range(values[:], probe), (left, right))
  }
}

///|
test "bisect by: a descending order is searched with its own comparator" {
  let values : Array[Int32] = [9, 7, 5, 3, 1]
  let descending = (a : Int32, b : Int32) => b.compare(a)
  @test.assert_eq(@algo.bisect_left_by(values[:], 5, cmp=descending), 2)
  @test.assert_eq(@algo.bisect_right_by(values[:], 5, cmp=descending), 3)
}

///|
test "insort: keeps the run sorted" {
  let run : Array[Int32] = [1, 3, 3, 7]
  @algo.insort_left_in_place(run, 3)
  @test.assert_eq(run, [1, 3, 3, 3, 7])
  @algo.insort_right_in_place(run, 4)
  @test.assert_eq(run, [1, 3, 3, 3, 4, 7])
}

///|
test "sorted and selection: the k-th element and the k smallest" {
  let rng = AlgoRng::new(0x9e3779b97f4a7c15)
  let values : Array[Int32] = []
  for _ in 0..<300 {
    values.push(rng.below(1000))
  }
  let ordered = @algo.sorted(values[:])
  for k in [0, 1, 7, 150, 298, 299] {
    let probe = values.copy()
    @algo.nth_element_in_place(probe, k)
    @test.assert_eq(probe[k], ordered[k])
  }
  @test.assert_eq(@algo.k_smallest(5, values[:]), ordered[:5].to_owned())
  @test.assert_eq(@algo.k_largest(5, values[:]), ordered[295:].to_owned().rev())
}

///|
test "partial sort: the first k are the k smallest and sorted" {
  let values : Array[Int32] = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
  let probe = values.copy()
  @algo.partial_sort_in_place(probe, 4)
  @test.assert_eq(probe[:4].to_owned(), [0, 1, 2, 3])
}

///|
test "extremes: positions and the sets that hold them" {
  let values : Array[Int32] = [3, 1, 4, 1, 5, 9, 2, 6, 5]
  @test.assert_eq(@algo.position_min(values[:]), Some(1))
  @test.assert_eq(@algo.position_max(values[:]), Some(5))
  @test.assert_eq(@algo.min_max_element(values[:]), Some((1, 5)))
  @test.assert_eq(@algo.min_set(values[:]).length(), 2)
  @test.assert_eq(@algo.max_set(values[:]).length(), 1)
  let spread : Array[Int32] = [4, 1, 9]
  @test.assert_eq(@algo.min_max(spread.iter()), Some((1, 9)))
  @test.assert_eq(@algo.clamp(12, min=0, max=10), 10)
}

///|
test "permutations of a run: next follows lexicographic order" {
  let run : Array[Int32] = [1, 2, 3]
  let seen : Array[Array[Int32]] = [run.copy()]
  while @algo.next_permutation_in_place(run) {
    seen.push(run.copy())
  }
  @test.assert_eq(seen.length(), 6)
  @test.assert_eq(seen[0], [1, 2, 3])
  @test.assert_eq(seen[5], [3, 2, 1])
  @test.assert_eq(run, [1, 2, 3])
  @test.assert_eq(@algo.prev_permutation_in_place(run), false)
  @test.assert_eq(run, [3, 2, 1])
}

///|
test "permutation generators: count and order" {
  let permutations : @algo.Permutations[Int32] = @algo.Permutations::new([
    1, 2, 3,
  ])
  @test.assert_eq(permutations.iter().to_array().length(), 6)
  let pairs : @algo.Permutations[Int32] = @algo.Permutations::new(
    [1, 2, 3],
    length=2,
  )
  @test.assert_eq(pairs.iter().to_array(), [
    [1, 2],
    [1, 3],
    [2, 1],
    [2, 3],
    [3, 1],
    [3, 2],
  ])
  let combinations : @algo.Combinations[Int32] = @algo.Combinations::new(
    [1, 2, 3, 4],
    k=3,
  )
  @test.assert_eq(combinations.iter().to_array(), [
    [1, 2, 3],
    [1, 2, 4],
    [1, 3, 4],
    [2, 3, 4],
  ])
  let power : @algo.Powerset[Int32] = @algo.Powerset::new([1, 2, 3])
  @test.assert_eq(power.iter().to_array().length(), 8)
  let code : @algo.GrayCode = @algo.GrayCode::new(3)
  let words = code.iter().to_array()
  @test.assert_eq(words.length(), 8)
  for i in 1..<words.length() {
    let mut flips = 0
    for j in 0..<3 {
      if words[i][j] != words[i - 1][j] {
        flips = flips + 1
      }
    }
    @test.assert_eq(flips, 1)
  }
}

///|
test "partition and rotation: shapes survive" {
  let values : Array[Int32] = [1, 2, 3, 4, 5, 6, 7, 8]
  let probe = values.copy()
  let boundary = @algo.stable_partition_in_place(probe, x => x % 2 == 0)
  @test.assert_eq(boundary, 4)
  @test.assert_eq(probe, [2, 4, 6, 8, 1, 3, 5, 7])
  let rotated = values.copy()
  @algo.rotate_in_place(rotated, mid=3)
  @test.assert_eq(rotated, [4, 5, 6, 7, 8, 1, 2, 3])
  @test.assert_eq(@algo.rotate(values[:], mid=6), [7, 8, 1, 2, 3, 4, 5, 6])
  let pair = @algo.partition_copy(values[:], x => x > 5)
  @test.assert_eq(pair.0, [6, 7, 8])
  @test.assert_eq(pair.1, [1, 2, 3, 4, 5])
}

///|
test "merge: two runs and k runs agree" {
  let left : Array[Int32] = [1, 4, 7]
  let right : Array[Int32] = [2, 3, 9]
  @test.assert_eq(@algo.merge(left[:], right[:]), [1, 2, 3, 4, 7, 9])
  let merged = left.copy()
  @algo.merge_in_place(merged, right)
  @test.assert_eq(merged, [1, 2, 3, 4, 7, 9])
  let many : Array[ArrayView[Int32]] = [[1, 5][:], [2, 6][:], [3, 4][:]]
  @test.assert_eq(@algo.k_way_merge(many), [1, 2, 3, 4, 5, 6])
}

///|
test "merge join by: the entries line up" {
  let left : Array[Int32] = [1, 3, 5]
  let right : Array[Int32] = [2, 3, 6]
  let joined = @algo.merge_join_by(left[:], right[:], cmp=(a, b) => a.compare(b))
  @test.assert_eq(joined.to_array().length(), 5)
}

///|
test "dedup and run queries" {
  let values : Array[Int32] = [1, 1, 2, 3, 3, 3, 4]
  @test.assert_eq(@algo.unique(values[:]), [1, 2, 3, 4])
  @test.assert_eq(@algo.duplicates(values[:]), [1, 3])
  @test.assert_eq(@algo.all_equal(values[:]), false)
  @test.assert_eq(@algo.all_equal([7, 7, 7][:]), true)
  @test.assert_eq(@algo.all_unique([1, 2, 3][:]), true)
  @test.assert_eq(@algo.is_palindrome([1, 2, 1][:]), true)
  @test.assert_eq(@algo.is_partitioned([2, 4, 1, 3][:], x => x % 2 == 0), true)
  @test.assert_eq(
    @algo.is_partitioned_until([2, 1, 4][:], x => x % 2 == 0),
    Some(2),
  )
  @test.assert_eq(
    @algo.is_partitioned_until([2, 4, 1][:], x => x % 2 == 0),
    None,
  )
  @test.assert_eq(@algo.mismatch([1, 2, 3][:], [1, 2, 4][:]), Some((2, 2)))
  @test.assert_eq(@algo.mismatch([1, 2][:], [1, 2][:]), None)
  @test.assert_eq(@algo.find_run([1, 4, 7, 1, 4, 9][:], [1, 4][:]), Some(0))
}

///|
test "prefix sums and differences" {
  let values : Array[Int32] = [1, 2, 3, 4]
  @test.assert_eq(@algo.prefix_sum(values[:], op=(a, b) => a + b), [1, 3, 6, 10])
  let running = values.copy()
  @algo.scan_in_place(running, op=(a, b) => a + b)
  @test.assert_eq(running, [1, 3, 6, 10])
  @test.assert_eq(@algo.adjacent_difference(values[:], op=(a, b) => a - b), [
    1, 1, 1, 1,
  ])
}

///|
test "lazy adaptors: chunks, windows and interleave" {
  let numbers : Array[Int32] = [1, 2, 3, 4, 5]
  @test.assert_eq(@algo.chunks(numbers.iter(), 2).to_array(), [
    [1, 2],
    [3, 4],
    [5],
  ])
  @test.assert_eq(@algo.windows_circular(numbers[:], 3).to_array().length(), 5)
  @test.assert_eq(
    @algo.interleave([1, 3][:].iter(), [2, 4][:].iter()).to_array(),
    [1, 2, 3, 4],
  )
  @test.assert_eq(
    @algo.interleave_shortest([1, 3, 5][:].iter(), [2][:].iter()).to_array(),
    [1, 2],
  )
  @test.assert_eq(
    @algo.zip_longest([1][:].iter(), [2, 3][:].iter(), fill=0, fill_b=0).to_array(),
    [(1, 2), (0, 3)],
  )
  @test.assert_eq(@algo.count(1).take(3).to_array(), [1, 2, 3])
  @test.assert_eq(
    @algo.chunk_by([1, 1, 2, 3, 3][:].iter(), (a, b) => a == b).to_array(),
    [[1, 1], [2], [3, 3]],
  )
}

///|
test "lazy adaptors: folds" {
  @test.assert_eq(
    @algo.fold_first([1, 2, 3][:].iter(), (a, b) => a + b),
    Some(6),
  )
  let empty : Array[Int32] = []
  @test.assert_eq(@algo.fold_first(empty[:].iter(), (a, b) => a + b), None)
  @test.assert_eq(
    @algo.tree_reduce([1, 2, 3, 4][:].iter(), (a, b) => a + b),
    Some(10),
  )
  @test.assert_eq(
    @algo.fold_while([1, 2, 3, 4][:].iter(), init=0, (sum, x) => {
      if x > 2 {
        Err(sum)
      } else {
        Ok(sum + x)
      }
    }),
    3,
  )
}

///|
test "randomised: nth element agrees with sorting" {
  let rng = AlgoRng::new(0xdeadbeefcafebabe)
  for round in 0..<20 {
    let values : Array[Int32] = []
    for _ in 0..<40 {
      values.push(rng.below(50))
    }
    let ordered = @algo.sorted(values[:])
    let k = rng.below(40)
    let probe = values.copy()
    @algo.nth_element_in_place(probe, k)
    @test.assert_eq(probe[k], ordered[k])
    let merged = @algo.merge(values[:], ordered[:])
    @test.assert_eq(merged.length(), values.length() + ordered.length())
    ignore(round)
  }
}

///|
test "windows: every contiguous run of the size, in order" {
  let run : Array[Int32] = [1, 2, 3, 4, 5]
  @test.assert_eq(@algo.windows(run[:], 1).to_array(), [[1], [2], [3], [4], [5]])
  @test.assert_eq(@algo.windows(run[:], 2).to_array(), [
    [1, 2],
    [2, 3],
    [3, 4],
    [4, 5],
  ])
  @test.assert_eq(@algo.windows(run[:], 3).to_array(), [
    [1, 2, 3],
    [2, 3, 4],
    [3, 4, 5],
  ])
  @test.assert_eq(@algo.windows(run[:], 5).to_array(), [[1, 2, 3, 4, 5]])
  @test.assert_eq(@algo.windows(run[:], 6).to_array().length(), 0)
  @test.assert_eq(@algo.windows(run[:], 0).to_array().length(), 0)
  @test.assert_eq(@algo.windows(run[:], -2).to_array().length(), 0)
  let empty : Array[Int32] = []
  @test.assert_eq(@algo.windows(empty[:], 1).to_array().length(), 0)
}

///|
test "windows: the run is read as it is, and stays as it was" {
  let run : Array[Int32] = [7, 8, 9]
  let windows = @algo.windows(run[:], 2).to_array()
  @test.assert_eq(windows, [[7, 8], [8, 9]])
  @test.assert_eq(run, [7, 8, 9])
  // a window is a copy: changing one leaves the run and the other windows alone
  windows[0][0] = 0
  @test.assert_eq(run, [7, 8, 9])
  @test.assert_eq(windows[1], [8, 9])
}

///|
test "reservoir: a draw of the whole stream keeps it in order" {
  let run : Array[Int32] = [10, 20, 30, 40, 50]
  @test.assert_eq(@algo.reservoir_sample(run.iter(), k=5, seed=7UL), [
    10, 20, 30, 40, 50,
  ])
  @test.assert_eq(@algo.reservoir_sample(run.iter(), k=99, seed=7UL), [
    10, 20, 30, 40, 50,
  ])
}

///|
test "reservoir: an empty draw and an empty stream" {
  let run : Array[Int32] = [1, 2, 3]
  @test.assert_eq(@algo.reservoir_sample(run.iter(), k=0, seed=1UL).length(), 0)
  @test.assert_eq(
    @algo.reservoir_sample(run.iter(), k=-3, seed=1UL).length(),
    0,
  )
  let empty : Array[Int32] = []
  @test.assert_eq(
    @algo.reservoir_sample(empty[:].iter(), k=4, seed=1UL).length(),
    0,
  )
}

///|
test "reservoir: the same seed draws the same sample" {
  let run : Array[Int32] = []
  for i in 0..<64 {
    run.push(i)
  }
  @test.assert_eq(
    @algo.reservoir_sample(run[:].iter(), k=8, seed=0x2545f4914f6cdd1dUL),
    @algo.reservoir_sample(run[:].iter(), k=8, seed=0x2545f4914f6cdd1dUL),
  )
  // a different seed is a different draw; over eight slots a collision is
  // possible but a run of two seeds that agree everywhere is not
  let a = @algo.reservoir_sample(run[:].iter(), k=8, seed=1UL)
  let b = @algo.reservoir_sample(run[:].iter(), k=8, seed=2UL)
  @test.assert_not_eq(a, b)
}

///|
test "reservoir: a sample holds stream elements, each at most once" {
  let run : Array[Int32] = []
  for i in 0..<20 {
    run.push(i)
  }
  for seed in 0..<50 {
    let drawn = @algo.reservoir_sample(
      run[:].iter(),
      k=6,
      seed=seed.to_uint64(),
    )
    @test.assert_eq(drawn.length(), 6)
    let seen : Array[Bool] = []
    for _ in 0..<20 {
      seen.push(false)
    }
    for x in drawn {
      @test.assert_eq(x >= 0 && x < 20, true)
      @test.assert_eq(seen[x], false)
      seen[x] = true
    }
  }
}

///|
test "reservoir: every element is drawn about k/n of the time" {
  // 8 elements, 2 slots, 4000 seeds: each element should land in about 1000
  // draws, with a standard deviation near 27. The bounds below are more than
  // five deviations wide, so a real bias fails here and noise does not.
  let run : Array[Int32] = [0, 1, 2, 3, 4, 5, 6, 7]
  let counts : Array[Int32] = []
  for _ in 0..<8 {
    counts.push(0)
  }
  for seed in 0..<4000 {
    for x in @algo.reservoir_sample(run[:].iter(), k=2, seed=seed.to_uint64()) {
      counts[x] = counts[x] + 1
    }
  }
  for x in 0..<8 {
    @test.assert_eq(counts[x] > 850 && counts[x] < 1150, true)
  }
}
