# Hooks（可选，当前停用作备用）

本目录放**自定义的 Claude Code 钩子**。当前均**不启用**——保留在此作备用,日后遇到类似问题再按下方配置重新挂上。

> 钩子脚本本身与其输出给 agent 的文本统一用**英文**(`permissionDecisionReason` 等);仅本说明文档用中文。

## `diagnose-gate.sh`

**作用**:PreToolUse 钩子。当用户最新一条消息是**诊断类提问**(检查/为什么/分析/排查…且没有"改/修/执行/apply/fix…"这类动作词)时,拦截代码类 `Edit|Write|NotebookEdit`,强制先交付「根因分析 + 按结果枚举的方案」,待用户选定后再改码。下一条消息不再命中诊断模式即自动放行。

**放行**:scratchpad/tmp、`~/.claude/**`(分析产物与 Claude 自身配置不拦)。

**触发模式**:同时匹配中文(主)与英文动词——因为它读的是用户的自然语言提问,不是给 agent 的文本。

### 重新启用

把脚本放到 `~/.claude/hooks/` 并在 `~/.claude/settings.json` 加入:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write|NotebookEdit",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/diagnose-gate.sh",
            "timeout": 10,
            "statusMessage": "diagnose-gate: checking whether this is a diagnostic-phase request"
          }
        ]
      }
    ]
  }
}
```

```bash
cp hooks/diagnose-gate.sh ~/.claude/hooks/ && chmod +x ~/.claude/hooks/diagnose-gate.sh
# 依赖 jq;改完重启 Claude Code 生效
```
