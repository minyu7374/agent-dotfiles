#!/usr/bin/env bash
# diagnose-gate: when the user's latest message is a *diagnostic* request, block
# code Edit/Write — force a root-cause analysis + options-by-outcome first, then
# wait for the user to decide.
# Self-releasing: once the next user message is no longer diagnostic (e.g. "go with
# option B"), edits pass through again.
#
# NOTE: the trigger/allow patterns below match the operator's natural-language
# prompts, which are written in Chinese (plus common English verbs). They are
# input-matching data, not agent-facing text — that is why they are not English-only.
# Everything emitted to the agent (permissionDecisionReason) is English.
set -euo pipefail

input=$(cat)
tp=$(jq -r '.transcript_path // empty' <<<"$input")
[ -n "$tp" ] && [ -f "$tp" ] || exit 0

# Allow analysis/output paths: scratchpad/tmp, and Claude's own config & memory
fp=$(jq -r '.tool_input.file_path // empty' <<<"$input")
case "$fp" in
  /tmp/*|/private/tmp/*|"$HOME"/.claude/*) exit 0 ;;
esac

# Take the most recent real user message (exclude tool_result and local-command echoes)
last=$(jq -rs '
  [ .[]
    | select(.type? == "user")
    | .message.content?
    | if type == "string" then .
      elif type == "array" then ([ .[] | select(.type? == "text") | .text ] | join("\n"))
      else empty end
    | select(length > 0)
    | select(test("<command-name>|<local-command") | not)
  ] | last // empty' "$tp" 2>/dev/null) || exit 0
[ -n "$last" ] || exit 0

# Diagnostic mode hit AND no action verb → deny.
# Patterns match Chinese prompts (primary) + English equivalents.
verdict=$(jq -rn --arg t "$last" '
  ($t | test("检查[^。]*(原因|问题)|什么原因|为什么|分析一?下|排查|怎么回事|why|diagnose|root.?cause|investigate|what.?s causing"))
  and (($t | test("改|修复|实现|执行|继续|动手|应用|换成|去掉|删除|切换|提交|apply|fix|implement|change|proceed|go ahead")) | not)')

if [ "$verdict" = "true" ]; then
  jq -n '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "deny",
    permissionDecisionReason: "The latest user message is a diagnostic request (check / why / analyze). Deliver first: (1) a root-cause analysis, (2) options enumerated by outcome (for each option, what the user would observe in each scenario). Wait for the user to pick an option before editing code."}}'
fi
exit 0
