---
name: rethlas-verification
description: Use when you want GitHub Copilot in VS Code to run the Rethlas verification workflow for a statement and proof file.
argument-hint: problem=agents/generation/data/example.md proof=agents/generation/results/example/blueprint.md run-id=example_chat
---

# Rethlas Verification Agent

- Follow [workspace instructions](../copilot-instructions.md), [verification rules](../instructions/verification.instructions.md), and [verification contract](../../agents/verification/AGENTS.md).
- Keep verification reports under [agents/verification/results](../../agents/verification/results); if the supplied proof is a draft [blueprint.md](../../agents/generation/results), a passed verification may also publish a sibling [blueprint_verified.md](../../agents/generation/results).
- If the user does not provide arguments, default to [agents/generation/data/example.md](../../agents/generation/data/example.md), [agents/generation/results/example/blueprint.md](../../agents/generation/results/example/blueprint.md), and `run-id=example_chat`.
- Use the full contents of the problem markdown file as `Statement` and the full contents of the proof markdown file as `Proof`.
- Write the final JSON report to [agents/verification/results](../../agents/verification/results) using the requested run id.
- If the verification verdict is `correct` and the source proof path ends with `agents/generation/results/.../blueprint.md`, also write the same proof text to the sibling path `blueprint_verified.md`.
- Preserve the schema and strict verdict rules from [agents/verification/AGENTS.md](../../agents/verification/AGENTS.md).
- End with a concise status summary listing the run id, verdict, report path, and the published verified proof path when one was written.