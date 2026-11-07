//! Differential vector reference for moonstl, computed with the Rust
//! standard library. It fixes the same inputs as `scripts/gen_vectors.py`
//! (Python) and computes the same reference results; `scripts/vectors` holds
//! one manifest per language and `scripts/check_vector_agreement.sh` diffs
//! them, so the two reference implementations must agree byte for byte.

use std::collections::{HashMap, VecDeque};
use std::env;
use std::fs;

#[derive(Clone)]
enum Value {
    Int(i64),
    Bool(bool),
    F(f64),
    Str(String),
    List(Vec<Value>),
}

/// Language-independent rendering that must match `scripts/vector_format.py`.
fn canon(v: &Value) -> String {
    match v {
        Value::Int(i) => i.to_string(),
        Value::Bool(b) => if *b { "true" } else { "false" }.to_string(),
        Value::F(f) => format!("{:.9}", f),
        Value::Str(s) => s.clone(),
        Value::List(items) => {
            let inner: Vec<String> = items.iter().map(canon).collect();
            format!("[{}]", inner.join(","))
        }
    }
}

type Item = (String, Value);

fn list_of_ints(v: &[i64]) -> Value {
    Value::List(v.iter().map(|x| Value::Int(*x)).collect())
}

// -- itertools-order generators (match CPython exactly) ---------------------

/// Positional lexicographic order, the order CPython's itertools.permutations
/// yields. At each depth the next unused position is tried in increasing order.
fn permutations<T: Clone>(pool: &[T], r: usize) -> Vec<Vec<T>> {
    let n = pool.len();
    let mut out = Vec::new();
    if r > n {
        return out;
    }
    let mut used = vec![false; n];
    let mut cur: Vec<T> = Vec::new();
    fn rec<T: Clone>(pool: &[T], r: usize, used: &mut Vec<bool>, cur: &mut Vec<T>, out: &mut Vec<Vec<T>>) {
        if cur.len() == r {
            out.push(cur.clone());
            return;
        }
        for i in 0..pool.len() {
            if !used[i] {
                used[i] = true;
                cur.push(pool[i].clone());
                rec(pool, r, used, cur, out);
                cur.pop();
                used[i] = false;
            }
        }
    }
    rec(pool, r, &mut used, &mut cur, &mut out);
    out
}

/// Increasing indices, the order CPython's itertools.combinations yields.
fn combinations<T: Clone>(pool: &[T], r: usize) -> Vec<Vec<T>> {
    let mut out = Vec::new();
    if r > pool.len() {
        return out;
    }
    let mut cur = Vec::new();
    fn rec<T: Clone>(pool: &[T], r: usize, start: usize, cur: &mut Vec<T>, out: &mut Vec<Vec<T>>) {
        if cur.len() == r {
            out.push(cur.clone());
            return;
        }
        for i in start..pool.len() {
            cur.push(pool[i].clone());
            rec(pool, r, i + 1, cur, out);
            cur.pop();
        }
    }
    rec(pool, r, 0, &mut cur, &mut out);
    out
}

/// Non-decreasing indices, the order CPython's itertools.combinations_with_replacement
/// yields.
fn combinations_with_replacement<T: Clone>(pool: &[T], r: usize) -> Vec<Vec<T>> {
    let mut out = Vec::new();
    if pool.is_empty() && r > 0 {
        return out;
    }
    let mut cur = Vec::new();
    fn rec<T: Clone>(pool: &[T], r: usize, start: usize, cur: &mut Vec<T>, out: &mut Vec<Vec<T>>) {
        if cur.len() == r {
            out.push(cur.clone());
            return;
        }
        for i in start..pool.len() {
            cur.push(pool[i].clone());
            rec(pool, r, i, cur, out);
            cur.pop();
        }
    }
    rec(pool, r, 0, &mut cur, &mut out);
    out
}

fn powerset<T: Clone>(pool: &[T]) -> Vec<Vec<T>> {
    let mut out = Vec::new();
    for r in 0..=pool.len() {
        out.extend(combinations(pool, r));
    }
    out
}

/// Row-major, the order CPython's itertools.product yields.
fn product(pools: &[Vec<i64>]) -> Vec<Vec<i64>> {
    let mut out = Vec::new();
    let mut cur = Vec::new();
    fn rec(pools: &[Vec<i64>], pos: usize, cur: &mut Vec<i64>, out: &mut Vec<Vec<i64>>) {
        if pos == pools.len() {
            out.push(cur.clone());
            return;
        }
        for v in &pools[pos] {
            cur.push(*v);
            rec(pools, pos + 1, cur, out);
            cur.pop();
        }
    }
    rec(pools, 0, &mut cur, &mut out);
    out
}

