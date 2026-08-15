#!/usr/bin/env bash
# Promote one of Frank's drafts to the public blog.
#
# Run this on a machine that has BOTH repos and your GitHub credentials.
# Do NOT put this, or any credential for this repo, on the AIRbox — Frank not
# being able to publish himself is the whole point of the split. He writes into
# the private repo; a human moves things across.
#
#   ./bin/promote-post.sh 2026-08-11-prime-gap-oscillation
#   ./bin/promote-post.sh --list
#
# Env:
#   FRANK_REPO   path to the private frank-agent clone (default ~/frank-agent)

set -euo pipefail

FRANK_REPO="${FRANK_REPO:-$HOME/frank-agent}"
DRAFTS="$FRANK_REPO/workspace/blog"
BLOG_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

die() { printf 'error: %s\n' "$*" >&2; exit 1; }

[ -d "$DRAFTS" ] || die "drafts not found at $DRAFTS (set FRANK_REPO)"

if [ "${1:-}" = "--list" ] || [ $# -eq 0 ]; then
  echo "Drafts in $DRAFTS:"
  for f in "$DRAFTS"/*.md; do
    b="$(basename "$f" .md)"
    [ "$b" = "README" ] && continue
    if [ -f "$BLOG_ROOT/_posts/$b.md" ]; then st="published"; else st="draft"; fi
    printf '  %-46s %s\n' "$b" "$st"
  done
  exit 0
fi

SLUG="${1%.md}"
SRC="$DRAFTS/$SLUG.md"
[ -f "$SRC" ] || die "no such draft: $SRC"

# Filename must start with a date for Jekyll to treat it as a post.
echo "$SLUG" | grep -qE '^[0-9]{4}-[0-9]{2}-[0-9]{2}-' \
  || die "draft name must start with YYYY-MM-DD- (got: $SLUG)"

DATE="${SLUG:0:10}"
DEST="$BLOG_ROOT/_posts/$SLUG.md"

# Title: first markdown H1, minus the leading '# '.
TITLE="$(grep -m1 '^# ' "$SRC" | sed 's/^# //')"
[ -n "$TITLE" ] || die "no '# Title' heading found in $SRC"

# Body: drop the H1 and Frank's '*Draft · date*' line; Jekyll renders those.
BODY="$(sed -e '0,/^# /d' -e '/^\*Draft · /d' "$SRC")"

mkdir -p "$BLOG_ROOT/_posts"
{
  echo "---"
  echo "layout: post"
  # Quote-escape any embedded double quotes in the title.
  echo "title: \"${TITLE//\"/\\\"}\""
  echo "date: $DATE"
  echo "---"
  echo
  echo "*Written by Frank, an autonomous AI agent. Unreviewed — see [About](/frank-blog/about/).*"
  echo
  echo "$BODY"
} > "$DEST"

echo "staged: $DEST"
echo
echo "--- review it, then: ---"
echo "  cd $BLOG_ROOT && git add -A && git commit -m 'post: $TITLE' && git push"
