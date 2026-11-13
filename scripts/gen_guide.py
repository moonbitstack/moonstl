#!/usr/bin/env python3
"""Turn site/guide.md into site/guide.html, in the shell the rest of the site uses.

The guide's prose and code live in the markdown file, which is what
`scripts/check_snippets.py` compiles; the page is generated from it so the two
cannot drift. Regenerate after any edit and commit the result — CI reruns this
script and requires no diff.
"""

import html
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "site" / "guide.md"
OUT = ROOT / "site" / "guide.html"

NAV = [
    ("Workbench", "index.html#workbench"),
    ("Guide", "guide.html"),
    ("Families", "index.html#families"),
    ("Assay", "index.html#conformance"),
    ("Reference", "index.html#reference"),
    ("Install", "index.html#install"),
]

FAVICON = (
    "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 32 32'%3E"
    "%3Crect width='32' height='32' fill='%23151009'/%3E%3Crect x='8' y='8' width='16' height='16'"
    " fill='none' stroke='%23e9e6df' stroke-width='1'/%3E%3Cpath d='M16 10l4 6-4 6-4-6z'"
    " fill='%23c9b98f'/%3E%3C/svg%3E"
)

# The damascus rule from the title page; its gradient is what the footer's copy
# of the ornament refers to, so it has to be defined on this page too.
DAMASK = """    <div class="damask" aria-hidden="true">
      <svg viewBox="0 0 1200 26" preserveAspectRatio="none">
        <defs>
          <linearGradient id="steel" x1="0" y1="0" x2="1" y2="0">
            <stop offset="0" stop-color="#4d473e"/><stop offset=".22" stop-color="#cfc9bb"/>
            <stop offset=".34" stop-color="#6d6558"/><stop offset=".5" stop-color="#efece3"/>
            <stop offset=".62" stop-color="#736c60"/><stop offset=".8" stop-color="#d8d2c4"/>
            <stop offset="1" stop-color="#4d473e"/>
          </linearGradient>
        </defs>
        <g fill="none" stroke="url(#steel)" stroke-width="1.4">
          <path d="M0 9 C 120 2, 240 16, 360 9 S 600 2, 720 9 S 960 16, 1080 9 S 1200 4, 1200 9"/>
          <path d="M0 14 C 120 7, 240 21, 360 14 S 600 7, 720 14 S 960 21, 1080 14 S 1200 9, 1200 14" opacity=".75"/>
          <path d="M0 19 C 120 12, 240 26, 360 19 S 600 12, 720 19 S 960 26, 1080 19 S 1200 14, 1200 19" opacity=".5"/>
          <path d="M0 4 C 120 -3, 240 11, 360 4 S 600 -3, 720 4 S 960 11, 1080 4 S 1200 -1, 1200 4" opacity=".45"/>
        </g>
      </svg>
    </div>"""


def roman(n):
    numerals = [
        (10, "X"),
        (9, "IX"),
        (5, "V"),
        (4, "IV"),
        (1, "I"),
    ]
    out = ""
    for value, sign in numerals:
        while n >= value:
            out += sign
            n -= value
    return out


def inline(text):
    """Escaped text with the three inline forms the guide uses."""
    s = html.escape(text, quote=False)
    s = re.sub(r"`([^`]+)`", r"<code>\1</code>", s)
    s = re.sub(r"\*\*([^*]+)\*\*", r"<b>\1</b>", s)
    s = re.sub(r"\[([^\]]+)\]\(([^)]+)\)", r'<a href="\2">\1</a>', s)
    return s


def answer_rows(lines):
    """The answer under a snippet: a label and its value, split where the writer
    left a column gap, so the page can align them instead of guessing widths."""
    rows = []
    for line in lines:
        if not line.strip():
            continue
        parts = re.split(r"\s{2,}", line.strip())
        if len(parts) >= 2:
            rows.append(
                "<dt>%s</dt><dd>%s</dd>" % (inline(parts[0]), inline(" ".join(parts[1:])))
            )
        else:
            rows.append('<dd class="wide">%s</dd>' % inline(parts[0]))
    return "".join(rows)


def patch_rows(lines):
    """A patch is literal text, so it keeps its own lines; only the sign each
    line starts with is coloured, the way a reader scans it."""
    rows = []
    for line in lines:
        text = html.escape(line, quote=False)
        if line.startswith("+++") or line.startswith("---"):
            rows.append('<span class="meta">%s</span>' % text)
        elif line.startswith("@@"):
            rows.append('<span class="hunk">%s</span>' % text)
        elif line.startswith("+"):
            rows.append('<span class="add">%s</span>' % text)
        elif line.startswith("-"):
            rows.append('<span class="del">%s</span>' % text)
        else:
            rows.append(text)
    return "\n".join(rows)


