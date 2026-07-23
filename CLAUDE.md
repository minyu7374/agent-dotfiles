# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

This is **not a software project** — there is no build, test, or lint step. It is a git-tracked **configuration source-of-truth (SSOT) snapshot** for running three AI coding assistants (Claude Code / Codex / Gemini · Antigravity) with aligned engineering conventions. "Verifying a change" here means re-reading the affected snapshot for internal consistency and cross-app alignment, not running a command.

The repo content is almost entirely Chinese markdown. The primary entry point and full mental model is `README.md` — read it before making structural changes.

## Core principles (govern every change here)

1. **Reuse first.** Only author custom content for gaps that no open-source plugin/skill covers. Before adding a custom rule or skill, verify superpowers / Anthropic docs don't already cover it.
2. **superpowers is the primary framework**, and — unlike ECC — it ships a **native plugin install for every harness** (Claude / Codex CLI / Antigravity), so the same lean skills library carries the engineering discipline on all three apps. Keep the surrounding plugin/skill set minimal to avoid overlap with superpowers' built-ins. (ECC was the previous primary; it was retired as too bloated — 228 skills / 60 agents — in favor of superpowers' focused 14-skill workflow. See `open-source.md`.)
3. **cc-switch is the single source of truth.** Providers, common config, and the skills matrix all converge in `cc-switch/`; cc-switch *renders* each app's live config file on switch. Edits here are snapshots that get pushed back into cc-switch via its CLI — they do not take effect by themselves. **The command-line binary is `cc-switch-cli`** (renamed to avoid colliding with the `cc-switch` desktop app's command); every shell invocation in the docs uses `cc-switch-cli`, while prose still refers to the tool/product as "cc-switch".
4. **No vendoring of open-source content.** Open-source plugins/skills are recorded by *source + install method only* (`open-source.md`). The repo carries only **custom assets** and **config snapshots**.

## Architecture: how the pieces fit

Three assistants are kept aligned on the same engineering discipline (plan-first / architectural coherence / function layout / coding discipline). The carrier is now **uniform**: superpowers installs natively on each harness, then a thin custom layer (rules / GEMINI.md / cc-switch skills) adds the gaps superpowers doesn't cover.

- **Claude** — superpowers **plugin** (`superpowers@claude-plugins-official`, via `enabledPlugins`) **+ always-on rules** in `~/.claude/rules/` (loaded **natively** by Claude Code's memory feature — no plugin needed).
- **Codex** — superpowers installs as a **native Codex plugin** from the official `openai/plugins` marketplace (`/plugins` → search `superpowers` → Install). No sync script, no clone. cc-switch-cli only handles Codex's provider / reasoning config; the custom principles get appended to `~/.codex/AGENTS.md`.
- **Gemini (=Antigravity)** — superpowers installs as an Antigravity **plugin**: `agy plugin install https://github.com/obra/superpowers` (runs its session-start hook, active from the first message). The custom layer stays on `~/.gemini/GEMINI.md` (from `memories/agent-principles.md`) + cc-switch-synced skills (`architectural-coherence`). See `apps/gemini.md`.

superpowers' own 14 skills ride along with each plugin install (not cc-switch-managed). The skill matrix (`cc-switch/skills-matrix.md`) governs only the **custom + open-source doc skills** that superpowers doesn't bundle — `architectural-coherence`, `skill-creator`, `docx/pdf/pptx/xlsx` — across all three apps.

### The custom footprint (the only hand-authored assets)

Everything else is open-source. The repo's own content is just:

| File / dir | Role |
|---|---|
| `rules/architectural-coherence.md` | always-on rule (Claude); the one verified gap — terse general rule, points to the skill |
| `rules/minimal-change.md` | always-on rule (Claude); surgical/minimal-diff discipline, explicitly subordinate to architectural-coherence (coherence first, then minimal). Replaces the retired karpathy-guidelines skill |
| `rules/function-layout.md` | always-on rule (Claude); in-file function ordering convention |
| `rules/technical-writing.md` | always-on rule (Claude); plain engineering prose for docs/comments/messages — no literary/metaphor/translationese wording. Scoped to written output, doesn't touch conversational tone |
| `skills/architectural-coherence/` | the detailed playbook behind `architectural-coherence` (on-demand, all three apps) |
| `memories/agent-principles.md` | resident principles → `~/.gemini/GEMINI.md` (Gemini) and appended to `~/.codex/AGENTS.md` (Codex). Keep it app-neutral. |
| `hooks/diagnose-gate.sh` | optional PreToolUse hook (currently **shelved** — see `hooks/README.md`); forces root-cause-first on diagnostic prompts. Agent-facing text in English |

### Layout of the rest

- `cc-switch/` — the SSOT snapshot: `common-config.claude.json` (`enabledPlugins` + statusLine + effort + marketplaces + env; LSP plugins toggle by language, so the set isn't fixed), `common-config.codex.toml`, `skills-matrix.md` (skill × app enable matrix + cc-switch commands).
- `apps/` — per-app assembly guides: `claude.md`, `codex.md`, `gemini.md`. Each maps *repo file → landing location → mechanism*.
- `open-source.md` — inventory of open-source plugins/skills (enabled vs. deliberately disabled, with reasons) and their marketplaces.

## Working in this repo

- Changes to `cc-switch/*` and `apps/*` are **documentation of intent**. To actually apply them you (or the user) run `cc-switch-cli` commands — see `README.md` ("全新机器:应用流程") and `cc-switch/skills-matrix.md` ("维护命令"). Don't claim a config is "applied" from editing a snapshot file alone.
- When editing `memories/agent-principles.md`, its live targets are **`~/.gemini/GEMINI.md`** and **`~/.codex/AGENTS.md`** (appended); keep it app-neutral.
- Keep the alignment invariant: the same discipline on every app. The *carrier* is now uniform — **superpowers native plugin** on each of Claude / Codex / Antigravity — plus a thin custom layer (Claude `~/.claude/rules/`, Gemini/Codex `GEMINI.md`/`AGENTS.md`, and `architectural-coherence` via cc-switch). Mirror a discipline change across whichever carriers apply.
- The custom rules in `rules/` are themselves the conventions this repo follows (function layout, architectural coherence). Apply them when editing the custom skill or any future source.

## Known traps (from README "已知坑")

- **`enabledPlugins` is additive (union).** When cc-switch renders Claude's `settings.json`, it merges the provider's `settings_config.enabledPlugins` with the live state — stale plugins can get merged back in. The authoritative set must live on the **provider (`claude-official`) `settings_config`**, aligned with this repo's `common-config.claude.json`.
- **`ccstatusline` must be installed separately.** `common-config.claude.json` declares a `statusLine` command; without the `ccstatusline` binary present the status bar errors (drop that block if not installed).
- **`~/.claude/rules/` is native, not plugin-loaded.** Claude Code's memory feature auto-loads `~/.claude/rules/*.md` at launch (same priority as `CLAUDE.md`) — this survives removing ECC/any plugin. (The old docs wrongly credited ECC with loading rules.)
- **superpowers is installed per-harness, outside cc-switch.** Each harness's own plugin manager owns it (Claude `enabledPlugins`, Codex `openai/plugins`, Antigravity `agy plugin install`). cc-switch renders only the Claude `enabledPlugins` entry, providers, common config, and the custom/doc skills — it does not install superpowers on Codex/Antigravity.
- **Restart to take effect.** Plugins/skills/rules load at client startup. For a clean state, start a new session rather than relying on `claude -c` (which reloads config but carries old context residue).
