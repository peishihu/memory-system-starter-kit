# Set up a memory workspace

Use a new destination for the blank template. Do not overwrite an existing workspace or global client instruction file.

## New workspace

1. Open the unpacked kit directory.
2. Choose a destination that does not exist.
3. Run the setup command in README.md with the selected destination.
4. Open that workspace in a file-capable agent.
5. Use the first-session prompt in README.md.
6. Check that the client read AGENTS.md and can identify the selected project from its handoff.

Paths can contain spaces. Quote such paths in shell commands. The helper copies the template and preserves script modes. It refuses an existing or symlinked destination.

## Agent-assisted setup

Give the agent the kit location and a new destination. Ask it to run the helper or copy `os/` without replacing any existing content. Ask it to keep guides outside the operational workspace.

The interview must collect answers before replacing placeholders. Do not infer personal facts from the example wording. If a check cannot run, record that limitation instead of claiming a completed setup.

## Existing workspace

Do not run a fresh installation over it. Inspect its rules, source pointers, and current project records. Compare required methods with the kit. Propose only the missing changes. Preserve existing decisions and conflicting evidence.

For legacy files, create a local triage note. Propose destinations before moving an unclear or large collection. Keep a move record. Do not delete an old directory simply because it appears empty.

## Client instructions

The default setup uses workspace-local AGENTS.md. Claude Code also has a local CLAUDE.md pointer. Other clients may need a supported instruction entry point or an explicit request to read AGENTS.md.

Global pointers are optional. Before any global change, inspect the existing file and obtain permission for the specific change. Merge a new pointer into existing instructions. Do not use a copy command that replaces the file. The examples in `global-pointers/` contain path placeholders; replace them only with the selected workspace path.

The method skill remains in `03_resources/skills-custom/workspace-os/`. An agent can read it there. Installing a client-level copy is optional. Preserve installed customizations and document its source if you choose that step.

## Local verification

From the new workspace, run:

```sh
bash 03_resources/scripts/projects-dashboard.sh
bash 03_resources/scripts/os-health.sh
python3 03_resources/scripts/os-review-due.py
```

Read all reported findings. The health script is report-only; exit 0 alone does not mean every section is clean. The reminder does not run a review.

Run the correction scanner only with permission to read the current user's local Claude Code transcripts. It prints candidate corrections for human or agent review. It does not discover every preference or cover every client.

## Optional version control

Git is optional. If the owner requests it, initialize a repository inside this workspace. Set the chosen identity locally before committing. Inspect the selected files before staging them. Do not initialize a remote or push without scoped permission. A private backup destination also requires review of actual content.
