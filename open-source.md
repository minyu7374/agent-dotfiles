# 开源插件 & 技能清单（不 vendoring，仅记来源 + 安装方式）

这些内容从各自 marketplace / repo 拉取,本仓**不复制内容**,只记录"装什么、从哪来、怎么装、为何装/不装"。自定义内容见 `rules/`、`skills/architectural-harmony/`。

## Marketplaces（插件市场）

| 名称 | 来源 |
|---|---|
| `claude-plugins-official` | github: anthropics/claude-plugins-official |
| `ecc` | git: <https://github.com/affaan-m/everything-claude-code.git> |
| `karpathy-skills` | github: forrestchang/andrej-karpathy-skills |

```bash
# 注册 marketplace（若全新机器）
claude  # 进入后用 /plugin 添加,或在 cc-switch 公共配置的 extraKnownMarketplaces 里声明（已含 ecc / karpathy-skills）
```

## Claude 插件（plugin 是 Claude Code 专属概念）

主框架 = **ECC**。启用集保持精简,避免与 ECC 的 228 skills / 60 agents 重叠。

### ✅ 启用（5）

| 插件 | 市场 | 作用 |
|---|---|---|
| `ecc` | ecc | **主框架**:agents / skills / commands / hooks / MCP(context7·exa·github·memory·playwright·sequential-thinking) |
| `gopls-lsp` | official | Go 语言服务 |
| `pyright-lsp` | official | Python 语言服务 |
| `clangd-lsp` | official | C/C++ 语言服务（通用底座,主流语言默认带上） |
| `context7` | official | 实时库文档（与 ECC 正交;ECC 亦自带 context7 MCP,二者不冲突） |

### ⬜ 已安装但停用（6）— 故意不启用,原因如下

| 插件 | 停用原因 |
|---|---|
| `superpowers` | 同类整框架,与 ECC 重叠最严重;主框架定为 ECC 后退场 |
| `code-simplifier` | ECC 有 refactor-clean / code-simplifier agent 覆盖 |
| `claude-md-management` | ECC 有 doc-updater;需要时再开 |
| `andrej-karpathy-skills` | 改用其中的 `karpathy-guidelines` **技能**(经 cc-switch 管理),不整插件 |
| `playwright` | 后端为主,无 Web 自动化需求;ECC 亦自带 playwright MCP |
| `telegram` | 本想用其远程控制功能,但当前 team 订阅的 Claude 对远程管理有限制(管理员配置),故未启用 |

> 停用 = 不加载(已从 `enabledPlugins` 移除)。仍想从磁盘彻底卸载:`/plugin` 里 uninstall。

## 开源技能（跨 app，cc-switch 管理）

| 技能 | 来源 | 用途 |
|---|---|---|
| `docx` / `pdf` / `pptx` / `xlsx` | anthropics/skills | Office / PDF 文档处理 |
| `skill-creator` | anthropics/claude-plugins-official | 创建 / 优化 / 评测技能 |
| `karpathy-guidelines` | forrestchang/andrej-karpathy-skills | LLM 编码行为准则(think-before-coding / simplicity / surgical / goal-driven) |

启用矩阵与命令见 `cc-switch/skills-matrix.md`。
