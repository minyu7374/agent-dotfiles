# agent-dotfiles

跨 AI 编码助手(Claude Code / Codex / Gemini · Antigravity / OpenCode / CodeBuddy)的统一配置,本仓即**单一真源(SSOT)**,`scripts/sync.sh` 一键把自定义资产同步到各 agent。provider / 模型不再由第三方切换工具接管——各厂商现在都有明确的主流原生接入方式,各 agent 自己配。

## 设计理念

1. **复用优先**:先用已有的开源插件 / 技能,只为"真正没人覆盖的空白"写自定义内容。
2. **superpowers 为主框架**(多端统一):一套精简的工程纪律技能库(brainstorming → TDD → 调试 → 计划 → 评审 → worktree 等 14 个技能),且每个 harness 都支持原生插件/技能导入安装,同一框架覆盖各端。其余插件/技能保持精简,避免重叠。(前身为 **ECC**,因 228 skills / 60 agents 过于臃肿而退场,换成更聚焦的 superpowers。)
3. **本仓为单一真源**:配置快照、常驻准则、自定义规则/技能都收口到本仓;`scripts/sync.sh` 负责把它们同步到各 agent 的配置目录。不再依赖 cc-switch。
4. **不 vendoring 开源内容**:开源插件/技能只记"装什么、从哪来、怎么装";仓库只承载**自定义资产**与**配置真源**。

## 仓库结构

```
agent-dotfiles/
├── README.md                       # 本文件:理念 + 结构 + 应用总流程
├── CLAUDE.md                       # 在 Claude Code 中维护本仓的说明
├── SKILLS.md                       # 技能清单:自定义(本仓同步) + 开源(记安装方式)
├── config/                         # 配置快照(SSOT,由 sync.sh 直接应用)
│   ├── claude.json                 #   Claude 公共配置(enabledPlugins + statusLine + effort + env)
│   ├── codex.toml                  #   Codex 行为级配置(reasoning effort / 关闭响应存储)
│   ├── opencode.json               #   OpenCode 公共配置快照
│   └── codebuddy.json              #   CodeBuddy 公共配置快照
├── apps/                           # 各 app 装配指南
│   ├── claude.md                   #   superpowers 插件 + MCP + 技能 + 规则 + sync.sh
│   ├── codex.md                    #   superpowers 原生插件(openai/plugins) + sync.sh
│   ├── gemini.md                   #   Gemini & Antigravity(agy plugin install superpowers + GEMINI.md + 技能)
│   ├── opencode.md                 #   OpenCode(AGENTS.md + 技能 + 公共配置)
│   └── codebuddy.md                #   CodeBuddy(Claude 兼容 settings.json + rules + 技能)
├── open-source.md                  # 开源插件/技能清单 + 来源 + 安装/取舍(不 vendoring)
├── rules/                          # 【自定义】Claude / CodeBuddy always-on 规则(原生加载)
│   ├── architectural-coherence.md  #   改动后架构连贯性(极简总则,指向同名 skill)
│   ├── minimal-change.md           #   最小化变动/外科手术式改动(从属架构连贯:先连贯后最小)
│   ├── function-layout.md          #   文件内函数布局
│   ├── technical-writing.md        #   技术文档写作风格
│   ├── no-plaintext-secrets.md     #   不回显明文密钥
│   ├── diagrams-svg-first.md       #   技术文档图示用 SVG(或 mermaid),不用 ASCII
│   ├── no-auto-commit.md           #   未经明确要求不自动 commit
│   └── language.md                 #   简体中文交流
├── skills/                         # 【自定义】技能(sync.sh 同步到各端技能目录)
│   └── architectural-coherence/    #   架构连贯的详细实施手册(与同名 rule 配对:rule=总则 / skill=手册)
├── hooks/                          # 【自定义】可选钩子(当前停用,作备用)
│   ├── diagnose-gate.sh            #   诊断类提问时先给根因+方案再改码
│   └── README.md                   #   钩子说明 + 重新启用的配置
├── memories/
│   └── agent-principles.md         # 常驻准则 → ~/.gemini/GEMINI.md、~/.codex/AGENTS.md、~/.config/opencode/AGENTS.md、~/.codebuddy/AGENTS.md
└── scripts/
    └── sync.sh                     # 一键同步自定义资产到各 agent(见下)
```

