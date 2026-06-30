# Codex CLI 装配方案

Codex **没有 Claude 的 plugin 概念**,但 ECC 为 Codex 提供 **first-class 原生安装器**(非插件):一条 sync 脚本把 ECC 的工程纪律、技能、MCP 推进 `~/.codex`。**本仓已选择 codex 采用 ECC 原生 sync** 作为能力来源;cc-switch-cli 只负责 provider / 模型 / 公共配置。

## 能力来源（ECC 原生 sync）

`scripts/sync-ecc-to-codex.sh` 安装:

- `~/.codex/AGENTS.md`(root 通用)+ `.codex/AGENTS.md`(Codex 专属)—— ECC 自带工程纪律
- 32 个 skills(`.agents/skills/`)
- 6–7 个 MCP(GitHub / Context7 / Exa / Memory / Playwright / Sequential Thinking,可选 Supabase)
- 参考配置 `.codex/config.toml`、agent 角色 `.codex/agents/`(explorer / reviewer / docs_researcher)

## 配置来源（本仓 → 落地）

| 层 | 来源 | 落地 | 机制 |
|---|---|---|---|
| 工程纪律 + 技能 + MCP | ECC 仓库 | `~/.codex/AGENTS.md`、`~/.codex` skills、MCP | `bash scripts/sync-ecc-to-codex.sh` |
| 公共配置(reasoning 等) | `cc-switch/common-config.codex.toml` | `~/.codex/config.toml` 注入段 | cc-switch 公共配置 |
| Provider/模型 | cc-switch providers(codex: 3 个) | `~/.codex/config.toml` | `cc-switch-cli use --app codex <id>` |

## 公共配置（已采用）

```toml
model_reasoning_effort = "high"
disable_response_storage = true
model_catalog_json = "cc-switch-model-catalog.json"
```

## 应用命令（全新机器复现）

```bash
# 1) ECC 原生 sync(纪律 + 32 skills + MCP + 参考 config)
git clone https://github.com/affaan-m/ECC && cd ECC && npm install
bash scripts/sync-ecc-to-codex.sh                       # --dry-run 预览 / --update-mcp 刷新 MCP
cd -                                                    # 回到本仓

# 2) cc-switch:公共配置 + provider/模型(注入 ~/.codex/config.toml)
cc-switch-cli config common set --app codex --file cc-switch/common-config.codex.toml
cc-switch-cli use --app codex <provider-id>             # 渲染 ~/.codex/config.toml

# 3) 保留本仓准则措辞:追加而非覆盖 ECC 的 AGENTS.md
cat memories/agent-principles.md >> ~/.codex/AGENTS.md
```

> **`~/.codex/config.toml` 双写**:ECC sync 写参考配置、cc-switch-cli 写 provider/reasoning 注入段——二者管不同部分。先 sync 再 cc-switch,让 cc-switch 的注入段最后落定(它负责 provider 切换);**不要**手动 `cp .codex/config.toml ~/.codex/config.toml` 覆盖 cc-switch 的注入段。

> **脚本归属(须 clone)**:`sync-ecc-to-codex.sh` 是 **ECC 仓库内**的脚本,按仓库相对路径读取 `AGENTS.md`/`.codex/`/`commands/` 并调 `scripts/codex/*` 辅助脚本——**必须在 clone 出来的 ECC 仓库里跑,没有 `npx` 免 clone 版**。这点和 `install.sh`(可用 `npx ecc-install`)不同;ECC 也只为 codex 提供 clone+sync 或手动 `cp .codex/config.toml`,不推荐 `npx ecc-install --target codex`。

> 注:Codex 的全局指令文件按 AGENTS.md 约定放在 `~/.codex/AGENTS.md`(ECC sync 已写入)。若你的 Codex 版本用不同的全局指令路径,把对应文件放到该位置即可。
