# 技能 × 应用 启用矩阵（cc-switch SSOT）

cc-switch 把技能(SSOT)按"每个 app 是否启用"同步到各自的技能目录:
- Claude → `~/.claude/skills/`
- Codex → Codex 的技能目录
- Gemini → `~/.gemini/skills/`（**Antigravity / agy 直接读 `~/.gemini` 下的 skills 与 GEMINI.md**，故 gemini 列即 agy）

> 本表只管 **superpowers 未覆盖、由 cc-switch 同步**的技能。superpowers 自带的 14 个技能随各端插件走,不在此表。

| 技能 | 来源 | claude | codex | gemini(=agy) | 说明 |
|---|---|:---:|:---:|:---:|---|
| `docx` | anthropics/skills | ◐ | ✅ | ✅ | Word 文档读写 |
| `pdf` | anthropics/skills | ◐ | ✅ | ✅ | PDF 处理 |
| `pptx` | anthropics/skills | ◐ | ✅ | ✅ | 幻灯片 |
| `xlsx` | anthropics/skills | ◐ | ✅ | ✅ | 表格 |
| `skill-creator` | anthropics/claude-plugins-official | ◐ | ✅ | ✅ | 创建/优化技能 |
| `architectural-coherence` | **自定义**(本仓 `skills/`,已纳入 cc-switch SSOT) | ✅ | ✅ | ✅ | 架构连贯详细手册;superpowers 无等价物。与 Claude 同名 always-on 规则配对(rule=总则 / skill=手册) |

图例:✅ 启用(常驻) / ◐ 启用但 **name-only**(Claude 仅载描述、正文按需展开,省 token;codex/gemini 无此区分,等同启用) / ⬜ 未启用。**三端均启用,差异仅在 Claude 把体量大/低频的技能(文档技能 + `skill-creator`)设为 name-only。**

> 这些状态**可按需临时调整**(`cc-switch-cli skills enable/disable`,或在客户端里把某技能切成 name-only / 停用)。

> **主框架不在此表**:三端的工程纪律主要来自 **superpowers 原生插件**(Claude `enabledPlugins` / Codex `openai/plugins` / Antigravity `agy plugin install`,见 `apps/*.md`),其 14 技能随插件走、不经 cc-switch。本表是 superpowers 之外的补充层。

> **对齐说明**:三端载体已统一为 superpowers 插件;cc-switch 这一层负责补齐 superpowers 未覆盖的部分——① `architectural-coherence` 作为技能同步到三端(上表,superpowers 无等价物);② Claude 侧 `~/.claude/rules/` 的 always-on 规则(`architectural-coherence`/`minimal-change`/`function-layout`,Claude Code 原生加载);③ 常驻准则文件 `~/.gemini/GEMINI.md` 与 `~/.codex/AGENTS.md`(源自 `memories/agent-principles.md`,已覆盖上述规则,供无原生 rules 的端使用)。

## 维护命令（cc-switch）

```bash
# 查看 / 发现
cc-switch-cli skills list
cc-switch-cli skills discover                      # 从已启用的 skill repo 发现可装技能

# 安装/启用到某 app(SSOT -> app 技能目录)
cc-switch-cli skills install <name>                # 从 skill repo 安装(默认启用到 claude)
cc-switch-cli skills import-from-apps <dir> --apps claude,gemini   # 把手放的自定义技能纳入 SSOT 并启用
cc-switch-cli skills enable  <name> --app gemini   # 启用到 gemini(= agy 生效)
cc-switch-cli skills enable  <name> --apps claude,codex,gemini
cc-switch-cli skills disable <name> --app <app>    # 取消某 app(保留 SSOT 记录)
cc-switch-cli skills uninstall <name>              # 从 SSOT + 各 app 目录彻底移除
cc-switch-cli skills sync                           # 把"已启用"同步到各 app 技能目录
```
