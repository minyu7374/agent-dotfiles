# Gemini CLI & Antigravity(agy) 装配方案

> **agy = Antigravity**。它当前**直接读取 `~/.gemini` 下的 skills 与 `GEMINI.md`**,无需特殊处理 —— 因此本节同时覆盖 Gemini CLI 和 Antigravity。等官方对 agy 做原生支持后再按需拆分。

Gemini / agy **没有 plugin 概念**,能力来自:① `~/.gemini/skills/`(cc-switch 以 `--app gemini` 同步);② `~/.gemini/GEMINI.md`(全局记忆 + 准则);③ provider/模型配置。

## 与 Claude 端的对齐方式

Claude 端的工程准则 = 插件(ECC/karpathy)+ always-on 规则(architectural-coherence / function-layout)。Gemini/agy 无插件,故用**两层**对齐:

1. **GEMINI.md(常驻准则层)** ← 承载 Claude 那边由"规则"承载的部分:方案先行、架构连贯、函数布局,并指向技能。本仓 `memories/agent-principles.md` 即对齐后的版本。
2. **技能层** ← 把准则的"详细方法论"作为技能启用,弥补无插件。

## 配置来源（本仓 → 落地）

| 层 | 本仓文件 | 落地 | 机制 |
|---|---|---|---|
| 常驻准则/记忆 | `memories/agent-principles.md` | `~/.gemini/GEMINI.md` | 直接放置(agy 也读它) |
| 技能 | 见 `cc-switch/skills-matrix.md` | `~/.gemini/skills/` | cc-switch-cli skills(`--app gemini`) |
| Provider/模型 | cc-switch providers(gemini: Google Official) | `~/.gemini/...` | `cc-switch-cli use --app gemini <id>` |

## 已启用技能（与 Claude 对齐）

`~/.gemini/skills/` 现含:`architectural-harmony`、`karpathy-guidelines`、`skill-creator`、`docx`、`pdf`、`pptx`、`xlsx`。
其中 `karpathy-guidelines`(编码纪律)与 `architectural-harmony`(架构连贯手册)是为对齐 Claude 而启用的。

## 应用命令（全新机器复现）

```bash
# 记忆/准则
cp memories/agent-principles.md ~/.gemini/GEMINI.md

# 技能(纳入 cc-switch 后,enable 到 gemini 再 sync)
cc-switch-cli skills enable karpathy-guidelines  --app gemini
cc-switch-cli skills enable architectural-harmony --app gemini   # 自定义技能需先 import-from-apps 纳入 SSOT
cc-switch-cli skills sync                                          # 同步到 ~/.gemini/skills/

# provider/模型
cc-switch-cli use --app gemini <provider-id>
```

> Antigravity 另有自己的 `~/.gemini/antigravity-cli/settings.json`(statusLine / trustedWorkspaces)与 `builtin/skills`、`brain`、`knowledge` 等私有体系 —— 当前不纳入 cc-switch 管理,等官方原生支持再议。它对工程准则的读取走 `~/.gemini/GEMINI.md` + `~/.gemini/skills/`,已被上面的对齐覆盖。
