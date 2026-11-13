#!/usr/bin/env bash
# os-health.sh: mechanical hygiene check for an OS folder. Reports only, never modifies.
#   bash "03_resources/scripts/os-health.sh"
# Run weekly (wired into AGENTS.md Reviews). Fix what it reports, don't just note it.
set -uo pipefail

WOS="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$WOS"

# ---- instance config (the ONLY block to edit when cloning this script into another OS) ----
# Generated memory files: exempt from the size check (regenerated, not pruned).
GENERATED_MEMORY=''
# Optional house rule: set to 1 to flag em/en dashes.
DASH_CHECK=0
# Files allowed to contain em/en dashes: generated mirrors, the rule line itself, verbatim archives.
DASH_EXEMPT='(90_memory/core\.md|\.obsidian|/node_modules/)'
# Per-project handoff.md line cap (AGENTS.md end-of-task rule says ≤60).
HANDOFF_MAX=60
# Shown when git has no remote (instance decision, keep it one line).
NO_REMOTE_NOTE='no remote configured: folder is the single copy; back it up, or add a remote on infrastructure this content is allowed on'
# -------------------------------------------------------------------------------------------

echo "=== $(basename "$WOS") health $(date +%Y-%m-%d) ==="

echo
echo "--- stray items at root (only AGENTS.md, CLAUDE.md, client pointer .md files + dotfiles + NN_kebab-name dirs) ---"
ls -A | grep -vE '^(\.git|\.gitignore|\.claude|\.codex|\.mcp\.json|\.obsidian|\.DS_Store|[A-Za-z0-9_-]+\.md|[0-9]{2}_[a-z0-9-]+)$' | sed 's/^/  /'
for d in [0-9][0-9]_*/; do [ -d "$d" ] && grep -q "${d%/}" AGENTS.md || echo "  ${d%/}: category dir not registered in AGENTS.md Map"; done

echo
echo "--- client pointer files (every root .md except AGENTS.md must be a thin pointer to it, and AGENTS.md should stay under 200 lines) ---"
for p in *.md; do
  [ -f "$p" ] || continue
  [ "$p" = "AGENTS.md" ] && { n=$(wc -l < "$p" | tr -d ' '); [ "$n" -gt 200 ] && echo "  AGENTS.md is $n lines: move detail into routed memory or skills"; continue; }
  grep -q 'AGENTS.md' "$p" || echo "  $p does not point at AGENTS.md"
  n=$(wc -l < "$p" | tr -d ' ')
  [ "$n" -gt 40 ] && echo "  $p is $n lines: should stay a thin pointer, not a copy (drift risk)"
done

echo
echo "--- 00_inbox items older than 7 days (file them per AGENTS.md filing rules) ---"
find 00_inbox -type f ! -name '.gitkeep' ! -name '.DS_Store' -mtime +7 | sed 's/^/  /'
echo
echo "--- 00_inbox drops not yet filed (name outside YYYYMMDD_keyword_type.ext = the user dropped it; file at session start) ---"
find 00_inbox -type f ! -name '.*' | grep -vE '/[0-9]{8}_[a-z0-9-]+_[a-z-]+\.[a-z0-9]+$' | sed 's/^/  /'

echo
echo "--- 90_memory files over 110 lines (prune per monthly review; generated files exempt) ---"
for f in 90_memory/*.md; do
  case " $GENERATED_MEMORY " in *" $f "*) continue;; esac
  n=$(wc -l < "$f" | tr -d ' ')
  [ "$n" -gt 110 ] && echo "  $f: $n lines"
done

echo
echo "--- naming: flat files in 03_resources should be YYYYMMDD_keyword_type.ext ---"
find 03_resources -maxdepth 1 -type f ! -name '.*' | grep -vE '/[0-9]{8}_[a-z0-9-]+_[a-z-]+\.[a-z]+$' | sed 's/^/  /'

echo
if [ "$DASH_CHECK" = 1 ]; then
  echo "--- banned punctuation (em/en dash) outside exempt files ---"
  grep -rlE '—|–' --include='*.md' . 2>/dev/null | grep -vE "$DASH_EXEMPT" | sed 's/^/  /'
fi

echo
echo "--- one home per thing (same folder name twice in a project: merge or rename by purpose) ---"
for d in 01_projects/*/; do
  [ -d "$d" ] || continue
  find "$d" -mindepth 1 -maxdepth 4 -type d -not -path '*/node_modules*' -not -path '*/.*' -not -path '*/dist*' -not -path '*/build*' 2>/dev/null \
    | awk -F/ '{print $NF}' | grep -vxE 'assets|docs|src|scripts|styles|images|img|fonts|components|lib|public|archive|data|tests?|utils|pages' \
    | sort | uniq -d | while IFS= read -r dup; do echo "  $d has two '$dup' folders"; done
done

echo
echo "--- empty dirs git cannot carry (add a .gitkeep) ---"
find . -type d -empty -not -path './.git/*' -not -path './.git' -not -path './.obsidian*' -not -path '*/node_modules/*' | sed 's/^/  /'

