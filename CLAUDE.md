# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

This is **not a software project** — there is no build, test, or lint step. It is a git-tracked **configuration source-of-truth (SSOT) snapshot** for running five AI coding assistants (Claude Code / Codex / Gemini · Antigravity / OpenCode / CodeBuddy) with aligned engineering conventions. "Verifying a change" here means re-reading the affected snapshot for internal consistency and cross-app alignment, not running a command.

The repo content is almost entirely Chinese markdown. The primary entry point and full mental model is `README.md` — read it before making structural changes.

## Core principles (govern every change here)

1. **Reuse first.** Only author custom content for gaps that no open-source plugin/skill covers. Before adding a custom rule or skill, verify superpowers / Anthropic docs don't already cover it.
2. **superpowers is the primary framework.** Every harness has a native plugin install (Claude / Codex CLI / Antigravity / CodeBuddy), so the same lean skills library carries the engineering discipline on all apps. Keep the surrounding plugin/skill set minimal to avoid overlap with superpowers' built-ins. (ECC was the previous primary; it was retired as too bloated — 228 skills / 60 agents — in favor of superpowers' focused 14-skill workflow. See `open-source.md`.)
3. **This repo is the single source of truth.** Config snapshots, resident principles, and custom rules/skills all live here; `scripts/sync.sh` applies them to each agent's live config. Provider/model config is **not** in scope — each vendor now configures it natively (`claude` login, `codex login`, opencode.json, in-app settings), so there is no cc-switch-style switching layer.
4. **No vendoring of open-source content.** Open-source plugins/skills are recorded by *source + install method only* (`open-source.md`). The repo carries only **custom assets** and **config snapshots**.

## Architecture: how the pieces fit

Five assistants are kept aligned on the same engineering discipline (plan-first / architectural coherence / function layout / coding discipline). The carrier is now **uniform**: superpowers installs natively on each harness, then a thin custom layer (rules / AGENTS.md / GEMINI.md / the `architectural-coherence` skill) adds the gaps superpowers doesn't cover. `scripts/sync.sh` moves the custom layer from this repo into each harness:

