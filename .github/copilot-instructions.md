# Rethlas Workspace

- This repository has two agent workspaces: `agents/generation` and `agents/verification`.
- Use the path-specific instructions in `.github/instructions/` when working in either subtree.
- Prefer the Copilot-native launchers in `.github/prompts/` and `.github/agents/` for routine generation and verification workflows in VS Code.
- Keep generated artifacts inside the owning agent directory and preserve existing output locations.
- For VS Code workflows, prefer the instruction files in this repository over any legacy local automation config.
- Preserve existing file and API contracts unless the task explicitly changes them.
