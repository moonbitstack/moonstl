///|
/// Counters every cache keeps. `hits` and `misses` count lookups, `evictions`
/// counts the entries a policy dropped to make room — a `remove` is not an
/// eviction, and neither is a replacement.
#derive(Eq, Debug)
pub(all) struct CacheStats {
  hits : Int64
  misses : Int64
  evictions : Int64
}

///|
pub extend CacheStats with Eq::{equal, not_equal}

///|
pub extend CacheStats with Debug::{to_repr}

///|
pub impl Show for CacheStats with fn output(self, logger) {
  logger.write_string(
    "CacheStats(hits=\{self.hits}, misses=\{self.misses}, evictions=\{self.evictions})",
  )
}

///|
pub extend CacheStats with Show::{to_string, output}

///|
/// The hit rate, or `0` when nothing has been looked up.
///
/// ```mbt check
/// test {
///   let stats : @cache.CacheStats = { hits: 3, misses: 1, evictions: 0, }
///   @test.assert_eq(stats.hit_rate(), 0.75)
/// }
/// ```
pub fn CacheStats::hit_rate(self : CacheStats) -> Double {
  let lookups = self.hits + self.misses
  if lookups == 0 {
    0.0
  } else {
    self.hits.to_double() / lookups.to_double()
  }
}
