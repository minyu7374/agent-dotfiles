# Claude Code 装配方案

Claude Code 由本仓直接管理:自定义规则/技能/公共配置快照经 `scripts/sync.sh` 落地到 `~/.claude/`。provider 与模型用 Claude Code 官方方式配置(`claude` 登录 / `/model`),脚本不接管。

## 配置来源（本仓 → 落地）

| 层 | 本仓文件 | 落地位置 | 机制 |
|---|---|---|---|
| 公共配置(插件/statusLine/effort/env) | `config/claude.json` | `~/.claude/settings.json` | `scripts/sync.sh`(JSON 合并,保留用户专属字段) |
| 自定义 always-on 规则 | `rules/*.md` | `~/.claude/rules/` | **Claude Code 原生加载** `~/.claude/rules/*.md`(与 `CLAUDE.md` 同级,不依赖任何插件) |
| 自定义技能 | `skills/architectural-coherence/` | `~/.claude/skills/` | `scripts/sync.sh` 同步 |
| 开源插件 | 见 `open-source.md` | 插件 cache | marketplace 安装 + `enabledPlugins` 启用 |
| 开源技能 | 见 `SKILLS.md` | `~/.claude/skills/` | 随 anthropics/skills 安装(默认 name-only) |
| Provider/模型 | 官方原生 | `claude` 登录 / `/model` | 脚本不管 |

## 能力构成

- **插件**:`superpowers`(主框架) + `context7` + 各语言 LSP(`gopls`/`pyright`/`clangd`,按所用语言临时开关,用到再开)。
- **MCP**:`context7`(来自 context7 插件)。需要其它 MCP 时按需在 settings.json 单独引入。
- **技能**:superpowers 自带 14 个(brainstorming / TDD / systematic-debugging / writing-plans / code-review / worktrees 等,随插件走)+ 开源(docx/pdf/pptx/xlsx/skill-creator = name-only) + 自定义(architectural-coherence)。
- **规则(always-on)**:`architectural-coherence`、`minimal-change`、`function-layout`、`technical-writing` 等 —— 由 Claude Code 原生加载 `~/.claude/rules/`,与是否装插件无关。

## 应用命令

```bash
# 0) 首次:把 superpowers 装进插件 cache(安装 ≠ 启用;走内置官方市场)
#    在 claude 会话内: /plugin install superpowers@claude-plugins-official

# 1) 同步本仓自定义资产(规则/技能/公共配置合并进 ~/.claude/settings.json)
./scripts/sync.sh --app claude
```

> ⚠️ **`enabledPlugins` / `skillOverrides` 是整体替换,非叠加**:sync.sh 用 `config/claude.json` 里的集合**整体覆盖** settings.json 中这两个字段,避免旧插件/旧覆盖被并回来。其它字段(permissions / mcpServers / model / theme 等)保持不动。改完**重启 Claude Code**(插件在启动时加载)。

## 自定义规则/技能落地

```bash
./scripts/sync.sh --app claude
# 等于:
#   cp rules/*.md ~/.claude/rules/
#   cp -R skills/architectural-coherence ~/.claude/skills/
#   jq 合并 config/claude.json 到 ~/.claude/settings.json
```