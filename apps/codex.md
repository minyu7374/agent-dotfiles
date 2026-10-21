# Codex CLI 装配方案

Codex CLI 有原生插件系统:superpowers 通过官方 `openai/plugins` 市场直接安装。工程纪律主框架由 superpowers 插件承载;本仓的自定义准则经 `scripts/sync.sh` 同步进 `~/.codex/`。provider 与模型用 Codex 官方方式配置(`codex login` / `codex` 配置),脚本不接管。

## 能力来源

| 来源 | 内容 |
|---|---|
| **superpowers 原生插件**(openai/plugins 市场) | 14 个工程纪律技能(brainstorming / TDD / systematic-debugging / writing-plans / executing-plans / code-review / worktrees 等)+ session bootstrap;随插件走 |
| **`~/.codex/AGENTS.md`**(自定义准则) | `memories/agent-principles.md` 的精简规则标记块(`<!-- agent-dotfiles:begin/end -->`),由 sync.sh 维护;块外内容保留 |
| **自定义技能** | `architectural-coherence`(架构连贯手册),经 sync.sh 同步到 `~/.codex/skills/` |
| **Codex 配置 / Provider / 模型** | 官方原生(`codex login` / `~/.codex/config.toml`),脚本不接管 |

## 配置来源（本仓 → 落地）

| 层 | 来源 | 落地 | 机制 |
|---|---|---|---|
| 工程纪律主框架 | openai/plugins 市场 | Codex 插件面 | 会话内 `/plugins` → 搜 `superpowers` → Install Plugin |
| 常驻准则 | `rules/` 的精简形式 `memories/agent-principles.md` | `~/.codex/AGENTS.md`(标记块) | `scripts/sync.sh` |
| 补充技能 | `skills/architectural-coherence/` | `~/.codex/skills/` | `scripts/sync.sh` |
| Codex 配置 / Provider / 模型 | 官方原生 | `codex login` / `~/.codex/config.toml` | 脚本不管 |

## 应用命令（全新机器复现）

```bash
# 1) superpowers 原生插件(工程纪律主框架)
#    在 Codex CLI 会话内: /plugins → 搜 superpowers → 选 Install Plugin

# 2) 同步本仓自定义资产(常驻准则标记块 + 技能)
./scripts/sync.sh --app codex
```

> **`~/.codex/AGENTS.md` 是本仓资产**:内容 = `memories/agent-principles.md`(以标记块维护,幂等)。你在块外写的内容会被保留。常驻准则定义本项目的流程边界，superpowers 提供边界内适用的方法。
>
> **`~/.codex/config.toml` 由 Codex 原生管理**:sync.sh 不读取或写入该文件。

## 流程选择与校准

[规划校准规则](../rules/plan-calibration.md)规定：按当前需求、实际影响和已有证据，选择足够完成任务的最轻流程。简单明确的改动直接处理；非简单但范围明确的改动先给简短设计并批准；涉及共享契约、组件关系、数据迁移或重要未决决策时，再展开详细设计。

信息不足先针对性查证，不因“不熟悉”或“新增文件”自动升级。新证据表明当前方案不足时升级；用户澄清、原假设被否定或风险消除后允许降级。调整只影响相关部分，保留已确认目标、约束和必要验收，删除只由失效假设支撑的行为与检查。

Codex 通过 `memories/agent-principles.md` 的常驻摘要接收这些边界，`rules/plan-calibration.md` 不单独同步到 Codex。摘要明确覆盖第三方技能默认的全任务强制触发、单向升级和重复审批；流程升级不授权扩大实现范围。架构一致性技能保持原样，必要的调试、验证和权限要求继续适用，简洁以当前整体结构为准。

只维护仓库内的规则真源，不直接修改插件缓存。更新后先运行 `./scripts/sync.sh --app codex --dry-run`，再运行 `./scripts/sync.sh --app codex`；核对 `~/.codex/AGENTS.md` 托管块与摘要一致，并在新会话中确认这些准则已进入上下文。文件已同步不等于现有会话已重新加载，也不能仅凭文件存在保证模型遵守。

验证时覆盖四种情景：个人更新函数保持简单；新增能力允许必要的结构重塑；用户收窄需求后删除多余设计；发现真实的数据迁移问题时补足设计与授权。检查是否同时避免了无需求扩展和不断堆积的临时补丁。
