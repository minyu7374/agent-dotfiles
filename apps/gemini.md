# Gemini CLI & Antigravity(agy) 装配方案

> **agy = Antigravity**。它当前**直接读取 `~/.gemini` 下的 skills 与 `GEMINI.md`**,故本节同时覆盖 Gemini CLI 和 Antigravity。等官方对 agy 做进一步原生支持后再按需拆分。

Gemini/agy 现在通过 superpowers 的**原生插件**获得工程纪律主框架(`agy plugin install`),再叠 `GEMINI.md`(常驻准则)+ cc-switch 技能两层补齐 superpowers 未覆盖的部分。这与三端统一的载体一致。

## 能力构成（三层）

1. **superpowers 插件(主框架)** ← `agy plugin install https://github.com/obra/superpowers`。装为插件,**启动即跑 session-start hook,从第一条消息起生效**;重装同命令即更新。自带 14 个工程纪律技能。
2. **GEMINI.md(常驻准则层)** ← `~/.gemini/GEMINI.md`,承载方案先行 / 架构连贯 / 函数布局总则,并指向技能。本仓 `memories/agent-principles.md` 即对齐后的版本。
3. **技能层(cc-switch)** ← `architectural-coherence`(superpowers 无等价物),经 `cc-switch-cli skills --app gemini` 同步到 `~/.gemini/skills/`。

## 配置来源（本仓 → 落地）

| 层 | 来源 | 落地 | 机制 |
|---|---|---|---|
| 工程纪律主框架 | obra/superpowers | Antigravity 插件 | `agy plugin install https://github.com/obra/superpowers` |
| 常驻准则/记忆 | `memories/agent-principles.md` | `~/.gemini/GEMINI.md` | 直接放置(agy 也读它) |
| 补充技能 | 见 `cc-switch/skills-matrix.md` | `~/.gemini/skills/` | cc-switch-cli skills(`--app gemini`) |
| Provider/模型 | cc-switch providers(gemini: Google Official) | `~/.gemini/...` | `cc-switch-cli use --app gemini <id>` |

## 应用命令（全新机器复现）

```bash
# 1) superpowers 原生插件(主框架;含 session-start hook)
agy plugin install https://github.com/obra/superpowers

# 2) 常驻准则/记忆
cp memories/agent-principles.md ~/.gemini/GEMINI.md

# 3) 补充技能(纳入 cc-switch 后,enable 到 gemini 再 sync)
cc-switch-cli skills enable architectural-coherence --app gemini   # 自定义技能需先 import-from-apps 纳入 SSOT
cc-switch-cli skills sync                                          # 同步到 ~/.gemini/skills/

# 4) provider/模型
cc-switch-cli use --app gemini <provider-id>
```

## Antigravity 读取实情（已核实）

**Antigravity 全局/项目实际读哪些**:
- **全局(跨项目)**:`~/.gemini/GEMINI.md`、`~/.gemini/AGENTS.md`(纯规则 markdown)。`GEMINI.md` 与 Gemini CLI **共用同一文件**(gemini-cli #16058),一份即覆盖两者,但无法给两者配不同内容。
- **项目根**:`GEMINI.md`、`AGENTS.md`。**工作区**:`.agent/rules/`(单数 `agent`)。优先级:`GEMINI.md` > `AGENTS.md` > `.agent/rules/`。
- 全局 `~/.gemini/skills/` agy 确实读——本仓自始即按此搭建。

**插件/运行时(重要更正)**:Antigravity **有**原生插件系统——`agy plugin install <repo>` 装插件、跑其 session-start hook,superpowers 即经此落地。
> 旧文档曾基于 **ECC 的 `install.sh --target antigravity`** 得出"agy 全局只有规则 markdown、没有插件/运行时面"的结论。那只对 **ECC 的项目级 `install.sh`** 成立(它只写项目本地 `./.agent/`,够不到全局);**不适用于 agy 的原生 `plugin install`**。ECC 退场后此限制不再相关。

> `~/.gemini/antigravity-cli/`(settings.json / statusLine / trustedWorkspaces 等)是 **Antigravity 自管**的私有配置,不手动塞内容进去。
