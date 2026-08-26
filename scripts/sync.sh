#!/usr/bin/env bash
# sync.sh — 把本仓的自定义资产(规则 / 技能 / 常驻准则 / 公共配置快照)同步到本机各 AI agent。
#
# 用法:
#   ./scripts/sync.sh                 # 同步全部 5 个 agent
#   ./scripts/sync.sh --app claude    # 只同步某一个
#   ./scripts/sync.sh --dry-run       # 只打印将要执行的操作,不写盘
#
# 边界:本脚本只管"纪律层"——规则 / 技能 / 常驻准则 / 公共配置快照。provider 与模型
# 由各 agent 官方原生配置(Claude `claude` 登录 / Codex `codex login` / OpenCode opencode.json /
# Antigravity 应用内设置 / CodeBuddy 应用内设置),脚本不接管。
#
# 依赖:jq(JSON 合并);python3(Codex 的托管块替换;macOS 自带)。
set -euo pipefail
shopt -s nullglob

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

DRY_RUN=0
APP_FILTER=""

usage() {
  cat <<'EOF'
用法: ./scripts/sync.sh [--dry-run] [--app claude|codex|gemini|opencode|codebuddy]

把本仓的自定义规则/技能/常驻准则/公共配置快照同步到各 AI agent。
不管理 provider / 模型(由各 agent 原生配置)。
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=1; shift ;;
    --app)
      APP_FILTER="${2:-}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "未知参数: $1" >&2; usage >&2; exit 1 ;;
  esac
done

if [[ -n "$APP_FILTER" ]]; then
  case "$APP_FILTER" in
    claude|codex|gemini|opencode|codebuddy) ;;
    *) echo "未知 app: $APP_FILTER (可选: claude codex gemini opencode codebuddy)" >&2; exit 1 ;;
  esac
fi

command -v jq >/dev/null 2>&1 || { echo "缺少依赖: jq (安装 jq 后重试)" >&2; exit 1; }
command -v python3 >/dev/null 2>&1 || { echo "缺少依赖: python3" >&2; exit 1; }

# 目标目录
CLAUDE_DIR="$HOME/.claude"
CODEBUDDY_DIR="$HOME/.codebuddy"
GEMINI_DIR="$HOME/.gemini"
CODEX_DIR="$HOME/.codex"
OPENCODE_DIR="$HOME/.config/opencode"

# 统一执行入口(支持 dry-run)
run() {
  if [[ $DRY_RUN -eq 1 ]]; then
    printf '  [dry-run] %s\n' "$*"
  else
    "$@"
  fi
}

wants() {
  [[ -z "$APP_FILTER" || "$APP_FILTER" == "$1" ]]
}

# ---- 常驻准则 ----
# Gemini / OpenCode / CodeBuddy 的目标文件由本仓完全托管,直接覆盖;
# Codex 的 AGENTS.md 可能与用户内容共存,用标记块替换,保留块外内容。
PRINCIPLES_SRC="$REPO_ROOT/memories/agent-principles.md"

cp_principles() {
  local dest="$1"
  run mkdir -p "$(dirname "$dest")"
  run cp "$PRINCIPLES_SRC" "$dest"
}

# 把 target 中 begin/end 标记之间的块替换为 src 的内容(幂等;保留块外内容)。
# 新块插到文件顶部:对 TOML 而言这保证键落在根级而非某个 [table] 段内。
replace_block() {
  local target="$1" src="$2" begin="$3" end="$4"
  if [[ $DRY_RUN -eq 1 ]]; then
    printf '  [dry-run] update managed block in %s from %s\n' "$target" "$src"
    return
  fi
  python3 - "$target" "$src" "$begin" "$end" <<'PY'
import sys
target, src, bm, em = sys.argv[1:5]
with open(src, encoding="utf-8") as f:
    new = f.read().rstrip("\n") + "\n"
try:
    with open(target, encoding="utf-8") as f:
        cur = f.read()
except FileNotFoundError:
    cur = ""
b, e = cur.find(bm), cur.find(em)
if b != -1 and e != -1 and e > b:
    before = cur[:b].strip("\n")
    after = cur[e + len(em):].strip("\n")
    content = (before + "\n" if before else "") + bm + "\n" + new.rstrip("\n") + "\n" + em
    if after:
        content += "\n\n" + after
    content += "\n"
else:
    if b != -1 or e != -1:
        print(f"warn: {target} 标记不完整,跳过(需手动修复)", file=sys.stderr)
        sys.exit(1)
    head = bm + "\n" + new.rstrip("\n") + "\n" + em
    content = head + ("\n\n" + cur.strip("\n") if cur.strip() else "") + "\n"
with open(target, "w", encoding="utf-8") as f:
    f.write(content)
PY
}

