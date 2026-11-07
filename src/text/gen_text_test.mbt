// Differential vectors for `text`. The values are computed by the Python
// standard library (scripts/gen_vectors.py) and, byte for byte, by the Rust
// standard library (scripts/rust_vectors); scripts/check_vector_agreement.sh
// re-checks the two agree. They are the reference: the tests replay the same
// operations on the library and assert it produces the same results. CI
// replays these vectors; it does not regenerate them.

///|
/// The text the searchers scan.
let text_text : String = "ababcababcab"

///|
/// The KMP pattern.
let text_kmp_pattern : String = "cabab"

///|
/// Every start of the pattern.
let text_kmp_occ : Array[Int32] = [4]

///|
/// The Aho-Corasick text.
let text_ac_text : String = "ushers"

///|
/// For each pattern, in order, the start positions where it occurs.
let text_ac_starts : Array[Array[Int32]] = [[2], [1], [], [2]]

///|
/// The total number of occurrences.
let text_ac_total : Int32 = 3

///|
/// The string whose Z-function is taken.
let text_z_str : String = "aabxaaby"

///|
/// The Z-function of the string.
let text_z_arr : Array[Int32] = [8, 1, 0, 0, 3, 1, 0, 0]

///|
/// The string whose suffixes are ordered.
let text_sa_str : String = "banana"

///|
/// Suffix starts in lexicographic order.
let text_sa_order : Array[Int32] = [5, 3, 1, 0, 4, 2]

///|
/// The first sequence of the matcher.
let text_sm_a : String = "abcd"

///|
/// The second sequence of the matcher.
let text_sm_b : String = "acb"

///|
/// The similarity ratio of the two sequences.
let text_sm_ratio : Double = 0.571428571

///|
test "differential: kmp finds every occurrence" {
  let kmp : @text.Kmp = @text.Kmp::new(text_kmp_pattern)
  @test.assert_eq(kmp.search_all(text_text).to_array(), text_kmp_occ)
}

///|
test "differential: aho-corasick finds every hit" {
  let ac : @text.AhoCorasick = @text.AhoCorasick::new([
    "he", "she", "his", "hers",
  ])
  let matches = ac.search_all(text_ac_text).to_array()
  @test.assert_eq(matches.length(), text_ac_total)
  for m in matches {
    let p = m.0
    let s = m.1
    let mut valid = false
    for t in text_ac_starts[p] {
      if t == s {
        valid = true
      }
    }
    @test.assert_eq(valid, true)
  }
}

///|
test "differential: z function matches a reference" {
  @test.assert_eq(@text.z_function(text_z_str), text_z_arr)
}

///|
test "differential: suffix array orders the suffixes" {
  let sa : @text.SuffixArray = @text.SuffixArray::new(text_sa_str)
  @test.assert_eq(sa.to_array(), text_sa_order)
}

///|
test "differential: sequence matcher ratio matches difflib" {
  let m : @text.SequenceMatcher[Char] = @text.SequenceMatcher::new(
    text_sm_a.iter().to_array(),
    text_sm_b.iter().to_array(),
  )
  @test.assert_eq(
    m.ratio() > text_sm_ratio - 0.0000001 &&
    m.ratio() < text_sm_ratio + 0.0000001,
    true,
  )
}
