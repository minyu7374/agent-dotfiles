# Codex CLI 装配方案

Codex CLI 有原生插件系统:superpowers 通过官方 `openai/plugins` 市场直接安装。工程纪律主框架由 superpowers 插件承载;本仓的自定义准则经 `scripts/sync.sh` 同步进 `~/.codex/`。provider 与模型用 Codex 官方方式配置(`codex login` / `codex` 配置),脚本不接管。

## 能力来源

| 来源 | 内容 |
|---|---|
| **superpowers 原生插件**(openai/plugins 市场) | 14 个工程纪律技能(brainstorming / TDD / systematic-debugging / writing-plans / executing-plans / code-review / worktrees 等)+ session bootstrap;随插件走 |
| **`~/.codex/AGENTS.md`**(自定义准则) | `memories/agent-principles.md` 的**标记块**(`<!-- agent-dotfiles:begin/end -->`),由 sync.sh 维护;块外内容保留 |
| **自定义技能** | `architectural-coherence`(架构连贯手册),经 sync.sh 同步到 `~/.codex/skills/` |
| **行为级配置** | `config/codex.toml`(reasoning effort / 关闭响应存储),经 sync.sh 以标记块写入 `~/.codex/config.toml` |
| **Provider/模型** | 官方原生(`codex login` / `codex` 配置),脚本不接管 |

## 配置来源（本仓 → 落地）

| 层 | 来源 | 落地 | 机制 |
|---|---|---|---|
| 工程纪律主框架 | openai/plugins 市场 | Codex 插件面 | 会话内 `/plugins` → 搜 `superpowers` → Install Plugin |
| 常驻准则 | `memories/agent-principles.md` | `~/.codex/AGENTS.md`(标记块) | `scripts/sync.sh` |
| 补充技能 | `skills/architectural-coherence/` | `~/.codex/skills/` | `scripts/sync.sh` |
| 行为级配置 | `config/codex.toml` | `~/.codex/config.toml`(标记块) | `scripts/sync.sh` |
| Provider/模型 | 官方原生 | `codex login` / `codex` 配置 | 脚本不管 |

## 行为级配置（已采用）

```toml
model_reasoning_effort = "high"
disable_response_storage = true
```

## 应用命令（全新机器复现）

```bash
# 1) superpowers 原生插件(工程纪律主框架)
#    在 Codex CLI 会话内: /plugins → 搜 superpowers → 选 Install Plugin

# 2) 同步本仓自定义资产(常驻准则标记块 + 技能 + config.toml 标记块)
./scripts/sync.sh --app codex
```

> **`~/.codex/AGENTS.md` 是本仓资产**:内容 = `memories/agent-principles.md`(以标记块维护,幂等)。你在块外写的内容会被保留。superpowers 的纪律来自插件,与这份 AGENTS.md 互补、不冲突。
>
> **`~/.codex/config.toml` 只动托管块**:sync.sh 只替换 `# >>> agent-dotfiles:begin/end` 之间的两行,其余(plugins / mcp_servers / marketplaces 等)保持不动。