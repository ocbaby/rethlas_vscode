# Rethlas Workspace

- This repository contains two agent workspaces: `agents/generation` and `agents/verification`.
- In Claude Code, the project-scoped MCP servers live in `.mcp.json`; approve and inspect them from `/mcp` when prompted.
- `.mcp.json` starts `rethlasGenerationMcp` and `rethlasVerificationMcp` through `.vscode/mcp/start-python-mcp.sh`, reusing `.vscode/.mcp-generation-venv` and `.vscode/.mcp-verification-venv`.
- Preferred Claude Code entrypoints are `/run-rethlas` and `/verify-rethlas` from `.claude/skills/`.
- `.claude/settings.json` sets `MCP_TIMEOUT=60000` so first-run dependency bootstrap has enough time to complete.
- Before editing files in either subtree, read the matching local `CLAUDE.md` or `AGENTS.md` in that folder.
- Keep generated artifacts inside the owning agent directory; do not mix generation and verification outputs.
- Typical outputs are `agents/generation/results/{problem_id}/blueprint.md`, `agents/verification/results/{run_id}/verification.json`, and `agents/generation/results/{problem_id}/blueprint_verified.md` after a passed standalone verification run.
- This release bundle already ships one ready-to-use sample at `agents/generation/results/example/` and `agents/verification/results/example_chat/` so the default example verification path exists immediately after clone.
- For VS Code workflows, the source of truth is `CLAUDE.md`, `.github/copilot-instructions.md`, `.github/instructions/`, and each folder's `AGENTS.md`.
- For a human-oriented setup, first-use, `/mcp` check, slash-command, and troubleshooting guide, see `.github/SETUP_CLAUDE_CODE.md`.
- Preserve existing file and API contracts unless the task explicitly changes them.
