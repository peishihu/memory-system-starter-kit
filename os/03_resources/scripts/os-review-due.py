#!/usr/bin/env python3
"""Read-only. Prints one line when the weekly review is overdue, otherwise nothing.
Used by the session-start hook in .claude/settings.json. Any client can run it."""
import datetime as dt, re
from pathlib import Path

try:
    text = (Path(__file__).resolve().parents[2] / "90_memory/core.md").read_text()
    weekly = re.search(r"Weekly: (\d{4}-\d{2}-\d{2})", text)
    init = re.search(r"Init: (\d{4}-\d{2}-\d{2})", text)
    found = weekly or init
    if found:
        days = (dt.date.today() - dt.date.fromisoformat(found.group(1))).days
        if days > 7:
            print(f"The weekly review is overdue ({days} days). Say so in one line and run 03_resources/templates/os-reviews.md after the requested work.")
except Exception:
    pass
