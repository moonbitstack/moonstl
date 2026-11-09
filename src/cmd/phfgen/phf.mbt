///|
/// `#phf.map`, `#phf.ordered_map`, `#phf.set` and `#phf.ordered_set` on a
/// top-level `let` holding a literal list, turned into a perfect hash table whose
/// layout is worked out now, at build time. The list stays where it is and the
/// table reads it, so the values need not be literals; only the keys are hashed
/// here.
priv struct Phf {}

///|
impl @gen.Generator for Phf with fn name(_) {
  "moonstl phf"
}

///|
/// What the generator refuses, as the line a reader sees: where, then why.
priv suberror Refused {
  Refused(String)
}

///|
impl Show for Refused with fn output(self, logger) {
  let Refused(why) = self
  logger.write_string(why)
}

///|
/// The four tables, by the annotation that asks for each.
priv enum Table {
  Map
  OrderedMap
  Set
  OrderedSet
}

///|
fn Table::of(name : String) -> Table? {
  match name {
    "phf.map" => Some(Map)
    "phf.ordered_map" => Some(OrderedMap)
    "phf.set" => Some(Set)
    "phf.ordered_set" => Some(OrderedSet)
    _ => None
  }
}

///|
fn Table::type_name(self : Table) -> String {
  match self {
    Map => "PhfMap"
    OrderedMap => "PhfOrderedMap"
    Set => "PhfSet"
    OrderedSet => "PhfOrderedSet"
  }
}

///|
fn Table::is_set(self : Table) -> Bool {
  self is (Set | OrderedSet)
}

///|
/// Every table takes the same options, the flat mirror of `PhfOptions` plus the
/// name of what is generated.
fn spec(name : String) -> @attr.Spec {
  @attr.Spec::new(name)
  .optional("name", Str)
  .optional("build", Str)
  .optional("seed", Str)
}

///|
/// A key as the source writes it, already in the type the table hashes.
priv enum Key {
  Text(String)
  Int(Int32)
  Int64(Int64)
  UInt64(UInt64)
}

///|
fn Key::type_name(self : Key) -> String {
  match self {
    Text(_) => "String"
    Int(_) => "Int"
    Int64(_) => "Int64"
    UInt64(_) => "UInt64"
  }
}

///|
fn at_expr(e : @syntax.Expr) -> String {
  let l = e.loc()
  "\{l.start.fname}:\{l.start.lnum}:\{l.start.column()}"
}

///|
fn at_type(t : @syntax.Type) -> String {
  let l = t.loc()
  "\{l.start.fname}:\{l.start.lnum}:\{l.start.column()}"
}

///|
fn hex_digit(c : Char) -> Int32? {
  match c {
    '0'..<='9' => Some(c.to_int() - '0'.to_int())
    'a'..<='f' => Some(c.to_int() - 'a'.to_int() + 10)
    'A'..<='F' => Some(c.to_int() - 'A'.to_int() + 10)
    _ => None
  }
}

///|
/// A string literal's text as the compiler reads it. The parser hands keys over
/// with their escapes still written, and a key hashed in its written form would
/// not be the key the program holds at run time. The escapes are the lexer's:
/// the single-character ones, `\xHH`, `\oOOO`, `\uHHHH` and `\u{...}`.
fn unescape(raw : String, where_ : String) -> String raise {
  let cs = raw.to_array()
  let out = StringBuilder()
  let mut i = 0
  fn code(from : Int32, len : Int32, base : Int32) -> Int32 raise {
    guard from + len <= cs.length() else {
      raise Refused("\{where_}: a key ends inside an escape")
    }
    let mut n = 0
    for k in from..<(from + len) {
      guard hex_digit(cs[k]) is Some(d) && d < base else {
        raise Refused("\{where_}: `\{cs[k]}` is not a digit of this escape")
      }
      n = n * base + d
    }
    n
  }
  fn put(n : Int32) -> Unit raise {
    guard n <= 0x10FFFF && !(n >= 0xD800 && n <= 0xDFFF) else {
      raise Refused(
        "\{where_}: \\u{\{n.to_string(radix=16)}} is not a character",
      )
    }
    out.write_char(n.unsafe_to_char())
  }
  while i < cs.length() {
    let c = cs[i]
    if c != '\\' {
      out.write_char(c)
      i += 1
      continue
    }
    guard i + 1 < cs.length() else {
      raise Refused("\{where_}: a key ends in `\\`")
    }
    match cs[i + 1] {
      'n' => out.write_char('\n')
      't' => out.write_char('\t')
      'r' => out.write_char('\r')
      'b' => out.write_char('\b')
      'f' => out.write_char('\u{0C}')
      '\\' | '\'' | '"' | '`' | '/' | ' ' as e => out.write_char(e)
      'x' => {
        put(code(i + 2, 2, 16))
        i += 2
      }
      'o' => {
        put(code(i + 2, 3, 8))
        i += 3
      }
      'u' if i + 2 < cs.length() && cs[i + 2] == '{' => {
        let mut end = i + 3
        while end < cs.length() && cs[end] != '}' {
          end += 1
        }
        guard end < cs.length() && end > i + 3 else {
          raise Refused("\{where_}: `\\u{` has no closing brace")
        }
        put(code(i + 3, end - i - 3, 16))
        i = end - 1
      }
      'u' => {
        put(code(i + 2, 4, 16))
        i += 4
      }
      e => raise Refused("\{where_}: `\\\{e}` is not an escape")
    }
    i += 2
  }
  out.to_string()
}

