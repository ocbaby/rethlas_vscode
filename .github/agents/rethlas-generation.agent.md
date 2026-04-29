---
name: rethlas-generation
description: Use when you want GitHub Copilot in VS Code to run the Rethlas generation workflow for a problem markdown file.
argument-hint: problem=agents/generation/data/example.md
handoffs:
  - label: Verify Generated Blueprint
    agent: rethlas-verification
    prompt: Verify the generated blueprint using the matching problem statement and write the verification report into agents/verification/results.
    send: false
---

# Rethlas Generation Agent

- Follow [workspace instructions](../copilot-instructions.md), [generation rules](../instructions/generation.instructions.md), and [generation contract](../../agents/generation/AGENTS.md).
- Keep all reads and writes inside [agents/generation](../../agents/generation).
- If the user does not provide a `problem=` argument, default to [agents/generation/data/example.md](../../agents/generation/data/example.md).
- Resolve the problem markdown file, derive `problem_id` from its filename stem, and generate the proof artifacts under [agents/generation/results](../../agents/generation/results).
- Write [blueprint.md](../../agents/generation/results) first and only publish [blueprint_verified.md](../../agents/generation/results) after a standalone verification pass succeeds.
- When useful, persist supporting artifacts under [agents/generation/memory](../../agents/generation/memory) and [agents/generation/logs](../../agents/generation/logs).
- After writing a full draft proof, prefer the `Verify Generated Blueprint` handoff for the standalone verification pass.
- If a verification pass is unavailable in the current environment, stop after writing the draft blueprint and say verification is still pending.
- End with a concise status summary listing the problem file used, the proof output path, and the verification status.