#!/bin/bash
set -euo pipefail

config_root="$HOME/.config"
relay_binary=/usr/local/libexec/herdr-web/current/herdr-mobile-relay

case "${1:-}" in
  app)
    prefix='herdrelay://pair?'
    params=$(jq -n \
      --slurpfile cfg "$config_root/herdr-mobile/endpoints.json" \
      --slurpfile identity "$config_root/herdr/herdrelay.id" \
      --rawfile token "$config_root/herdr/herdrelay.token" \
      '{host: $cfg[0].app.host, port: $cfg[0].app.port, mode: "funnel",
        token: ($token | rtrimstr("\n")), relay_id: $identity[0].relay_id,
        name: ($identity[0].name // "Herdr")}')
    ;;
  web|relay)
    if [[ "$1" == web ]]; then
      origin_key=web
    else
      origin_key=web_vps
    fi
    source "$config_root/herdr-web/relay.env"
    origin=$(jq -r --arg key "$origin_key" '.[$key].origin | rtrimstr("/")' "$config_root/herdr-mobile/endpoints.json")
    prefix="$origin/#"
    params=$(jq -n --arg setup "$HERDR_RELAY_TOKEN" --arg relay "wss://${origin#*://}" \
      '{setup: $setup, label: "Herdr", relay: $relay}')
    kill -USR1 "$(cat "$config_root/herdr-web/relay.pid")"
    ;;
  *)
    echo "用法：herdr-pair app|web|relay" >&2
    exit 1
    ;;
esac

query=$(printf '%s' "$params" | jq -r \
  'to_entries | map((.key | @uri) + "=" + (.value | tostring | @uri)) | join("&")')
link="$prefix$query"
printf '%s\n\n' "$link"
"$relay_binary" qr "$link"
if [[ "$1" == web || "$1" == relay ]]; then
  echo '网页邀请一次有效，请在 10 分钟内完成配对。'
fi
