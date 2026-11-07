#!/usr/bin/env python3
"""Build the moonstl showcase site.

Steps:
  1. regenerate site/api.json from the package interfaces (python scripts/gen_api.py)
  2. compile the browser bridge to a release JS bundle (moon build --target js --release)
  3. copy that bundle to site/moonstl.js so the page can load it with <script>

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
BUNDLE_SRC = BRIDGE / "_build" / "js" / "release" / "build" / "moonstl-site-bridge" / "main" / "main.js"
BUNDLE_DST = SITE / "moonstl.js"


def run(cmd, **kw):
    print("$", " ".join(cmd))
    subprocess.run(cmd, check=True, **kw)


def main():
    # 1. API reference straight from the interfaces.
    run([sys.executable, str(ROOT / "scripts" / "gen_api.py")])

    # 2. Compile the bridge (workspace: bridge + moonstl).
    run(["moon", "build", "--target", "js", "--release"], cwd=BRIDGE)

    # 3. Copy the bundle where the page loads it from.
    if not BUNDLE_SRC.exists():
        sys.exit("bridge bundle not found at %s" % BUNDLE_SRC)
    shutil.copyfile(BUNDLE_SRC, BUNDLE_DST)
    print("site ready: %s  (%d KB bundle, %s api.json)" % (
        SITE, BUNDLE_DST.stat().st_size // 1024, "site/api.json"))


if __name__ == "__main__":
    main()
