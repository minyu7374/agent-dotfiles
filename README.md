# agent-dotfiles

Claude Code、Codex、Gemini / Antigravity、OpenCode、CodeBuddy 的共享配置真源。
`scripts/sync.sh` 同步自定义规则、技能、常驻准则和 Claude / CodeBuddy 公共配置。

本项目的贡献指令统一在 [AGENTS.md](AGENTS.md)。

## 维护边界

- **复用优先**：Superpowers 提供工程方法，本仓补充流程边界、架构一致性和个人约定。
- **按实际影响选择流程**：简单明确的任务直接处理，复杂任务再展开设计；详见[规划校准规则](rules/plan-calibration.md)。
- **开源内容不入库**：来源、安装、升级和版本状态集中在[开源插件清单](open-source.md)，技能说明见[SKILLS.md](SKILLS.md)。
- **原生管理 provider 和模型**：本仓不接管登录凭据、模型选择或 OpenCode JSON / JSONC 配置。

## 仓库资产

| 位置 | 职责 |
|---|---|
| `config/claude.json`、`config/codebuddy.json` | 两端公共配置快照 |
| `rules/` | Claude / CodeBuddy 原生加载的常驻规则 |
| `memories/agent-principles.md` | Codex、Gemini / Antigravity、OpenCode 的常驻摘要 |
| `skills/architectural-coherence/` | 各端共享的架构一致性手册 |
| `scripts/sync.sh` | 同步上述自定义资产 |
| `apps/` | 各客户端的来源、落地位置与应用说明 |
| `hooks/` | 可选诊断钩子，当前停用 |
| `remote-control/` | 远程控制接入和运维文档 |

## 同步行为

| 客户端 | 本仓同步内容 |
|---|---|
| [Claude](apps/claude.md) | `rules/`、自定义技能、公共 `settings.json` 字段 |
| [CodeBuddy](apps/codebuddy.md) | `rules/`、自定义技能、公共 `settings.json` 字段 |
| [Codex](apps/codex.md) | `AGENTS.md` 托管块、自定义技能；保留块外内容 |
| [Gemini / Antigravity](apps/gemini.md) | 完全托管的 `GEMINI.md`、自定义技能 |
| [OpenCode](apps/opencode.md) | 完全托管的 `AGENTS.md`、自定义技能 |

Claude / CodeBuddy 的公共配置按对象递归合并：快照中的值优先，未托管字段保留，
包括 `env` 中用户自己的变量。`enabledPlugins` 和 `skillOverrides` 两张表由本仓
整体替换，避免失效的插件和技能设置重新混入。

插件安装由各客户端的原生管理器完成，`sync.sh` 不下载插件或开源技能。
本机状态栏程序也需单独安装：Claude 使用 `ccstatusline`，CodeBuddy 使用
`$HOME/.codebuddy/statusline-command.sh`。

## 应用与检查

依赖 Bash、jq、Python 3。

```bash
# 预览与应用；也可用 --app claude|codex|gemini|opencode|codebuddy
./scripts/sync.sh --dry-run
./scripts/sync.sh

# 修改脚本或配置后的检查
bash -n scripts/*.sh hooks/*.sh
jq empty config/*.json
```

同步逻辑的验证在临时目录进行，核对用户字段保留、托管表替换和重复同步幂等性，
不在项目中保留测试脚本。

编辑快照不等于已经应用；同步后重启客户端或新开会话，再确认规则与插件加载结果。

## 远程控制

[远程控制方案](remote-control/README.md)记录 Herdr–Telegram、codex-tg 与 Herdr Mobile
的接入、部署和验收步骤。私密配置保留在本机，不由 `sync.sh` 同步。
