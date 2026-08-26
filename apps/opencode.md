# OpenCode 装配方案

OpenCode 由本仓直接管理:常驻准则 / 技能 / 公共配置快照经 `scripts/sync.sh` 落地到 `~/.config/opencode/`。provider 与模型在 `opencode.json`(或项目 `.opencode/`)里官方原生配置,脚本不接管。

## 配置来源（本仓 → 落地）

| 层 | 本仓文件 | 落地位置 | 机制 |
|---|---|---|---|
| 公共配置 | `config/opencode.json` | `~/.config/opencode/opencode.jsonc` | `scripts/sync.sh`(合并进已存在的 json/.jsonc) |
| 常驻准则 | `memories/agent-principles.md` | `~/.config/opencode/AGENTS.md` | `scripts/sync.sh`(直接覆盖,文件完全托管) |
| 技能 | `skills/architectural-coherence/` | `~/.config/opencode/skills/` | `scripts/sync.sh` |
| Provider/模型 | 官方原生 | `opencode.json` / 项目 `.opencode/` | 脚本不管 |

## 能力构成

- **技能**: `architectural-coherence`(架构连贯手册)+ 开源文档技能(`docx`/`pdf`/`pptx`/`xlsx`/`skill-creator`,随 anthropics/skills 安装)。
- **常驻准则**: `~/.config/opencode/AGENTS.md` 承载方案先行 / 架构连贯 / 函数布局 / 最小变动等总则。

## 应用命令

```bash
# 1) 同步本仓自定义资产(AGENTS.md + 技能 + 公共配置)
./scripts/sync.sh --app opencode
```