// The matchers are checked against each other and against the plain loops they
// replace, and the rope against a plain `String`.

///|
test "matchers agree on every offset" {
  let text = "abracadabra abracadabra"
  let pattern = "abra"
  let expected : Array[Int32] = [0, 7, 12, 19]
  @test.assert_eq(@text.Kmp::new(pattern).search_all(text).to_array(), expected)
  @test.assert_eq(
    @text.BoyerMoore::new(pattern).search_all(text).to_array(),
    expected,
  )
  let automaton = @text.AhoCorasick::new([pattern])
  let found : Array[Int32] = []
  for (_, offset) in automaton.search_all(text) {
    found.push(offset)
  }
  @test.assert_eq(found, expected)
}

///|
test "a matcher that finds nothing says so" {
  @test.assert_eq(@text.Kmp::new("zz").search("abc"), None)
  @test.assert_eq(@text.BoyerMoore::new("zz").search("abc"), None)
  @test.assert_eq(@text.AhoCorasick::new(["zz"]).is_match("abc"), false)
}

///|
test "z function is a repeated prefix count" {
  let text = "aabxaab"
  let z = @text.z_function(text)
  @test.assert_eq(z[0], 7)
  for i in 1..<text.length() {
    let mut length = 0
    while i + length < text.length() &&
          text.unsafe_get(length) == text.unsafe_get(i + length) {
      length = length + 1
    }
    @test.assert_eq(z[i], length)
  }
}

///|
test "longest palindrome agrees with the plain scan" {
  for text in ["forgeeksskeegfor", "abc", "aaaa", "abacdfgdcaba", "x"] {
    let (start, end) = @text.longest_palindrome(text)
    let found = text[start:end].to_owned()
    @test.assert_eq(found.iter().to_array(), found.rev_iter().to_array())
    // Nothing longer is a palindrome, so the scan found the longest one.
    for bigger in (end - start + 1)..<=text.length() {
      for from in 0..<(text.length() - bigger + 1) {
        let window = text[from:from + bigger].to_owned()
        @test.assert_eq(
          window.iter().to_array() == window.rev_iter().to_array(),
          false,
        )
      }
    }
  }
}

///|
test "suffix array finds what the naive scan finds" {
  let text = "mississippi"
  let array = @text.SuffixArray::new(text)
  for pattern in ["ss", "is", "ppi", "mississippi", "x"] {
    let expected : Array[Int32] = []
    let m = pattern.length()
    for i in 0..<(text.length() - m + 1) {
      if text[i:i + m].to_owned() == pattern {
        expected.push(i)
      }
    }
    @test.assert_eq(array.search(pattern), expected)
  }
  let lcp = array.lcp_array()
  @test.assert_eq(lcp.length(), text.length())
}

///|
test "suffix automaton counts what the naive scan counts" {
  let text = "banana"
  let automaton = @text.SuffixAutomaton::new(text)
  for pattern in ["a", "an", "ana", "banana", "nan", "x"] {
    let mut expected = 0
    let m = pattern.length()
    for i in 0..<(text.length() - m + 1) {
      if text[i:i + m].to_owned() == pattern {
        expected = expected + 1
      }
    }
    @test.assert_eq(automaton.count_occurrences(pattern), expected)
    @test.assert_eq(automaton.contains(pattern), expected > 0)
  }
  // The range names a window of the second text, not of this one.
  let other = "cabana"
  let (start, end) = automaton.longest_common_substring(other)
  @test.assert_eq(other[start:end].to_owned(), "bana")
}

///|
test "sequence matcher: opcodes describe the change" {
  let left : Array[Char] = "abcd".iter().to_array()
  let right : Array[Char] = "bcde".iter().to_array()
  let matcher : @text.SequenceMatcher[Char] = @text.SequenceMatcher::new(
    left[:],
    right[:],
  )
  let opcodes = matcher.get_opcodes()
  @test.assert_eq(opcodes.length(), 3)
  @test.assert_eq(opcodes[0].tag(), "delete")
  @test.assert_eq(opcodes[1].tag(), "equal")
  @test.assert_eq(opcodes[2].tag(), "insert")
  @test.assert_eq(matcher.ratio(), 0.75)
  @test.assert_eq(matcher.real_quick_ratio(), 1.0)
  @test.assert_eq(matcher.quick_ratio() >= matcher.ratio(), true)
}

///|
test "sequence matcher: junk keeps blank lines out of the diff" {
  let options : @text.SequenceMatcherOptions[Char] = {
    autojunk: false,
    junk: @text.is_character_junk,
  }
  let left : Array[Char] = "a b".iter().to_array()
  let right : Array[Char] = "ab".iter().to_array()
  let strict : @text.SequenceMatcher[Char] = @text.SequenceMatcher::new(
    left[:],
    right[:],
  )
  let loose : @text.SequenceMatcher[Char] = @text.SequenceMatcher::new(
    left[:],
    right[:],
    options~,
  )
  @test.assert_eq(loose.ratio() >= strict.ratio(), true)
}

///|
test "ndiff and unified diff mark the lines" {
  let before = "one\ntwo\nthree\n"
  let after = "one\nthree\nfour\n"
  let plain = @text.ndiff(before, after)
  @test.assert_eq(plain.contains("- two"), true)
  @test.assert_eq(plain.contains("+ four"), true)
  @test.assert_eq(plain.contains("  one"), true)
  let unified = @text.unified_diff(before, after, fromfile="a", tofile="b")
  @test.assert_eq(unified.contains("--- a"), true)
  @test.assert_eq(unified.contains("+++ b"), true)
  @test.assert_eq(unified.contains("@@"), true)
  let restored = @text.restore(plain)
  @test.assert_eq(restored.length() > 0, true)
}

///|
test "close matches rank by similarity" {
  let candidates : Array[StringView] = ["apple", "apply", "ape", "banana"]
  let close = @text.get_close_matches("appel", candidates, n=2)
  @test.assert_eq(close.length(), 2)
  @test.assert_eq(close[0], "apple")
}

///|
test "rope: edits against a string model" {
  let rope = @text.Rope::from_string("hello world")
  let mut model = "hello world"
  rope.insert(5, ",")
  model = "hello, world"
  @test.assert_eq(rope.to_string(), model)
  rope.edit(start=0, end=5, "goodbye")
  model = "goodbye, world"
  @test.assert_eq(rope.to_string(), model)
  rope.remove(start=0, end=7)
  model = ", world"
  @test.assert_eq(rope.to_string(), model)
  rope.append("!")
  model = ", world!"
  @test.assert_eq(rope.to_string(), model)
  @test.assert_eq(rope.length(), model.length())
}

///|
test "rope: lines and offsets" {
  let rope = @text.Rope::from_string("alpha\nbeta\ngamma")
  @test.assert_eq(rope.line_count(), 3)
  @test.assert_eq(rope.line_start(1), 6)
  @test.assert_eq(rope.line_at(7), 1)
  @test.assert_eq(rope.lines().to_array(), ["alpha", "beta", "gamma"])
  @test.assert_eq(rope.char_at(0), Some('a'))
  @test.assert_eq(rope.char_at(100), None)
}

///|
test "rope: a view reads without copying the document" {
  let rope = @text.Rope::from_string("0123456789")
  let window = rope.slice(start=3, end=6)
  @test.assert_eq(window.to_string(), "345")
  @test.assert_eq(window.length(), 3)
  rope.append("!")
  @test.assert_eq(window.to_string(), "345")
  let split = rope.split_off(4)
  @test.assert_eq(rope.to_string(), "0123")
  @test.assert_eq(split.to_string(), "456789!")
}
