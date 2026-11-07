#!/usr/bin/env python3
"""Parse moonstl's `pkg.generated.mbti` interface files into site/api.json.

The .mbti files are produced by `moon info` and reflect the public surface of
each package exactly. Reading them (rather than hand-writing the docs) keeps
the reference on the site in lockstep with the code: regenerate after any
public change and the reference follows.
"""

import json
import re
from pathlib import Path

SRC = Path(__file__).resolve().parent.parent / "src"
OUT = Path(__file__).resolve().parent.parent / "site" / "api.json"

# Human-facing package order and one-line descriptions for the page.
PKG_META = {
    "spec":   "Shared vocabulary",
    "seq":    "Sequences & buffers",
    "map":    "Associative containers",
    "heap":   "Priority queues",
    "tree":   "Trees & range indexes",
    "cache":  "Caches with policies",
    "sketch": "Probabilistic sketches",
    "text":   "String algorithms",
    "phf":    "Perfect hash maps",
    "algo":   "Array algorithms & combinatorics",
}
PKG_ORDER = ["spec", "seq", "map", "heap", "tree", "cache", "sketch", "text", "phf", "algo"]

STRUCT = re.compile(r"^pub (?:all )?struct\s+([A-Za-z0-9_]+)(\[([^\]]*)\])?\s*\{")
ENUM = re.compile(r"^pub (?:all )?enum\s+([A-Za-z0-9_]+)(\[([^\]]*)\])?\s*\{")
TYPEALIAS = re.compile(r"^pub type(?:alias)?\s+([A-Za-z0-9_]+)(\[([^\]]*)\])?\s*=\s*(.+)$")
LET = re.compile(r"^pub let\s+([A-Za-z0-9_]+)\s*:\s*(.+)$")
# Matches just the head of a `pub fn` line up to (but not including) the
# parameter list; the parameters/return are parsed with balanced parens.
FN_HEAD = re.compile(r"^pub fn(?:\[([^\]]*)\])?\s+([A-Za-z0-9_]+)(?:::([A-Za-z0-9_]+))?\s*\(")
IMPL = re.compile(r"^pub impl(?:\[([^\]]*)\])?\s*(.*?)\s+for\s+([A-Za-z0-9_]+)(\[([^\]]*)\])?")
CONST = re.compile(r"^pub const\s+([A-Za-z0-9_]+)\s*[:=]\s*(.+)$")


def join_params(params: str) -> str:
    """Join a possibly-multi-line parameter list onto one line."""
    s = " ".join(params.split())
    return s.strip()


def split_signature(line: str):
    """Split a `pub fn` signature line into (params, ret) via balanced parens.

    We find the first `(`, match its closing paren counting nesting, take the
    text between as the parameters and the remainder as the return clause.
    """
    line = join_params(line)
    open_idx = line.find("(")
    if open_idx < 0:
        return "", ""
    depth = 0
    close_idx = -1
    for k in range(open_idx, len(line)):
        if line[k] == "(":
            depth += 1
        elif line[k] == ")":
            depth -= 1
            if depth == 0:
                close_idx = k
                break
    params = line[open_idx + 1:close_idx].strip()
    clause = line[close_idx + 1:].strip()
    # The return clause starts with an arrow token (`->`) followed by the type.
    # Strip only that first arrow (and its whitespace) so closure types like
    # "(K) -> V" keep their own arrow.
    ret = re.sub(r"^\s*->\s*", "", clause, count=1).strip()
    return params, (ret if ret else "Unit")


def parse_pkg(pkg: str):
    path = SRC / pkg / "pkg.generated.mbti"
    if not path.exists():
        return None
    lines = path.read_text(encoding="utf-8").splitlines()
    types: dict[str, dict] = {}   # name -> {kind, params, fields/variants/impls}
    free_fns = []
    lets = []

    def ensure(name, kind, params):
        if name not in types:
            types[name] = {"name": name, "kind": kind, "params": params,
                           "members": [], "impls": []}
        return types[name]

    i = 0
    n = len(lines)
    while i < n:
        line = lines[i]
        m = STRUCT.match(line)
        if m:
            name, params = m.group(1), (m.group(3) or "").strip()
            t = ensure(name, "struct", params)
            i += 1
            depth = 1
            fields = []
            while i < n and depth > 0:
                ln = lines[i]
                depth += ln.count("{") - ln.count("}")
                if depth <= 0:
                    break
                stripped = ln.strip()
                if stripped and not stripped.startswith("//"):
                    fields.append(stripped.rstrip(","))
                i += 1
            t["fields"] = fields
            i += 1
            continue
        m = ENUM.match(line)
        if m:
            name, params = m.group(1), (m.group(3) or "").strip()
            t = ensure(name, "enum", params)
            i += 1
            depth = 1
            variants = []
            while i < n and depth > 0:
                ln = lines[i]
                depth += ln.count("{") - ln.count("}")
                if depth <= 0:
                    break
                stripped = ln.strip()
                if stripped and not stripped.startswith("//"):
                    variants.append(stripped.rstrip(","))
                i += 1
            t["variants"] = variants
            i += 1
            continue
        m = TYPEALIAS.match(line)
        if m:
            t = ensure(m.group(1), "type", (m.group(3) or "").strip())
            t["alias"] = m.group(4).strip()
            i += 1
            continue
        m = LET.match(line)
        if m:
            lets.append({"name": m.group(1), "type": m.group(2).strip()})
            i += 1
            continue
        m = CONST.match(line)
        if m:
            lets.append({"name": m.group(1), "type": m.group(2).strip()})
            i += 1
            continue
        m = FN_HEAD.match(line)
        if m:
            generic = (m.group(1) or "").strip()
            receiver = m.group(2)
            method = m.group(3)
            params, ret = split_signature(line)
            if method:
                t = ensure(receiver, "struct", "")
                t["members"].append({
                    "name": method, "sig": f"fn{('<%s>' % generic) if generic else ''} {method}({params}) -> {ret}",
                    "kind": "method",
                })
            else:
                free_fns.append({
                    "name": receiver,
                    "sig": f"fn{('<%s>' % generic) if generic else ''} {receiver}({params}) -> {ret}",
                })
            i += 1
            continue
        m = IMPL.match(line)
        if m:
            trait = m.group(2).strip()
            name = m.group(3)
            t = ensure(name, "struct", "")
            if trait and trait not in t["impls"]:
                t["impls"].append(trait)
            i += 1
            continue
        i += 1

    # drop placeholder types that only appeared as impl targets with no body
    types = {k: v for k, v in types.items()
             if v.get("fields") or v.get("variants") or v.get("alias")
             or v.get("members") or v.get("impls")}
    return {"package": pkg, "types": types, "free_fns": free_fns, "lets": lets}


def main():
    out = {"packages": []}
    for pkg in PKG_ORDER:
        data = parse_pkg(pkg)
        if not data:
            continue
        types = sorted(data["types"].values(), key=lambda t: t["name"])
        out["packages"].append({
            "package": pkg,
            "blurb": PKG_META.get(pkg, ""),
            "types": types,
            "free_fns": data["free_fns"],
            "lets": data["lets"],
        })
    OUT.parent.mkdir(parents=True, exist_ok=True)
    with OUT.open("w", encoding="utf-8", newline="\n") as fh:
        fh.write(json.dumps(out, ensure_ascii=False, indent=2) + "\n")
    total = sum(len(p["types"]) for p in out["packages"])
    print("wrote %s: %d packages, %d types" % (OUT, len(out["packages"]), total))


if __name__ == "__main__":
    main()