///|
/// An integer literal's digits: the parser has already taken off the suffix and
/// folded a leading minus in, but keeps the base prefix and the underscores.
fn digits(raw : String) -> (Bool, UInt64, String)? {
  let negative = raw.has_prefix("-")
  let body = (if negative { raw[1:] } else { raw[:] })
    .to_owned()
    .replace_all(old="_", new="")
  let (base, text) = if body.has_prefix("0x") || body.has_prefix("0X") {
    (16, body[2:].to_owned())
  } else if body.has_prefix("0o") || body.has_prefix("0O") {
    (8, body[2:].to_owned())
  } else if body.has_prefix("0b") || body.has_prefix("0B") {
    (2, body[2:].to_owned())
  } else {
    (10, body)
  }
  guard text != "" else { return None }
  let mut n = 0UL
  for c in text {
    guard hex_digit(c) is Some(d) && d < base else { return None }
    let next = n * base.to_uint64() + d.to_uint64()
    guard (next - d.to_uint64()) / base.to_uint64() == n else { return None }
    n = next
  }
  Some((negative, n, text))
}

///|
fn key_of(e : @syntax.Expr) -> Key raise {
  let where_ = at_expr(e)
  let out_of_range = fn(raw : String, ty : String) -> Key raise {
    raise Refused("\{where_}: \{raw} is not an \{ty}")
  }
  match e {
    Constant(c=String(raw), ..) => Text(unescape(raw, where_))
    Constant(c=Int(raw), ..) =>
      match digits(raw) {
        Some((false, n, _)) if n <= 0x7FFFFFFFUL =>
          Int(n.reinterpret_as_int64().to_int())
        Some((true, n, _)) if n <= 0x80000000UL =>
          Int((0L - n.reinterpret_as_int64()).to_int())
        _ => out_of_range(raw, "Int")
      }
    Constant(c=Int64(raw), ..) =>
      match digits(raw) {
        Some((false, n, _)) if n <= 0x7FFFFFFFFFFFFFFFUL =>
          Int64(n.reinterpret_as_int64())
        Some((true, n, _)) if n <= 0x8000000000000000UL =>
          Int64(0L - n.reinterpret_as_int64())
        _ => out_of_range(raw, "Int64")
      }
    Constant(c=UInt64(raw), ..) =>
      match digits(raw) {
        Some((false, n, _)) => UInt64(n)
        _ => out_of_range(raw, "UInt64")
      }
    _ =>
      raise Refused(
        "\{where_}: a key is a literal string or integer, worked out before the program runs",
      )
  }
}

///|
/// The source text of a type the table names: a name with its arguments, a
/// tuple, or an option. Function types are refused rather than half printed.
fn type_text(t : @syntax.Type) -> String raise {
  match t {
    Name(constr_id={ id, .. }, tys~, ..) => {
      let head = match id {
        Ident(name~) => name
        Dot(pkg~, id~) => "@\{pkg}.\{id}"
      }
      if tys.is_empty() {
        head
      } else {
        let args = []
        for arg in tys {
          args.push(type_text(arg))
        }
        head + "[" + args.join(", ") + "]"
      }
    }
    Tuple(tys~, ..) => {
      let parts = []
      for part in tys {
        parts.push(type_text(part))
      }
      "(" + parts.join(", ") + ")"
    }
    Option(ty~, ..) => type_text(ty) + "?"
    _ =>
      raise Refused(
        "\{at_type(t)}: name the value type with a type alias; a table cannot spell this one",
      )
  }
}

