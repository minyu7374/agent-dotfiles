# codex-tg 安装与远程控制

[mideco-tech/codex-tg](https://github.com/mideco-tech/codex-tg) 直接对接本机 Codex App Server，通过 Telegram 查看会话、接收最终回复、继续对话、停止执行和处理审批。操作按 Codex 的 `thread_id` 路由；服务通过本地 stdio 启动 App Server，不开放公网端口。

## 配置与文件

以下以 macOS 用户目录安装为例，使用上游 CLI 压缩包，无需安装 Go 或系统级 `.pkg`。其他系统及安装方式按[上游安装说明](https://github.com/mideco-tech/codex-tg/blob/main/docs/wiki/Quickstart.md)操作；表中路径以安装器实际生成结果为准，本仓库不预置这些文件或私密配置。

| 项目 | 路径 |
|---|---|
| 程序 | `~/.local/bin/ctr-go` |
| 私密配置 | `~/.codex-tg/config.env`，权限 `0600` |
| 服务定义 | `~/.codex-tg/service/tech.mideco.codex-tg.plist` |
| 状态数据库 | `~/.codex-tg/data/state.sqlite` |
| 日志 | `~/.codex-tg/logs/daemon.out.log`、`daemon.err.log` |
| 登录启动 | `~/Library/LaunchAgents/tech.mideco.codex-tg.plist` |

服务由用户级 LaunchAgent 管理，环境只指定 `CTR_GO_CONFIG`；Bot token、访问白名单和代理配置保存在私密配置文件中。

## 配置选项

- `CTR_GO_TELEGRAM_BOT_TOKEN`：独立 Bot 的 token。
- `CTR_GO_ALLOWED_USER_IDS`：允许控制 Codex 的 Telegram 数字用户 ID。
- `CTR_GO_ALLOWED_CHAT_IDS`：可选的聊天白名单。
- `CTR_GO_CODEX_BIN`：Codex 可执行文件的绝对路径。使用原生可执行文件可避免后台服务依赖 pnpm/Node 的交互式 PATH。
- `CTR_GO_APP_SERVER_LISTEN=stdio://`：使用本地进程管道。
- `CTR_GO_DEFAULT_CWD`：默认工作目录。
- `CTR_GO_CODEX_CHATS_ROOT`：Codex Chats 目录，通常为 `~/Documents/Codex` 的绝对路径。
- `CTR_GO_NOTIFY_NEW_RUN=false`：运行开始卡片静音，保留计划提示和最终回复提醒。

Codex 登录、规则、技能和 MCP 配置由 Codex 管理。

## 部署步骤

### 1. 安装程序

从 [GitHub Releases](https://github.com/mideco-tech/codex-tg/releases) 下载与本机架构对应的 `darwin_arm64` 或 `darwin_amd64` CLI 压缩包，按发布页的 `SHA256SUMS` 校验并解压。在解压目录执行：

```bash
mkdir -p ~/.local/bin
install -m 755 ctr-go ~/.local/bin/ctr-go
~/.local/bin/ctr-go version
```

### 2. 创建独立 Bot

在 Telegram 的 [BotFather](https://t.me/BotFather) 使用 `/newbot` 创建专用于 codex-tg 的 Bot，保存 token，并向新 Bot 私聊发送 `/start`。若同时使用 Herdr Telegram Bridge，应为两者创建不同 Bot：两套 poller 消费同一个 Bot 会冲突。

### 3. 获取数字用户 ID

需要 Telegram 数字用户 ID，而不是 `@用户名`。如果你已知道 ID，可直接进入下一步。否则，在启动新 Bot 的 poller 前，在本机普通终端执行下面的只读查询。token 通过隐藏输入提供，不要贴到聊天或命令参数中。

```bash
python3 - <<'PY'
import getpass, json, urllib.request

token = getpass.getpass("新 Bot token（不回显）: ")
request = urllib.request.Request(
    f"https://api.telegram.org/bot{token}/getUpdates",
    data=json.dumps({"timeout": 0, "allowed_updates": ["message"]}).encode(),
    headers={"Content-Type": "application/json"},
)
try:
    with urllib.request.urlopen(request, timeout=20) as response:
        body = json.load(response)
except Exception:
    raise SystemExit("查询失败；请检查新 Bot token 和 Telegram 网络连通性。")
messages = [u["message"] for u in body.get("result", []) if "message" in u]
messages = [m for m in messages if m.get("chat", {}).get("type") == "private"]
if not messages:
    raise SystemExit("请先向新 Bot 私聊发送 /start，再运行此查询。")
message = messages[-1]
print("User ID:", message["from"]["id"])
print("Private chat ID:", message["chat"]["id"])
PY
```

### 4. 配置并启动服务

```bash
~/.local/bin/ctr-go service install --start --start-at-login
```

向导要求填写 Bot token、允许的用户 ID、可选聊天 ID、默认工作目录、Chats root、Codex 路径和通知选项；私聊使用上一步查询到的 chat ID。向导把配置保存在本机，并注册登录启动、启动服务。已有配置文件需要更新时，在命令中加 `--force`；向导会读取已有配置作为默认值。

如本机访问 Telegram 依赖代理，请在运行向导的终端先配置所需代理环境；安装器会将支持的代理变量保存在私密配置，供后台服务使用。

### 5. 在 Telegram 启用并验收

```text
/start
/observe all
/threads
/status
```

- 在电脑端完成一轮简单任务，确认收到最终回复。
- 选择会话或回复对应卡片继续任务，用 `/context` 核对会话和目录。
- 在两个同目录会话中分别发出不同请求，确认回复路由正确。
- 在测试会话中验证 `/stop`，以及需要审批时的 `/approve`、`/deny`。

电脑端已有会话的工具面板展示已完成工具；Telegram 发起的任务支持当前工具的实时展示。

## 日常维护

```bash
ctr-go service status
ctr-go doctor
ctr-go service stop
ctr-go service start
ctr-go service restart
ctr-go service disable-login
```

停止或重启服务可能中断 Telegram 发起的运行，先等待任务结束。Codex 升级后，确认 `CTR_GO_CODEX_BIN` 仍指向有效版本；pnpm 清理旧包后可能需要更新该路径。

`ctr-go doctor` 展示配置与持久状态；Telegram 连通性通过 `/status` 和实际收发验证。

来源：[发布包](https://github.com/mideco-tech/codex-tg/releases)、[安装说明](https://github.com/mideco-tech/codex-tg/blob/main/docs/wiki/Quickstart.md)、[运行维护](https://github.com/mideco-tech/codex-tg/blob/main/docs/wiki/Operations.md)、[Telegram Bot API](https://core.telegram.org/bots/api#getupdates)。
