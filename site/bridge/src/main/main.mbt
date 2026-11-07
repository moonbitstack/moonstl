// The page hands us a demo name and a JSON input; we answer with a JSON string.
// Every answer is produced by moonstl itself, so the page shows the library's
// real output, not a reimplementation of it.

///|
extern "js" fn expose(
  run : (String, String) -> String,
  names : () -> String,
) -> Unit = "function(run, names){ globalThis.moonstl = { run: run, names: names }; }"

// ---- tiny JSON helpers over core's Json (moonjson reads/writes it) ----

///|
fn as_int(j : @cjson.Json) -> Int32? {
  match j {
    @cjson.Json::Number(d, ..) => Some(d.to_int())
    _ => None
  }
}

///|
fn as_str(j : @cjson.Json) -> String? {
  match j {
    @cjson.Json::String(s) => Some(s)
    _ => None
  }
}

///|
fn ints_of(j : @cjson.Json) -> Array[Int32] {
  match j {
    @cjson.Json::Array(a) =>
      a.filter(x => as_int(x) != None).map(x => as_int(x).unwrap_or(0))
    _ => []
  }
}

///|
fn strs_of(j : @cjson.Json) -> Array[String] {
  match j {
    @cjson.Json::Array(a) =>
      a.filter(x => as_str(x) != None).map(x => as_str(x).unwrap_or(""))
    _ => []
  }
}

///|
fn get_str(j : @cjson.Json, key : String) -> String {
  match j {
    @cjson.Json::Object(m) =>
      as_str(m.get(key).unwrap_or(@cjson.Json::null())).unwrap_or("")
    _ => ""
  }
}

///|
fn get_int(j : @cjson.Json, key : String) -> Int32 {
  match j {
    @cjson.Json::Object(m) =>
      as_int(m.get(key).unwrap_or(@cjson.Json::null())).unwrap_or(0)
    _ => 0
  }
}

///|
fn get_field(j : @cjson.Json, key : String) -> @cjson.Json {
  match j {
    @cjson.Json::Object(m) => m.get(key).unwrap_or(@cjson.Json::null())
    _ => @cjson.Json::null()
  }
}

///|
fn set_ints(j : @cjson.Json, key~ : String = "set") -> Array[Int32] {
  ints_of(get_field(j, key))
}

///|
fn set_strs(j : @cjson.Json, key~ : String = "set") -> Array[String] {
  strs_of(get_field(j, key))
}

///|
fn jints(a : Array[Int32]) -> @cjson.Json {
  @cjson.Json::array(a.map(x => @cjson.Json::number(x.to_double())))
}

///|
fn jstrs(a : Array[String]) -> @cjson.Json {
  @cjson.Json::array(a.map(x => @cjson.Json::string(x)))
}

// ---- map ----

///|
fn indexmap(input : String) -> String raise {
  let m : @map.IndexMap[Int32, Int32] = @map.IndexMap::new()
  for e in set_ints(@json.loads(input, @json.strict)) {
    let _ = m.set(e, e * 2)
  }
  let ks : Array[Int32] = m.keys().to_array()
  let out : Map[String, @cjson.Json] = Map([])
  out["keys"] = jints(ks)
  out["positions"] = jints(ks.map(k => m.get_index_of(k).unwrap_or(-1)))
  @json.dumps(@cjson.Json::object(out))
}

///|
fn trie(input : String) -> String raise {
  let j = @json.loads(input, @json.strict)
  let t : @map.Trie[Int32] = @map.Trie::new()
  for w in set_strs(j, key="words") {
    let _ = t.insert(w, 1)
  }
  let prefix = get_str(j, "prefix")
  let out : Map[String, @cjson.Json] = Map([])
  out["words"] = jstrs(t.to_array().map(e => e.0))
  out["prefix"] = @cjson.Json::string(prefix)
  out["matches"] = jstrs(t.keys_with_prefix(prefix))
  @json.dumps(@cjson.Json::object(out))
}

// ---- cache ----

///|
fn lru(input : String) -> String raise {
  let j = @json.loads(input, @json.strict)
  let cap = get_int(j, "cap")
  let c : @cache.LruCache[Int32, Int32] = @cache.LruCache::new(capacity=cap)
  let displaced : Array[Int32] = []
  for e in set_ints(j) {
    match c.set(e, e) {
      Some((k, _)) => displaced.push(k)
      None => ()
    }
  }
  let out : Map[String, @cjson.Json] = Map([])
  out["capacity"] = @cjson.Json::number(cap.to_double())
  out["displaced"] = jints(displaced)
  out["keys"] = jints(c.keys().to_array())
  @json.dumps(@cjson.Json::object(out))
}

