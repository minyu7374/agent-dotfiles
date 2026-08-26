# CodeBuddy 装配方案

CodeBuddy 架构与 Claude Code 完全兼容(共享 `settings.json`、`rules/*.md`、`skills/` 规范)。由本仓经 `scripts/sync.sh` 直接管理。provider 与模型用 CodeBuddy 应用内设置(官方原生),脚本不接管。

## 配置来源（本仓 → 落地）

| 层 | 本仓文件 | 落地位置 | 机制 |
|---|---|---|---|
| 公共配置快照 | `config/codebuddy.json` | `~/.codebuddy/settings.json` | `scripts/sync.sh`(JSON 合并,保留 trustedDirectories/model/statusLine) |
| 自定义 always-on 规则 | `rules/*.md` | `~/.codebuddy/rules/` | CodeBuddy 原生加载 `~/.codebuddy/rules/*.md` |
| 常驻准则 | `memories/agent-principles.md` | `~/.codebuddy/AGENTS.md` | `scripts/sync.sh`(直接覆盖,文件完全托管) |
| 自定义技能 | `skills/architectural-coherence/` | `~/.codebuddy/skills/` | `scripts/sync.sh` |
| 开源技能 | 见 `SKILLS.md` | `~/.codebuddy/skills/` | 随 anthropics/skills 安装 |
| Provider/模型 | 官方原生 | CodeBuddy 应用内设置 | 脚本不管 |

## 能力构成

- **插件**: `superpowers`(工程纪律主框架,从 `codebuddy-plugins-official` 安装/启用)。
- **规则(always-on)**: `architectural-coherence`、`minimal-change`、`function-layout`、`technical-writing` 等 —— 由 CodeBuddy 原生加载 `~/.codebuddy/rules/`。
- **技能**: `architectural-coherence` + 开源文档技能(`docx`/`pdf`/`pptx`/`xlsx`/`skill-creator`)。

## 应用命令

```bash
# 1) 同步本仓自定义资产(规则 + 常驻准则 + 技能 + settings.json 合并)
./scripts/sync.sh --app codebuddy
```

> **`enabledPlugins` / `skillOverrides` 是整体替换,非叠加**:sync.sh 用 `config/codebuddy.json` 里的集合**整体覆盖** settings.json 中这两个字段;`trustedDirectories` / `model` / `statusLine` 等用户专属字段保持不动。