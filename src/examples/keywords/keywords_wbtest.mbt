///|
test "every keyword reads as its token, in the order it was written" {
  for i, entry in keywords {
    assert_eq(keywords_phf.get(entry.0), Some(entry.1))
    assert_eq(keywords_phf.index(entry.0), Some(i))
  }
  assert_eq(keywords_phf.get("loop"), None)
  assert_eq(keywords_phf.length(), keywords.length())
}