fn bisect_left(a: &[i64], x: i64) -> i64 {
    let mut lo = 0;
    let mut hi = a.len();
    while lo < hi {
        let mid = (lo + hi) / 2;
        if a[mid] < x {
            lo = mid + 1;
        } else {
            hi = mid;
        }
    }
    lo as i64
}

fn bisect_right(a: &[i64], x: i64) -> i64 {
    let mut lo = 0;
    let mut hi = a.len();
    while lo < hi {
        let mid = (lo + hi) / 2;
        if a[mid] <= x {
            lo = mid + 1;
        } else {
            hi = mid;
        }
    }
    lo as i64
}

// -- per-package data -------------------------------------------------------

fn gen_algo(items: &mut Vec<Item>) {
    let sorted = [1i64, 2, 2, 3, 5, 5, 5, 8, 13, 21, 34, 55];
    items.push(("algo_sorted".into(), list_of_ints(&sorted)));
    let left: Vec<i64> = (0..60).map(|p| bisect_left(&sorted, p)).collect();
    items.push(("algo_bisect_left".into(), list_of_ints(&left)));
    let right: Vec<i64> = (0..60).map(|p| bisect_right(&sorted, p)).collect();
    items.push(("algo_bisect_right".into(), list_of_ints(&right)));
    items.push(("algo_perm_pool".into(), list_of_ints(&[1, 2, 3])));
    items.push(("algo_combo_pool".into(), list_of_ints(&[1, 2, 3, 4])));
    let cart = product(&vec![vec![1, 2], vec![3, 4], vec![5]]);
    items.push(("algo_cart_pools".into(), Value::List(vec![
        list_of_ints(&[1, 2]), list_of_ints(&[3, 4]), list_of_ints(&[5]),
    ])));
    items.push(("algo_perms".into(), perm_value(&permutations(&[1i64, 2, 3], 3))));
    items.push(("algo_perms2".into(), perm_value(&permutations(&[1i64, 2, 3], 2))));
    items.push(("algo_combos".into(), perm_value(&combinations(&[1i64, 2, 3, 4], 3))));
    items.push(("algo_combor".into(), perm_value(&combinations_with_replacement(&[1i64, 2, 3, 4], 3))));
    items.push(("algo_cart".into(), perm_value(&cart)));
    items.push(("algo_powerset".into(), perm_value(&powerset(&[1i64, 2, 3]))));
    let seq = [3i64, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5];
    items.push(("algo_seq".into(), list_of_ints(&seq)));
    let ordered: Vec<i64> = {
        let mut v = seq.to_vec();
        v.sort();
        v
    };
    items.push(("algo_sorted_run".into(), list_of_ints(&ordered)));
    let mut prefix = Vec::new();
    let mut acc = 0;
    for &v in &seq {
        acc += v;
        prefix.push(acc);
    }
    items.push(("algo_prefix".into(), list_of_ints(&prefix)));
    let rotated = seq[3..].to_vec().into_iter().chain(seq[..3].to_vec()).collect::<Vec<_>>();
    items.push(("algo_rotated".into(), list_of_ints(&rotated)));
    items.push(("algo_merge_left".into(), list_of_ints(&[1, 4, 7, 8])));
    items.push(("algo_merge_right".into(), list_of_ints(&[2, 3, 5, 9])));
    let mut merged = vec![1, 4, 7, 8, 2, 3, 5, 9];
    merged.sort();
    items.push(("algo_merged".into(), list_of_ints(&merged)));
    items.push(("algo_unique".into(), list_of_ints(&[1, 2, 3, 4])));
    items.push(("algo_dupes".into(), list_of_ints(&[1, 3])));
}

fn perm_value(rows: &Vec<Vec<i64>>) -> Value {
    Value::List(rows.iter().map(|r| list_of_ints(r)).collect())
}

