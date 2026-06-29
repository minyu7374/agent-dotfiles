# 技能 × 应用 启用矩阵（cc-switch SSOT）

cc-switch 把技能(SSOT)按"每个 app 是否启用"同步到各自的技能目录:
- Claude → `~/.claude/skills/`
- Codex → Codex 的技能目录
- Gemini → `~/.gemini/skills/`（**Antigravity / agy 直接读 `~/.gemini` 下的 skills 与 GEMINI.md**，故 gemini 列即 agy）

| 技能 | 来源 | claude | codex | gemini(=agy) | 说明 |
|---|---|:---:|:---:|:---:|---|
| `docx` | anthropics/skills | ✅ | ✅ | ✅ | Word 文档读写 |
| `pdf` | anthropics/skills | ✅ | ✅ | ✅ | PDF 处理 |
| `pptx` | anthropics/skills | ✅ | ✅ | ✅ | 幻灯片 |
| `xlsx` | anthropics/skills | ✅ | ✅ | ✅ | 表格 |
| `skill-creator` | anthropics/claude-plugins-official | ✅ | ✅ | ✅ | 创建/优化技能 |
| `karpathy-guidelines` | forrestchang/andrej-karpathy-skills | ✅ | ✅ | ✅ | 编码行为准则;非 Claude 端用它弥补"无插件" |
| `architectural-harmony` | **自定义**(本仓 `skills/`,已纳入 cc-switch SSOT) | ✅ | ✅ | ✅ | 改动后架构连贯性的实施手册 |

图例:✅ 启用 / ⬜ 未启用。**当前三端(claude/codex/gemini=agy)全部一致启用。**

> **对齐说明**:Claude 端的工程准则来自插件(ECC/karpathy)+ always-on 规则;非 Claude 端(codex / gemini / agy)无插件,故用**两层**对齐:① 把 `karpathy-guidelines` 与 `architectural-harmony` **作为技能**启用(上表);② 各自的常驻准则文件 —— `~/.gemini/GEMINI.md`(gemini/agy)与 `~/.codex/AGENTS.md`(codex)—— 承载 Claude 那边由规则承载的"方案先行/架构连贯/函数布局"总则,二者同源自 `memories/agent-principles.md`。

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
