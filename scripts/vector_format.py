"""Shared plumbing for the differential vector generators.

A generator produces two things for one package:

* a list of *data items*: the reference values (fixed inputs and the results the
  reference computes for them), each with a name, a MoonBit literal, and a
  JSON form. The JSON form is what the Rust generator must reproduce, byte for
  byte, so the two reference implementations are checked against each other.
* a list of *test blocks*: MoonBit ``test`` bodies that replay the operations on
  the library and assert it agrees with the data items.

The generator writes both the ``src/<pkg>/gen_<pkg>.mbt`` file (data items as
top-level ``let`` bindings, then the test blocks) and a manifest line per data
item, sorted by name, so a shell script can diff the Python manifest against the
Rust manifest and fail on any disagreement.

The Rust generator lives in ``scripts/rust_vectors`` and implements the same
rules; it must be kept in lockstep with this file.
"""

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
PKGS = ["algo", "map", "heap", "tree", "cache", "seq", "sketch", "text", "phf"]


def data(name, type_name, mbt_text, json_value, comment):
    return {
        "name": name,
        "type": type_name,
        "mbt": mbt_text,
        "json": json_value,
        "comment": comment,
    }


def test(name, lines):
    body = "\n".join("  " + ln for ln in lines)
    return {"name": name, "body": body}


# -- MoonBit literal builders ----------------------------------------------


def ints(values):
    return "[" + ", ".join(str(int(v)) for v in values) + "]"


def int_arr(values):
    return data(
        None, "Array[Int32]", ints(values), [int(v) for v in values], None
    )


def str_arr(values):
    return "[" + ", ".join('"' + v + '"' for v in values) + "]"


def char_arr(values):
    return "[" + ", ".join("'" + v + "'" for v in values) + "]"


def float_arr(values, nd=9):
    fmt = ",".join(_float(v, nd) for v in values)
    return "[" + fmt + "]"


def fscalar(v, nd=9):
    return _float(v, nd)


def _float(v, nd):
    s = ("%%.%df" % nd) % float(v)
    if "." not in s:
        s += ".0"
    return s


def tuples(items):
    return "[" + ", ".join(tuple_text(t) for t in items) + "]"


def arr_of_tuples(rows):
    return "[" + ", ".join("[" + ", ".join(tuple_text(x) for x in row) + "]" for row in rows) + "]"


def tuple_text(t):
    return "(" + ", ".join(_scalar(x) for x in t) + ")"


def arr_of_arr(rows, kind="ints"):
    if kind == "ints":
        inner = ",".join(ints(r) for r in rows)
    elif kind == "strs":
        inner = ",".join(str_arr(r) for r in rows)
    elif kind == "floats":
        inner = ",".join(float_arr(r) for r in rows)
    return "[" + inner + "]"


def _scalar(x):
    if isinstance(x, bool):
        return "true" if x else "false"
    if isinstance(x, int):
        return str(int(x))
    if isinstance(x, float):
        return _float(x, 9)
    if isinstance(x, str):
        return '"' + x + '"'
    raise TypeError("unsupported scalar %r" % (x,))


def json_value(values, kind="ints"):
    if kind == "ints":
        return [int(v) for v in values]
    if kind == "strs":
        return list(values)
    if kind == "floats":
        return [round(float(v), 9) for v in values]
    if kind == "tuples":
        return [_jrow(r) for r in values]
    if kind == "arr_of_ints":
        return [[int(v) for v in r] for r in values]
    raise TypeError("unsupported kind %r" % (kind,))


def _jrow(r):
    return [_scalar(x) if isinstance(x, str) else (int(x) if isinstance(x, int) else float(x)) for x in r]


def let_block(item):
    return (
        "/// %s\n"
        "let %s : %s = %s\n" % (item["comment"], item["name"], item["type"], item["mbt"])
    )


def test_block(item):
    return '///|\ntest "%s" {\n%s\n}\n' % (item["name"], item["body"])


def header(pkg):
    return (
        "// Differential vectors for `%s`. The values are computed by the Python\n"
        "// standard library (scripts/gen_vectors.py) and, byte for byte, by the Rust\n"
        "// standard library (scripts/rust_vectors); scripts/check_vector_agreement.sh\n"
        "// re-checks the two agree. They are the reference: the tests replay the same\n"
        "// operations on the library and assert it produces the same results. CI\n"
        "// replays these vectors; it does not regenerate them.\n" % pkg
    )


def render(pkg, data_items, test_items):
    parts = [header(pkg), ""]
    for item in data_items:
        parts.append(let_block(item))
        parts.append("")
    for item in test_items:
        parts.append(test_block(item))
        parts.append("")
    return "\n".join(parts)


def _canon(v):
    """A language-independent rendering of a value, used for the agreement
    manifest. Integers are plain, booleans are true/false, floats are fixed to
    nine decimals, strings are raw, and lists are comma-joined in square
    brackets, so Python and Rust write the identical line for identical values."""
    if isinstance(v, bool):
        return "true" if v else "false"
    if isinstance(v, int):
        return str(v)
    if isinstance(v, float):
        return ("%.9f" % v)
    if isinstance(v, str):
        return v
    if isinstance(v, (list, tuple)):
        return "[" + ",".join(_canon(x) for x in v) + "]"
    raise TypeError("unsupported manifest value %r" % (v,))


def manifest(pkg, data_items):
    lines = []
    for item in sorted(data_items, key=lambda d: d["name"]):
        lines.append("%s\t%s" % (item["name"], _canon(item["json"])))
    return "\n".join(lines) + "\n"


def write(pkg, data_items, test_items, src_root, vec_root):
    mbt = render(pkg, data_items, test_items)
    # A `_test.mbt` file: the test harness imports (and the `test` blocks that
    # use `@test`) only resolve there, and its top-level data `let`s stay out of
    # the public interface so `moon info` is unaffected.
    path = Path(src_root) / pkg / ("gen_%s_test.mbt" % pkg)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(mbt, encoding="utf-8", newline="\n")
    vroot = Path(vec_root)
    vroot.mkdir(parents=True, exist_ok=True)
    (vroot / ("py_%s.json" % pkg)).write_text(manifest(pkg, data_items), encoding="utf-8", newline="\n")
    return path
