# Repository Guidelines

## Project Structure & Module Organization

This repository is the configuration source of truth for Claude Code, Codex, Gemini/Antigravity, OpenCode, and CodeBuddy. Read `README.md` before structural changes.

- `config/`: public JSON configuration snapshots.
- `rules/`: shared engineering rules; `memories/agent-principles.md`: app-neutral resident instructions.
- `skills/<skill-name>/SKILL.md`: custom skills.
- `scripts/sync.sh`: applies repository assets to assistant configuration directories.
- `apps/`, `SKILLS.md`, and `open-source.md`: setup guides and dependency inventories.
- `hooks/`: optional hooks, currently disabled.

Keep shared rules aligned between `rules/` and `memories/agent-principles.md`.
Record external plugins by source and installation instructions; do not vendor them.

## Build, Test, and Development Commands

There is no build pipeline. Synchronization requires Bash, `jq`, and Python 3.

```bash
bash -n scripts/sync.sh hooks/diagnose-gate.sh  # Check shell syntax
jq empty config/*.json                      # Validate JSON
./scripts/sync.sh --dry-run                 # Preview synchronization
./scripts/sync.sh --app codex --dry-run      # Preview one assistant
./scripts/sync.sh --app codex                # Apply to local Codex
```

Real synchronization writes outside the repository. Editing a snapshot alone does not apply it; restart affected clients after synchronization.
Report source edits, synchronization, and client reload status separately.

## Coding Style & Naming Conventions

Match nearby formatting: shell scripts use two-space indentation and `set -euo pipefail`. Use descriptive lowercase, hyphenated names for rules and skills, such as `plan-calibration.md`.

Use Simplified Chinese for communication and explanatory documentation; preserve English agent-facing hook text. Write plainly. Use SVG for technical diagrams; Mermaid requires an explicit request or an SVG-incapable target, with the reason stated.

Preserve consistent source layout: public items before private items, callers before callees. Use the `architectural-coherence` skill; change only the affected design. Present a proportional design and obtain approval before non-trivial changes.

## Testing Guidelines

No test framework, coverage threshold, or formatter/linter is configured in tracked files. Run the checks above for script/configuration changes. For documentation, verify paths, commands, and consistency across applicable rule carriers. Validate synchronization changes in a disposable environment, including a second run for idempotence.

## Commit & Pull Request Guidelines

History uses concise factual subjects in Chinese or English, such as `add rule: diagrams-svg-first`; no uniform prefix is enforced. Agents must obtain explicit authorization before committing or rewriting history. Agent-created commits include `Co-authored-by: Codex MODEL <noreply@openai.com>` using the actual model, omitted if unknown.

PR descriptions should identify the change, affected assistants, verification performed, and relevant issues. Never publish plaintext credentials; keep private machine configuration out of snapshots.