// ---- heap ----

///|
fn heap(input : String) -> String raise {
  let h : @heap.DaryHeap[Int32] = @heap.DaryHeap::default()
  for v in set_ints(@json.loads(input, @json.strict)) {
    h.push(v)
  }
  let pops : Array[Int32] = []
  for _ in 0..<h.length() {
    match h.pop() {
      Some(v) => pops.push(v)
      None => ()
    }
  }
  let out : Map[String, @cjson.Json] = Map([])
  out["pops"] = jints(pops)
  @json.dumps(@cjson.Json::object(out))
}

// ---- tree ----

///|
fn segment(input : String) -> String raise {
  let j = @json.loads(input, @json.strict)
  let vals = set_ints(j)
  let st : @tree.SegmentTree[Int32] = @tree.SegmentTree::from_array(
    vals[:],
    op=(x, y) => x + y,
    identity=0,
  )
  let out : Map[String, @cjson.Json] = Map([])
  out["values"] = jints(vals)
  out["total"] = @cjson.Json::number(st.query_all().to_double())
  let prefix : Array[Int32] = []
  for i in 0..<=vals.length() {
    prefix.push(st.query(0, i))
  }
  out["prefix"] = jints(prefix)
  @json.dumps(@cjson.Json::object(out))
}

///|
fn disjoint(input : String) -> String raise {
  let j = @json.loads(input, @json.strict)
  let n = get_int(j, "n")
  let d : @tree.DisjointSet = @tree.DisjointSet::new()
  for _ in 0..<n {
    let _ = d.add()
  }
  let unions = set_ints(j)
  let pairs = unions.length() / 2
  for i in 0..<pairs {
    let _ = d.union(unions[2 * i], unions[2 * i + 1])
  }
  let out : Map[String, @cjson.Json] = Map([])
  out["sets"] = @cjson.Json::array(d.to_sets().map(s => jints(s)))
  out["count"] = @cjson.Json::number(d.set_count().to_double())
  @json.dumps(@cjson.Json::object(out))
}

// ---- sketch ----

///|
fn bloom(input : String) -> String raise {
  let j = @json.loads(input, @json.strict)
  let cap = get_int(j, "cap")
  let b : @sketch.BloomFilter[Int32] = @sketch.BloomFilter::new(
    expected_items=cap,
    hash_seed=0,
  )
  for v in set_ints(j) {
    let _ = b.insert(v)
  }
  let query = get_int(j, "n")
  let out : Map[String, @cjson.Json] = Map([])
  out["found"] = @cjson.Json::boolean(b.may_contain(query))
  out["false_pos"] = @cjson.Json::number(b.estimated_false_positive_rate())
  @json.dumps(@cjson.Json::object(out))
}

///|
fn countmin(input : String) -> String raise {
  let j = @json.loads(input, @json.strict)
  let s : @sketch.CountMinSketch[Int32] = @sketch.CountMinSketch::new(
    epsilon=0.01,
    hash_seed=0,
  )
  for v in set_ints(j) {
    let _ = s.insert(v)
  }
  let q = get_int(j, "q")
  let out : Map[String, @cjson.Json] = Map([])
  out["estimate"] = @cjson.Json::number(s.estimate(q).to_double())
  @json.dumps(@cjson.Json::object(out))
}

// ---- text ----

///|
fn kmp(input : String) -> String raise {
  let j = @json.loads(input, @json.strict)
  let k : @text.Kmp = @text.Kmp::new(get_str(j, "pattern"))
  let out : Map[String, @cjson.Json] = Map([])
  out["text"] = @cjson.Json::string(get_str(j, "text"))
  out["pattern"] = @cjson.Json::string(get_str(j, "pattern"))
  out["hits"] = jints(k.search_all(get_str(j, "text")).to_array())
  @json.dumps(@cjson.Json::object(out))
}

