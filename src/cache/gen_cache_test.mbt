// Differential vectors for `cache`. The values are computed by the Python
// standard library (scripts/gen_vectors.py) and, byte for byte, by the Rust
// standard library (scripts/rust_vectors); scripts/check_vector_agreement.sh
// re-checks the two agree. They are the reference: the tests replay the same
// operations on the library and assert it produces the same results. CI
// replays these vectors; it does not regenerate them.

///|
/// The key index evicted at each LRU step (-1 when none).
let cache_lru_evicted : Array[Int32] = [-1, -1, -1, -1, 1, -1, 0, 3]

///|
/// Surviving key indices after each step, sorted.
let cache_lru_survivors : Array[Array[Int32]] = [
  [0],
  [0, 1],
  [0, 1, 2],
  [0, 1, 2],
  [0, 2, 3],
  [0, 2, 3],
  [2, 3, 4],
  [1, 2, 4],
]

///|
/// The key the LFU cache evicts when the seventh insert arrives.
let cache_lfu_evicted : Int32 = 2

///|
/// The queried times.
let cache_exp_times : Array[Int64] = [0L, 5L, 8L, 10L, 108L]

///|
/// The number of keys still alive when read at each time.
let cache_exp_alive_count : Array[Int32] = [3, 3, 3, 1, 0]

///|
test "differential: lru eviction order matches" {
  let cache : @cache.LruCache[Int32, Int32] = @cache.LruCache::new(capacity=3)
  let log : Array[(Int32, String, Int32)] = [
    (0, "set", 1),
    (1, "set", 2),
    (2, "set", 3),
    (0, "get", 0),
    (3, "set", 4),
    (2, "get", 0),
    (4, "set", 5),
    (1, "set", 6),
  ]
  for step in 0..<log.length() {
    let (key, verb, value) = log[step]
    if verb == "set" {
      let displaced = cache.set(key, value)
      if cache_lru_evicted[step] < 0 {
        @test.assert_eq(displaced, None)
      } else {
        match displaced {
          Some(pair) => @test.assert_eq(pair.0, cache_lru_evicted[step])
          None => @test.assert_eq(false, true)
        }
      }
    } else {
      let _ = cache.get(key)
    }
    @test.assert_eq(cache.length(), cache_lru_survivors[step].length())
    for k in cache_lru_survivors[step] {
      @test.assert_eq(cache.contains(k), true)
    }
  }
}

///|
test "differential: lfu keeps the most frequent" {
  let cache : @cache.LfuCache[Int32, Int32] = @cache.LfuCache::new(capacity=3)
  let _ = cache.set(0, 1)
  let _ = cache.set(1, 1)
  let _ = cache.set(2, 1)
  let _ = cache.get(0)
  let _ = cache.get(0)
  let _ = cache.get(1)
  let displaced = cache.set(3, 1)
  match displaced {
    Some(pair) => @test.assert_eq(pair.0, cache_lfu_evicted)
    None => @test.assert_eq(false, true)
  }
  @test.assert_eq(cache.frequency(0), Some(3))
  @test.assert_eq(cache.frequency(1), Some(2))
  @test.assert_eq(cache.frequency(2), None)
}

///|
test "differential: expiring cache drops at the deadline" {
  let mut now = 0L
  let cache : @cache.ExpiringCache[Int32, Int32] = @cache.ExpiringCache::new(
    ttl=100,
    capacity=8,
    now=() => now,
  )
  let _ = cache.set(0, 1, ttl=10)
  let _ = cache.set(1, 1, ttl=10)
  let _ = cache.set(2, 1, ttl=108)
  for i in 0..<cache_exp_times.length() {
    now = cache_exp_times[i]
    let mut alive = 0
    if cache.get(0) is Some(_) {
      alive = alive + 1
    }
    if cache.get(1) is Some(_) {
      alive = alive + 1
    }
    if cache.get(2) is Some(_) {
      alive = alive + 1
    }
    @test.assert_eq(alive, cache_exp_alive_count[i])
  }
}
