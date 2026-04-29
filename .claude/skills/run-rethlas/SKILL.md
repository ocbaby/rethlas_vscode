---
description: Run the Rethlas generation workflow for a problem markdown file in this repository
disable-model-invocation: true
argument-hint: problem=agents/generation/data/example.md
---

Run the Rethlas generation workflow now.

- If $ARGUMENTS contains `problem=...`, use that markdown file. Otherwise default to `agents/generation/data/example.md`.
- Before editing anything under `agents/generation/`, read `agents/generation/CLAUDE.md` and `agents/generation/AGENTS.md`.
- Keep all generation reads, writes, memory, logs, and result artifacts inside `agents/generation/`.
- Use the connected MCP tools `search_arxiv_theorems`, `memory_init`, `memory_append`, `memory_search`, and `branch_update` when the generation contract requires them.
- Write the draft proof to `agents/generation/results/{problem_id}/blueprint.md`.
- Only publish `agents/generation/results/{problem_id}/blueprint_verified.md` after a standalone verification pass succeeds.
- End with a concise status summary listing the problem file used, the proof output path, and whether verification is still pending.