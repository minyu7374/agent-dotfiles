# Gemini CLI 与 Antigravity 装配方案

Gemini CLI 和 Antigravity 是不同客户端。本机 Antigravity（`agy`）与 Gemini
使用 `~/.gemini/GEMINI.md` 和 `~/.gemini/skills/` 中的自定义资产。
Superpowers 的安装与升级方式分别见[开源插件清单](../open-source.md#superpowers)。

| 本仓来源 | 落地位置 | 机制 |
|---|---|---|
| `memories/agent-principles.md` | `~/.gemini/GEMINI.md` | 完全托管，直接覆盖 |
| `skills/architectural-coherence/` | `~/.gemini/skills/architectural-coherence/` | 同步技能目录 |

```bash
./scripts/sync.sh --app gemini --dry-run
./scripts/sync.sh --app gemini
```

Superpowers 7 在 Antigravity 中通过技能发现引导模型加载 `using-superpowers`，
不是 session-start hook。该机制见[上游 7.0.0 发布说明](https://github.com/obra/superpowers/releases/tag/v7.0.0)。
安装或同步后新开会话检查实际加载结果。

Provider、模型和 `~/.gemini/antigravity-cli/` 下的运行时文件由客户端管理。
