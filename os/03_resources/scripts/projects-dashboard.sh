#!/usr/bin/env bash
# projects-dashboard.sh: regenerate the Active table in 01_projects/PROJECTS.md from each project's handoff.md.
#   bash 03_resources/scripts/projects-dashboard.sh          # rewrite the table between the ACTIVE markers
#   bash 03_resources/scripts/projects-dashboard.sh --check  # print a line and exit 1 if the table is stale (used by os-health.sh)
set -uo pipefail
cd "$(dirname "$0")/../.."
DASH=01_projects/PROJECTS.md
gen() {
  echo "| Project | Status | Now | Next | Updated |"
  echo "|---|---|---|---|---|"
  for h in 01_projects/*/handoff.md 01_projects/*/*/handoff.md; do
    [ -f "$h" ] || continue
    local d name hdr upd st now nxt
    d=$(dirname "$h"); name=${d#01_projects/}
    hdr=$(sed -n '2p' "$h")
    upd=$(echo "$hdr" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' | head -1)
    st=$(echo "$hdr" | grep -oE 'Status [A-Za-z ]+' | sed 's/Status //; s/ *$//')
    now=$(awk '/^## Now/{f=1;next} /^## /{f=0} f&&NF{print;exit}' "$h" | cut -c1-110 | sed 's/|/\//g')
    nxt=$(awk '/^## Next/{f=1;next} /^## /{f=0} f&&/^1\./{sub(/^1\. */,"");print;exit}' "$h" | cut -c1-90 | sed 's/|/\//g')
    echo "| $name | ${st:-?} | $now | $nxt | ${upd:-?} |"
  done
}
new=$(gen)
cur=$(sed -n '/<!-- BEGIN ACTIVE -->/,/<!-- END ACTIVE -->/p' "$DASH" | sed '1d;$d')
if [ "${1:-}" = "--check" ]; then
  [ "$new" = "$cur" ] && exit 0
  echo "  PROJECTS.md Active table stale: bash 03_resources/scripts/projects-dashboard.sh"; exit 1
fi
{ sed -n '1,/<!-- BEGIN ACTIVE -->/p' "$DASH"; echo "$new"; sed -n '/<!-- END ACTIVE -->/,$p' "$DASH"; } > "$DASH.tmp" && mv "$DASH.tmp" "$DASH"
echo "PROJECTS.md Active table regenerated"
