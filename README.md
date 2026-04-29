# Rethlas

Rethlas 的日常推荐用法是直接在 VS Code 中配合 GitHub Copilot 或 Claude Code 运行生成与验证流程。正常使用不需要手工启动本地 HTTP 服务，也不需要预先创建 `.venv`。

这个发布包已经随附一组可直接使用的最小样例：`agents/generation/data/example.md`、`agents/generation/results/example/blueprint.md`、`agents/generation/results/example/blueprint_verified.md` 和 `agents/verification/results/example_chat/verification.json`。因此，默认的 `/verify-rethlas` 路径在首次 clone 后就已经可用。

仓库同时提供了两套项目级 MCP 配置：

- VS Code + GitHub Copilot 使用 `.vscode/mcp.json`
- Claude Code 使用仓库根目录 `.mcp.json`

两边都会启动同一组本地 MCP server：`rethlasGenerationMcp` 和 `rethlasVerificationMcp`。两者都通过 `.vscode/mcp/start-python-mcp.sh` 启动，并在 `.vscode/.mcp-generation-venv` 与 `.vscode/.mcp-verification-venv` 下复用本地环境。对 Claude Code 而言，`.claude/settings.json` 还把 `MCP_TIMEOUT` 设为 `60000`，用来覆盖首次安装依赖时较慢的启动过程。

更完整的配置与排障说明见 `.github/SETUP_CLAUDE_CODE.md`。

## 工作流概览

1. 选择题目文件，例如 `agents/generation/data/example.md`。
2. 运行 `/run-rethlas` 生成草稿 proof。
3. 运行 `/verify-rethlas` 验证草稿 proof。
4. 如果验证 verdict 为 `correct`，查看发布后的 `blueprint_verified.md`。

如果你只是想快速确认整个发布包是否工作正常，可以直接使用随包的 `example` 样例跑一遍默认流程。

## VS Code + GitHub Copilot

### 首次使用

1. 在 VS Code 中打开仓库根目录。
2. 接受 workspace MCP server 的 trust 或 start 提示。
3. 运行 `MCP: List Servers`，确认 `rethlasGenerationMcp` 和 `rethlasVerificationMcp` 都已连接。
4. 如需进一步确认工具可用，可在 Chat 的 `Configure Tools` 中查看 generation 与 verification 工具列表。

### 常用入口

直接在 Chat 中运行：

```text
/run-rethlas problem=agents/generation/data/example.md
```

```text
/verify-rethlas problem=agents/generation/data/example.md proof=agents/generation/results/example/blueprint.md run-id=example_chat
```

也可以打开以下 prompt 文件后直接运行：

- `.github/prompts/run-rethlas.prompt.md`
- `.github/prompts/verify-rethlas.prompt.md`

生成完成后，推荐直接使用 generation agent 提供的 `Verify Generated Blueprint` handoff 进入独立验证流程。

### MCP 检查点

如果你想确认 MCP 工具是否真正挂上，VS Code 侧应能看到：

- generation server 提供 `search_arxiv_theorems`、`memory_init`、`memory_append`、`memory_search`、`branch_update`
- verification server 提供 `verification_search_arxiv_theorems`、`verification_memory_init`、`verification_memory_append`、`verification_memory_query`、`verification_validate_output`、`verification_write_output`

## Claude Code

### 首次使用

1. 在仓库根目录打开 Claude Code。
2. 运行 `/mcp`。
3. 接受 `.mcp.json` 中两个项目级 MCP server 的授权或启动提示。
4. 确认 `/mcp` 中显示 `rethlasGenerationMcp` 和 `rethlasVerificationMcp` 均已连接。

第一次启动较慢是正常现象，因为 Claude Code 会通过 `.vscode/mcp/start-python-mcp.sh` 准备本地环境，并安装 `agents/generation/mcp/requirements.txt` 与 `agents/verification/mcp/requirements.txt`。

### 常用入口

Claude Code 从 `.claude/skills/` 读取两个技能入口，命令如下：

```text
/run-rethlas problem=agents/generation/data/example.md
```

```text
/verify-rethlas problem=agents/generation/data/example.md proof=agents/generation/results/example/blueprint.md run-id=example_chat
```

如果你省略参数，`/run-rethlas` 默认使用 `agents/generation/data/example.md`；`/verify-rethlas` 默认使用 `agents/generation/data/example.md`、`agents/generation/results/example/blueprint.md` 和 `run-id=example_chat`。

这个发布包已经预置了上述默认 proof 路径，因此 `/verify-rethlas` 可以直接运行；如果你重新执行它，`agents/verification/results/example_chat/verification.json` 会被新的验证结果覆盖。

## 结果路径

生成阶段的主要输出：

- `agents/generation/results/{problem_id}/blueprint.md`
- `agents/generation/memory/{problem_id}/`
- `agents/generation/logs/{problem_id}/`

验证阶段的主要输出：

- `agents/verification/results/{run_id}/verification.json`

当且仅当验证 verdict 为 `correct`，且输入 proof 路径是 `agents/generation/results/.../blueprint.md` 时，还会发布：

- `agents/generation/results/{problem_id}/blueprint_verified.md`

当前发布包已随附的样例结果路径是：

- `agents/generation/results/example/blueprint.md`
- `agents/generation/results/example/blueprint_verified.md`
- `agents/verification/results/example_chat/verification.json`

## 常见排障

- 看不到 MCP server：确认你打开的是仓库根目录，而不是 `agents/generation` 或 `agents/verification` 子目录。
- Claude Code 首次启动超时：先确认 `.claude/settings.json` 仍然保留 `MCP_TIMEOUT=60000`，然后重试一次；第一次依赖安装通常最慢。
- VS Code 里 MCP 没自动拉起：运行 `MCP: List Servers` 重新检查 server 状态，并重新接受 workspace trust。
- Claude Code 里没有 `/run-rethlas` 或 `/verify-rethlas`：确认 `.claude/skills/run-rethlas/SKILL.md` 与 `.claude/skills/verify-rethlas/SKILL.md` 仍存在，并且 Claude Code 打开的是仓库根目录。
- 已生成验证报告但没有 `blueprint_verified.md`：只有当 verdict 为 `correct`，且验证的 proof 输入路径是 `agents/generation/results/{problem_id}/blueprint.md` 时，才会发布同级 `blueprint_verified.md`。
- 想找旧的本地 `/verify` 服务：当前推荐流程没有单独的本地 `/verify` HTTP 服务，也没有单独的 VS Code launch config；请直接使用 `/verify-rethlas` 或 VS Code 的验证 handoff。

## 可选：旧的非交互路径

当前仓库的推荐入口是 VS Code 与 Claude Code 的原生 MCP / slash-command 工作流。如果你刻意要走旧的非交互自动化路径，请自行准备兼容的 runner 与 Python 环境；这不是当前文档的主路径。

