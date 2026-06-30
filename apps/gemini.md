# Gemini CLI & Antigravity(agy) 装配方案

> **agy = Antigravity**。它当前**直接读取 `~/.gemini` 下的 skills 与 `GEMINI.md`**,无需特殊处理 —— 因此本节同时覆盖 Gemini CLI 和 Antigravity。等官方对 agy 做原生支持后再按需拆分。

Gemini / agy **没有 plugin 概念**。ECC 虽有 `install.sh --target gemini/antigravity`,但**只能装到项目本地、且只有"规则"会被读到,够不到全局**(详见末尾「ECC 接入实情」)——故**全局不走 ECC 安装器**,能力来自:① `~/.gemini/skills/`(cc-switch-cli 以 `--app gemini` 同步);② `~/.gemini/GEMINI.md`(全局记忆 + 准则);③ provider/模型配置。本节即此方案。

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

## ECC 接入实情(求证结论)

> 一句话:**全局这块 ECC 的 `install.sh` 给不了,只能靠上面的 `GEMINI.md`(可选加 `AGENTS.md`)维护;`install.sh` 只能做项目级,且仅"规则"被读到。**

**Antigravity 实际读哪些**(已核实):
- **全局(跨项目)**:`~/.gemini/GEMINI.md`、`~/.gemini/AGENTS.md`(纯规则 markdown)。`GEMINI.md` 与 Gemini CLI **共用同一文件**(gemini-cli #16058),一份即覆盖两者,但无法给两者配不同内容。
- **项目根**:`GEMINI.md`、`AGENTS.md`。
- **工作区**:`.agent/rules/`(确认单数 `agent`)。
- 优先级:`GEMINI.md` > `AGENTS.md` > `.agent/rules/`。
- 注:Antigravity 工作区文档只说读 `.agent/rules/` 里的**规则**,未提 `.agent/skills`、`.agent/agents`、`.agent/workflows`,故 `install.sh` 项目级产物里这几类未必被消费。(全局 `~/.gemini/skills/` agy 确实读——本仓自始即按此搭建。)

**ECC `install.sh --target antigravity` 实际写哪**(已核实源码 `antigravity-project.js`):
- `kind: 'project'` + `rootSegments: ['.agent']` → 写**项目本地** `<项目根>/.agent/`,**绝不写 `~/.gemini` 或 `~/.gemini/antigravity-cli`**。
- install-targets 里**没有 `antigravity-home`**(对比 `claude-home`/`codex-home` 才是 `kind:'home'` → 写 `~/`),所以**任何参数都到不了全局**。
- 在 ECC 仓库里跑 = 写进 `ECC/.agent/`(没用);要进你的项目,得 `cd 你的项目` 再调 ECC 的 install.sh。

**可行性小结**:

| 目标 | 可行? | 怎么做 |
|---|---|---|
| 全局接入(所有项目) | `install.sh` ❌ | 维护 `~/.gemini/GEMINI.md`(本仓 `agent-principles.md`)+ 可选 `~/.gemini/AGENTS.md`;即本节上文方案 |
| 某仓库接入 ECC 规则 | ✅(仅规则) | 在该仓库 `./install.sh --profile minimal --target antigravity`(**别用 `core`**:`hooks-runtime` 在 agy 跑不起来);产物 `./.agent/rules/`,按仓库、在 cc-switch 之外 |
| 完整 ECC 运行时(agents/skills/hooks) | ❌ | Antigravity 全局只有规则 markdown,没有插件/运行时面,与装法无关 |

> `~/.gemini/antigravity-cli/`(settings.json / statusLine / trustedWorkspaces 等)是 **Antigravity 自管**的私有配置,ECC 不写、也不该手动塞 ECC 内容进去。