///|
/// The key and value types out of `Array[(K, V)]`, or the key type out of
/// `Array[K]`.
fn element_types(
  ty : @syntax.Type?,
  table : Table,
  where_ : String,
) -> (String, String?) raise {
  let shape = if table.is_set() { "Array[K]" } else { "Array[(K, V)]" }
  guard ty is Some(Name(constr_id={ id: Ident(name="Array"), .. }, tys~, ..)) &&
    tys.length() == 1 else {
    raise Refused(
      "\{where_}: the list is declared `\{shape}`, so the table knows its types",
    )
  }
  let element = tys.iter().head().unwrap()
  if table.is_set() {
    (type_text(element), None)
  } else {
    guard element is Tuple(tys=pair, ..) && pair.length() == 2 else {
      raise Refused("\{where_}: a map's list holds pairs, `Array[(K, V)]`")
    }
    let parts = pair.iter().collect()
    (type_text(parts[0]), Some(type_text(parts[1])))
  }
}

///|
fn options_of(args : @attr.Args, where_ : String) -> @phf.PhfOptions raise {
  let build : @phf.PhfBuild = match args.str("build") {
    None => @phf.phf_options.build
    Some("search") => Search
    Some("quick") => Quick
    Some("minimal") => Minimal
    Some(other) =>
      raise Refused(
        "\{where_}: `build` is search, quick or minimal, not `\{other}`",
      )
  }
  let seed = match args.str("seed") {
    None => @phf.phf_options.seed
    Some(text) =>
      match digits(text) {
        Some((false, n, _)) if n <= 0x7FFFFFFFUL =>
          n.reinterpret_as_int64().to_int()
        _ => raise Refused("\{where_}: `seed` is a whole number, not `\{text}`")
      }
  }
  { build, seed, }
}

///|
/// The layout for the keys, from the same builder the program would run, so the
/// table generated here and one built at run time agree field for field.
fn layout_of(
  keys : Array[Key],
  options : @phf.PhfOptions,
  where_ : String,
) -> @phf.PhfLayout raise {
  let wrong = fn(k : Key) -> Unit raise {
    raise Refused(
      "\{where_}: every key has one type; \{k.type_name()} sits among \{keys[0].type_name()} keys",
    )
  }
  try {
    match keys {
      [] | [Text(_), ..] => {
        let b : @phf.PhfBuilder[String, Unit] = @phf.PhfBuilder::new(
          phf_options=options,
        )
        for k in keys {
          guard k is Text(s) else { wrong(k) }
          b.entry(s, ())
        }
        b.build().layout()
      }
      [Int(_), ..] => {
        let b : @phf.PhfBuilder[Int32, Unit] = @phf.PhfBuilder::new(
          phf_options=options,
        )
        for k in keys {
          guard k is Int(n) else { wrong(k) }
          b.entry(n, ())
        }
        b.build().layout()
      }
      [Int64(_), ..] => {
        let b : @phf.PhfBuilder[Int64, Unit] = @phf.PhfBuilder::new(
          phf_options=options,
        )
        for k in keys {
          guard k is Int64(n) else { wrong(k) }
          b.entry(n, ())
        }
        b.build().layout()
      }
      [UInt64(_), ..] => {
        let b : @phf.PhfBuilder[UInt64, Unit] = @phf.PhfBuilder::new(
          phf_options=options,
        )
        for k in keys {
          guard k is UInt64(n) else { wrong(k) }
          b.entry(n, ())
        }
        b.build().layout()
      }
    }
  } catch {
    @spec.Refused::DuplicateValue =>
      raise Refused("\{where_}: a key is written twice")
    Refused(_) as e => raise e
    e => raise Refused("\{where_}: no layout for these keys: \{e}")
  }
}

