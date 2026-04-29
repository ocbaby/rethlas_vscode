---
name: Verification Agent
description: Rules for files under agents/verification.
applyTo: "agents/verification/**"
---

# Verification Agent

- Read `agents/verification/AGENTS.md` before changing files in this subtree.
- Keep primary verification reads and artifacts inside `agents/verification/`.
- Preserve the `results/{run_id}/verification.json` output schema.
- When a passed draft proof from `agents/generation/results/**/blueprint.md` is being published, a sibling `blueprint_verified.md` may also be written there.
- Preserve the strict verdict rule: any critical error or gap means `"wrong"`.
- Prefer neutral wording such as "built-in web search" unless a file is explicitly documenting the legacy runner automation path.
