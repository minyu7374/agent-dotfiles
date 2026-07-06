# 开源插件 & 技能清单（不 vendoring，仅记来源 + 安装方式）

这些内容从各自 marketplace / repo 拉取,本仓**不复制内容**,只记录"装什么、从哪来、怎么装、为何装/不装"。自定义内容见 `rules/`、`skills/architectural-coherence/`。

## Marketplaces（插件市场）

| 名称 | 来源 |
|---|---|
| `claude-plugins-official` | github: anthropics/claude-plugins-official（内置官方市场,含 superpowers / LSP / context7） |

```bash
# 在 claude 会话内(交互式)。superpowers / LSP / context7 都走内置官方市场,无需 marketplace add,
# 故 common-config.claude.json 已不再需要 extraKnownMarketplaces。
/plugin install superpowers@claude-plugins-official       # 安装 superpowers 到本地缓存(安装 ≠ 启用)
# 启用与否由 enabledPlugins 决定,经 `cc-switch-cli use` 渲染进 settings.json;但首次仍需上面的 install 把插件下载到缓存
```

## superpowers 跨端安装（三端都有原生插件——这正是换掉 ECC 的关键收益）

superpowers 为每个 harness 都提供**原生插件安装**,不再像 ECC 那样三端机制各异(Claude 插件 / Codex sync 脚本 / Gemini 无全局安装器)。装法以 superpowers 官方 README 为准:

| App | 机制 | 命令 | 落地 |
|---|---|---|---|
| **Claude** | 插件(官方市场) | `/plugin install superpowers@claude-plugins-official` | 插件 cache + `enabledPlugins` |
| **Codex CLI** | 原生插件(openai/plugins 市场) | 会话内 `/plugins` → 搜 `superpowers` → Install Plugin | Codex 插件面(自带 skills + session bootstrap) |
| **Antigravity(agy)** | 原生插件 | `agy plugin install https://github.com/obra/superpowers` | 装为插件,启动即跑 session-start hook;重装同命令即更新 |

> **cc-switch 的边界**:superpowers 由各 harness 自带的插件管理器安装,**不经 cc-switch**。cc-switch 只渲染 Claude 的 `enabledPlugins` 条目、provider/模型、公共配置,以及 superpowers 未覆盖的自定义/文档技能。
> **保留本仓准则措辞**:Codex 侧 `cat memories/agent-principles.md >> ~/.codex/AGENTS.md`;Gemini 侧写入 `~/.gemini/GEMINI.md`。详见 `apps/codex.md` / `apps/gemini.md`。

## Claude 插件（plugin 是 Claude Code 专属概念）

主框架 = **superpowers**(自带 14 个工程纪律技能)。启用集保持精简。

> **插件/技能可按需临时开关**:用不到的随手停用、体量大低频的设 name-only,用到再开——所以本文件不逐一写死谁被禁用。各语言 LSP 尤其如此(见下)。

### ✅ 常驻启用

| 插件 | 市场 | 作用 |
|---|---|---|
| `superpowers` | claude-plugins-official | **主框架**:14 skills(brainstorming / TDD / systematic-debugging / writing-plans / executing-plans / code-review / worktrees 等)+ session-start hook 自动引导 |
| `context7` | claude-plugins-official | 实时库文档 + context7 MCP |

**各语言 LSP**(`gopls-lsp` / `pyright-lsp` / `clangd-lsp`,均来自 claude-plugins-official):按所用语言**临时启用**——用到哪个开哪个,不在此写死开了哪几个。

### ⬜ 按设计不以插件形式启用 — 原因如下(非临时开关,而是取舍)

| 插件 | 原因 |
|---|---|
| `ecc` | **前主框架,已退场**:228 skills / 60 agents 过于臃肿,agents/hooks/MCP 面太重;换成更聚焦的 superpowers。marketplace 亦已移除。需要个别 ECC 能力时再单独按需引入 |
| `andrej-karpathy-skills` | 整套已弃用:其编码纪律(think-before / simplicity / surgical / goal-driven)已被 superpowers + 自定义 `minimal-change` 规则覆盖;marketplace 亦已移除 |
| `code-simplifier` | 与 superpowers 的评审/重构流程有部分重叠;需要时再开 |
| `claude-md-management` | 需要时再开 |
| `playwright` | 后端为主,无 Web 自动化需求 |
| `telegram` | 本想用其远程控制功能,但当前 team 订阅的 Claude 对远程管理有限制(管理员配置),故未启用 |

> 上表是**设计取舍**(为何不把它当常驻插件),与"用不到就临时停用"不同。想从磁盘彻底卸载:`/plugin` 里 uninstall。

## 开源技能（跨 app，cc-switch 管理）

> superpowers 自带的 14 个技能**随插件走**,不在此表、也不经 cc-switch;这里只列 superpowers 未覆盖、由 cc-switch 同步到各端的技能。

| 技能 | 来源 | 用途 | Claude 加载态 |
|---|---|---|---|
| `docx` / `pdf` / `pptx` / `xlsx` | anthropics/skills | Office / PDF 文档处理 | **name-only**(仅载描述,用到才展开;省 token) |
| `skill-creator` | anthropics/claude-plugins-official | 创建 / 优化 / 评测技能 | **name-only**(低频) |
| `architectural-coherence`(自定义) | 本仓 `skills/` | 架构连贯详细手册(与同名 always-on 规则配对) | on |

> **name-only vs on**:Claude Code 特有的技能加载态——`name-only` 只把技能描述放进上下文,正文按需加载,适合体量大、低频的文档技能(docx/pdf/pptx/xlsx);`on` 则常驻。codex/gemini 端无此区分,启用即可用。启用矩阵与命令见 `cc-switch/skills-matrix.md`。
