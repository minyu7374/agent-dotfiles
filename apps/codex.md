# Codex 装配方案

Superpowers 使用 Codex 原生插件系统；安装、升级和当前来源统一见
[开源插件清单](../open-source.md#superpowers)。本仓只同步常驻准则和自定义技能。

| 本仓来源 | 落地位置 | 机制 |
|---|---|---|
| `memories/agent-principles.md` | `~/.codex/AGENTS.md` | 替换 `agent-dotfiles` 标记块，保留块外内容 |
| `skills/architectural-coherence/` | `~/.codex/skills/architectural-coherence/` | 同步技能目录 |

```bash
./scripts/sync.sh --app codex --dry-run
./scripts/sync.sh --app codex
```

`~/.codex/config.toml` 由 Codex 原生管理，`sync.sh` 不读取或写入它。
插件管理命令可以更新其中的插件登记。

流程边界以[规划校准规则](../rules/plan-calibration.md)为准，其常驻摘要在
`memories/agent-principles.md`；Superpowers 提供边界内适用的方法。
摘要保留按实际影响选择流程、允许双向调整、反馈只修订相关部分的约束。

同步后核对托管块与源文件一致，再在新会话中确认准则和插件已加载。
当前会话的上下文不会因磁盘文件更新而自动替换。