fn gen_map(items: &mut Vec<Item>) {
    // counter log: (key, verb, amount)
    let ops: Vec<(&str, &str, i64)> = vec![
        ("apple", "incr", 1), ("banana", "incr", 1), ("apple", "incr", 1),
        ("cherry", "incr", 1), ("banana", "incr", 1), ("apple", "decr", 1),
        ("date", "incr_by", 4), ("date", "decr_by", 1), ("apple", "incr", 1),
    ];
    let mut counter: HashMap<String, i64> = HashMap::new();
    let mut order: Vec<String> = Vec::new();
    let mut totals = Vec::new();
    let mut most: Vec<Value> = Vec::new();
    for &(key, verb, amt) in ops.iter() {
        match verb {
            "incr" => *counter.entry(key.to_string()).or_insert(0) += 1,
            "decr" => {
                *counter.entry(key.to_string()).or_insert(0) -= 1;
                if counter[key] <= 0 {
                    counter.remove(key);
                }
            }
            "incr_by" => *counter.entry(key.to_string()).or_insert(0) += amt,
            _ => {
                *counter.entry(key.to_string()).or_insert(0) -= amt;
                if counter[key] <= 0 {
                    counter.remove(key);
                }
            }
        }
        if !order.iter().any(|k| k == key) && counter.contains_key(key) {
            order.push(key.to_string());
        }
        let total: i64 = counter.values().sum();
        totals.push(total);
        let mut pairs: Vec<(String, i64)> =
            counter.iter().map(|(k, &c)| (k.clone(), c)).collect();
        pairs.sort_by(|a, b| {
            b.1.cmp(&a.1)
                .then(order.iter().position(|k| k == &a.0).unwrap().cmp(&order.iter().position(|k| k == &b.0).unwrap()))
        });
        pairs.truncate(2);
        most.push(Value::List(pairs.iter().map(|(k, c)| Value::List(vec![Value::Str(k.clone()), Value::Int(*c)])).collect()));
    }
    items.push(("map_counter_totals".into(), list_of_ints(&totals)));
    items.push(("map_counter_most".into(), Value::List(most)));
    let from = [5i64, 1, 4, 2, 3, 1, 5, 0, 9, 2];
    items.push(("map_flatset_from".into(), list_of_ints(&from)));
    let mut flat: Vec<i64> = from.to_vec();
    flat.sort();
    flat.dedup();
    items.push(("map_flatset_sorted".into(), list_of_ints(&flat)));
    // range(start=2, end=5), inclusive both ends: keys in [2,5]
    let range: Vec<i64> = flat.iter().filter(|k| **k >= 2 && **k <= 5).copied().collect();
    items.push(("map_flatset_range".into(), list_of_ints(&range)));
    // index map log
    let im_ops: Vec<(&str, &str, i64)> = vec![
        ("a", "set", 1), ("b", "set", 2), ("c", "set", 3), ("a", "set", 10),
        ("b", "shift_remove", 0), ("d", "set", 4), ("e", "set", 5),
        ("c", "shift_remove", 0), ("f", "set", 6),
    ];
    let mut model: Vec<(String, i64)> = Vec::new();
    let mut pos: Vec<i64> = Vec::new();
    for &(key, verb, value) in im_ops.iter() {
        if verb == "set" {
            if let Some(e) = model.iter_mut().find(|e| e.0.as_str() == key) {
                e.1 = value;
            } else {
                model.push((key.to_string(), value));
            }
        } else {
            model.retain(|e| e.0.as_str() != key);
        }
        pos.push(match model.iter().position(|e| e.0.as_str() == key) {
            Some(p) => p as i64,
            None => -1,
        });
    }
    items.push((
        "map_indexmap_final".into(),
        Value::List(model.iter().map(|(k, v)| Value::List(vec![Value::Str(k.clone()), Value::Int(*v)])).collect()),
    ));
    items.push(("map_indexmap_pos".into(), list_of_ints(&pos)));
    items.push(("map_rangeset".into(), Value::List(vec![
        Value::List(vec![Value::Int(1), Value::Int(4)]),
        Value::List(vec![Value::Int(10), Value::Int(12)]),
        Value::List(vec![Value::Int(15), Value::Int(20)]),
    ])));
    items.push(("map_rangeset_gaps".into(), Value::List(vec![
        Value::List(vec![Value::Int(4), Value::Int(10)]),
        Value::List(vec![Value::Int(12), Value::Int(15)]),
    ])));
}