# ---- 规则(always-on,Claude / CodeBuddy) ----
sync_rules() {
  local dest="$1"
  run mkdir -p "$dest"
  for f in "$REPO_ROOT"/rules/*.md; do
    run cp "$f" "$dest/"
  done
}

# ---- 技能(自定义,本仓 skills/ 下;同步到各 app 技能目录) ----
sync_skills() {
  local dest="$1"
  run mkdir -p "$dest"
  for sdir in "$REPO_ROOT"/skills/*/; do
    local name
    name="$(basename "$sdir")"
    if [[ $DRY_RUN -eq 1 ]]; then
      printf '  [dry-run] sync skill %s -> %s\n' "$name" "$dest"
    else
      rm -rf "$dest/$name"
      cp -R "$sdir" "$dest/$name"
    fi
  done
}

# ---- 公共配置快照(JSON 合并:保留用户专属字段,整体替换集合类字段) ----
merge_settings_json() {
  local target="$1" src="$2"
  run mkdir -p "$(dirname "$target")"
  if [[ $DRY_RUN -eq 1 ]]; then
    printf '  [dry-run] merge %s <- %s\n' "$target" "$src"
    return
  fi
  if [[ ! -f "$target" ]]; then
    jq . "$src" > "$target"
    printf '  wrote %s\n' "$target"
    return
  fi
  local tmp="${target}.agent-dotfiles.tmp"
  jq --slurpfile src "$src" '
    . + $src[0]
    | if $src[0] | has("enabledPlugins") then .enabledPlugins = $src[0].enabledPlugins else . end
    | if $src[0] | has("skillOverrides") then .skillOverrides = $src[0].skillOverrides else . end
  ' "$target" > "$tmp"
  mv "$tmp" "$target"
  printf '  merged %s\n' "$target"
}

# ================= 各 app =================

sync_claude() {
  echo "## Claude"
  sync_rules "$CLAUDE_DIR/rules"
  sync_skills "$CLAUDE_DIR/skills"
  merge_settings_json "$CLAUDE_DIR/settings.json" "$REPO_ROOT/config/claude.json"
}

sync_codebuddy() {
  echo "## CodeBuddy"
  cp_principles "$CODEBUDDY_DIR/AGENTS.md"
  sync_rules "$CODEBUDDY_DIR/rules"
  sync_skills "$CODEBUDDY_DIR/skills"
  merge_settings_json "$CODEBUDDY_DIR/settings.json" "$REPO_ROOT/config/codebuddy.json"
}

sync_gemini() {
  echo "## Gemini / Antigravity"
  cp_principles "$GEMINI_DIR/GEMINI.md"
  sync_skills "$GEMINI_DIR/skills"
}

sync_codex() {
  echo "## Codex"
  run mkdir -p "$CODEX_DIR"
  replace_block "$CODEX_DIR/AGENTS.md" "$PRINCIPLES_SRC" \
    '<!-- agent-dotfiles:begin -->' '<!-- agent-dotfiles:end -->'
  sync_skills "$CODEX_DIR/skills"
  replace_block "$CODEX_DIR/config.toml" "$REPO_ROOT/config/codex.toml" \
    '# >>> agent-dotfiles:begin >>>' '# <<< agent-dotfiles:end <<<'
}

sync_opencode() {
  echo "## OpenCode"
  cp_principles "$OPENCODE_DIR/AGENTS.md"
  sync_skills "$OPENCODE_DIR/skills"
  # opencode 配置:合并进已存在的 opencode.json/.jsonc,都不存在则新建 .jsonc
  local target=""
  [[ -f "$OPENCODE_DIR/opencode.json" ]] && target="$OPENCODE_DIR/opencode.json"
  [[ -f "$OPENCODE_DIR/opencode.jsonc" ]] && target="$OPENCODE_DIR/opencode.jsonc"
  [[ -z "$target" ]] && target="$OPENCODE_DIR/opencode.jsonc"
  if [[ -f "$target" ]] && jq -e . "$target" >/dev/null 2>&1; then
    merge_settings_json "$target" "$REPO_ROOT/config/opencode.json"
  else
    run cp "$REPO_ROOT/config/opencode.json" "$target"
  fi
}

for app in claude codex gemini opencode codebuddy; do
  wants "$app" && "sync_$app"
done

if [[ $DRY_RUN -eq 1 ]]; then
  echo
  echo "(dry-run:以上为将要执行的操作,未写盘)"
else
  echo
  echo "同步完成。重启各 agent(插件/技能/规则在启动时加载)后生效。"
fi