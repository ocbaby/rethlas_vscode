@AGENTS.md

## Claude Code

- Keep primary verification reads and writes inside `agents/verification/`.
- Preserve the `results/{run_id}/verification.json` schema and strict verdict rule.
- Keep primary verification artifacts under `agents/verification/`; when a passed draft proof from `agents/generation/results/**/blueprint.md` is being published, a sibling `blueprint_verified.md` may also be written there.
- Preserve the strict verdict rule: any critical error or gap means `"wrong"`.
- Prefer neutral wording such as "built-in web search" unless a file is explicitly documenting a legacy noninteractive CLI path.