def body(lines):
    """Render the markdown subset the guide is written in."""
    out = []
    i = 0
    n = len(lines)
    while i < n:
        line = lines[i]
        if not line.strip():
            i += 1
            continue
        if line.startswith("```"):
            lang = line[3:].strip()
            i += 1
            body_lines = []
            while i < n and not lines[i].startswith("```"):
                body_lines.append(lines[i])
                i += 1
            i += 1
            if lang == "diff":
                out.append(
                    '<div class="gout"><span class="lbl">answer</span>'
                    "<pre class=\"gpatch\">%s</pre></div>" % patch_rows(body_lines)
                )
                continue
            if lang == "text":
                out.append(
                    '<div class="gout"><span class="lbl">answer</span>'
                    "<dl>%s</dl></div>" % answer_rows(body_lines)
                )
            else:
                code = html.escape("\n".join(body_lines), quote=False)
                out.append('<pre class="gcode">%s</pre>' % code)
            continue
        if line.startswith("### "):
            out.append("<h4>%s</h4>" % inline(line[4:].strip()))
            i += 1
            continue
        if line.startswith("- "):
            items = []
            while i < n and lines[i].startswith("- "):
                items.append(inline(lines[i][2:].strip()))
                i += 1
            out.append("<ul>%s</ul>" % "".join("<li>%s</li>" % x for x in items))
            continue
        if line.startswith("> "):
            quote = []
            while i < n and lines[i].startswith("> "):
                quote.append(lines[i][2:].strip())
                i += 1
            out.append('<div class="gnote">%s</div>' % inline(" ".join(quote)))
            continue
        para = []
        while i < n and lines[i].strip() and not lines[i].startswith(
            ("## ", "### ", "```", "- ", "> ")
        ):
            para.append(lines[i].strip())
            i += 1
        out.append("<p>%s</p>" % inline(" ".join(para)))
    return "\n        ".join(out)


def main():
    text = SRC.read_text(encoding="utf-8")
    lines = text.splitlines()
    title = "The Guide"
    lede = []
    sections = []
    current = None
    i = 0
    while i < len(lines):
        line = lines[i]
        if line.startswith("# "):
            title = line[2:].strip()
            i += 1
            continue
        if line.startswith("## "):
            head = line[3:].strip()
            name, _, sub = head.partition("|")
            current = {"title": name.strip(), "sub": sub.strip(), "lines": []}
            sections.append(current)
            i += 1
            continue
        if current is None:
            lede.append(line)
        else:
            current["lines"].append(line)
        i += 1
    # A `### ` inside a section is a sub-head; split it out here rather than in
    # the block parser so the headings keep the page's own type.
    parts = []
    for index, section in enumerate(sections):
        rendered = body(section["lines"])
        parts.append(
            """    <section class="gsec" id="step-%d">
      <div class="wrap">
        <div class="shead">
          <div class="num">Step %s</div>
          <h3>%s</h3>
          <div class="sub">%s</div>
        </div>
        <div class="gbody">
        %s
        </div>
      </div>
    </section>"""
            % (index + 1, roman(index + 1), inline(section["title"]), inline(section["sub"]), rendered)
        )

    nav = "\n      ".join(
        '<a href="%s"%s>%s</a>'
        % (href, ' aria-current="page"' if href == "guide.html" else "", label)
        for label, href in NAV
    )

    intro = ""
    if lede and " ".join(x.strip() for x in lede if x.strip()):
        intro = """    <section class="gsec gintro">
      <div class="wrap">
        <div class="gbody">
        <p>%s</p>
        </div>
      </div>
    </section>""" % inline(" ".join(x.strip() for x in lede if x.strip()))

    page = """<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="icon" href="%(favicon)s">
<title>%(title)s — MoonBit STL</title>
<meta name="description" content="A step-by-step tour of the moonstl containers, caches, sketches, text structures and algorithms, with the answer each snippet produces.">
<link rel="stylesheet" href="style.css">
</head>
<body>

<div class="strip">
  <div class="wrap strip-in">
    <a class="brand" href="index.html" aria-label="MoonBit STL">
      <span class="mark"><i></i></span><b>MoonBit <em>STL</em></b>
    </a>
    <div class="strip-right">
      <span class="edition">Vol. I &nbsp;·&nbsp; MMXXVI &nbsp;·&nbsp; The MoonBit Standard Library</span>
    </div>
  </div>
</div>

<header class="masthead" id="top">
  <div class="wrap">
    <div class="rule2"></div>
    <h1 class="wordmark">The&nbsp;<span>Guide</span></h1>
    <p class="subtitle">A Step-by-Step Tour of the Atlas</p>
    <nav>
      %(nav)s
    </nav>
    <div class="rule2" style="margin-top:22px"></div>
%(damask)s
  </div>
</header>

<main class="guide">
%(intro)s
%(sections)s

    <section class="gsec">
      <div class="wrap">
        <div class="gnext">
          <a class="btn" href="index.html">The title page</a>
          <a class="btn" href="index.html#workbench">The workbench</a>
          <a class="btn solid" href="index.html#reference">The reference</a>
        </div>
      </div>
    </section>
</main>

<footer>
  <div class="wrap">
    <div class="rule2"></div>
    <div class="colophon">
      <p class="l">Bound in leather and steel, after the manner of the
        <a href="https://www.sgi.com/tech/stl/" rel="noopener">SGI STL reference</a> and
        <a href="https://en.cppreference.com/" rel="noopener">cppreference</a>.</p>
      <p class="l" style="margin-top:8px"><a href="https://github.com/moonbitstack/moonstl" rel="noopener">source</a> ·
        <a href="https://mooncakes.io/docs/moonbitstack/moonstl" rel="noopener">mooncakes</a> ·
        <a href="index.html">the title page</a></p>
      <p class="fine">MoonBit STL · MIT · set in Constantia &amp; Cascadia · checked on three systems</p>
    </div>
  </div>
</footer>

</body>
</html>
""" % {
        "favicon": FAVICON,
        "title": inline(title),
        "intro": intro,
        "nav": nav,
        "damask": DAMASK,
        "sections": "\n\n".join(parts),
    }
    OUT.write_text(page, encoding="utf-8", newline="\n")
    print("wrote %s: %d steps" % (OUT, len(sections)))


if __name__ == "__main__":
    main()
