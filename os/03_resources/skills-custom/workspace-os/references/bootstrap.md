# First setup and interview

Use this guide after copying the blank workspace. Do not change global client settings by default.

## Day-one questions

Ask one at a time. Skip a question already answered in the request.

1. What role and explanation depth should the agent use?
2. Which language, response format, and creative tone do you prefer?
3. Which local actions are allowed, and which actions require approval?
4. Which clients will use this workspace, and can each read and write files?
5. Which active projects need saved state? Ask for the goal and next action for each.
6. Which working conventions should this workspace follow?
7. Where do credentials and machine-local settings live? Ask for names or locations, never values.

## Save the answers

Update core.md with confirmed answers only. Replace all answered placeholders. Keep unknown fields marked for confirmation. Set Init to the current date.

For each selected project, create README.md, handoff.md, and log.md from the templates. Use real answers for goal and next action. Keep owner none until a session claims the project.

Run the dashboard and health scripts if available. Inspect reported findings. Record unsupported commands as limitations. Do not read real client transcripts during setup without permission.

Start a separate session or independent reader with only AGENTS.md and the saved records. Confirm it can identify the selected project, goal, current state, and next action. A successful script check alone does not verify client instruction loading.

## Optional setup

If the owner requests Git, initialize it in this workspace and set repository-local identity before committing. Do not configure a remote automatically. Installing a client-level skill or global pointer is separate from workspace-local setup and must preserve existing configuration.

For an existing workspace, compare and merge missing methods. Do not copy a blank core.md over saved memory. If confidentiality requires a separate workspace, create an independent one and transfer only approved method files.
