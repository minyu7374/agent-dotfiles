# Codex CLI 装配方案

Codex **没有 Claude 的 plugin 概念**,能力来自三处:① 模型/行为级公共配置;② cc-switch 同步的技能;③ 常驻准则文件。由 cc-switch 以 `--app codex` 管理。

## 与 Claude 端的对齐方式（同 gemini,两层）

1. **常驻准则层** ← `~/.codex/AGENTS.md`(Codex 的全局 AGENTS 指令),承载方案先行 / 架构连贯 / 函数布局。来源:`memories/agent-principles.md`(与 gemini 的 `GEMINI.md` 同一份)。
2. **技能层** ← `karpathy-guidelines` + `architectural-harmony` 等,弥补无插件。

## 配置来源（本仓 → 落地）

| 层 | 本仓文件 | 落地 | 机制 |
|---|---|---|---|
| 公共配置(reasoning 等) | `cc-switch/common-config.codex.toml` | `~/.codex/config.toml` 注入段 | cc-switch 公共配置 |
| 常驻准则 | `memories/agent-principles.md` | `~/.codex/AGENTS.md` | 直接放置 |
| 技能 | 见 `cc-switch/skills-matrix.md` | `~/.codex/skills/` | cc-switch-cli skills(`--app codex`) |
| Provider/模型 | cc-switch providers(codex: 3 个) | `~/.codex/config.toml` | `cc-switch-cli use --app codex <id>` |

## 公共配置（已采用）

```toml
model_reasoning_effort = "high"
disable_response_storage = true
model_catalog_json = "cc-switch-model-catalog.json"
```

## 已启用技能（与 Claude 对齐）

`~/.codex/skills/` 现含 7 个:`architectural-harmony`、`karpathy-guidelines`、`skill-creator`、`docx`、`pdf`、`pptx`、`xlsx`。

## 应用命令（全新机器复现）

```bash
cc-switch-cli config common set --app codex --file cc-switch/common-config.codex.toml
cc-switch-cli skills enable karpathy-guidelines  --app codex
cc-switch-cli skills enable architectural-harmony --app codex
cc-switch-cli skills sync                                   # -> ~/.codex/skills/
cp memories/agent-principles.md ~/.codex/AGENTS.md      # 常驻准则
cc-switch-cli use --app codex <provider-id>                 # 渲染 ~/.codex/config.toml
```

> 注:Codex 的全局指令文件按 AGENTS.md 约定放在 `~/.codex/AGENTS.md`。若你的 Codex 版本用不同的全局指令路径,把 `agent-principles.md` 放到对应位置即可(内容不变)。
