#!/usr/bin/env python3
"""Read-only. Lists likely corrections from the user in local Claude Code transcripts.

Usage: os-corrections-scan.py [YYYY-MM-DD]   (default: Weekly date in 90_memory/core.md)

Prints candidates to stdout and writes nothing. The review decides which are real
corrections; a match is only a candidate. Claude Code transcripts only: Codex and
other clients keep their own history and are not covered.
"""
import json, re, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
TRANSCRIPTS = Path.home() / ".claude/projects" / re.sub(r"[^A-Za-z0-9]", "-", str(ROOT))
SIGNALS = re.compile(
    r"不要|不用|别再|不是|太丑|太多|太浅|不对|错了|应该|其实|乱|生硬|我喜欢|我不喜欢|下次|以后|每次|记住"
    r"|\bdon'?t\b|\bnever\b|\balways\b|\bstop\b|\bwrong\b|\binstead\b|\bshould\b|\bnot what\b|\bremember\b",
    re.I)
SKIP = ("This session is being continued", "Background (from the session", "Prompt:", "<system-reminder", "<command-", "<local-command", "<task-notification", "<side-sessions-event", "<ci-monitor-event")
MAX_PER_SESSION, MAX_LEN = 12, 260


def since_date():
    if len(sys.argv) > 1:
        return sys.argv[1]
    m = re.search(r"^Weekly: (\d{4}-\d{2}-\d{2})", (ROOT / "90_memory/core.md").read_text(), re.M)
    return m.group(1) if m else "2000-01-01"


def texts(message):
    content = message.get("content")
    if isinstance(content, str):
        return [content]
    if isinstance(content, list):
        return [c.get("text", "") for c in content if isinstance(c, dict) and c.get("type") == "text"]
    return []


def main():
    since, found = since_date(), 0
    print(f"Candidate corrections since {since}. Unverified: read each one before saving it.")
    if not TRANSCRIPTS.is_dir():
        print(f"No transcripts at {TRANSCRIPTS}")
        return
    for path in sorted(TRANSCRIPTS.glob("*.jsonl")):
        hits, seen = [], set()
        for line in path.open(errors="ignore"):
            try:
                rec = json.loads(line)
            except ValueError:
                continue
            if rec.get("type") != "user" or rec.get("isSidechain") or rec.get("isMeta"):
                continue
            stamp = (rec.get("timestamp") or "")[:10]
            if not stamp or stamp < since:
                continue
            for text in texts(rec.get("message") or {}):
                text = re.sub(r"</?pasted_content[^>]*>", "", text).strip()
                if not text or text.startswith(SKIP) or text in seen or not SIGNALS.search(text):
                    continue
                seen.add(text)
                hits.append(f"- {stamp} [{path.stem[:8]}] {' '.join(text.split())[:MAX_LEN]}")
        for hit in hits[:MAX_PER_SESSION]:
            print(hit)
        if len(hits) > MAX_PER_SESSION:
            print(f"  ... {len(hits) - MAX_PER_SESSION} more in session {path.stem[:8]}")
        found += len(hits)
    print(f"Total candidates: {found}")


if __name__ == "__main__":
    main()
