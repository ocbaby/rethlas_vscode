---
name: Generation Agent
description: Rules for files under agents/generation.
applyTo: "agents/generation/**"
---

# Generation Agent

- Read `agents/generation/AGENTS.md` before changing files in this subtree.
- Keep all reads and writes inside `agents/generation/`.
- Preserve the `problem_id`-based artifact layout under `results/`, `memory/`, and `logs/`.
- Preserve the MCP tool contract and the verification repair loop unless the task explicitly changes them.
- Prefer neutral wording such as "built-in web search" or "sub-agent support" unless a file is explicitly documenting the legacy runner automation path.
