# agent-dotfiles

跨 AI 编码助手(Claude Code / Codex / Gemini · Antigravity)的统一配置,按 **cc-switch 统一管理**的逻辑组织。

## 设计理念

1. **复用优先**:先用已有的开源插件 / 技能,只为"真正没人覆盖的空白"写自定义内容。
2. **ECC 为主框架**(Claude 端):agents / skills / commands / hooks / MCP 一站式;其余插件保持精简,避免重叠。
3. **cc-switch 为单一真源**:provider、公共配置、技能矩阵都收口到 cc-switch;它在切换时渲染各 app 的实际配置文件。
4. **不 vendoring 开源内容**:开源插件/技能只记"装什么、从哪来、怎么装";仓库只承载**自定义资产**与**配置真源**。

## 仓库结构

```
agent-dotfiles/
├── README.md                       # 本文件:理念 + 清单 + 应用总流程
├── cc-switch/                      # cc-switch 真源快照(可回灌)
│   ├── common-config.claude.json   #   Claude 公共配置(5 插件 + statusLine + effort + marketplaces)
│   ├── common-config.codex.toml    #   Codex 公共配置(reasoning=high 等)
│   └── skills-matrix.md            #   技能 × 应用 启用矩阵 + cc-switch 命令
├── apps/                           # 各 app 装配方案
│   ├── claude.md                   #   插件 + MCP + 技能 + 规则 + 应用命令(含 enabledPlugins 叠加坑)
│   ├── codex.md                    #   reasoning + 技能 + AGENTS.md(无 plugin 概念)
│   └── gemini.md                   #   Gemini & Antigravity(agy 读 .gemini skills + GEMINI.md)
├── open-source.md                  # 开源插件/技能清单 + 来源 + 安装/取舍(不 vendoring)
├── rules/                          # 【自定义】Claude always-on 规则
│   ├── architectural-coherence.md  #   改动后架构连贯性(极简总则,指向 skill)
│   └── function-layout.md          #   文件内函数布局
├── skills/                         # 【自定义】技能(已纳入 cc-switch SSOT,三端同步)
│   └── architectural-harmony/      #   架构连贯性的详细实施手册
└── memories/
    └── agent-principles.md         # 非 Claude 端常驻准则 → 部署到 ~/.gemini/GEMINI.md 与 ~/.codex/AGENTS.md
```

## 自定义足迹（仅此而已）

经过"复用优先"收敛后,真正自定义的只有:

- `rules/architectural-coherence.md` —— 经核实 ECC + karpathy 均无等价物的唯一空白(总则)。
- `skills/architectural-harmony/` —— 上者的详细手册(按需触发)。
- `rules/function-layout.md` —— 既有的文件内布局约定。
- `memories/agent-principles.md` —— 非 Claude 端(codex/gemini/agy)的常驻准则,单一来源部署到 `~/.gemini/GEMINI.md` 与 `~/.codex/AGENTS.md`。

其余全部依赖开源:**ECC**(主框架) + **karpathy-guidelines** + **ECC coding-standards** + Anthropic 官方文档技能(docx/pdf/pptx/xlsx)。

> **三端对齐**:claude / codex / gemini(=agy)的工程准则一致。Claude 经"插件(ECC/karpathy)+ always-on 规则"承载;codex/gemini 无插件,经"技能(karpathy-guidelines + architectural-harmony)+ 常驻准则文件(agent-principles.md)"承载。技能集三端完全一致(见 `cc-switch/skills-matrix.md`)。

## 全新机器:应用流程

> 命令行工具为 **`cc-switch-cli`**(与桌面版 `cc-switch` 区分,避免命令冲突);下文所有命令均用 `cc-switch-cli`,正文里的 "cc-switch" 指工具/产品本身。

```bash
# 0) 装 cc-switch-cli,注册 marketplaces(ecc / karpathy-skills 已在公共配置的 extraKnownMarketplaces)

# 1) Claude
cc-switch-cli config common set --app claude --file cc-switch/common-config.claude.json
cc-switch-cli use claude-official                      # 渲染 ~/.claude/settings.json
cp rules/*.md ~/.claude/rules/                      # 自定义规则
cp -r skills/architectural-harmony ~/.claude/skills/
#    (开源插件:首次需在 /plugin 里从 marketplace 安装;详见 open-source.md 与 apps/claude.md 的叠加坑)

# 2) Codex
cc-switch-cli config common set --app codex --file cc-switch/common-config.codex.toml
cc-switch-cli skills enable karpathy-guidelines architectural-harmony --app codex   # 必要时分两条
cc-switch-cli skills sync                               # -> ~/.codex/skills/
cp memories/agent-principles.md ~/.codex/AGENTS.md  # 常驻准则
cc-switch-cli use --app codex <provider-id>

# 3) Gemini / Antigravity(agy)
cc-switch-cli skills enable karpathy-guidelines architectural-harmony --app gemini
cc-switch-cli skills sync                               # -> ~/.gemini/skills/
cp memories/agent-principles.md ~/.gemini/GEMINI.md

# 重启 Claude Code / 各客户端,并重启 CC Switch app 让其缓存对齐 DB
```

各 app 细节见 `apps/`,技能命令见 `cc-switch/skills-matrix.md`,插件取舍见 `open-source.md`。

## 已知坑

- **`enabledPlugins` 叠加式**:cc-switch 渲染 Claude `settings.json` 时与 provider 的 `settings_config` 合并,旧插件可能被并回来。权威集要落在 **provider(claude-official)的 `settings_config`** 上(见 `apps/claude.md`)。
- **`ccstatusline` 需另装**:`common-config.claude.json` 里声明了 statusLine,但需本机存在 `ccstatusline` 命令,否则状态栏会报错(可删掉该段)。
- **重启才生效**:插件/技能/规则在客户端启动时加载;`claude -c` 也是新进程会重载配置,但上下文会带旧残影,干净起见可开新会话。
