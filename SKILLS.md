# 技能清单

自定义技能由本仓同步；开源技能通过其原生插件或安装方式获得，`sync.sh` 不下载它们。
Superpowers 的工程技能随插件走，来源和版本统一见[开源插件清单](open-source.md#superpowers)。

## 自定义技能

| 技能 | 来源 | 用途 |
|---|---|---|
| `architectural-coherence` | 本仓 `skills/` | 架构一致性的详细方法；常驻规则负责总则，技能按需加载 |

| 客户端 | 技能目录 |
|---|---|
| Claude | `~/.claude/skills/` |
| Codex | `~/.codex/skills/` |
| Gemini / Antigravity | `~/.gemini/skills/` |
| OpenCode | `~/.config/opencode/skills/` |
| CodeBuddy | `~/.codebuddy/skills/` |

常驻规则的载体与同步行为见 [README](README.md#同步行为)，各端细节见 `apps/`。

## 可选开源技能

| 技能 | 来源 | 用途 |
|---|---|---|
| `docx` / `pdf` / `pptx` / `xlsx` | [anthropics/skills](https://github.com/anthropics/skills) | Office / PDF 文档处理 |
| `skill-creator` | [Anthropic 官方插件市场](https://github.com/anthropics/claude-plugins-official) | 创建、优化和评测技能 |

这些是可选能力，不表示已在所有客户端安装。Codex 已有对应官方文档插件或系统技能时，
直接使用现有能力，无需再重复安装 Anthropic 版本。

## 技能可见性

本仓在 Claude / CodeBuddy 公共快照中将文档技能和 `skill-creator` 设为 `name-only`。
Claude 的[官方定义](https://code.claude.com/docs/en/skills#override-skill-visibility-from-settings)是：

| 状态 | 模型看到的列表 | 用户菜单 |
|---|---|---|
| `on` | 名称和描述 | 可见 |
| `name-only` | 仅名称 | 可见 |
| `user-invocable-only` | 隐藏 | 可见 |
| `off` | 隐藏 | 隐藏 |

`on` 与 `name-only` 都在调用时加载正文；`on` 不表示正文常驻。
Claude 的 `skillOverrides` 不作用于插件提供的技能，插件通过原生插件管理器控制。
其他客户端按自身机制加载，不套用 Claude 的设置值。
