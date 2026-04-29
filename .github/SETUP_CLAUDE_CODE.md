# Rethlas Setup Guide for VS Code and Claude Code

This document is the operator-facing setup and troubleshooting reference for the repository's native VS Code and Claude Code workflows.

## What config is actually used

### VS Code + GitHub Copilot

- MCP server registration lives in `.vscode/mcp.json`
- Copilot launchers live in `.github/prompts/run-rethlas.prompt.md`, `.github/prompts/verify-rethlas.prompt.md`, `.github/agents/rethlas-generation.agent.md`, and `.github/agents/rethlas-verification.agent.md`

### Claude Code

- Project-scoped MCP server registration lives in `.mcp.json`
- Claude timeout configuration lives in `.claude/settings.json`
- Claude slash-command entrypoints live in `.claude/skills/run-rethlas/SKILL.md` and `.claude/skills/verify-rethlas/SKILL.md`

### Shared bootstrap behavior

- Both VS Code and Claude Code start the same local servers: `rethlasGenerationMcp` and `rethlasVerificationMcp`
- Both use `.vscode/mcp/start-python-mcp.sh`
- The bootstrap script prepares `.vscode/.mcp-generation-venv` and `.vscode/.mcp-verification-venv`
- Claude Code extends first-run startup time by setting `MCP_TIMEOUT=60000` in `.claude/settings.json`

## First-time setup

### VS Code + GitHub Copilot

1. Open the repository root in VS Code.
2. Accept the workspace MCP trust or start prompt.
3. Run `MCP: List Servers`.
4. Confirm both `rethlasGenerationMcp` and `rethlasVerificationMcp` show up as connected.
5. If you want a tool-level check, open Copilot Chat and inspect `Configure Tools`.

### Claude Code

1. Open Claude Code at the repository root.
2. Run `/mcp`.
3. Approve the servers declared in `.mcp.json`.
4. Confirm `rethlasGenerationMcp` and `rethlasVerificationMcp` both appear as connected.
5. If first launch is slow, let it finish; the bootstrap path installs the requirements from `agents/generation/mcp/requirements.txt` and `agents/verification/mcp/requirements.txt`.

## Running the workflows

The slash-command syntax is intentionally aligned between VS Code and Claude Code.

This release bundle already ships one verified sample proof bundle for the default example path:

- `agents/generation/data/example.md`
- `agents/generation/results/example/blueprint.md`
- `agents/generation/results/example/blueprint_verified.md`
- `agents/verification/results/example_chat/verification.json`

That means the default `/verify-rethlas` path is immediately usable after clone, even before you run a fresh generation pass yourself.

### Generation

```text
/run-rethlas problem=agents/generation/data/example.md
```

Behavior aligned with the checked-in launchers:

- If `problem=` is omitted, the default problem is `agents/generation/data/example.md`
- The generation workflow writes `agents/generation/results/{problem_id}/blueprint.md`
- A later standalone verification pass may publish `agents/generation/results/{problem_id}/blueprint_verified.md`

### Verification

```text
/verify-rethlas problem=agents/generation/data/example.md proof=agents/generation/results/example/blueprint.md run-id=example_chat
```

Behavior aligned with the checked-in launchers:

- If arguments are omitted, the defaults are `problem=agents/generation/data/example.md`, `proof=agents/generation/results/example/blueprint.md`, and `run-id=example_chat`
- The verification workflow writes `agents/verification/results/{run_id}/verification.json`
- If the verdict is `correct` and the proof path is `agents/generation/results/.../blueprint.md`, the same proof is also published to `blueprint_verified.md`
- Re-running the default example verification will overwrite `agents/verification/results/example_chat/verification.json`

### VS Code-only convenience path

In VS Code, you can also open `.github/prompts/run-rethlas.prompt.md` or `.github/prompts/verify-rethlas.prompt.md` and run them directly. After generation, the preferred next step is the `Verify Generated Blueprint` handoff from the generation agent to the verification agent.

## Expected result locations

### Generation outputs

- `agents/generation/results/{problem_id}/blueprint.md`
- `agents/generation/results/{problem_id}/blueprint_verified.md` after a successful standalone verification run
- `agents/generation/memory/{problem_id}/`
- `agents/generation/logs/{problem_id}/`

Shipped sample in this release:

- `agents/generation/results/example/blueprint.md`
- `agents/generation/results/example/blueprint_verified.md`

### Verification outputs

- `agents/verification/results/{run_id}/verification.json`

Shipped sample in this release:

- `agents/verification/results/example_chat/verification.json`

## MCP health checks

### Server names you should expect

- `rethlasGenerationMcp`
- `rethlasVerificationMcp`

### Tool families you should expect

- Generation: `search_arxiv_theorems`, `memory_init`, `memory_append`, `memory_search`, `branch_update`
- Verification: `verification_search_arxiv_theorems`, `verification_memory_init`, `verification_memory_append`, `verification_memory_query`, `verification_validate_output`, `verification_write_output`

If the server names appear but the tool families do not, the MCP bootstrap completed only partially and should be retried.

## Common troubleshooting

### `/mcp` or `MCP: List Servers` does not show the Rethlas servers

- Make sure you opened the repository root, not `agents/generation` or `agents/verification` directly
- Re-run the trust or approval flow so the checked-in MCP config is allowed to start

### First run takes too long or times out

- Claude Code should inherit `MCP_TIMEOUT=60000` from `.claude/settings.json`
- The first bootstrap creates local Python environments and installs dependencies, so retry once before assuming the setup is broken

### Claude Code does not offer `/run-rethlas` or `/verify-rethlas`

- Make sure `.claude/skills/run-rethlas/SKILL.md` and `.claude/skills/verify-rethlas/SKILL.md` still exist
- Re-open Claude Code at the repository root so it reloads the project skills

### VS Code can see the prompt files but generation or verification tools are missing

- Check `.vscode/mcp.json` and confirm both server entries still point at `.vscode/mcp/start-python-mcp.sh`
- Re-run `MCP: List Servers` and re-open Chat so Copilot refreshes the connected tools

### `blueprint_verified.md` was not published

- This only happens when the verification verdict is `correct`
- The proof input must be a draft path under `agents/generation/results/.../blueprint.md`

### Looking for a standalone local `/verify` service

- The recommended workflow does not use a separate local `/verify` HTTP service
- Use `/verify-rethlas` or the VS Code `Verify Generated Blueprint` handoff instead

## Optional legacy path

If you intentionally want an old noninteractive automation path, treat it as a manual, unsupported workflow: prepare your own compatible runner and Python environment instead of relying on the native VS Code or Claude Code entrypoints described above.