///|
fn layout_source(layout : @phf.PhfLayout) -> String {
  let disps = layout.disps.map(d => d.to_string()).join(", ")
  "{ build: \{layout.build}, salt: \{layout.salt}, buckets: \{layout.buckets}, table_len: \{layout.table_len}, length: \{layout.length}, disps: [\{disps}] }"
}

///|
/// The code for one annotated list.
fn table_code(
  note : @attribute.Attribute,
  table : Table,
  binder : String,
  ty : @syntax.Type?,
  expr : @syntax.Expr,
  public : Bool,
  file : String,
) -> String raise {
  let where_ = "\{file}:\{note.loc.start.lnum}:\{note.loc.start.column()}"
  let args = spec(@attr.name_of(note).unwrap()).bind(note) catch {
    e => raise Refused("\{where_}: \{e}")
  }
  let (key_type, value_type) = element_types(ty, table, where_)
  guard expr is Array(exprs~, ..) else {
    raise Refused(
      "\{where_}: the list is written out, `[...]`, so its keys can be read now",
    )
  }
  let keys = []
  for item in exprs {
    if table.is_set() {
      keys.push(key_of(item))
    } else {
      guard item is Tuple(exprs=pair, ..) && pair.length() == 2 else {
        raise Refused(
          "\{at_expr(item)}: a map's entry is a pair, `(key, value)`",
        )
      }
      keys.push(key_of(pair.iter().head().unwrap()))
    }
  }
  if keys is [first, ..] && first.type_name() != key_type {
    raise Refused(
      "\{where_}: the keys are \{first.type_name()} but the list says \{key_type}",
    )
  }
  guard key_type is ("String" | "Int" | "Int64" | "UInt64") else {
    raise Refused(
      "\{where_}: a key is String, Int, Int64 or UInt64, not \{key_type}",
    )
  }
  let layout = layout_of(keys, options_of(args, where_), where_)
  let name = args.str("name").unwrap_or(binder + "_phf")
  let table_type = match value_type {
    Some(v) => "@phf.\{table.type_name()}[\{key_type}, \{v}]"
    None => "@phf.\{table.type_name()}[\{key_type}]"
  }
  let vis = if public { "pub " } else { "" }
  (
    $|let \{name}_layout : @phf.PhfLayout = \{layout_source(layout)}
    $|
    $|\{vis}let \{name} : \{table_type} = @phf.\{table.type_name()}::from_layout(\{name}_layout, \{binder}) catch {
    $|  _ => abort("\{name}: the layout no longer fits `\{binder}`; run the #phf generator again")
    $|}
  )
}

///|
fn file_of(decl : @gen.Decl) -> String {
  match decl {
    Struct(file~, ..) | Enum(file~, ..) | Func(file~, ..) | Other(file~, ..) =>
      file
  }
}

///|
impl @gen.Generator for Phf with fn generate(_, decls) {
  let out = []
  for decl in decls {
    // moonast 0.2.7 hands a top-level `let` over without its annotations, so
    // they are read off the syntax tree.
    let attrs = match decl.raw() {
      TopLetDef(attrs~, ..) => attrs
      _ => decl.attrs()
    }
    for attr in attrs {
      if @attr.name_of(attr) is None && attr.raw.has_prefix("#phf.") {
        raise Refused(
          "\{file_of(decl)}:\{attr.loc.start.lnum}:\{attr.loc.start.column()}: `\{attr.raw}` does not parse as an annotation",
        )
      }
    }
    let notes = @attr.under(attrs, "phf")
    guard notes is [note, .. rest] else { continue }
    let where_ = "\{file_of(decl)}:\{note.loc.start.lnum}:\{note.loc.start.column()}"
    guard Table::of(@attr.name_of(note).unwrap_or("")) is Some(table) else {
      raise Refused("\{where_}: `\{note.raw}` is not a moonstl annotation")
    }
    if rest is [second, ..] {
      raise Refused(
        "\{file_of(decl)}:\{second.loc.start.lnum}:\{second.loc.start.column()}: one list makes one table",
      )
    }
    guard decl.raw() is TopLetDef(binder~, ty~, expr~, vis~, ..) else {
      raise Refused("\{where_}: the annotation goes on a top-level `let`")
    }
    out.push(
      table_code(
        note,
        table,
        binder.name,
        ty,
        expr,
        vis is Pub(..),
        file_of(decl),
      ),
    )
  }
  @quote.items(out.join("\n\n")).render()
}