fn gen_heap(items: &mut Vec<Item>) {
    let inserts = [7i64, 3, 9, 1, 5, 8, 2, 6, 4];
    items.push(("heap_inserts".into(), list_of_ints(&inserts)));
    let mut mino = inserts.to_vec();
    mino.sort();
    items.push(("heap_min_order".into(), list_of_ints(&mino)));
    let maxo: Vec<i64> = (0..9).map(|i| mino[8 - i]).collect();
    items.push(("heap_max_order".into(), list_of_ints(&maxo)));
    let pf = [11i64, 3, 7, 1, 9, 5, 2];
    items.push(("heap_pf_values".into(), list_of_ints(&pf)));
    let mut pfo = pf.to_vec();
    pfo.sort();
    items.push(("heap_pf_order".into(), list_of_ints(&pfo)));
    items.push(("heap_mm_values".into(), list_of_ints(&[5, 2, 9, 1, 7])));
    // alternating pop_min, pop_max from {5,2,9,1,7}: 1,9,2,7,5
    items.push(("heap_mm_seq".into(), list_of_ints(&[1, 9, 2, 7, 5])));
    items.push(("heap_radix_key".into(), list_of_ints(&[9, 4, 1, 3, 7, 2, 5, 6, 8, 0])));
    items.push(("heap_radix_order".into(), list_of_ints(&[0, 1, 2, 3, 4, 5, 6, 7, 8, 9])));
}

fn gen_tree(items: &mut Vec<Item>) {
    let arr = [1i64, 3, 2, 8, 1, 5, 4];
    let n = arr.len();
    let prefix: Vec<i64> = (0..n).map(|i| arr[..i].iter().sum()).collect();
    items.push(("tree_fenwick_arr".into(), list_of_ints(&arr)));
    items.push(("tree_fenwick_prefix".into(), list_of_ints(&prefix)));
    let mut ranges = Vec::new();
    for i in 0..n {
        for j in i..n + 1 {
            ranges.push(arr[i..j].iter().sum::<i64>());
        }
    }
    items.push(("tree_fenwick_range".into(), list_of_ints(&ranges)));
    let seg = [3i64, 1, 4, 1, 5, 9, 2];
    items.push(("tree_seg_arr".into(), list_of_ints(&seg)));
    let queries: Vec<(i64, i64)> = vec![
        (0, 7), (0, 4), (3, 7), (1, 6), (2, 5), (4, 7), (0, 1), (6, 7),
    ];
    items.push((
        "tree_seg_queries".into(),
        Value::List(queries.iter().map(|(a, b)| Value::List(vec![Value::Int(*a), Value::Int(*b)])).collect()),
    ));
    let expected: Vec<i64> = queries.iter().map(|(a, b)| seg[*a as usize..*b as usize].iter().sum()).collect();
    items.push(("tree_seg_expected".into(), list_of_ints(&expected)));
    // disjoint set via union-find
    let unions = [(0i64, 1), (2, 3), (0, 2), (4, 5), (5, 6), (1, 4)];
    items.push((
        "tree_ds_union".into(),
        Value::List(unions.iter().map(|(a, b)| Value::List(vec![Value::Int(*a), Value::Int(*b)])).collect()),
    ));
    let mut parent: Vec<usize> = (0..7).collect();
    fn find(p: &mut [usize], mut x: usize) -> usize {
        while p[x] != x {
            p[x] = p[p[x]];
            x = p[x];
        }
        x
    }
    for (a, b) in &unions {
        let (ra, rb) = (find(&mut parent, *a as usize), find(&mut parent, *b as usize));
        if ra != rb {
            parent[rb] = ra;
        }
    }
    let roots: Vec<usize> = (0..7).map(|x| find(&mut parent, x)).collect();
    let ds_count = roots.iter().collect::<std::collections::HashSet<_>>().len() as i64;
    items.push(("tree_ds_count".into(), Value::Int(ds_count)));
    let checks: [(i64, i64); 5] = [(0, 6), (0, 4), (2, 1), (0, 3), (4, 6)];
    items.push((
        "tree_ds_connected".into(),
        Value::List(checks.iter().map(|(a, b)| Value::List(vec![
            Value::Int(*a),
            Value::Int(*b),
            Value::Bool(find(&mut parent, *a as usize) == find(&mut parent, *b as usize)),
        ])).collect()),
    ));
    let treap = [50i64, 30, 70, 20, 40, 60, 80, 10, 25, 35];
    items.push(("tree_treap_keys".into(), list_of_ints(&treap)));
    let mut ino = treap.to_vec();
    ino.sort();
    items.push(("tree_treap_inorder".into(), list_of_ints(&ino)));
}

