# agent-dotfiles

跨 AI 编码助手(Claude Code / Codex / Gemini · Antigravity)的统一配置,按 **cc-switch 统一管理**的逻辑组织。

## 设计理念

1. **复用优先**:先用已有的开源插件 / 技能,只为"真正没人覆盖的空白"写自定义内容。
2. **superpowers 为主框架**(三端统一):一套精简的工程纪律技能库(brainstorming → TDD → 调试 → 计划 → 评审 → worktree 等 14 个技能),且**每个 harness 都有原生插件安装**(Claude / Codex CLI / Antigravity),同一框架覆盖三端。其余插件/技能保持精简,避免重叠。(前身为 **ECC**,因 228 skills / 60 agents 过于臃肿而退场,换成更聚焦的 superpowers。)
3. **cc-switch 为单一真源**:provider、公共配置、技能矩阵都收口到 cc-switch;它在切换时渲染各 app 的实际配置文件。superpowers 本身由各 harness 自带的插件管理器安装,不经 cc-switch。
4. **不 vendoring 开源内容**:开源插件/技能只记"装什么、从哪来、怎么装";仓库只承载**自定义资产**与**配置真源**。

## 仓库结构

```
agent-dotfiles/
├── README.md                       # 本文件:理念 + 清单 + 应用总流程
├── cc-switch/                      # cc-switch 真源快照(可回灌)
│   ├── common-config.claude.json   #   Claude 公共配置(enabledPlugins + statusLine + effort + marketplaces + env)
│   ├── common-config.codex.toml    #   Codex 公共配置(reasoning=high 等)
│   └── skills-matrix.md            #   技能 × 应用 启用矩阵 + cc-switch 命令
├── apps/                           # 各 app 装配方案
│   ├── claude.md                   #   superpowers 插件 + MCP + 技能 + 规则 + 应用命令(含 enabledPlugins 叠加坑)
│   ├── codex.md                    #   superpowers 原生插件(openai/plugins) + cc-switch provider/reasoning
│   └── gemini.md                   #   Gemini & Antigravity(agy plugin install superpowers + .gemini skills + GEMINI.md)
├── open-source.md                  # 开源插件/技能清单 + 来源 + 安装/取舍(不 vendoring)
├── rules/                          # 【自定义】Claude always-on 规则(Claude Code 原生加载)
│   ├── architectural-coherence.md  #   改动后架构连贯性(极简总则,指向同名 skill)
│   ├── minimal-change.md           #   最小化变动/外科手术式改动(从属架构连贯:先连贯后最小)
│   └── function-layout.md          #   文件内函数布局
├── skills/                         # 【自定义】技能(已纳入 cc-switch SSOT,三端同步)
│   └── architectural-coherence/    #   架构连贯的详细实施手册(与同名 rule 配对:rule=总则 / skill=手册)
├── hooks/                          # 【自定义】可选钩子(当前停用,作备用)
│   ├── diagnose-gate.sh            #   诊断类提问时先给根因+方案再改码
│   └── README.md                   #   钩子说明 + 重新启用的配置
└── memories/
    └── agent-principles.md         # 常驻准则 → ~/.gemini/GEMINI.md(Gemini) & 追加到 ~/.codex/AGENTS.md(Codex)
```

## 自定义足迹（仅此而已）

经过"复用优先"收敛后,真正自定义的只有:

- `rules/architectural-coherence.md` —— 经核实 superpowers 无等价物的空白(总则);配套同名 skill 作详细手册。
- `rules/minimal-change.md` —— 最小化变动/外科手术式改动;**从属于架构连贯**(先定连贯形状,再做到最小)。取代已退场的 karpathy-guidelines。
- `rules/function-layout.md` —— 既有的文件内布局约定。
- `skills/architectural-coherence/` —— 架构连贯 rule 的详细手册(按需触发;与 rule 同名配对)。
- `memories/agent-principles.md` —— 常驻准则 → `~/.gemini/GEMINI.md`(Gemini)+ 追加到 `~/.codex/AGENTS.md`(Codex)。保持 app-neutral。
- `hooks/diagnose-gate.sh` —— 可选 PreToolUse 钩子(当前停用作备用,见 `hooks/README.md`)。

