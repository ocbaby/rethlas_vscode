---
name: run-rethlas
description: Use when you want a one-click GitHub Copilot launcher for the Rethlas generation workflow in VS Code.
agent: rethlas-generation
argument-hint: problem=agents/generation/data/example.md
---

# Run Rethlas

Launch the Rethlas generation workflow now.

- If the user provided a `problem=` argument, use that markdown file.
- Otherwise default to [agents/generation/data/example.md](../../agents/generation/data/example.md).
- Run the workflow through the referenced custom agent [rethlas-generation](../agents/rethlas-generation.agent.md).
- If generation reaches a full draft blueprint, mention that the normal next step is the `Verify Generated Blueprint` handoff to [rethlas-verification](../agents/rethlas-verification.agent.md).
- Return the final proof path and whether the result is verified.