///|
fn diff(input : String) -> String raise {
  let j = @json.loads(input, @json.strict)
  let m : @text.SequenceMatcher[Char] = @text.SequenceMatcher::new(
    get_str(j, "a").iter().to_array(),
    get_str(j, "b").iter().to_array(),
  )
  let ops = m.get_opcodes()
  let out : Map[String, @cjson.Json] = Map([])
  out["a"] = @cjson.Json::string(get_str(j, "a"))
  out["b"] = @cjson.Json::string(get_str(j, "b"))
  out["ratio"] = @cjson.Json::number(m.ratio())
  out["ops"] = @cjson.Json::array(
    ops.map(o => {
      @cjson.Json::array([
        @cjson.Json::string(o.tag()),
        @cjson.Json::number(o.a1().to_double()),
        @cjson.Json::number(o.a2().to_double()),
        @cjson.Json::number(o.b1().to_double()),
        @cjson.Json::number(o.b2().to_double()),
      ])
    }),
  )
  @json.dumps(@cjson.Json::object(out))
}

// ---- phf ----

///|
fn phf(input : String) -> String raise {
  let j = @json.loads(input, @json.strict)
  let builder : @phf.PhfBuilder[String, Int32] = @phf.PhfBuilder::new()
  for e in set_strs(j) {
    let _ = builder.entry(e, e.length())
  }
  let map = builder.build()
  let out : Map[String, @cjson.Json] = Map([])
  out["size"] = @cjson.Json::number(map.length().to_double())
  out["keys"] = jstrs(map.keys().to_array())
  @json.dumps(@cjson.Json::object(out))
}

// ---- seq ----

///|
fn ring(input : String) -> String raise {
  let j = @json.loads(input, @json.strict)
  let cap = get_int(j, "cap")
  let r : @seq.RingBuffer[Int32] = @seq.RingBuffer::new(
    capacity=cap,
    overflow=@seq.Overflow::Overwrite,
  )
  for v in set_ints(j) {
    let _ = r.push_back(v)
  }
  let out : Map[String, @cjson.Json] = Map([])
  out["capacity"] = @cjson.Json::number(cap.to_double())
  out["values"] = jints(r.to_array())
  @json.dumps(@cjson.Json::object(out))
}

///|
fn bitset(input : String) -> String raise {
  let j = @json.loads(input, @json.strict)
  let b : @seq.BitSet = @seq.BitSet::new()
  for v in set_ints(j) {
    let _ = b.insert(v)
  }
  let n = get_int(j, "n")
  let rank : Array[Int32] = []
  for i in 0..<n {
    rank.push(b.rank(i))
  }
  let out : Map[String, @cjson.Json] = Map([])
  out["bits"] = jints(b.to_array())
  out["rank"] = jints(rank)
  out["select0"] = @cjson.Json::number(b.select(0).unwrap_or(-1).to_double())
  @json.dumps(@cjson.Json::object(out))
}

// ---- algo ----

///|
fn perms(input : String) -> String raise {
  let j = @json.loads(input, @json.strict)
  let pool = set_ints(j)
  let r = get_int(j, "r")
  let out : Map[String, @cjson.Json] = Map([])
  let (kind, rows) = match r {
    0 => {
      let p = @algo.Permutations::new(pool)
      ("permutations", p.iter().map(row => jints(row)).to_array())
    }
    _ => {
      let c = @algo.Combinations::new(pool, k=r)
      ("combinations", c.iter().map(row => jints(row)).to_array())
    }
  }
  out["kind"] = @cjson.Json::string(kind)
  out["rows"] = @cjson.Json::array(rows)
  @json.dumps(@cjson.Json::object(out))
}

// ---- dispatch ----

///|
fn run(name : String, input : String) -> String {
  try {
    match name {
      "indexmap" => indexmap(input)
      "trie" => trie(input)
      "lru" => lru(input)
      "heap" => heap(input)
      "segment" => segment(input)
      "disjoint" => disjoint(input)
      "bloom" => bloom(input)
      "countmin" => countmin(input)
      "kmp" => kmp(input)
      "diff" => diff(input)
      "phf" => phf(input)
      "ring" => ring(input)
      "bitset" => bitset(input)
      "perms" => perms(input)
      _ => "{\"error\": \"unknown demo\"}"
    }
  } catch {
    e => "{\"error\": \"" + e.to_string() + "\"}"
  }
}

///|
fn names() -> String {
  @json.dumps(
    @cjson.Json::array([
      "indexmap", "trie", "lru", "heap", "segment", "disjoint", "bloom", "countmin",
      "kmp", "diff", "phf", "ring", "bitset", "perms",
    ]),
  )
}

///|
fn main {
  expose(run, names)
}