其余全部依赖开源:**superpowers**(主框架,自带 14 技能) + Anthropic 官方文档技能(docx/pdf/pptx/xlsx)。

> **三端对齐**:工程纪律一致,载体现已**统一** —— 三端都装 superpowers 原生插件(Claude `enabledPlugins` / Codex `openai/plugins` / Antigravity `agy plugin install`),再叠一层薄自定义(Claude `~/.claude/rules/`、Gemini/Codex `GEMINI.md`/`AGENTS.md`、`architectural-coherence` 经 cc-switch)。superpowers 自带 14 技能随插件走;技能矩阵只管 superpowers 未覆盖的自定义/文档技能。

## 全新机器:应用流程

> 命令行工具为 **`cc-switch-cli`**(与桌面版 `cc-switch` 区分,避免命令冲突);下文所有命令均用 `cc-switch-cli`,正文里的 "cc-switch" 指工具/产品本身。

```bash
# 0) 装 cc-switch-cli(superpowers / LSP / context7 都走内置官方市场 claude-plugins-official,
#     无需注册 marketplace;公共配置里也不再需要 extraKnownMarketplaces)

# 1) Claude
cc-switch-cli config common set --app claude --file cc-switch/common-config.claude.json
cc-switch-cli use claude-official                      # 渲染 ~/.claude/settings.json
cp rules/*.md ~/.claude/rules/                      # 自定义规则(Claude Code 原生加载)
cp -r skills/architectural-coherence ~/.claude/skills/
#    首次需在会话内安装 superpowers 插件:/plugin install superpowers@claude-plugins-official
#    (enabledPlugins 叠加坑详见 apps/claude.md)

# 2) Codex —— superpowers 原生插件(openai/plugins 市场;详见 apps/codex.md)
#    在 Codex CLI 会话内:/plugins → 搜 superpowers → Install Plugin
cc-switch-cli config common set --app codex --file cc-switch/common-config.codex.toml
cc-switch-cli use --app codex <provider-id>         # provider/模型注入 ~/.codex/config.toml
cat memories/agent-principles.md >> ~/.codex/AGENTS.md   # 常驻准则
cc-switch-cli skills enable architectural-coherence --app codex && cc-switch-cli skills sync

# 3) Gemini / Antigravity(agy)—— superpowers 原生插件 + cc-switch 技能 + GEMINI.md
agy plugin install https://github.com/obra/superpowers    # 装 superpowers(含 session-start hook)
cc-switch-cli skills enable architectural-coherence --app gemini
cc-switch-cli skills sync                               # -> ~/.gemini/skills/
cp memories/agent-principles.md ~/.gemini/GEMINI.md

# 重启 Claude Code / 各客户端,并重启 CC Switch app 让其缓存对齐 DB
```

各 app 细节见 `apps/`,技能命令见 `cc-switch/skills-matrix.md`,插件取舍见 `open-source.md`。

## 已知坑

- **`enabledPlugins` 叠加式**:cc-switch 渲染 Claude `settings.json` 时与 provider 的 `settings_config` 合并,旧插件可能被并回来。权威集要落在 **provider(claude-official)的 `settings_config`** 上(见 `apps/claude.md`)。
- **`ccstatusline` 需另装**:`common-config.claude.json` 里声明了 statusLine,但需本机存在 `ccstatusline` 命令,否则状态栏会报错(可删掉该段)。
- **重启才生效**:插件/技能/规则在客户端启动时加载;`claude -c` 也是新进程会重载配置,但上下文会带旧残影,干净起见可开新会话。
