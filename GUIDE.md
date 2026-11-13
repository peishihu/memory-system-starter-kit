# How the memory workspace works

The workspace contains saved records. An agent uses those records when it has permission to read them. Saved files support continuity; they do not guarantee that every client loads the right context.

## Core method

1. Keep workspace rules in AGENTS.md. Use a short client entry file when required.
2. Keep current project state in handoff.md. Keep stable context in README.md. Append history to log.md.
3. Route memory by task. Load core.md first and other records only when relevant.
4. Give each type of content one authoritative home. Use pointers instead of hand-maintained copies.
5. Check structure with scripts and review meaning with an agent or person.
6. Keep credentials outside the workspace. Review other private content before any external transfer.

## Directory roles

| Directory | Content |
|---|---|
| 00_inbox | New material and unresolved filing decisions |
| 01_projects | Work with a defined outcome; one project record per outcome |
| 02_areas | Ongoing responsibilities and standards |
| 03_resources | Reusable templates, scripts, references, and method skills |
| 90_memory | Saved preferences, corrections, and durable decisions |
| 99_archive | Preserved inactive material; do not edit it as current work |

The six starting categories are a template convention. Add other structure only when it serves actual content. For a new subfolder, three related files is a useful starting threshold, not a universal requirement.

## Session continuity

Read the handoff before editing a project. State its goal, current position, and next action briefly. Claim project ownership when the project uses ownership fields. Preserve unrelated uncommitted work.

At session end, rewrite the handoff with current state and append a dated log entry. Keep the handoff at 60 lines or fewer. Preserve failed attempts and untested conditions. Release ownership when work stops.

A new session should resume from the handoff and its linked files without the original chat. Test that behavior with a small project before using the kit for important work.

## Learning and review

Record direct corrections promptly. Include date, source, and scope. Keep a new hypothesis separate from a verified preference. Do not turn a single project choice into a global rule.

Weekly review checks active projects, inbox, routing, and saved corrections. Monthly review consolidates duplicate or stale records. The scripts report structural findings. They do not prove that saved facts are true or complete.

## Adaptation and migration

Read the workspace-os references for setup, extension, maintenance, and migration. Keep one source for each rule. Update its pointers, templates, and applicable check in the same change.

Before moving a workspace, inventory external dependencies and write restore steps. Do not move credentials with the files. Test instruction loading, project resume, and checks at the destination before retiring the earlier environment.

Keep work and personal content separate when policy requires it. A shared method does not authorize sharing records across those boundaries.
