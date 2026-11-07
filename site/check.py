#!/usr/bin/env python3
"""CI gate for the showcase site. Proves, without depending on the exact
moon version that produced the committed bundle:

  1. the API reference (site/api.json) is in sync with the package interfaces —
     regenerate it and require no diff;
  2. the browser bridge compiles to a release JS bundle;
  3. a freshly built bundle actually runs — load it in Node and call a couple
     of the demos, asserting the library's real output comes back.

Run with:  python site/check.py
It builds into the (gitignored) site/bridge/_build directory and never rewrites
the committed site/moonstl.js, so it is safe on any moon version.
"""

import json
import os
import subprocess
import sys
import textwrap
from pathlib import Path

SITE = Path(__file__).resolve().parent
ROOT = SITE.parent
BRIDGE = SITE / "bridge"
BUNDLE = BRIDGE / "_build" / "js" / "release" / "build" / "moonstl-site-bridge" / "main" / "main.js"


def sh(cmd, **kw):
    print("$", " ".join(cmd), flush=True)
    return subprocess.run(cmd, check=True, **kw)


def fail(msg):
    sys.stderr.write("FAIL: %s\n" % msg)
    sys.exit(1)


def main():
    # 1. API reference must match the interfaces.
    sh([sys.executable, str(ROOT / "scripts" / "gen_api.py")])
    diff = subprocess.run(["git", "diff", "--exit-code", "--", "site/api.json"], cwd=ROOT)
    if diff.returncode != 0:
        fail("site/api.json is out of sync with the package interfaces "
             "(run scripts/gen_api.py and commit the result)")

    # 2. Compile the bridge.
    sh(["moon", "build", "--target", "js", "--release"], cwd=BRIDGE)
    if not BUNDLE.exists():
        fail("bridge did not produce a bundle at %s" % BUNDLE)

    # 3. The fresh bundle must run: load it in Node and call a few demos.
    node = textwrap.dedent(r"""
      const fs = require('fs'), vm = require('vm');
      const { TextEncoder, TextDecoder } = require('util');
      const bundle = fs.readFileSync(process.argv[2], 'utf8');
      const sandbox = { console, document: undefined, TextEncoder, TextDecoder,
                        crypto: require('crypto').webcrypto };
      sandbox.globalThis = sandbox;
      vm.createContext(sandbox);
      vm.runInContext(bundle, sandbox);
      const st = sandbox.moonstl;
      if (!st || typeof st.run !== 'function') { console.error('bundle did not expose moonstl.run'); process.exit(1); }
      const idx = JSON.parse(st.run('indexmap', '{"set":[3,1,2,8]}'));
      if (idx.keys.join(',') !== '3,1,2,8') { console.error('indexmap wrong', idx); process.exit(1); }
      const heap = JSON.parse(st.run('heap', '{"set":[5,1,9,3,7]}'));
      if (heap.pops.join(',') !== '1,3,5,7,9') { console.error('heap wrong', heap); process.exit(1); }
      const seg = JSON.parse(st.run('segment', '{"set":[3,1,4,1,5]}'));
      if (seg.total !== 14) { console.error('segment wrong', seg); process.exit(1); }
      console.log('site bundle runs: indexmap / heap / segment verified');
    """)
    node_file = BRIDGE / "_smoke_node.js"
    node_file.write_text(node, encoding="utf-8")
    try:
        sh(["node", str(node_file), str(BUNDLE)])
    finally:
        node_file.unlink(missing_ok=True)

    print("site check passed: api.json in sync, bridge compiles, bundle runs")


if __name__ == "__main__":
    main()
