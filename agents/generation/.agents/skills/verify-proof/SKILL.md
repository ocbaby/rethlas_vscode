---
name: verify-proof
description: Verify candidate proofs with the repository's standalone verification workflow. Use only when a full candidate proof of the entire problem has been assembled in markdown, and before publishing the final verified blueprint.
---

# Verify Proof

Use the repository's standalone verification workflow as the canonical verifier before accepting a solution.
Do not use this skill for partial proofs, isolated subgoals, or branches that have not yet produced a full proof draft of the whole problem.

## Input Contract

Read:

- target theorem statement
- assembled proof blueprint candidate from `results/{problem_id}/blueprint.md` as pure markdown text
- relevant prior failure reports and branch context

## Procedure

1. Read the current `results/{problem_id}/blueprint.md` draft as pure text.
2. First check that `blueprint.md` contains a full proof draft of the entire target theorem rather than a partial proof, fragment, or exploratory notes. If it does not, do not call the verifier yet.
3. Run the repository's standalone verification workflow against the same statement and the raw markdown text from `blueprint.md`.
4. In GitHub Copilot, prefer the `Verify Generated Blueprint` handoff or `/verify-rethlas`.
5. In Claude Code, switch to `agents/verification` and follow `agents/verification/AGENTS.md` on the same statement and proof.
6. Read `verification_report.summary`, `critical_errors`, `gaps`, `verdict`, and `repair_hints` from that verification pass.
7. Return and persist exactly what the standalone verification workflow returns. Do not rename keys, add keys, or change the JSON structure.
8. Treat the proof as failed if any of the following hold:
   - `verdict` is `"wrong"`
   - `verification_report.critical_errors` is non-empty
   - `verification_report.gaps` is non-empty
9. Only treat the proof as passed when none of the failure conditions above hold.
10. If the proof passes, rename `results/{problem_id}/blueprint.md` to `results/{problem_id}/blueprint_verified.md`.

## Output Contract

Append to `verification_reports`:

```json
{
  "verification_report": {
    "summary": "string",
    "critical_errors": [
      {"location": "", "issue": "detailed description of the issue"}
    ],
    "gaps": [
      {"location": "", "issue": "detailed description of the gap"}
    ]
  },
  "verdict": "string",
  "repair_hints": "string"
}
```

Persist the standalone verification response exactly as returned.

If verification fails, revise `blueprint.md` directly and append to `failed_paths` when a branch is invalidated.

## Supporting Tools

- `memory_append`
- `memory_search`
- `branch_update`
- the agent's built-in web search and `search_arxiv_theorems` when the verifier identifies a missing lemma or gap
- GitHub Copilot handoffs or the standalone verification workflow described above

## Failure Logging

Always persist verification output, including successful checks.
