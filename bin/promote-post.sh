#!/usr/bin/env python3
"""Promote one of Frank's drafts to the public blog.

Run on a machine that has BOTH repos and your GitHub credentials. Do NOT put
this, or any credential for this repo, on the AIRbox — Frank not being able to
publish himself is the whole point of the split.

    ./bin/promote-post.sh --list
    ./bin/promote-post.sh 2026-08-11-prime-gap-oscillation

Figures are carried across automatically: any local image the draft references
is copied into assets/posts/<slug>/ and the path rewritten, so a post that looks
right in the private repo also looks right once published.

Env: FRANK_REPO  path to the private frank-agent clone (default ~/frank-agent)
"""

import os
import re
import shutil
import sys

FRANK_REPO = os.environ.get("FRANK_REPO", os.path.expanduser("~/frank-agent"))
DRAFTS = os.path.join(FRANK_REPO, "workspace", "blog")
BLOG_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
POSTS = os.path.join(BLOG_ROOT, "_posts")

# ![alt](path "title")  and  <img src="path">
#
# The gap between ] and ( is captured rather than required to be empty: Frank
# writes "![alt] (path)" most of the time, which is not valid markdown and would
# publish as literal text. Tolerate it, normalise it, and say so. Alt text may
# also span lines, hence re.S.
MD_IMG = re.compile(r'(!\[)([^\]]*)(\])(\s*)\(([^)\s]+)((?:\s+"[^"]*")?\))', re.S)
HTML_IMG = re.compile(r'(<img[^>]*\bsrc=["\'])([^"\']+)(["\'])')

DATED = re.compile(r"^\d{4}-\d{2}-\d{2}-")


def die(msg):
    print(f"error: {msg}", file=sys.stderr)
    sys.exit(1)


def list_drafts():
    if not os.path.isdir(DRAFTS):
        die(f"drafts not found at {DRAFTS} (set FRANK_REPO)")
    print(f"Drafts in {DRAFTS}:")
    for fn in sorted(os.listdir(DRAFTS)):
        if not fn.endswith(".md") or fn == "README.md":
            continue
        slug = fn[:-3]
        live = os.path.join(POSTS, fn)
        if not os.path.exists(live):
            state = "draft"
        else:
            # Existence alone says nothing: Frank revises published posts, and a
            # stale live copy looked identical to an up-to-date one. Compare the
            # rendered output against what is actually published.
            try:
                fresh, _, _, _, _ = render(slug, copy_assets=False)
                same = fresh == open(live, encoding="utf-8").read()
            except SystemExit:
                same = True          # unrenderable; not a staleness question
            state = "published" if same else "UPDATED - needs re-promote"
        print(f"  {slug:<46} {state}")


def resolve_asset(ref, draft_dir):
    """Find a referenced image on disk. Frank may reference it relative to the
    draft, or reach up into projects/ where his matplotlib output actually lives."""
    ref = ref.split("#")[0].split("?")[0]
    for base in (draft_dir, os.path.join(FRANK_REPO, "workspace"), FRANK_REPO):
        cand = os.path.normpath(os.path.join(base, ref))
        if os.path.isfile(cand):
            return cand
    return None


def render(slug, copy_assets=True):
    """Produce the exact text that belongs in _posts/. With copy_assets=False it
    has no side effects, so --list can compare it against what is published and
    tell whether the live post is stale."""
    src = os.path.join(DRAFTS, slug + ".md")
    if not os.path.isfile(src):
        die(f"no such draft: {src}")
    if not DATED.match(slug):
        die(f"draft name must start with YYYY-MM-DD- (got: {slug})")

    date = slug[:10]
    text = open(src, encoding="utf-8").read()

    m = re.search(r"^# (.+)$", text, re.M)
    if not m:
        die(f"no '# Title' heading found in {src}")
    title = m.group(1).strip()

    # Drop the H1 and Frank's "*Draft · date*" line; the layout renders those.
    body = text[m.end():]
    body = re.sub(r"^\*Draft · [^\n]*\n", "", body, flags=re.M)

    # --- carry figures across -------------------------------------------------
    asset_dir = os.path.join(BLOG_ROOT, "assets", "posts", slug)
    copied, missing = [], []

    fixed_syntax = []

    def _asset(ref):
        """Resolve and (optionally) copy. Returns the rewritten path or None."""
        if re.match(r"^(https?:)?//|^/|^\{\{", ref):
            return None                      # remote or already absolute
        found = resolve_asset(ref, DRAFTS)
        if not found:
            missing.append(ref)
            return None
        name = os.path.basename(found)
        if copy_assets:
            os.makedirs(asset_dir, exist_ok=True)
            shutil.copy2(found, os.path.join(asset_dir, name))
        copied.append(name)
        return "{{ '/assets/posts/%s/%s' | relative_url }}" % (slug, name)

    def rewrite_md(m):
        bang, alt, close, gap, ref, tail = m.groups()
        if gap.strip() != "" or "\n" in gap:
            pass                              # handled below by normalising gap
        if gap != "":
            fixed_syntax.append(ref)
        alt = " ".join(alt.split())           # collapse multi-line alt text
        new = _asset(ref)
        if new is None:
            return f"{bang}{alt}{close}({ref}{tail}"
        return f"{bang}{alt}{close}({new}{tail}"

    def rewrite_html(m):
        pre, ref, post = m.groups()
        new = _asset(ref)
        return m.group(0) if new is None else f"{pre}{new}{post}"

    body = MD_IMG.sub(rewrite_md, body)
    body = HTML_IMG.sub(rewrite_html, body)

    out = (
        "---\n"
        "layout: post\n"
        + 'title: "%s"\n' % title.replace('"', '\\"')
        + f"date: {date}\n"
        "---\n"
        # No byline: the site header identifies Frank on every page, including
        # permalinks and feed entries. Repeating it above each post just delays
        # the reader getting to the writing.
        + body
    )
    return out, title, copied, missing, fixed_syntax


def promote(slug):
    slug = slug[:-3] if slug.endswith(".md") else slug
    out, title, copied, missing, fixed_syntax = render(slug, copy_assets=True)
    os.makedirs(POSTS, exist_ok=True)
    dest = os.path.join(POSTS, slug + ".md")
    open(dest, "w", encoding="utf-8").write(out)

    print(f"staged: {dest}")
    if copied:
        print(f"figures: {len(copied)} copied to assets/posts/{slug}/")
        for c in copied:
            print(f"  + {c}")
    if fixed_syntax:
        print(f"normalised {len(fixed_syntax)} malformed image ref(s) — "
              "'![alt] (path)' is not valid markdown, should be '![alt](path)':")
        for r in fixed_syntax:
            print(f"  ~ {r}")
    if missing:
        print("WARNING: referenced images not found on disk (left as-is):")
        for mref in missing:
            print(f"  ? {mref}")
    print("\n--- review it, then: ---")
    print(f"  cd {BLOG_ROOT} && git add -A && git commit -m 'post: {title}' && git push")


if __name__ == "__main__":
    if len(sys.argv) < 2 or sys.argv[1] == "--list":
        list_drafts()
    else:
        promote(sys.argv[1])
