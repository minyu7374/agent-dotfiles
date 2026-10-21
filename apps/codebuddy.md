# CodeBuddy 装配方案

CodeBuddy 原生加载 `~/.codebuddy/rules/*.md` 与 `skills/`。本仓直接同步这两项及公共配置；不再写入不受支持的全局 `AGENTS.md`。provider 与模型由 CodeBuddy 应用内设置管理。

## 配置来源（本仓 → 落地）

| 层 | 本仓文件 | 落地位置 | 机制 |
|---|---|---|---|
| 公共配置快照 | `config/codebuddy.json` | `~/.codebuddy/settings.json` | 对象递归合并，快照中的值优先 |
| 自定义 always-on 规则 | `rules/*.md` | `~/.codebuddy/rules/` | CodeBuddy 原生加载 `~/.codebuddy/rules/*.md` |
| 自定义技能 | `skills/architectural-coherence/` | `~/.codebuddy/skills/` | `scripts/sync.sh` |
| 开源技能 | 见 `SKILLS.md` | `~/.codebuddy/skills/` | 随 anthropics/skills 安装 |
| Provider/模型 | 官方原生 | CodeBuddy 应用内设置 | 脚本不管 |

## 能力构成

- **插件**: `superpowers` 只从 `codebuddy-plugins-official` 安装/启用；版本与升级命令见[开源插件清单](../open-source.md#superpowers)。
- **规则(always-on)**: `architectural-coherence`、`minimal-change`、`function-layout`、`technical-writing` 等 —— 由 CodeBuddy 原生加载 `~/.codebuddy/rules/`。
- **技能**: `architectural-coherence` + 开源文档技能(`docx`/`pdf`/`pptx`/`xlsx`/`skill-creator`)。

## 应用命令

```bash
# 1) 同步本仓自定义资产(规则 + 技能 + settings.json 合并)
./scripts/sync.sh --app codebuddy
```

> 公共配置按对象递归合并，保留未托管字段，包括用户自己的 `env` 变量；`enabledPlugins` / `skillOverrides` 两张表由快照整体替换。状态栏命令通过 `$HOME` 定位本机脚本，该脚本需单独安装。
