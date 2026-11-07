#!/usr/bin/env bash
# Re-run the differential vector generators in both the Python and the Rust
# standard library and diff their manifests. A difference means the two
# reference implementations disagree on the shared inputs, which is the bug;
# the committed `src/*/gen_*_test.mbt` data is regenerated only when both
# agree. CI replays the committed vectors via `moon test`; it does not
# regenerate them.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PY="${PYTHON:-python3}"
V="$ROOT/scripts/vectors"

cd "$ROOT"

# Python reference: writes the data files and the py_* manifests.
"$PY" scripts/gen_vectors.py

# Rust reference: writes the rust_* manifests for the same inputs.
(cd scripts/rust_vectors && cargo run --release --quiet -- "$V")

# Compare.
status=0
for pkg in algo map heap tree cache seq sketch text phf; do
  py="$V/py_$pkg.json"
  rust="$V/rust_$pkg.json"
  if ! diff -u "$py" "$rust" > "$V/$pkg.diff"; then
    echo "MISMATCH: $pkg" >&2
    cat "$V/$pkg.diff" >&2
    status=1
  fi
done

if [ "$status" -eq 0 ]; then
  echo "all nine packages agree between the Python and Rust references"
fi
exit "$status"
