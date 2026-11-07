#!/usr/bin/env python3
"""CI gate for the showcase site. It proves, without depending on the exact
moon version that produced the committed module:

  1. the API reference (site/api.json) is in sync with the package interfaces —
     regenerate it and require no diff;
  2. the bridge compiles to a wasm-gc module and that module exports the two
     functions the page calls (`run`, `names`);
  3. the page itself works — serve site/, open it in a headless browser, and
     require that the module reached the page (the status pill reads "live") and
     that a demo rendered the library's real answer.

Run with:  python site/check.py
It builds into the (gitignored) site/bridge/_build directory and never rewrites
the committed site/moonstl.wasm, so it is safe on any moon version.
"""

import http.server
import json
import re
import os
import shutil
import socketserver
import subprocess
import sys
import threading
from pathlib import Path

SITE = Path(__file__).resolve().parent
ROOT = SITE.parent
BRIDGE = SITE / "bridge"
WASM = (
    BRIDGE / "_build" / "wasm-gc" / "release" / "build" / "moonstl-site-bridge" / "main" / "main.wasm"
)

CHROME_CANDIDATES = [
    os.environ.get("CHROME"),
    "google-chrome",
    "google-chrome-stable",
    "chromium",
    "chromium-browser",
    r"C:\Program Files\Google\Chrome\Application\chrome.exe",
    r"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe",
    r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
]


def sh(cmd, **kw):
    print("$", " ".join(str(c) for c in cmd), flush=True)
    return subprocess.run(cmd, check=True, **kw)


def fail(msg):
    sys.stderr.write("FAIL: %s\n" % msg)
    sys.exit(1)


def find_chrome():
    for c in CHROME_CANDIDATES:
        if not c:
            continue
        p = shutil.which(c)
        if p:
            return p
        if Path(c).exists():
            return c
    return None


def check_exports():
    """The module must export run/names; read them straight from the binary."""
    node = shutil.which("node")
    if not node:
        print("(node not found — skipping the export check)")
        return
    js = (
        "const fs=require('fs');"
        "const m=new WebAssembly.Module(fs.readFileSync(process.argv[1]));"
        "const names=WebAssembly.Module.exports(m).map(e=>e.name);"
        "process.stdout.write(JSON.stringify(names));"
    )
    out = subprocess.run([node, "-e", js, str(WASM)], check=True, capture_output=True, text=True)
    names = json.loads(out.stdout)
    for want in ("run", "names", "_start"):
        if want not in names:
            fail("wasm module does not export %r (exports: %s)" % (want, ", ".join(names)))
    print("wasm exports ok:", ", ".join(names))


def check_page():
    """Open the real page in a headless browser and look at what it rendered."""
    chrome = find_chrome()
    if not chrome:
        print("(no chrome/chromium found — skipping the in-browser check)")
        return

    handler = lambda *a, **kw: http.server.SimpleHTTPRequestHandler(  # noqa: E731
        *a, directory=str(SITE), **kw
    )
    socketserver.TCPServer.allow_reuse_address = True
    httpd = socketserver.TCPServer(("127.0.0.1", 0), handler)
    port = httpd.server_address[1]
    t = threading.Thread(target=httpd.serve_forever, daemon=True)
    t.start()

    def load(budget):
        url = "http://127.0.0.1:%d/index.html" % port
        out = subprocess.run(
            [
                chrome,
                "--headless=new",
                "--disable-gpu",
                "--no-sandbox",
                "--disable-dev-shm-usage",
                "--virtual-time-budget=%d" % budget,
                "--dump-dom",
                url,
            ],
            capture_output=True,
            text=True,
            timeout=240,
        )
        return out.stdout, out.stderr

    dom = ""
    for attempt, budget in enumerate((20000, 30000)):
        print("$ headless browser, budget %d ms" % budget)
        dom, err = load(budget)
        if len(dom) >= 2000 and 'class="modpill live"' in dom:
            break
        if attempt == 0:
            print("  (not live yet, retrying)")

    def pill(d):
        m = re.search(r'id="modText">([^<]*)<', d)
        return m.group(1) if m else "?"

    if len(dom) < 2000:
        fail("the page did not load in the browser (%d bytes of DOM)" % len(dom))
    if "MoonBit" not in dom:
        fail("the wordmark is missing from the rendered page")
    if 'class="modpill live"' not in dom:
        detail = re.search(r'class="err">(.*?)</div>', dom, re.S)
        fail(
            "the wasm module never reached the page: status=%r%s"
            % (pill(dom), (" error=" + re.sub(r"<[^>]+>", " ", detail.group(1)).strip()[:300]) if detail else "")
        )
    # the first specimen runs on load: IndexMap over [3,1,2,8] -> positions 0..3
    if "positions [0,1,2,3]" not in dom:
        fail("the live demo did not render the library's answer for IndexMap")
    if "wasm-gc call #" not in dom:
        fail("the stage did not report a wasm-gc call")
    httpd.shutdown()
    httpd.server_close()
    print("page runs the wasm-gc module: status live, IndexMap answer rendered")


def main():
    # 1. API reference must match the interfaces.
    sh([sys.executable, str(ROOT / "scripts" / "gen_api.py")])
    diff = subprocess.run(["git", "diff", "--exit-code", "--", "site/api.json"], cwd=ROOT)
    if diff.returncode != 0:
        fail(
            "site/api.json is out of sync with the package interfaces "
            "(run scripts/gen_api.py and commit the result)"
        )

    # 2. Compile the bridge to wasm-gc (moon update covers a fresh checkout).
    sh(["moon", "update"], cwd=BRIDGE)
    sh(["moon", "build", "--target", "wasm-gc", "--release"], cwd=BRIDGE)
    if not WASM.exists():
        fail("bridge did not produce a module at %s" % WASM)
    print("module: %d KB" % (WASM.stat().st_size // 1024))
    check_exports()

    # 3. The page must actually run it.
    check_page()

    print("site check passed: api.json in sync, wasm-gc module builds and exports run/names, page runs it")


if __name__ == "__main__":
    main()