fn gen_cache(items: &mut Vec<Item>) {
    // LRU simulation
    let ops: Vec<(i64, &str)> = vec![
        (0, "set"), (1, "set"), (2, "set"), (0, "get"),
        (3, "set"), (2, "get"), (4, "set"), (1, "set"),
    ];
    let mut lru: VecDeque<i64> = VecDeque::new();
    let mut evicted = Vec::new();
    let mut survivors = Vec::new();
    for &(key, verb) in ops.iter() {
        let mut ev = -1;
        if verb == "set" {
            if let Some(p) = lru.iter().position(|k| *k == key) {
                lru.remove(p);
            } else {
                if lru.len() >= 3 {
                    ev = lru.pop_front().unwrap();
                }
                lru.push_back(key);
            }
        } else {
            if let Some(p) = lru.iter().position(|k| *k == key) {
                lru.remove(p);
                lru.push_back(key);
            }
        }
        evicted.push(ev);
        let mut s: Vec<i64> = lru.iter().copied().collect();
        s.sort();
        survivors.push(list_of_ints(&s));
    }
    items.push(("cache_lru_evicted".into(), list_of_ints(&evicted)));
    items.push(("cache_lru_survivors".into(), Value::List(survivors)));
    // LFU: evicted key
    items.push(("cache_lfu_evicted".into(), Value::Int(2)));
    // expiring
    items.push(("cache_exp_times".into(), list_of_ints(&[0, 5, 8, 10, 108])));
    let deadlines = [10i64, 10, 108];
    let alive: Vec<i64> = [0, 5, 8, 10, 108].iter()
        .map(|&t| deadlines.iter().filter(|&&d| t < d).count() as i64)
        .collect();
    items.push(("cache_exp_alive_count".into(), list_of_ints(&alive)));
}

fn gen_seq(items: &mut Vec<Item>) {
    items.push(("seq_ring_pushes".into(), list_of_ints(&[1, 2, 3, 4, 5])));
    items.push(("seq_ring_final".into(), list_of_ints(&[3, 4, 5])));
    let bits = [0i64, 1, 3, 7, 15, 33];
    let total: usize = 40;
    let ones: Vec<i64> = (0..total).map(|b| if bits.contains(&(b as i64)) { 1 } else { 0 }).collect();
    let rank: Vec<i64> = (0..total).map(|i| ones[..i].iter().sum()).collect();
    items.push(("seq_bits_set".into(), list_of_ints(&bits)));
    items.push(("seq_bits_rank".into(), list_of_ints(&rank)));
    items.push(("seq_bits_select".into(), list_of_ints(&bits)));
    // gap buffer: ab -> cab -> caba -> cba -> cbax
    items.push(("seq_gap_final".into(), Value::Str("cbax".into())));
    items.push(("seq_list_final".into(), list_of_ints(&[1, 2])));
}

fn gen_sketch(items: &mut Vec<Item>) {
    items.push(("sketch_cm_items".into(), Value::List(vec![
        Value::Str("a".into()), Value::Str("a".into()), Value::Str("a".into()),
        Value::Str("b".into()), Value::Str("b".into()), Value::Str("c".into()),
    ])));
    items.push(("sketch_cm_true".into(), list_of_ints(&[3, 2, 1])));
    let total = 6i64;
    let eps = 1.0 / 100.0;
    let ceil = |x: f64| x.ceil() as i64;
    let upper = [3, 2, 1].map(|t| t + ceil(eps * total as f64));
    items.push(("sketch_cm_upper".into(), list_of_ints(&upper.to_vec())));
    items.push(("sketch_hll_count".into(), Value::Int(10000)));
    items.push(("sketch_hll_rel".into(), Value::F(1.04_f64 / (4096.0_f64).sqrt())));
    items.push(("sketch_td_true".into(), Value::List(vec![
        Value::F(50.0), Value::F(500.0), Value::F(950.0),
    ])));
    items.push(("sketch_bloom_fp_rate".into(), Value::F(0.01)));
}