## 自定义足迹（仅此而已）

经过"复用优先"收敛后,真正自定义的只有:

- `rules/` —— always-on 规则,Claude / CodeBuddy 原生加载。其中 `architectural-coherence` 经核实 superpowers 无等价物(总则);`minimal-change` 取代已退场的 karpathy-guidelines;其余为写作/密钥/图示/提交纪律。
- `skills/architectural-coherence/` —— 架构连贯 rule 的详细手册(按需触发;与 rule 同名配对)。
- `memories/agent-principles.md` —— 常驻准则 → `~/.gemini/GEMINI.md`(Gemini) / `~/.codex/AGENTS.md`(Codex,标记块) / `~/.config/opencode/AGENTS.md`(OpenCode) / `~/.codebuddy/AGENTS.md`(CodeBuddy)。保持 app-neutral。
- `config/` —— 各 agent 公共配置快照,sync.sh 直接应用。
- `scripts/sync.sh` —— 同步脚本。
- `hooks/diagnose-gate.sh` —— 可选 PreToolUse 钩子(当前停用作备用,见 `hooks/README.md`)。

其余全部依赖开源:**superpowers**(主框架,自带 14 技能) + Anthropic 官方文档技能(docx/pdf/pptx/xlsx)。

> **多端对齐**:工程纪律一致,载体统一 —— 各端安装 superpowers 原生插件,再叠一层薄自定义(Claude/CodeBuddy `rules/`、Gemini/Codex/OpenCode/CodeBuddy 的 AGENTS.md/GEMINI.md、`architectural-coherence` 技能),全部由 `scripts/sync.sh` 落地。

## 全新机器:应用流程

```bash
# 0) 装依赖:jq(sync.sh 做 JSON 合并用)
# 安装 jq

# 1) 一键同步自定义资产到全部 5 个 agent
./scripts/sync.sh                       # 或 --app claude 单独同步某一个;--dry-run 先预览

# 2) 各端装 superpowers 原生插件(工程纪律主框架;superpowers 由各 harness 自带插件管理器安装,本仓不管)
#    Claude:    在 claude 会话内 /plugin install superpowers@claude-plugins-official
#    Codex:     在 Codex CLI 会话内 /plugins → 搜 superpowers → Install Plugin
#    Gemini:    agy plugin install https://github.com/obra/superpowers
#    CodeBuddy: 应用内从 codebuddy-plugins-official 安装 superpowers

# 3) provider / 模型:各 agent 官方原生配置(Claude `claude` 登录 / Codex `codex login` /
#    OpenCode opencode.json / Antigravity 应用内设置 / CodeBuddy 应用内设置),本仓不接管。

# 4) 重启各客户端(插件/技能/规则在启动时加载)
```

各 app 细节见 `apps/`,技能见 `SKILLS.md`,插件取舍见 `open-source.md`。

## 已知坑

- **`enabledPlugins` / `skillOverrides` 是整体替换,非叠加**:sync.sh 用 `config/claude.json`(及 `codebuddy.json`)里的集合**整体覆盖** settings.json 中这两个字段,避免旧插件/旧覆盖被并回来。其它用户专属字段(permissions / mcpServers / model / theme / trustedDirectories)不动。
- **`ccstatusline` 需另装**:`config/claude.json` 里声明了 statusLine,但需本机存在 `ccstatusline` 命令,否则状态栏会报错(可删掉该段)。
- **`~/.claude/rules/` 是原生,不是插件加载**:Claude Code 的 memory feature 在启动时自动加载 `~/.claude/rules/*.md`(与 `CLAUDE.md` 同级)——这不受移除 ECC/任何插件影响。
- **superpowers 由各 harness 自装,不在本仓**:每个 harness 自己的插件管理器负责(Claude `enabledPlugins` / Codex `openai/plugins` / Antigravity `agy plugin install`);本仓只渲染 Claude 的 `enabledPlugins` 条目与公共配置。
- **重启才生效**:插件/技能/规则在客户端启动时加载;`claude -c` 也是新进程会重载配置,但上下文会带旧残影,干净起见可开新会话。