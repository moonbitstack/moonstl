///|
/// Wraps `f` so that each argument is computed once and remembered, the way
/// `functools.lru_cache` does it: the returned function keeps the last
/// `capacity` results and recomputes anything that fell out.
///
/// ```mbt check
/// test {
///   let mut calls = 0
///   let square : (Int32) -> Int32 = @cache.memoize(
///     key => {
///       calls += 1
///       key * key
///     },
///     capacity=8,
///   )
///   @test.assert_eq(square(4), 16)
///   @test.assert_eq(square(4), 16)
///   @test.assert_eq(calls, 1)
/// }
/// ```
pub fn[K : Hash + Eq, V] memoize(
  f : (K) -> V,
  capacity~ : Int32,
) -> ((K) -> V) raise @spec.Refused {
  let cache : LruCache[K, V] = LruCache::new(capacity~)
  key => {
    match cache.get(key) {
      Some(value) => value
      None => {
        let value = f(key)
        let _ = cache.set(key, value)
        value
      }
    }
  }
}
