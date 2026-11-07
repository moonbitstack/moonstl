#!/usr/bin/env python3
"""Build the moonstl showcase site.

Steps:
  1. regenerate site/api.json from the package interfaces (scripts/gen_api.py)
  2. compile the browser bridge to WebAssembly with the wasm-gc backend
     (moon build --target wasm-gc --release)
  3. copy that module to site/moonstl.wasm, where the page instantiates it

The site is then served statically (e.g. `python -m http.server` from site/).
Running this after any library change keeps the demos and the API reference in
step with the code.
"""

import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SITE = ROOT / "site"
BRIDGE = SITE / "bridge"
WASM_SRC = (
    BRIDGE / "_build" / "wasm-gc" / "release" / "build" / "moonstl-site-bridge" / "main" / "main.wasm"
)
WASM_DST = SITE / "moonstl.wasm"


def run(cmd, **kw):
    print("$", " ".join(cmd))
    subprocess.run(cmd, check=True, **kw)


def main():
    # 1. API reference straight from the interfaces.
    run([sys.executable, str(ROOT / "scripts" / "gen_api.py")])

    # 2. Compile the bridge (workspace: bridge + moonstl) to wasm-gc. `moon update`
    #    fetches the registry (moonjson, and moonstl's moonseed) so a fresh
    #    checkout can resolve them before the build.
    run(["moon", "update"], cwd=BRIDGE)
    run(["moon", "build", "--target", "wasm-gc", "--release"], cwd=BRIDGE)

    # 3. Copy the module where the page instantiates it from.
    if not WASM_SRC.exists():
        sys.exit("bridge module not found at %s" % WASM_SRC)
    shutil.copyfile(WASM_SRC, WASM_DST)
    print(
        "site ready: %s  (%d KB wasm-gc module, %s api.json)"
        % (SITE, WASM_DST.stat().st_size // 1024, "site/api.json")
    )


if __name__ == "__main__":
    main()
