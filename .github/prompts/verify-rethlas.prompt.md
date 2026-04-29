---
name: verify-rethlas
description: Use when you want a one-click GitHub Copilot launcher for the standalone Rethlas verification workflow in VS Code.
agent: rethlas-verification
argument-hint: problem=agents/generation/data/example.md proof=agents/generation/results/example/blueprint.md run-id=example_chat
---

# Verify Rethlas Proof

Launch the Rethlas verification workflow now.

- If the user provided `problem=`, `proof=`, or `run-id=`, use those values.
- Otherwise default to [agents/generation/data/example.md](../../agents/generation/data/example.md), [agents/generation/results/example/blueprint.md](../../agents/generation/results/example/blueprint.md), and `run-id=example_chat`.
- Run the workflow through the referenced custom agent [rethlas-verification](../agents/rethlas-verification.agent.md).
- Return the verdict, verification report path, and the published verified proof path when the proof passes.