echo
echo "--- projects: each project dir needs handoff.md (≤$HANDOFF_MAX lines, Updated >= newest log date) + README.md + log.md + a PROJECTS.md row ---"
check_project() {
  local d="$1" name n hu ll
  name=$(basename "$d")
  [ -f "${d}README.md" ] || echo "  ${d} missing README.md"
  [ -f "${d}log.md" ] || echo "  ${d} missing log.md"
  grep -q "$name" 01_projects/PROJECTS.md || echo "  ${d} not on PROJECTS.md dashboard"
  if [ -f "${d}handoff.md" ]; then
    n=$(wc -l < "${d}handoff.md" | tr -d ' ')
    [ "$n" -gt "$HANDOFF_MAX" ] && echo "  ${d}handoff.md: $n lines (cap $HANDOFF_MAX: compress, push detail to log.md)"
    hu=$(grep -oE '^Updated [0-9]{4}-[0-9]{2}-[0-9]{2}' "${d}handoff.md" | head -1 | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}')
    [ -z "$hu" ] && echo "  ${d}handoff.md: missing 'Updated YYYY-MM-DD · by <client>' line 2"
    ll=$(grep -oE '\b20[0-9]{2}-[0-9]{2}-[0-9]{2}\b' "${d}log.md" 2>/dev/null | sort | tail -1)
    if [ -n "$hu" ] && [ -n "$ll" ] && [[ "$hu" < "$ll" ]]; then
      echo "  ${d}handoff.md Updated $hu older than newest log entry $ll: session ended without rewriting handoff"
    fi
    grep -q '^## Tried and failed' "${d}handoff.md" || echo "  ${d}handoff.md: no 'Tried and failed' section (template drift)"
  else
    echo "  ${d} missing handoff.md (scaffold from 03_resources/templates/project-handoff.md)"
  fi
}
for d in 01_projects/*/; do
  [ -d "$d" ] || continue
  if [ -f "${d}README.md" ] || [ -f "${d}log.md" ]; then
    check_project "$d"
  elif find "$d" -mindepth 1 -maxdepth 1 -type d | grep -q .; then
    # domain group (e.g. 01_projects/personal/): its children are the projects
    for c in "$d"*/; do check_project "$c"; done
  else
    echo "  ${d} has neither README/log nor project subfolders: file it or remove it"
  fi
done

echo
echo "--- dashboard (PROJECTS.md Active table generated from handoffs) ---"
[ -f 03_resources/scripts/projects-dashboard.sh ] && bash 03_resources/scripts/projects-dashboard.sh --check

echo
echo "--- wrap-up sweep candidates (project log newer than the Weekly tracker date in core.md; run project-wrapup.md at the weekly review) ---"
wk=$(grep -oE 'Weekly: [0-9]{4}-[0-9]{2}-[0-9]{2}' 90_memory/core.md | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}')
for l in 01_projects/*/log.md 01_projects/*/*/log.md; do
  [ -f "$l" ] || continue
  ll=$(grep -oE '\b20[0-9]{2}-[0-9]{2}-[0-9]{2}\b' "$l" | sort | tail -1)
  [ -n "$wk" ] && [ -n "$ll" ] && [[ "$ll" > "$wk" ]] && echo "  $(dirname "$l"): touched $ll"
done

echo
echo "--- 90_memory files not referenced in AGENTS.md (orphan memory never gets read) ---"
for f in 90_memory/*.md; do
  grep -q "$(basename "$f")" AGENTS.md || echo "  $f: add a routing row or merge it into a routed file"
done

echo
echo "--- git state (informational lines always print here) ---"
git_root=$(git rev-parse --show-toplevel 2>/dev/null || true)
if [ "$git_root" != "$WOS" ]; then
  echo "  no independent Git repository here; Git is optional"
else
  dirty=$(git status --short 2>/dev/null | wc -l | tr -d ' ')
  echo "  $dirty local uncommitted change(s); inspect before any authorized commit"
  git config --local user.email >/dev/null 2>&1 || echo "  repository-local Git identity is unset"
  if [ -z "$(git remote 2>/dev/null)" ]; then
    echo "  no remote configured; local files need an approved backup method"
  else
    echo "  remote configured; no network fetch was performed"
  fi
fi

if [ "${1:-}" = "--check-installed-skills" ] && [ -d 03_resources/skills-custom ]; then
  echo
  echo "--- optional installed-skill comparison (requested explicitly) ---"
  for m in 03_resources/skills-custom/*/; do
    [ -d "$m" ] || continue
    name=$(basename "$m")
    inst="$HOME/.claude/skills/$name"
    if [ ! -d "$inst" ]; then
      echo "  $name: no installed copy; the local method remains readable in this workspace"
    elif ! diff -rq "$m" "$inst" >/dev/null 2>&1; then
      echo "  $name: copies differ; inspect both before choosing which to update"
    fi
  done
fi

echo
echo "=== end (read findings; empty structural sections are not a complete content audit) ==="
