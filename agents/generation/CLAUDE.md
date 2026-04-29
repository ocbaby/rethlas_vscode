@AGENTS.md

## Claude Code

- Keep all reads and writes inside `agents/generation/`.
- Preserve the `problem_id`-based layout under `results/`, `memory/`, and `logs/`.
- Preserve MCP tool names and the verification repair loop unless the task explicitly changes that contract.
- Prefer neutral wording such as "built-in web search" or "sub-agent support" unless a file is explicitly documenting a legacy noninteractive CLI path.
