# Codex CLI 装配方案

Codex CLI 现在**有原生插件系统**,superpowers 通过官方 `openai/plugins` 市场直接安装——不再需要 ECC 那套 `sync-ecc-to-codex.sh`(clone + npm + 脚本合并)。工程纪律主框架由 superpowers 插件承载;cc-switch-cli 只负责 provider / 模型 / 公共配置;本仓的自定义准则追加进 `~/.codex/AGENTS.md`。

## 能力来源

| 来源 | 内容 |
|---|---|
| **superpowers 原生插件**(openai/plugins 市场) | 14 个工程纪律技能(brainstorming / TDD / systematic-debugging / writing-plans / executing-plans / code-review / worktrees 等)+ session bootstrap;随插件走 |
| **`~/.codex/AGENTS.md`**(自定义准则) | 追加 `memories/agent-principles.md`——方案先行 / 架构连贯 / 函数布局的常驻总则 |
| **cc-switch 技能** | superpowers 未覆盖的补充:`architectural-coherence`(架构连贯手册)等,经 `cc-switch-cli skills --app codex` 同步 |
| **cc-switch 公共/Provider 配置** | reasoning / provider / 模型,注入 `~/.codex/config.toml` |

## 配置来源（本仓 → 落地）

| 层 | 来源 | 落地 | 机制 |
|---|---|---|---|
| 工程纪律主框架 | openai/plugins 市场 | Codex 插件面 | 会话内 `/plugins` → 搜 `superpowers` → Install Plugin |
| 常驻准则 | `memories/agent-principles.md` | `~/.codex/AGENTS.md`(追加) | 手动 `cat ... >> ~/.codex/AGENTS.md` |
| 补充技能 | `cc-switch/skills-matrix.md` | Codex 技能目录 | `cc-switch-cli skills enable <name> --app codex` + `sync` |
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
# 1) superpowers 原生插件(工程纪律主框架)
#    在 Codex CLI 会话内: /plugins → 搜 superpowers → 选 Install Plugin

# 2) cc-switch:公共配置 + provider/模型(注入 ~/.codex/config.toml)
cc-switch-cli config common set --app codex --file cc-switch/common-config.codex.toml
cc-switch-cli use --app codex <provider-id>             # 渲染 ~/.codex/config.toml

# 3) 常驻准则:追加进 AGENTS.md(现由本仓维护,不再由 ECC 写)
cat memories/agent-principles.md >> ~/.codex/AGENTS.md

# 4) 补充技能:superpowers 未覆盖的自定义技能
cc-switch-cli skills enable architectural-coherence --app codex   # 自定义技能需先 import-from-apps 纳入 SSOT
cc-switch-cli skills sync
```

> **`~/.codex/AGENTS.md` 现在是本仓资产**:ECC 退场后不再有脚本自动写它。全局指令按 AGENTS.md 约定放在 `~/.codex/AGENTS.md`,内容 = `memories/agent-principles.md`(可按需增补)。superpowers 的纪律来自插件,与这份 AGENTS.md 互补、不冲突。

> **`~/.codex/config.toml` 归 cc-switch**:provider / reasoning 注入段由 `cc-switch-cli use --app codex` 写入;superpowers 是插件,不碰 config.toml。**不要**手动覆盖 cc-switch 的注入段。
