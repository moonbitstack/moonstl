///|
fn flat(code : String) -> String {
  let out = StringBuilder()
  for c in code {
    if c != ' ' && c != '\n' {
      out.write_char(c)
    }
  }
  out
  .to_string()
  .replace_all(old=",)", new=")")
  .replace_all(old=",]", new="]")
  .replace_all(old=",}", new="}")
}

///|
fn generate(source : String) -> String raise {
  flat(@gen.render(Phf::{ }, [("m.mbt", source)]))
}

///|
fn refused(source : String) -> String {
  try {
    ignore(generate(source))
    ""
  } catch {
    e => "\{e}"
  }
}

///|
/// The layout the program itself would build for these keys.
fn runtime_layout(
  keys : Array[String],
  options? : @phf.PhfOptions,
) -> String raise {
  let b : @phf.PhfBuilder[String, Unit] = @phf.PhfBuilder::new(
    phf_options=options.unwrap_or(@phf.phf_options),
  )
  for k in keys {
    b.entry(k, ())
  }
  flat(layout_source(b.build().layout()))
}

///|
test "a map's layout is the one the builder makes at run time" {
  let code = generate(
    (
      #|#phf.map
      #|pub let keywords : Array[(String, @tok.Kind)] = [("loop", Loop), ("while", While), ("for", For)]
    ),
  )
  assert_true(
    code.contains(
      flat(
        "let keywords_phf_layout : @phf.PhfLayout = " +
        runtime_layout(["loop", "while", "for"]),
      ),
    ),
  )
  assert_true(
    code.contains(
      flat(
        "pub let keywords_phf : @phf.PhfMap[String, @tok.Kind] = try { @phf.PhfMap::from_layout(keywords_phf_layout, keywords) }",
      ),
    ),
  )
}

///|
test "escaped keys are hashed as the program holds them" {
  let code = generate(
    (
      #|#phf.set
      #|let words : Array[String] = ["a\tb\u{41}", "\x41\o102", "C\\"]
    ),
  )
  assert_true(code.contains(runtime_layout(["a\tbA", "AB", "C\\"])))
  assert_true(
    code.contains(
      flat(
        "let words_phf : @phf.PhfSet[String] = try { @phf.PhfSet::from_layout(words_phf_layout, words) }",
      ),
    ),
  )
}

///|
test "integer keys keep their sign, base and width" {
  let code = generate(
    (
      #|#phf.ordered_set
      #|let codes : Array[Int] = [-2, 0x1_0, 0b11, 0o17, 2147483647, -2147483648]
    ),
  )
  let b : @phf.PhfBuilder[Int32, Unit] = @phf.PhfBuilder::new()
  for k in [-2, 16, 3, 15, 2147483647, -2147483648] {
    b.entry(k, ())
  }
  assert_true(code.contains(flat(layout_source(b.build().layout()))))
  let wide = generate(
    (
      #|#phf.map
      #|let big : Array[(UInt64, Bool)] = [(18446744073709551615UL, true), (0UL, false)]
    ),
  )
  let u : @phf.PhfBuilder[UInt64, Unit] = @phf.PhfBuilder::new()
  u.entry(18446744073709551615UL, ())
  u.entry(0UL, ())
  assert_true(wide.contains(flat(layout_source(u.build().layout()))))
}

///|
test "the options set the name and the layout" {
  let code = generate(
    (
      #|#phf.ordered_map(name="table", build="minimal", seed="7")
      #|let pairs : Array[(String, Int)] = [("a", 1), ("b", 2), ("c", 3)]
    ),
  )
  let options : @phf.PhfOptions = { build: Minimal, seed: 7, }
  assert_true(code.contains(runtime_layout(["a", "b", "c"], options~)))
  assert_true(
    code.contains(
      flat(
        "let table : @phf.PhfOrderedMap[String, Int] = try { @phf.PhfOrderedMap::from_layout(table_layout, pairs) }",
      ),
    ),
  )
  assert_true(!code.contains("pub"))
}

///|
test "what the generator refuses, and where" {
  inspect(
    refused("#phf.map\nlet m : Array[(String, Int)] = [(name, 1)]"),
    content="m.mbt:2:34: a key is a literal string or integer, worked out before the program runs",
  )
  inspect(
    refused("#phf.set\nlet s = [\"a\"]"),
    content="m.mbt:1:1: the list is declared `Array[K]`, so the table knows its types",
  )
  inspect(
    refused("#phf.set\nlet s : Array[String] = [\"a\", 1]"),
    content="m.mbt:1:1: every key has one type; Int sits among String keys",
  )
  inspect(
    refused("#phf.set\nlet s : Array[String] = [\"a\", \"a\"]"),
    content="m.mbt:1:1: a key is written twice",
  )
  inspect(
    refused("#phf.set\nlet s : Array[Int] = [\"a\"]"),
    content="m.mbt:1:1: the keys are String but the list says Int",
  )
  inspect(
    refused("#phf.set\nlet s : Array[Double] = []"),
    content="m.mbt:1:1: a key is String, Int, Int64 or UInt64, not Double",
  )
  inspect(
    refused("#phf.set(build=\"fast\")\nlet s : Array[String] = [\"a\"]"),
    content="m.mbt:1:1: `build` is search, quick or minimal, not `fast`",
  )
  inspect(
    refused("#phf.map\nfn f() -> Unit {}"),
    content="m.mbt:1:1: the annotation goes on a top-level `let`",
  )
  inspect(
    refused("#phf.dict\nlet s : Array[String] = []"),
    content="m.mbt:1:1: `#phf.dict` is not a moonstl annotation",
  )
  inspect(
    refused("#phf.set\nlet s : Array[String] = make()"),
    content="m.mbt:1:1: the list is written out, `[...]`, so its keys can be read now",
  )
  inspect(
    refused("#phf.set\nlet s : Array[Int] = [2147483648]"),
    content="m.mbt:2:23: 2147483648 is not an Int",
  )
}

///|
test "a declaration without the annotation is left alone" {
  assert_true(!generate("let s : Array[String] = [\"a\"]").contains("let"))
}
