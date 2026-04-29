---
description: Run the Rethlas verification workflow for a statement and proof file in this repository
disable-model-invocation: true
argument-hint: problem=agents/generation/data/example.md proof=agents/generation/results/example/blueprint.md run-id=example_chat
---

Run the Rethlas verification workflow now.

- If $ARGUMENTS contains `problem=...`, `proof=...`, or `run-id=...`, use those values. Otherwise default to `agents/generation/data/example.md`, `agents/generation/results/example/blueprint.md`, and `run-id=example_chat`.
- Before editing anything under `agents/verification/`, read `agents/verification/CLAUDE.md` and `agents/verification/AGENTS.md`.
- Use the full contents of the problem markdown file as `Statement` and the full contents of the proof markdown file as `Proof`.
- Use the connected MCP tools `verification_search_arxiv_theorems`, `verification_memory_init`, `verification_memory_append`, `verification_memory_query`, `verification_validate_output`, and `verification_write_output` when the verification contract requires them.
- Write the final JSON report to `agents/verification/results/{run_id}/verification.json`.
- If the verdict is `correct` and the source proof path is `agents/generation/results/.../blueprint.md`, also write the sibling verified proof to `agents/generation/results/.../blueprint_verified.md`.
- End with a concise status summary listing the run id, verdict, report path, and the published verified proof path when one was written.