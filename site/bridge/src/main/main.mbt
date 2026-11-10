// The page hands us a demo name and a JSON input; we answer with a JSON string.
// Every answer is produced by moonstl itself, so the page shows the library's
// real output, not a reimplementation of it.
//
// The module is compiled with the wasm-gc backend and `run` / `names` are
// exported through the link configuration in moon.pkg, so the page calls into
// the WebAssembly instance directly. Strings cross the boundary as JavaScript
// strings (`use-js-builtin-string`), which is why `run` takes and returns
// `String` with no encoding of its own.

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
fn get_arr(j : @cjson.Json) -> Array[@cjson.Json]? {
  match j {
    @cjson.Json::Array(a) => Some(a)
    _ => None
  }
}

///|
fn elem_of(a : Array[@cjson.Json], i : Int32) -> Int32? {
  if i >= 0 && i < a.length() {
    as_int(a[i])
  } else {
    None
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
  let j = @json.loads(input, @json.strict)
  let vals = set_ints(j)
  let h : @heap.DaryHeap[Int32] = @heap.DaryHeap::default()
  for v in vals {
    h.push(v)
  }
  let f : @heap.FibonacciHeap[Int32] = @heap.FibonacciHeap::new()
  for v in vals {
    let _ = f.insert(v)
  }
  let p : @heap.PairingHeap[Int32] = @heap.PairingHeap::new()
  for v in vals {
    let _ = p.insert(v)
  }
  let out : Map[String, @cjson.Json] = Map([])
  out["pops"] = jints(h.into_sorted_array())
  out["fib"] = jints(f.into_sorted_array())
  out["pairing"] = jints(p.into_sorted_array())
  @json.dumps(@cjson.Json::object(out))
}

///|
fn radix(input : String) -> String raise {
  let h : @heap.RadixHeap[Int32] = @heap.RadixHeap::new()
  for v in set_ints(@json.loads(input, @json.strict)) {
    let _ = h.push(v.to_uint64(), v)
  }
  let pops : Array[Int32] = []
  for _ in 0..<h.length() {
    match h.pop_min() {
      Some((_, v)) => pops.push(v)
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
fn fenwick(input : String) -> String raise {
  let j = @json.loads(input, @json.strict)
  let vals = set_ints(j)
  let f : @tree.Fenwick[Int32] = @tree.Fenwick::from_array(vals[:])
  let prefix : Array[Int32] = []
  for i in 0..<=vals.length() {
    prefix.push(f.prefix_sum(i))
  }
  let out : Map[String, @cjson.Json] = Map([])
  out["values"] = jints(vals)
  out["prefix"] = jints(prefix)
  out["range_1_3"] = @cjson.Json::number(f.range_sum(1, 3).to_double())
  @json.dumps(@cjson.Json::object(out))
}

///|
fn interval(input : String) -> String raise {
  let j = @json.loads(input, @json.strict)
  let pairs = set_ints(j)
  let t : @tree.IntervalTree[Int32, Int32] = @tree.IntervalTree::new()
  let mut count = 0
  let mut i = 0
  while i + 1 < pairs.length() {
    let _ = t.insert(start=pairs[i], end=pairs[i + 1], count)
    count = count + 1
    i = i + 2
  }
  let qstart = get_int(j, "qstart")
  let qend = get_int(j, "qend")
  let overlaps : Array[Int32] = []
  for (a, b, _) in t.query_overlap(start=qstart, end=qend) {
    overlaps.push(a)
    overlaps.push(b)
  }
  let all : Array[Int32] = []
  for (a, b, _) in t.iter() {
    all.push(a)
    all.push(b)
  }
  let out : Map[String, @cjson.Json] = Map([])
  out["intervals"] = jints(all)
  out["q"] = @cjson.Json::array([
    @cjson.Json::number(qstart.to_double()),
    @cjson.Json::number(qend.to_double()),
  ])
  out["overlap"] = jints(overlaps)
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
  // The copy takes one more union, the original keeps the components it had.
  let twin = d.copy()
  let _ = twin.union(0, n - 1)
  let out : Map[String, @cjson.Json] = Map([])
  out["sets"] = @cjson.Json::array(d.to_sets().map(s => jints(s)))
  out["count"] = @cjson.Json::number(d.set_count().to_double())
  out["copy_count"] = @cjson.Json::number(twin.set_count().to_double())
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

///|
fn cuckoo(input : String) -> String raise {
  let j = @json.loads(input, @json.strict)
  let cap = get_int(j, "cap")
  let c : @sketch.CuckooFilter[Int32] = @sketch.CuckooFilter::new(
    expected_items=cap,
    hash_seed=0,
  )
  let set = set_ints(j)
  for v in set {
    let _ = c.insert(v)
  }
  let query = get_int(j, "n")
  let out : Map[String, @cjson.Json] = Map([])
  out["found"] = @cjson.Json::boolean(c.may_contain(query))
  out["removed"] = @cjson.Json::boolean(c.remove(query))
  out["after_remove"] = @cjson.Json::boolean(c.may_contain(query))
  @json.dumps(@cjson.Json::object(out))
}

///|
fn theta(input : String) -> String raise {
  let j = @json.loads(input, @json.strict)
  let set = set_ints(j)
  let nominal = get_int(j, "nominal")
  let t : @sketch.ThetaSketch[Int32] = @sketch.ThetaSketch::new(
    nominal_entries=if nominal > 0 { nominal } else { 4096 },
    hash_seed=0,
  )
  for v in set {
    t.add(v)
  }
  let out : Map[String, @cjson.Json] = Map([])
  out["distinct"] = @cjson.Json::number(distinct_count(set).to_double())
  out["estimate"] = @cjson.Json::number(t.estimate())
  @json.dumps(@cjson.Json::object(out))
}

///|
fn distinct_count(a : Array[Int32]) -> Int32 {
  let mut count = 0
  for i in 0..<a.length() {
    let mut first = true
    for k in 0..<i {
      if a[k] == a[i] {
        first = false
      }
    }
    if first {
      count = count + 1
    }
  }
  count
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

///|
fn aho(input : String) -> String raise {
  let j = @json.loads(input, @json.strict)
  let patterns = set_strs(j, key="patterns")
  let text = get_str(j, "text")
  let views : Array[StringView] = patterns.map(s => s.to_string_view())
  let ac : @text.AhoCorasick = @text.AhoCorasick::new(views)
  let out : Map[String, @cjson.Json] = Map([])
  out["patterns"] = jstrs(patterns)
  out["text"] = @cjson.Json::string(text)
  out["matches"] = @cjson.Json::array(
    ac
    .search_all(text)
    .to_array()
    .map(ms => {
      @cjson.Json::array([
        @cjson.Json::number(ms.0.to_double()),
        @cjson.Json::number(ms.1.to_double()),
      ])
    }),
  )
  @json.dumps(@cjson.Json::object(out))
}

///|
fn suffix(input : String) -> String raise {
  let j = @json.loads(input, @json.strict)
  let text = get_str(j, "text")
  let sa : @text.SuffixArray = @text.SuffixArray::new(text)
  let out : Map[String, @cjson.Json] = Map([])
  out["text"] = @cjson.Json::string(text)
  out["order"] = jints(sa.to_array())
  out["lcp"] = jints(sa.lcp_array())
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

///|
fn phf_ordered(input : String) -> String raise {
  let j = @json.loads(input, @json.strict)
  let words = set_strs(j)
  let builder : @phf.PhfBuilder[String, Int32] = @phf.PhfBuilder::new()
  for e in words {
    let _ = builder.entry(e, e.length())
  }
  let om = builder.build_ordered()
  let q = get_str(j, "q")
  let out : Map[String, @cjson.Json] = Map([])
  out["order"] = jstrs(om.keys().to_array())
  out["q"] = @cjson.Json::string(q)
  out["index"] = @cjson.Json::number(om.index(q).unwrap_or(-1).to_double())
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

///|
fn gap(input : String) -> String raise {
  let j = @json.loads(input, @json.strict)
  let base = set_ints(j)
  let g : @seq.GapBuffer[Int32] = @seq.GapBuffer::new()
  for v in base {
    g.insert(g.length(), v)
  }
  let ops = get_arr(get_field(j, "ops")).unwrap_or([])
  for op in ops {
    let oa = get_arr(op).unwrap_or([])
    let pos = elem_of(oa, 0).unwrap_or(0)
    let val = elem_of(oa, 1).unwrap_or(0)
    g.insert(pos, val)
  }
  let out : Map[String, @cjson.Json] = Map([])
  out["before"] = jints(base)
  out["after"] = jints(g.to_array())
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
pub fn run(name : String, input : String) -> String {
  try {
    match name {
      "indexmap" => indexmap(input)
      "trie" => trie(input)
      "lru" => lru(input)
      "heap" => heap(input)
      "radix" => radix(input)
      "segment" => segment(input)
      "fenwick" => fenwick(input)
      "interval" => interval(input)
      "disjoint" => disjoint(input)
      "bloom" => bloom(input)
      "cuckoo" => cuckoo(input)
      "countmin" => countmin(input)
      "theta" => theta(input)
      "kmp" => kmp(input)
      "aho" => aho(input)
      "suffix" => suffix(input)
      "diff" => diff(input)
      "phf" => phf(input)
      "phf_ordered" => phf_ordered(input)
      "ring" => ring(input)
      "gap" => gap(input)
      "bitset" => bitset(input)
      "perms" => perms(input)
      _ => "{\"error\": \"unknown demo\"}"
    }
  } catch {
    e => "{\"error\": \"" + e.to_string() + "\"}"
  }
}

///|
pub fn names() -> String {
  @json.dumps(
    @cjson.Json::array([
      "indexmap", "trie", "lru", "heap", "radix", "segment", "fenwick", "interval",
      "disjoint", "bloom", "cuckoo", "countmin", "theta", "kmp", "aho", "suffix",
      "diff", "phf", "phf_ordered", "ring", "gap", "bitset", "perms",
    ]),
  )
}

///|
fn main {

}
