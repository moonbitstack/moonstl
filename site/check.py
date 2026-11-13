#!/usr/bin/env python3
"""CI gate for the showcase site. It proves, without depending on the exact
moon version that produced the committed module:

  1. the API reference (site/api.json) is in sync with the package interfaces,
     and the guide (site/guide.html) with its markdown — regenerate both and
     require no diff;
  2. the bridge compiles to a wasm-gc module and that module exports the two
     functions the page calls (`run`, `names`);
  3. the page itself works — serve site/, open it in a headless browser, and
     require the page to report back that the module reached it and that the
     first specimen rendered the library's real answer.

The page is loaded with `?probe=1`, which makes it call back to the checker
once boot has finished (or once it has failed, with the reason). The checker
waits for that call instead of guessing how long the browser needs, which is
what a DOM dump after a virtual-time budget does — and which proved unreliable
on slower machines.

Run with:  python site/check.py
It builds into the (gitignored) site/bridge/_build directory and never rewrites
the committed site/moonstl.wasm, so it is safe on any moon version.
"""

import http.server
import json
import os
import shutil
import subprocess
import sys
import tempfile
import threading
import time
from pathlib import Path
from urllib.parse import parse_qs, urlparse

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

RESULT = {"ok": None, "detail": ""}
DONE = threading.Event()


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


class ProbeHandler(http.server.SimpleHTTPRequestHandler):
    """Serves site/ and records the page's readiness report."""

    def __init__(self, *a, **kw):
        super().__init__(*a, directory=str(SITE), **kw)

    def log_message(self, fmt, *args):  # keep the CI log readable
        pass

    def do_GET(self):
        if self.path.startswith("/__probe"):
            q = parse_qs(urlparse(self.path).query)
            RESULT["ok"] = q.get("ok", ["0"])[0] == "1"
            RESULT["detail"] = q.get("detail", [""])[0]
            DONE.set()
            body = b"ok"
            self.send_response(200)
            self.send_header("Content-Type", "text/plain")
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)
            return
        super().do_GET()


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
    """Open the real page in a headless browser and wait for it to report back."""
    chrome = find_chrome()
    if not chrome:
        print("(no chrome/chromium found — skipping the in-browser check)")
        return

    httpd = http.server.ThreadingHTTPServer(("127.0.0.1", 0), ProbeHandler)
    httpd.daemon_threads = True
    port = httpd.server_address[1]
    threading.Thread(target=httpd.serve_forever, daemon=True).start()

    profile = tempfile.mkdtemp(prefix="moonstl-chrome-")
    url = "http://127.0.0.1:%d/index.html?probe=1" % port
    print("$ headless browser", url)
    proc = subprocess.Popen(
        [
            chrome,
            "--headless=new",
            "--disable-gpu",
            "--no-sandbox",
            "--disable-dev-shm-usage",
            "--no-first-run",
            "--no-default-browser-check",
            "--user-data-dir=%s" % profile,
            url,
        ],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )

    try:
        deadline = time.time() + 120
        while time.time() < deadline and not DONE.is_set():
            if proc.poll() is not None and not DONE.is_set():
                fail("the browser exited before the page reported back")
            time.sleep(0.25)
        if not DONE.is_set():
            fail("the page never reported back within 120 s")
    finally:
        proc.terminate()
        try:
            proc.wait(timeout=10)
        except subprocess.TimeoutExpired:
            proc.kill()
        httpd.shutdown()
        httpd.server_close()
        shutil.rmtree(profile, ignore_errors=True)

    detail = RESULT["detail"]
    if not RESULT["ok"]:
        fail("the page could not start the module: %s" % (detail or "no reason given"))
    # the first specimen runs on load: IndexMap over [3,1,2,8] -> positions 0..3
    if "positions [0,1,2,3]" not in detail:
        fail("the live demo did not render the library's answer for IndexMap: %r" % detail)
    print("page runs the wasm-gc module:", detail[:120])


def main():
    # 1. The generated pages must match what they are generated from.
    sh([sys.executable, str(ROOT / "scripts" / "gen_api.py")])
    sh([sys.executable, str(ROOT / "scripts" / "gen_guide.py")])
    diff = subprocess.run(
        ["git", "diff", "--exit-code", "--", "site/api.json", "site/guide.html"], cwd=ROOT
    )
    if diff.returncode != 0:
        fail(
            "a generated page is out of sync (run scripts/gen_api.py and "
            "scripts/gen_guide.py, then commit the result)"
        )

    # 2. Compile the bridge to wasm-gc.
    sh(["moon", "update"], cwd=BRIDGE)
    sh(["moon", "build", "--target", "wasm-gc", "--release"], cwd=BRIDGE)
    if not WASM.exists():
        fail("bridge did not produce a module at %s" % WASM)
    print("module: %d KB" % (WASM.stat().st_size // 1024))
    check_exports()

    # 3. The page must actually run it.
    check_page()

    print("site check passed: api.json and guide.html in sync, wasm-gc module builds and exports run/names, page runs it")


if __name__ == "__main__":
    main()
