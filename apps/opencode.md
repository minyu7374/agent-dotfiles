# OpenCode 装配方案

本仓只同步 OpenCode 的常驻准则与自定义技能。`opencode.json`、`opencode.jsonc`
及其中的 provider、模型、插件配置均由 OpenCode 原生管理，`sync.sh` 不写入它们。

| 本仓来源 | 落地位置 | 机制 |
|---|---|---|
| `memories/agent-principles.md` | `~/.config/opencode/AGENTS.md` | 完全托管，直接覆盖 |
| `skills/architectural-coherence/` | `~/.config/opencode/skills/architectural-coherence/` | 同步技能目录 |

```bash
./scripts/sync.sh --app opencode --dry-run
./scripts/sync.sh --app opencode
```

需要 Superpowers 时按[上游 OpenCode 安装说明](https://github.com/obra/superpowers/blob/main/.opencode/INSTALL.md)
安装；本仓同步不代表该插件已安装。其他可选技能见[技能清单](../SKILLS.md)。
