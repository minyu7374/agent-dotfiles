# Claude Code 装配方案

由 cc-switch 统一管理(它在切换 provider / 应用公共配置时写 `~/.claude/settings.json`)。

## 配置来源（本仓 → 落地）

| 层 | 本仓文件 | 落地位置 | 机制 |
|---|---|---|---|
| 公共配置(插件/statusLine/effort/marketplaces/env) | `cc-switch/common-config.claude.json` | `~/.claude/settings.json` | cc-switch 公共配置 |
| 自定义 always-on 规则 | `rules/*.md` | `~/.claude/rules/` | **Claude Code 原生加载** `~/.claude/rules/*.md`(与 `CLAUDE.md` 同级,不依赖任何插件) |
| 自定义技能 | `skills/architectural-coherence/` | `~/.claude/skills/` | cc-switch-cli skills 或手放 |
| 开源插件 | 见 `open-source.md` | 插件 cache | marketplace 安装 + `enabledPlugins` 启用 |
| 开源技能 | 见 `cc-switch/skills-matrix.md` | `~/.claude/skills/` | cc-switch-cli skills |

## 能力构成

- **插件**:`superpowers`(主框架) + `context7` + 各语言 LSP(`gopls`/`pyright`/`clangd`,按所用语言临时开关,用到再开)。
- **MCP**:`context7`(来自 context7 插件)。ECC 那套 github/exa/memory/playwright/sequential-thinking MCP 已随 ECC 退场;需要时按需单独引入。
- **技能**:superpowers 自带 14 个(brainstorming / TDD / systematic-debugging / writing-plans / code-review / worktrees 等,随插件走)+ 开源(docx/pdf/pptx/xlsx/skill-creator = name-only) + 自定义(architectural-coherence)。
- **规则(always-on)**:`architectural-coherence`、`minimal-change`、`function-layout`(自定义)—— 由 Claude Code 原生加载 `~/.claude/rules/`,与是否装插件无关。

## 应用命令

```bash
# 0) 首次:把 superpowers 装进插件 cache(安装 ≠ 启用;走内置官方市场)
#    在 claude 会话内: /plugin install superpowers@claude-plugins-official

# 1) 公共配置(含 enabledPlugins)写入 cc-switch 真源
cc-switch-cli config common set --app claude --file cc-switch/common-config.claude.json

# 2) 渲染到 live settings.json(切到当前 provider 即可触发)
cc-switch-cli use claude-official
```

> ⚠️ **enabledPlugins 是叠加式(union)**:cc-switch 渲染 `settings.json` 时,会把 **provider 的 `settings_config.enabledPlugins`** 与 live 现状合并。若 provider 配置里还残留旧插件,会被并回来。确保权威集一致的稳妥做法:把 **provider(claude-official)的 `settings_config`** 与本仓 `enabledPlugins` 对齐(必要时直接改 cc-switch DB 的 providers 行),再 `cc-switch-cli use`。改完**重启 Claude Code**(插件在启动时加载),并**重启 CC Switch app** 让其缓存对齐 DB。

## 自定义规则/技能落地

```bash
cp rules/*.md ~/.claude/rules/

# cp -r skills/architectural-coherence ~/.claude/skills/
# cc-switch-cli skills install architectural-coherence  # 自定义技能纳入 cc-switch-cli skills 管理
cc-switch-cli skills enable architectural-coherence --app claude
cc-switch-cli skills sync
```
