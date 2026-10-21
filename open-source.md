# 开源插件与技能

本仓只记录来源、安装和升级方式，不复制开源内容。自定义规则与技能见 `rules/`、
`skills/`；它们的同步边界见 [README](README.md#同步行为)。

## Superpowers

上游：[obra/superpowers](https://github.com/obra/superpowers)。工程方法包括需求澄清、
规划、TDD、调试、实现和评审；本仓的[流程校准规则](rules/plan-calibration.md)定义适用边界。

2026-10-21 核对：正式版 [7.0.0](https://github.com/obra/superpowers/releases/tag/v7.0.0)
含 15 个技能。本机 Claude、Codex、Antigravity 已安装该版；CodeBuddy 官方市场仍提供
4.0.3。市场版本可能落后于上游，安装后应核对实际版本，不能只看命令是否成功。

| 客户端 | 安装 | 升级 / 加载 |
|---|---|---|
| Claude | `claude plugin install superpowers@claude-plugins-official` | `claude plugin update superpowers@claude-plugins-official`；新开会话 |
| Codex | `/plugins` 搜索 Superpowers；公共目录落后时按下方正式版源安装 | 通过原生插件管理器更新；新开会话 |
| Antigravity | `agy plugin install https://github.com/obra/superpowers` | 重复同一命令更新；通过技能发现引导加载 |
| Gemini CLI | `gemini extensions install https://github.com/obra/superpowers` | `gemini extensions update superpowers`；与 Antigravity 分别安装 |
| OpenCode | 按[上游说明](https://github.com/obra/superpowers/blob/main/.opencode/INSTALL.md)安装 | 按上游方式更新；不由 `sync.sh` 安装 |
| CodeBuddy | `codebuddy plugin install superpowers@codebuddy-plugins-official` | `codebuddy plugin update superpowers@codebuddy-plugins-official`；版本由该市场决定 |

Antigravity 的引导机制见[上游发布说明](https://github.com/obra/superpowers/releases/tag/v7.0.0)：
通过 `using-superpowers` 的技能描述引导模型加载，不是 session-start hook。
各客户端的插件载体不同，以实际加载结果为准。

### Codex 固定正式版源

2026-10-21 公共目录仍返回 6.4.2，本机改用上游仓库中的原生插件市场：

```bash
codex plugin marketplace add obra/superpowers --ref v7.0.0
codex plugin add superpowers@superpowers-dev
codex plugin list --json
```

`superpowers-dev` 是上游清单中的市场名；源固定在正式标签 `v7.0.0`。
如果原先安装的是公共目录版本，确认新版安装成功后再移除旧登记，避免重复加载：

```bash
codex plugin remove superpowers@openai-curated-remote
```

固定标签不会因 `marketplace upgrade` 自动变成下一个版本。后续升级时，先通过
`codex plugin marketplace remove superpowers-dev` 移除旧市场源，再以新正式标签执行
`marketplace add` 和 `plugin add`，核对版本后新开会话。
以上命令由 Codex 管理插件登记；本仓的 `sync.sh` 不修改 `config.toml`。

## 其他 Claude 插件

来源：[anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official)，
通过 Claude 原生插件管理器安装。本仓 `config/claude.json` 管理启用表。

| 插件 | 用途 / 取舍 |
|---|---|
| `context7` | 实时库文档与 MCP |
| `gopls-lsp` / `pyright-lsp` / `clangd-lsp` | 按当前项目语言选择启用 |
| `code-simplifier` / `claude-md-management` | 需要时再启用，避免与现有方法重复 |
| `playwright` | 有 Web 自动化需求时再启用 |
| `telegram` | 受当前团队远程管理策略限制，未启用 |

ECC 曾作为主框架，因技能、agent、hook 和 MCP 范围过大退出。
`andrej-karpathy-skills` 的通用编码纪律已由现有方法与本地规则覆盖，不重复安装。

Office / PDF 与技能创建能力的来源、可见性和跨端差异统一见[技能清单](SKILLS.md)。
