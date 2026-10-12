# Herdr Mobile 方案

运行 Herdr 的电脑没有公网 IP 时，可以通过 SSH 反向转发接入中转服务器。Web 与原生 App 使用各自配套的 relay，按需选择一种或同时部署。

本文以家用和 VPS 网页入口共用一个 Web relay、原生 App 另用独立 relay 为部署示例。可只使用一个入口或一台中转；下文端口、目录和自定义服务名用于说明配置关系，不是上游默认值，也不会由本仓库自动创建。

## 入口与组件

| 用途 | 家用中转网页 | VPS 中转网页 | Android App |
|---|---|---|---|
| 上游 | [0cv/herdr-mobile-relay](https://github.com/0cv/herdr-mobile-relay) | 同左 | [teasec4/herdr-mobile-app](https://github.com/teasec4/herdr-mobile-app) |
| 入口示例 | `https://herdr-web.example.com` | `https://herdr-relay.example.com` | `https://herdr-mobile.example.com` |
| 本机服务 | Web relay | 同左 | `herdrelay` |
| 本机端口 | TCP `8377`、事件 UDP `8378` | 同左 | TCP `8375` |
| 中转端口 | `127.0.0.1:18377` | 每台 VPS 的 `127.0.0.1:18379` | 每台 VPS 的 `127.0.0.1:18375` |
| 配对 | Web relay 设备授权、一次性邀请 | 共用 Web relay 的设备状态 | 共享 relay token |

示例中的 relay 仅监听 loopback。使用多台中转时，可将入口域名解析到这些服务器，各中转转发到配套的 relay。DNS 多地址不等于自动故障切换，切换取决于客户端及 DNS 缓存。运行 Herdr 的电脑离线时，远程入口无法控制会话。

App v0.4.0 的 `funnel` 模式忽略自定义端口，因此公网入口使用标准 **443**。网页版支持显式 HTTPS/WSS 端口。[App 地址构造](https://github.com/teasec4/herdr-mobile-app/blob/v0.4.0/client/lib/models/pair_config.dart)

## 安装与自定义部署示例

先按对应上游项目的说明安装，下面两种客户端按需选择：

```bash
# Web / PWA
herdr plugin install 0cv/herdr-mobile-relay
# 原生 App
herdr plugin install teasec4/herdr-mobile-app/plugin
```

以下是 macOS 上自行管理发布包、Nginx 和 SSH 隧道的部署示例。使用上游安装器管理服务时，以安装器生成的路径、服务和配置为准；其他操作系统使用各自的服务管理方式。

![原生 App 接入结构](images/herdr-mobile-app.svg)

![网页接入结构](images/herdr-mobile-pwa.svg)

手动部署时下载固定版本发布包，按发布说明安装。示例中的两个网页入口转发到同一个 Web relay；不能只部署 App 项目的 Flutter Web 骨架。所有 relay 使用运行 Herdr 的用户所对应的程序路径、socket 和主目录。

| 示例位置 | 内容 |
|---|---|
| `/usr/local/libexec/herdr-mobile/` | App relay |
| `/usr/local/libexec/herdr-web/releases/<版本>/` | 网页完整发布包，`current` 指向所选版本 |
| `/usr/local/etc/herdr-mobile/`、`herdr-web/`、`herdr-relay/` | 专用 SSH 配置 |
| `/usr/local/var/log/herdr-mobile/`、`herdr-web/`、`herdr-relay/` | 日志 |
| `/Library/LaunchDaemons/` | 系统级 relay 与隧道启动配置 |
| `~/.config/herdr/herdrelay.token`、`herdrelay.id` | App 凭据及身份 |
| `~/.config/herdr-web/relay.env` | Web relay 环境、凭据和设备状态 |

App 设置 `HERDRELAY_MODE=lan`、`HERDRELAY_LISTEN=127.0.0.1:8375`；配对链接使用 `mode=funnel`，公网 TLS 在中转终止。

网页环境如下；另设置实际 `HERDR_BIN`、`HERDR_SOCKET_PATH`、`HERDR_RELEASE_ROOT`、`HERDR_WEB_ROOT`，生成 Web 专用的 32 字符 `HERDR_RELAY_TOKEN` 和稳定的 `HERDR_RELAY_INSTANCE_ID`：

```bash
HERDR_RELAY_HOST=127.0.0.1
HERDR_RELAY_PORT=8377
HERDR_RELAY_PLUGIN_PORT=8378
HERDR_ALLOWED_ORIGINS=https://herdr-web.example.com
HERDR_PHONE_APP_URL=https://herdr-web.example.com
HERDR_GATEWAY_URL=
HERDR_TRANSPORT_FORCE_RELAY=1
HERDR_REACHABILITY_PORT_MAPPING=0
HERDR_RELAY_REARM_BOOTSTRAP=0
```

`HERDR_PHONE_APP_URL` 指定通知默认打开的网页入口；另一网页入口仍可独立访问和配对。

两个网页入口使用各自的域名和中转站点，经 SSH 隧道接入同一 Web relay。通过 `HERDR_RELAY_ENV` 指定其私密环境文件，固定设备状态目录；启动器加载环境后执行 `herdr-mobile-relay serve`。网页与 `/ws` 均由配套 relay 提供，此路径不需要额外 gateway。

## Web relay 升级

通过 Herdr 插件安装的 Web relay，按[上游升级说明](https://github.com/0cv/herdr-mobile-relay/blob/main/docs/updates.md)更新；手动更新入口与安装入口相同：

```bash
herdr plugin install 0cv/herdr-mobile-relay
```

自行管理发布包和服务时，从[上游 Releases](https://github.com/0cv/herdr-mobile-relay/releases)下载匹配系统和架构的完整发布包，同时更新 relay 程序与配套网页资源，再重启实际部署的 relay 服务。保留私密配置和设备状态；跨不兼容版本时按上游迁移说明处理配对。

## SSH 与常驻管理

从既有连接复制主机、用户、端口和密钥参数，不复制其他 `RemoteForward`。每台中转使用独立 SSH 进程：

```sshconfig
Host herdr-relay
  HostName <中转地址>
  User <SSH用户>
  Port <SSH端口>
  IdentityFile <私钥绝对路径>
  IdentitiesOnly yes
  IdentityAgent none
  ControlMaster no
  ControlPath none
  BatchMode yes
  ConnectTimeout 10
  ServerAliveInterval 30
  ServerAliveCountMax 3
  ExitOnForwardFailure yes
```

```bash
# 网页中转；SSH 配置中的 Host 使用 herdr-web-relay
ssh -F /usr/local/etc/herdr-web/ssh.conf -NT \
  -R 127.0.0.1:18377:127.0.0.1:8377 herdr-web-relay

# App 每台 VPS 各一条，配置对应的 Host 别名
ssh -F /usr/local/etc/herdr-mobile/vps-ssh.conf -NT \
  -R 127.0.0.1:18375:127.0.0.1:8375 <App中转别名>

# VPS 网页每台各一条，使用另一份 SSH 配置和 Host 别名
ssh -F /usr/local/etc/herdr-relay/vps-ssh.conf -NT \
  -R 127.0.0.1:18379:127.0.0.1:8377 <网页中转别名>
```

在 macOS 的系统级 launchd 示例中，将命令逐参数写入 plist 的 `ProgramArguments`，不加 `-f`。自定义标签可使用 `local.herdr-web-relay`、`local.herdr-web-tunnel` 等名称，后续命令中的 `<标签>` 替换为实际服务标签。

设置 `UserName` 为运行 Herdr 的用户，配置 `HOME`、`PATH`、`RunAtLoad`、`KeepAlive`、`ThrottleInterval=10`、`Umask=63` 和日志路径。系统级 plist 归管理员所有、权限 `0644`；私密目录 `0700`，凭据及日志文件 `0600`。用户级 LaunchAgent 的路径和服务域不同，不能直接套用下面的 `system` 命令。

```bash
sudo plutil -lint /Library/LaunchDaemons/<标签>.plist
sudo launchctl bootstrap system /Library/LaunchDaemons/<标签>.plist
sudo launchctl print system/<标签>
sudo launchctl kickstart -k system/<标签>  # 按需重启
```

修改 plist 后先 `launchctl bootout system/<标签>`，再 `bootstrap`。迁移后卸载并归档旧服务，避免重复隧道。

若只使用网页，可保留配置，停用原生 App relay 及其隧道。对自行创建的系统级服务依次执行 `sudo launchctl disable system/<标签>`、`sudo launchctl bootout system/<标签>`；恢复时依次执行 `enable` 和 `bootstrap`。使用上游服务管理入口安装的部署，按其说明启停。

### 动态 IP 与 DDNS

家用中转的公网 IP 会变化时，SSH 的 `HostName` 使用 DDNS 域名，不固定为某次解析得到的 IP。IP 变化会使原有 TCP 连接失效，SSH 不能把已有连接迁移到新 IP；退出后由 launchd 启动新的 SSH 进程，重新通过系统解析器获取地址。恢复仍受 DDNS 更新周期和 DNS 缓存影响，不能只按保活间隔估算。[OpenSSH 地址解析实现](https://github.com/openssh/openssh-portable/blob/master/ssh.c)

浏览器入口与 SSH 目标的解析都需要跟随地址变化。若由同一台家用中转承载，可将 `herdr-web.example.com` 配置为指向 DDNS 域名的 CNAME，移除该名称原有的独立 A、AAAA 记录；也可让 DDNS 同步维护这些入口记录。只发布当前可达的 IPv4、IPv6 地址。CNAME 不改变浏览器访问的域名，Nginx 的 `server_name` 和证书仍需覆盖网页入口。

### 双端保活与远端端口释放

客户端的 `ServerAliveInterval 30`、`ServerAliveCountMax 3` 用于发现失联服务器，通常约 90 秒后退出，再由 launchd 重试。`ExitOnForwardFailure yes` 确保远端监听端口绑定失败时退出，但不检查转发目标的 HTTP 服务是否正常。[OpenSSH 客户端配置](https://man.openbsd.org/ssh_config)

服务器也需要探测失联客户端。否则客户端断网、休眠或网络地址变化后，旧 `sshd` 会话可能继续占着远端端口，新连接会持续报 `remote port forwarding failed`。建议在服务器已有的 `sshd_config` Include 目录中添加独立配置，例如 `/etc/ssh/sshd_config.d/zz-tunnel-alive.conf`；含 `Match` 的文件应在其他全局配置之后读取。将 `<SSH用户>` 替换为实际隧道账户：

```sshconfig
Match User <SSH用户>
    ClientAliveInterval 30
    ClientAliveCountMax 3
Match all
```

该策略对指定账户的全部 SSH 连接生效。正常客户端会自动应答，不会仅因用户没有输入而被断开；失联客户端通常约 90 秒后被断开，并释放所属转发端口。[OpenSSH 服务端配置](https://man.openbsd.org/sshd_config#ClientAliveInterval)

在服务器上先检查配置，再使用其服务管理器 reload。systemd 且服务名为 `sshd` 时：

```bash
sudo sshd -t
# 将占位值替换为实际连接参数，确认 Match 后的有效配置
sudo sshd -T -C 'user=<SSH用户>,host=<客户端主机名>,addr=<客户端IP>' \
  | rg -i '^clientalive'
# 前述检查通过后执行
sudo systemctl reload sshd
```

reload 后的新连接使用新配置，已有会话不会自动应用。若远端转发端口被失效会话占用，可在 Linux 中转机用 `sudo ss -ltnp 'sport = :<远端端口>'` 定位占用者，确认其为失效的隧道会话且未承载其他连接后，仅终止该会话，让客户端服务管理器自动重连。手动清理可临时恢复，服务端保活用于自动释放这类端口。仅重启本机 SSH 或换用 autossh，不能保证远端失效会话立即释放端口；DNS 记录未更新的问题仍需独立处理。

### 普通 SSH 与 autossh 的选择

macOS 上已有 launchd 管理的隧道，优先使用前台 `ssh -NT`、上述客户端保活、`ExitOnForwardFailure yes` 和 launchd 重试。autossh 的 `-M 0` 关闭转发探测，只在 SSH 退出后重启；在这个配置下，其重启职责可由 launchd 承担。启用非零 `-M` 时，autossh 另有转发回环探测能力，不能直接视为等价。autossh 同样需要服务端保活来释放失效会话的监听端口。[autossh 官方说明](https://www.harding.motd.ca/autossh/README.txt)

迁移既有 `autossh -M 0` 服务时，将程序换为 `/usr/bin/ssh`，移除 autossh 专用的 `-M` 参数和 `AUTOSSH_*` 环境变量，保留 SSH 参数，并确认 `ConnectTimeout 10`、`ServerAliveInterval 30`、`ServerAliveCountMax 3` 和 `ExitOnForwardFailure yes` 生效。继续由 launchd 前台管理，不使用 `-f`。同时核对 `KeepAlive` 的布尔或条件字典语义、退出码处理、`ThrottleInterval`，保留定时启停服务的调度关系；不能只替换可执行文件而忽略这些差异。完成 plist 校验、卸载旧实例并重新加载后，确认远端端口只有一个有效占用者，再从网页或 `/readyz` 验证完整转发链路。

带定时启停的 launchd 服务，定时停止应先 `disable`、再 `bootout` 主任务，避免只发送 `SIGTERM` 后被 KeepAlive 重新启动；定时启动执行 `enable`、按需 `bootstrap` 和 `kickstart`。常驻与定时模式不能同时占用同一远端端口。迁移前备份原配置，按实际需要保留或调整启停状态。

## 独立站点配置

只操作 Herdr 独立配置，主站及其他子域名保持原样。域名与证书由部署者准备；证书未就绪时先验收内部转发，再加载 TLS 配置。

### 网页：Nginx 终止 TLS

保存为实际 include 目录中的 `herdr-web.conf`：

```nginx
map $http_upgrade $herdr_web_connection_upgrade {
    default upgrade;
    '' close;
}
server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name herdr-web.example.com;
    ssl_certificate /path/to/fullchain.pem;
    ssl_certificate_key /path/to/privkey.pem;
    client_max_body_size 32m;
    location / {
        proxy_pass http://127.0.0.1:18377;
        proxy_http_version 1.1;
        proxy_set_header Host $http_host;
        proxy_set_header Authorization $http_authorization;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $herdr_web_connection_upgrade;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_buffering off;
        proxy_read_timeout 300s;
        proxy_send_timeout 300s;
    }
}
```

保留 Host 中的端口。带密钥的浏览器连接由加密握手授权；`HERDR_ALLOWED_ORIGINS` 仅限制无令牌的本地开发连接。网页首页可能重定向到带版本的 HTML，验收时检查最终页面及资源。[上游安全说明](https://github.com/0cv/herdr-mobile-relay/blob/main/docs/security.md)

VPS 网页在每台中转服务器另建 `herdr-relay.conf`，沿用上述 Nginx 网页配置，将 `server_name` 改为 `herdr-relay.example.com`、`proxy_pass` 改为 `http://127.0.0.1:18379`，并使用独立的 `map` 变量名。它有自己的域名和证书覆盖范围，不复用家用网页或 App 的站点配置。

### App：Nginx 终止 TLS

在每台中转服务器的 Nginx include 目录中增加独立的 `herdr-mobile.conf`：

```nginx
map $http_upgrade $herdr_mobile_connection_upgrade {
    default upgrade;
    '' close;
}
server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name herdr-mobile.example.com;
    ssl_certificate /path/to/fullchain.pem;
    ssl_certificate_key /path/to/privkey.pem;
    client_max_body_size 32m;
    location / {
        proxy_pass http://127.0.0.1:18375;
        proxy_http_version 1.1;
        proxy_set_header Host $http_host;
        proxy_set_header Authorization $http_authorization;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $herdr_mobile_connection_upgrade;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_buffering off;
        proxy_read_timeout 300s;
        proxy_send_timeout 300s;
    }
}
```

将示例域名和证书路径替换为实际值，证书须覆盖对应入口域名。两个站点可以共享 443，由 Nginx 按域名分流；部署到多台中转时，每台分别配置证书和上游。

```bash
sudo nginx -t && sudo systemctl reload nginx
```

## 配对与验收

### 上游配对入口

使用插件安装时，通过对应插件显示配对链接或二维码：

```bash
# Web / PWA
herdr plugin action invoke setup-link --plugin herdr-mobile-relay.events
# 原生 App
herdr plugin action invoke show-pair-link --plugin herdrelay.events
```

详细步骤见 [Web relay 配对说明](https://github.com/0cv/herdr-mobile-relay/blob/main/QUICKSTART.md)和[原生 App 配对说明](https://github.com/teasec4/herdr-mobile-app#using-herdr-mobile)。

### 可选：自定义布局的配对脚本

仓库中的[配对脚本](../scripts/herdr-pair.sh)仅适用于上文的自定义目录和状态文件布局，不能直接套用于其他安装方式。需要使用时，先按实际安装位置调整脚本中的路径；它使用 Bash 和 `jq`，从自行创建的私密配置 `~/.config/herdr-mobile/endpoints.json` 读取入口：

```json
{
  "app": {"host": "herdr-mobile.example.com", "port": 443},
  "web": {"origin": "https://herdr-web.example.com"},
  "web_vps": {"origin": "https://herdr-relay.example.com"}
}
```

```bash
bash scripts/herdr-pair.sh app
bash scripts/herdr-pair.sh web
bash scripts/herdr-pair.sh relay
```

脚本直接在终端显示链接和二维码，不保存文件。网页邀请一次有效、有效期 10 分钟，每添加一个新浏览器重新运行；App 保留原 token 和身份。浏览器首次打开邀请后配对，之后直接打开站点，也可添加到手机主屏幕。

### 验收

验收顺序：各本机 relay → 每台中转上游 → `nginx -t` → 公网证书、鉴权及 WSS → 浏览器配对、会话查看、输入和审批。App 启用时另验 `/healthz`。

网页支持 Web Push，App 使用本地通知和后台检查；授权及锁屏到达需在手机上单独验收。升级方式取决于安装方式，见[Web relay 升级](#web-relay-升级)；保留设备状态，升级 App relay 时保留身份和 token。

如需出站 WSS，可改用上游的 [自建 gateway](https://github.com/0cv/herdr-mobile-relay/blob/main/docs/gateway-self-hosting.md)；它是网页协议的可选传输，不与 App relay 通用。私密凭据、实际域名、日志和临时排查状态不写入仓库。
