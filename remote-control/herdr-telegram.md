# Herdr Telegram 远程控制

Herdr 管理本机终端中的编码助手，Telegram Bridge 在任务完成或等待输入时发出通知。回复通知可向对应窗格提交下一条指令，也支持发送附件和读取终端输出。

## 接入方式

插件来源：[cokekitten/herdr-telegram-bridge](https://github.com/cokekitten/herdr-telegram-bridge)。

Codex 的 SessionStart hook 向 Herdr 登记窗格与会话。Herdr 的状态变化触发插件 `notify.py`，插件读取对应会话的最终回复并发送 Telegram；`bot.py` 长轮询接收回复，通过 `herdr agent prompt` 将输入交给对应窗格。

## 本机文件

| 路径 | 用途 |
|---|---|
| `~/.local/bin/herdr` | Herdr 程序 |
| `~/.config/herdr/config.toml` | Herdr 公共设置 |
| `~/.config/herdr/plugins/github/telegram.bridge-*/` | 插件程序，目录后缀由安装器生成 |
| `~/.config/herdr/plugins/config/telegram.bridge/config.toml` | Bot token、目标聊天及插件选项，权限 `0600` |
| `~/.local/state/herdr/plugins/telegram.bridge/` | 消息路由、附件 inbox 和 `bridge.log` |
| `~/.codex/hooks.json`、`~/.codex/herdr-agent-state.sh` | Codex 会话登记集成 |

## 配置说明

凭据和 Telegram 身份值只保存在上述私密配置中。主要选项为：

```toml
statuses = ["done", "blocked"]
snippet_chars = 0
markdown = true
max_messages = 20
fold = "auto"
replies = true
reply_to_latest = false
accept_files = true
```

`snippet_chars=0` 不按摘要字符数裁剪正文，长回复仍受 `max_messages` 限制。附件保留 7 天，大小上限 20 MB。通过 `chat_id` 指定目标聊天，`allowed_user_ids` 可进一步限制允许控制助手的用户。

## 日常使用

1. 在 Herdr 窗格内照常运行 Codex，等待 Telegram 通知。
2. **回复该通知**发送下一条指令；通过 `/agents` 选择目标后，也应回复目标确认消息再发送文本或附件。`reply_to_latest=false` 时，普通消息不会自动发给最近目标。
3. `/read 40` 查看目标的最近终端输出；`/esc` 发送 Escape 尝试中断；`/help` 查看帮助。

附件保存到本机 inbox，助手收到文件路径。`/esc` 是终端按键操作，不等同于 Codex App Server 的结构化中断或审批。

## 维护与验收

```bash
herdr plugin list
herdr integration status
herdr plugin action invoke bot-status --plugin telegram.bridge
herdr plugin action invoke bot-restart --plugin telegram.bridge
```

后两条调用插件动作，执行结果可在 Herdr 插件界面查看。日常维护无需重复安装插件，也无需改写 Codex 的 `notify` 配置。

验收时，在一个窗格请求明确的短回复，确认 Telegram 收到正文；回复通知让助手继续，确认目标窗格正确。完整正文依赖窗格登记的 Codex 会话准确；同目录多会话时按会话身份核对，不能只按目录判断。
