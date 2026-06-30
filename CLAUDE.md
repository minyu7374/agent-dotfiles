# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

This is **not a software project** — there is no build, test, or lint step. It is a git-tracked **configuration source-of-truth (SSOT) snapshot** for running three AI coding assistants (Claude Code / Codex / Gemini · Antigravity) with aligned engineering conventions. "Verifying a change" here means re-reading the affected snapshot for internal consistency and cross-app alignment, not running a command.

The repo content is almost entirely Chinese markdown. The primary entry point and full mental model is `README.md` — read it before making structural changes.

## Core principles (govern every change here)

1. **Reuse first.** Only author custom content for gaps that no open-source plugin/skill covers. Before adding a custom rule or skill, verify ECC / karpathy / Anthropic docs don't already cover it.
2. **ECC is the primary framework** on the Claude side (agents / skills / commands / hooks / MCP). Keep the Claude plugin set lean to avoid overlap with ECC's built-ins.
3. **cc-switch is the single source of truth.** Providers, common config, and the skills matrix all converge in `cc-switch/`; cc-switch *renders* each app's live config file on switch. Edits here are snapshots that get pushed back into cc-switch via its CLI — they do not take effect by themselves. **The command-line binary is `cc-switch-cli`** (renamed to avoid colliding with the `cc-switch` desktop app's command); every shell invocation in the docs uses `cc-switch-cli`, while prose still refers to the tool/product as "cc-switch".
4. **No vendoring of open-source content.** Open-source plugins/skills are recorded by *source + install method only* (`open-source.md`). The repo carries only **custom assets** and **config snapshots**.

## Architecture: how the pieces fit

Three assistants are kept aligned on the same engineering discipline (plan-first / architectural coherence / function layout / coding discipline):

- **Claude** — discipline via **plugins** (ECC + karpathy) **+ always-on rules** in `~/.claude/rules/`.
- **Codex** — no plugins, but ECC ships a **first-class native installer**: `scripts/sync-ecc-to-codex.sh` writes `~/.codex/AGENTS.md` + 32 skills + MCP. The repo adopts it; cc-switch-cli only handles Codex's provider / reasoning config.
- **Gemini (=Antigravity)** — ECC has **no global installer** for it (`install.sh` only does project-local `./.agent/`, and Antigravity reads just `.agent/rules/`), so globally Gemini stays on `~/.gemini/GEMINI.md` (from `memories/agent-principles.md`) + cc-switch-synced skills (`karpathy-guidelines` + `architectural-harmony`). See `apps/gemini.md`.

The skill matrix (`cc-switch/skills-matrix.md`) governs Claude + Gemini; Codex's skills come from ECC's sync.

### The custom footprint (the only hand-authored assets)

Everything else is open-source. The repo's own content is just:

| File / dir | Role |
|---|---|
| `rules/architectural-coherence.md` | always-on rule (Claude); the one verified gap — terse general rule, points to the skill |
| `rules/function-layout.md` | always-on rule (Claude); in-file function ordering convention |
| `skills/architectural-harmony/` | the detailed playbook behind `architectural-coherence` (on-demand, all three apps) |
| `memories/agent-principles.md` | resident principles → `~/.gemini/GEMINI.md` (Gemini). Codex uses ECC's own `AGENTS.md`, so this file is just an optional append there. |

### Layout of the rest

- `cc-switch/` — the SSOT snapshot: `common-config.claude.json` (5 plugins + statusLine + effort + marketplaces), `common-config.codex.toml`, `skills-matrix.md` (skill × app enable matrix + cc-switch commands).
- `apps/` — per-app assembly guides: `claude.md`, `codex.md`, `gemini.md`. Each maps *repo file → landing location → mechanism*.
- `open-source.md` — inventory of open-source plugins/skills (enabled vs. deliberately disabled, with reasons) and their marketplaces.

## Working in this repo

- Changes to `cc-switch/*` and `apps/*` are **documentation of intent**. To actually apply them you (or the user) run `cc-switch-cli` commands — see `README.md` ("全新机器:应用流程") and `cc-switch/skills-matrix.md` ("维护命令"). Don't claim a config is "applied" from editing a snapshot file alone.
- When editing `memories/agent-principles.md`, its live target is **`~/.gemini/GEMINI.md`**; keep it app-neutral. (Codex gets its `AGENTS.md` from ECC's sync — append this file there only if you want its exact wording.)
- Keep the alignment invariant: the same discipline on every app, but the *carrier* differs — **Claude** plugin/rule, **Codex** ECC sync, **Gemini** `GEMINI.md` + cc-switch skills. Mirror a discipline change across whichever carriers apply.
- The custom rules in `rules/` are themselves the conventions this repo follows (function layout, architectural coherence). Apply them when editing the custom skill or any future source.

## Known traps (from README "已知坑")

- **`enabledPlugins` is additive (union).** When cc-switch renders Claude's `settings.json`, it merges the provider's `settings_config.enabledPlugins` with the live state — stale plugins can get merged back in. The authoritative set must live on the **provider (`claude-official`) `settings_config`**, aligned with this repo's `common-config.claude.json`.
- **`ccstatusline` must be installed separately.** `common-config.claude.json` declares a `statusLine` command; without the `ccstatusline` binary present the status bar errors (drop that block if not installed).
- **Restart to take effect.** Plugins/skills/rules load at client startup. For a clean state, start a new session rather than relying on `claude -c` (which reloads config but carries old context residue).
