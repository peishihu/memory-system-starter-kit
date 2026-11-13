# Memory System Starter Kit

Keep project state, working preferences, and decisions in local Markdown files. A file-capable AI agent can read those records when you open the workspace and ask it to continue.

The kit supplies a method and blank templates. It does not provide automatic memory persistence, background execution, or access for every AI client. Records must be saved and loaded correctly.

## Quick start

Requirements: Python 3.9 or newer for setup and review helpers; Bash for health and dashboard scripts. Git is optional. Local checks were performed on macOS. Linux and Windows environments remain unverified.

1. Unzip the package.
2. Choose a new workspace directory. Do not reuse a populated directory for the first setup.
3. Run this command from the package directory. Replace the destination with your chosen path:

```sh
python3 scripts/setup_workspace.py --destination ~/Documents/my-ai-workspace
```

The command copies the blank `os/` template. It refuses an existing destination. It does not change global client settings, install software, initialize Git, or connect a remote.

4. Open the new workspace in a file-capable agent. Paste:

> Read AGENTS.md. This is a new workspace. Read the setup questions in 03_resources/skills-custom/workspace-os/references/bootstrap.md. Ask one question at a time. Save only my answers. Treat template placeholders as instructions, not facts. Create the project records I request. Run the available local checks. Report what was verified and what still needs setup.

If you prefer agent-assisted or manual setup, read [BOOTSTRAP.md](BOOTSTRAP.md). Read [GUIDE.md](GUIDE.md) for the method.

## Daily use

- Start: name the project and requested task. The agent reads the project handoff.
- Correct: state the correction. The agent records its date, evidence, and scope.
- End: ask the agent to save the current state. The next session reads that record.
- Review: ask for the weekly review. A session-start hook can remind Claude Code when review is overdue; it does not run a review in the background.

## What is included

`os/` contains the workspace rules, blank memory records, templates, local checks, and a workspace-os method skill. `scripts/` contains the safe copy helper. `global-pointers/` contains optional instruction examples; they are not needed for the default workspace-local setup.

## Privacy and limits

Do not put credentials in the workspace. Review actual content before any backup, sync, or sharing. An initially blank template does not make later project files safe to publish. Follow the policy for the device, organization, and AI tool you use.

A client must have file access and must load the workspace instructions. Check this explicitly. Platform memory, credentials, plugins, and machine settings are not transferred automatically. The correction scanner covers local Claude Code transcripts only and needs permission to read those records.

## Maintainer and license

Maintained by Pei Shi Hu. Released under the [MIT License](LICENSE). See [CHANGELOG.md](CHANGELOG.md) for changes. This package does not configure a public repository or upload user content.