- **Claude** — superpowers **plugin** (`superpowers@claude-plugins-official`, via `enabledPlugins` in `config/claude.json`) **+ always-on rules** in `~/.claude/rules/` (loaded **natively** by Claude Code's memory feature — no plugin needed).
- **Codex** — superpowers installs as a **native Codex plugin** from the official `openai/plugins` marketplace (`/plugins` → search `superpowers` → Install). The custom principles are kept in a managed marker block in `~/.codex/AGENTS.md`; behavioral config (`model_reasoning_effort`, `disable_response_storage`) lives in a managed block of `~/.codex/config.toml`.
- **Gemini (=Antigravity)** — superpowers installs as an Antigravity **plugin**: `agy plugin install https://github.com/obra/superpowers`. The custom layer stays on `~/.gemini/GEMINI.md` (from `memories/agent-principles.md`) + the synced `architectural-coherence` skill. See `apps/gemini.md`.
- **OpenCode** — global instructions in `~/.config/opencode/AGENTS.md`, skills in `~/.config/opencode/skills/`, config snapshot in `config/opencode.json`. See `apps/opencode.md`.
- **CodeBuddy** — Claude-compatible architecture (`~/.codebuddy/settings.json`, `~/.codebuddy/rules/`, `~/.codebuddy/skills/`, `~/.codebuddy/AGENTS.md`). Superpowers installed from marketplace, rules loaded natively. See `apps/codebuddy.md`.

superpowers' own 14 skills ride along with each plugin install. The skill layer (`SKILLS.md`) covers only the **custom `architectural-coherence` skill** plus the **open-source doc skills** (`skill-creator`, `docx/pdf/pptx/xlsx`) that superpowers doesn't bundle.

### The custom footprint (the only hand-authored assets)

Everything else is open-source. The repo's own content is just:

| File / dir | Role |
|---|---|
| `rules/architectural-coherence.md` | always-on rule (Claude / CodeBuddy); the one verified gap — terse general rule, points to the skill |
| `rules/minimal-change.md` | always-on rule (Claude / CodeBuddy); surgical/minimal-diff discipline, explicitly subordinate to architectural-coherence (coherence first, then minimal). Replaces the retired karpathy-guidelines skill |
| `rules/function-layout.md` | always-on rule (Claude / CodeBuddy); in-file function ordering convention |
| `rules/technical-writing.md` | always-on rule (Claude / CodeBuddy); plain engineering prose for docs/comments/messages |
| `rules/no-plaintext-secrets.md` | always-on rule (Claude / CodeBuddy); never display credentials in plaintext, redact instead. Mirrored to `memories/agent-principles.md` |
| `rules/diagrams-svg-first.md` | always-on rule (Claude / CodeBuddy); diagrams in technical docs go in SVG (or mermaid where rendered), not ASCII art. Mirrored to `memories/agent-principles.md` |
| `rules/no-auto-commit.md` | always-on rule (Claude / CodeBuddy); no autonomous commits |
| `rules/language.md` | always-on rule (Claude / CodeBuddy); respond in Simplified Chinese |
| `skills/architectural-coherence/` | the detailed playbook behind `architectural-coherence` (on-demand, all apps) |
| `memories/agent-principles.md` | resident principles → `~/.gemini/GEMINI.md` (Gemini), `~/.codex/AGENTS.md` (Codex, marker block), `~/.config/opencode/AGENTS.md` (OpenCode), `~/.codebuddy/AGENTS.md` (CodeBuddy). Keep it app-neutral. |
| `config/` | per-app public-config snapshots, applied by `scripts/sync.sh` (JSON merge for Claude/CodeBuddy, managed blocks for Codex, copy for OpenCode) |
| `scripts/sync.sh` | the one-command sync that applies the custom layer to all five agents |
| `hooks/diagnose-gate.sh` | optional PreToolUse hook (currently **shelved** — see `hooks/README.md`); forces root-cause-first on diagnostic prompts. Agent-facing text in English |

### Layout of the rest

- `apps/` — per-app assembly guides: `claude.md`, `codex.md`, `gemini.md`, `opencode.md`, `codebuddy.md`. Each maps *repo file → landing location → mechanism*.
- `open-source.md` — inventory of open-source plugins/skills (enabled vs. deliberately disabled, with reasons) and their marketplaces.
- `SKILLS.md` — skill inventory: custom (`skills/`) vs. open-source (install-only).

## Working in this repo

- **Changes to `config/*` and `apps/*` are documentation of intent.** To actually apply them you (or the user) run `scripts/sync.sh` — see `README.md` ("全新机器:应用流程") and `apps/*.md`. Don't claim a config is "applied" from editing a snapshot file alone.
- **When editing `memories/agent-principles.md`**, its live targets are `~/.gemini/GEMINI.md`, `~/.codex/AGENTS.md` (marker block), `~/.config/opencode/AGENTS.md`, `~/.codebuddy/AGENTS.md`; run `scripts/sync.sh` to refresh them. Keep it app-neutral.
- **Keep the alignment invariant**: the same discipline on every app. The *carrier* is uniform — **superpowers native plugin** on each harness — plus a thin custom layer (Claude/CodeBuddy `~/.claude/rules/` and `~/.codebuddy/rules/`, Gemini/Codex/OpenCode/CodeBuddy `GEMINI.md`/`AGENTS.md`, and the `architectural-coherence` skill). Mirror a discipline change across whichever carriers apply.
- **The custom rules in `rules/` are themselves the conventions this repo follows** (function layout, architectural coherence, technical writing). Apply them when editing the custom skill or any future source.
- **`scripts/sync.sh` is idempotent** by design (whole-set JSON keys, marker-block replacement). After editing it, verify with `./scripts/sync.sh --dry-run` and check that a second real run changes nothing.

## Known traps (from README "已知坑")

- **`enabledPlugins` / `skillOverrides` are replaced wholesale, not merged.** `scripts/sync.sh` overwrites these two fields with the set from `config/claude.json` / `config/codebuddy.json` to avoid stale plugins/overrides merging back in; other user-specific fields (permissions / mcpServers / model / theme / trustedDirectories) are preserved.
- **`ccstatusline` must be installed separately.** `config/claude.json` declares a `statusLine` command; without the `ccstatusline` binary present the status bar errors (drop that block if not installed).
- **`~/.claude/rules/` is native, not plugin-loaded.** Claude Code's memory feature auto-loads `~/.claude/rules/*.md` at launch (same priority as `CLAUDE.md`) — this survives removing ECC/any plugin.
- **superpowers is installed per-harness, outside this repo.** Each harness's own plugin manager owns it (Claude `enabledPlugins`, Codex `openai/plugins`, Antigravity `agy plugin install`). `scripts/sync.sh` only applies the Claude `enabledPlugins` entry and the custom/config snapshots — it does not install superpowers on Codex/Antigravity.
- **Restart to take effect.** Plugins/skills/rules load at client startup. For a clean state, start a new session rather than relying on `claude -c` (which reloads config but carries old context residue).