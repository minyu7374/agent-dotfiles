# 远程控制方案

通过 Telegram、手机 PWA 或原生 App 接收本机编码助手的通知，并远程继续任务。这里记录方案、部署步骤与验收要求；私密配置、运行数据和程序留在本机，`scripts/sync.sh` 不管理它们。

| 方案 | 接入方式 |
|---|---|
| [Herdr Telegram](herdr-telegram.md) | Herdr 管理终端窗格，Telegram Bridge 转发通知和输入 |
| [codex-tg](codex-tg.md) | 直接对接 Codex App Server，按会话路由通知与操作 |
| [Herdr Mobile](herdr-mobile.md) | 原生 App 与浏览器各用配套 relay；文档包含独立站点与 SSH 反向转发的部署示例 |

两套 Telegram 方案使用不同的 Bot，可并行使用。两种 Mobile 方案各自配套客户端和 relay，不能交叉连接；各入口分别管理凭据。Bot token、Telegram 身份值、配对凭据和日志不得写入仓库。

## 部署说明

Herdr Telegram 的配置和操作见[方案说明](herdr-telegram.md)。codex-tg 使用用户目录安装；准备独立 Bot 和 Telegram 数字用户 ID 后，按[部署步骤](codex-tg.md#部署步骤)配置服务并验收。

运行 Herdr 的电脑没有公网 IP 时，浏览器与原生 App 均可通过 SSH 反向转发接入；按需使用单台或多台中转，网页 gateway 为可选传输。[Herdr Mobile](herdr-mobile.md)区分上游安装入口与自定义部署示例，目录、端口及服务名需按实际环境配置。