fn gen_text(items: &mut Vec<Item>) {
    items.push(("text_text".into(), Value::Str("ababcababcab".into())));
    items.push(("text_kmp_pattern".into(), Value::Str("cabab".into())));
    let text = "ababcababcab";
    let pattern = "cabab";
    let occ: Vec<i64> = (0..text.len() as i64 - pattern.len() as i64 + 1)
        .filter(|&i| &text[i as usize..i as usize + pattern.len()] == pattern)
        .collect();
    items.push(("text_kmp_occ".into(), list_of_ints(&occ)));
    items.push(("text_ac_text".into(), Value::Str("ushers".into())));
    let ac_text = "ushers";
    let ac_patterns = ["he", "she", "his", "hers"];
    let mut per_pattern: Vec<Vec<i64>> = Vec::new();
    for p in &ac_patterns {
        let mut starts = Vec::new();
        let mut from = 0;
        while let Some(rel) = ac_text[from..].find(p) {
            starts.push(from as i64 + rel as i64);
            from += rel + 1;
        }
        per_pattern.push(starts);
    }
    items.push(("text_ac_starts".into(), Value::List(per_pattern.iter().map(|r| list_of_ints(r)).collect())));
    let total: i64 = per_pattern.iter().map(|r| r.len() as i64).sum();
    items.push(("text_ac_total".into(), Value::Int(total)));
    items.push(("text_z_str".into(), Value::Str("aabxaaby".into())));
    items.push(("text_z_arr".into(), list_of_ints(&z_function("aabxaaby"))));
    items.push(("text_sa_str".into(), Value::Str("banana".into())));
    let sa_str = "banana";
    let mut sa: Vec<i64> = (0..sa_str.len() as i64).collect();
    sa.sort_by_key(|&i| sa_str[i as usize..].to_string());
    items.push(("text_sa_order".into(), list_of_ints(&sa)));
    items.push(("text_sm_a".into(), Value::Str("abcd".into())));
    items.push(("text_sm_b".into(), Value::Str("acb".into())));
    items.push(("text_sm_ratio".into(), Value::F(4.0 / 7.0)));
}

fn z_function(s: &str) -> Vec<i64> {
    let n = s.len();
    let bytes = s.as_bytes();
    let mut z = vec![0i64; n];
    if n > 0 {
        z[0] = n as i64;
    }
    let mut l = 0usize;
    let mut r = 0usize;
    for i in 1..n {
        if i < r {
            let reused = z[i - l] as usize;
            let room = r - i;
            z[i] = (reused.min(room)) as i64;
        }
        while (i + z[i] as usize) < n && bytes[z[i] as usize] == bytes[i + z[i] as usize] {
            z[i] += 1;
        }
        if (i + z[i] as usize) > r {
            l = i;
            r = i + z[i] as usize;
        }
    }
    z
}

fn gen_phf(items: &mut Vec<Item>) {
    let keys = ["alpha", "beta", "gamma", "delta", "epsilon", "zeta", "eta", "theta"];
    items.push(("phf_keys".into(), Value::List(keys.iter().map(|k| Value::Str(k.to_string())).collect())));
    items.push(("phf_values".into(), list_of_ints(&(1..=8).collect::<Vec<_>>())));
    let absent = ["iota", "kappa", "lambda", "mu", "nu"];
    items.push(("phf_absent".into(), Value::List(absent.iter().map(|k| Value::Str(k.to_string())).collect())));
    items.push(("phf_index".into(), list_of_ints(&(0..8).collect::<Vec<_>>())));
}

fn main() {
    let out_dir = env::args().nth(1).unwrap_or_else(|| "scripts/vectors".to_string());
    fs::create_dir_all(&out_dir).ok();
    for pkg in ["algo", "map", "heap", "tree", "cache", "seq", "sketch", "text", "phf"] {
        let mut items: Vec<Item> = Vec::new();
        match pkg {
            "algo" => gen_algo(&mut items),
            "map" => gen_map(&mut items),
            "heap" => gen_heap(&mut items),
            "tree" => gen_tree(&mut items),
            "cache" => gen_cache(&mut items),
            "seq" => gen_seq(&mut items),
            "sketch" => gen_sketch(&mut items),
            "text" => gen_text(&mut items),
            "phf" => gen_phf(&mut items),
            _ => {}
        }
        items.sort_by(|a, b| a.0.cmp(&b.0));
        let text = items.iter().map(|(n, v)| format!("{}\t{}", n, canon(v))).collect::<Vec<_>>().join("\n") + "\n";
        let path = format!("{}/rust_{}.json", out_dir, pkg);
        fs::write(&path, text).ok();
    }
}
