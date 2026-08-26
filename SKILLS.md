# 技能清单（跨 app）

本仓承载的技能分两类:**自定义**(本仓 `skills/`,由 `scripts/sync.sh` 同步到各 app)与 **开源**(只记来源与安装方式,不 vendoring)。superpowers 自带的 14 个技能随各端插件走,不在此列。

## 自定义技能（sync.sh 同步到全部 5 个 app）

| 技能 | 来源 | 落地 | 说明 |
|---|---|---|---|
| `architectural-coherence` | 本仓 `skills/` | 各 app 技能目录 | 架构连贯详细手册;superpowers 无等价物。与 Claude/CodeBuddy 同名 always-on 规则配对(rule=总则 / skill=手册) |

各 app 技能目录:`~/.claude/skills/`(Claude)、`~/.codex/skills/`(Codex)、`~/.gemini/skills/`(**Antigravity / agy 直接读 `~/.gemini` 下的 skills 与 GEMINI.md**)、`~/.config/opencode/skills/`(OpenCode)、`~/.codebuddy/skills/`(CodeBuddy)。

## 开源技能（superpowers 未覆盖;随 anthropics/skills 安装）

| 技能 | 来源 | 用途 | Claude/CodeBuddy 加载态 |
|---|---|---|---|
| `docx` / `pdf` / `pptx` / `xlsx` | anthropics/skills | Office / PDF 文档处理 | **name-only**(仅载描述,用到才展开;省 token) |
| `skill-creator` | anthropics/claude-plugins-official | 创建 / 优化 / 评测技能 | **name-only**(低频) |

> **name-only vs on**:Claude / CodeBuddy 特有的技能加载态——`name-only` 只把技能描述放进上下文,正文按需加载,适合体量大、低频的文档技能;`on` 则常驻。codex / gemini / opencode 端无此区分,启用即可用。`config/claude.json` 与 `config/codebuddy.json` 里已把上述文档技能整体覆盖为 name-only。

> **主框架不在此表**:各端的工程纪律主要来自 **superpowers 原生插件**(Claude `enabledPlugins` / Codex `openai/plugins` / Antigravity `agy plugin install` / CodeBuddy 插件市场,见 `apps/*.md`),其 14 技能随插件走。

> **对齐说明**:各端载体统一为 superpowers 插件或共享技能库;本仓这一层负责补齐 superpowers 未覆盖的部分——① `architectural-coherence` 作为自定义技能同步到各端(superpowers 无等价物);② Claude & CodeBuddy 侧 `rules/` 的 always-on 规则;③ 常驻准则文件 `~/.gemini/GEMINI.md`、`~/.codex/AGENTS.md`、`~/.config/opencode/AGENTS.md` 与 `~/.codebuddy/AGENTS.md`(源自 `memories/agent-principles.md`,由 `scripts/sync.sh` 维护)。