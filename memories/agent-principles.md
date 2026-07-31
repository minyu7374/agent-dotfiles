# Agent engineering principles (resident layer for non-Claude harnesses)

> All three harnesses now share **superpowers** as the primary framework (native plugin). But the parts Claude carries as **always-on rules** (`~/.claude/rules/`, loaded natively) — plan-first / architectural coherence / minimal change / function layout — don't ride along with superpowers, so they live here for the other harnesses. Detailed methodology comes from installed **skills** (see end); this file doesn't restate them.
>
> **Deploy targets**: `~/.gemini/GEMINI.md` (Gemini / Antigravity) and `~/.codex/AGENTS.md` (Codex, appended).
> All three (Claude = superpowers plugin + `rules/`; Codex = superpowers plugin + this file; Gemini = superpowers plugin + this file + skills) keep the same engineering discipline.

## Plan first
For non-trivial changes, present a plan/design and get sign-off before writing code — the bigger the change, the more this matters. Don't rush into code, and don't expand scope beyond what the request explicitly covers.

## Architectural coherence
After a change lands, the code should read as if it had been designed that way from the start — no visible seam between old and new. When extending existing code, build toward the shape the module would have if the feature had been required on day one; "minimize the change" holds only when the existing structure already fits — don't bolt new code beside the old just to shrink the diff.
(Full playbook: the `architectural-coherence` skill.)

## Minimal change (architectural coherence first)
Once the shape is decided, implement it with the smallest change: touch only what the task needs; don't refactor / rename / reorder unrelated code; match the surrounding style; remove only the orphans your own change creates (flag pre-existing dead code, don't delete it); nothing speculative (KISS / YAGNI).
**Precedence — coherence first, then minimal change**: this rule is subordinate to architectural coherence. First settle the coherent shape (reshape when needed — a coherent larger diff beats a bolted-on small one), then make that shape minimal. A "smallest diff" must not buy an architectural seam, and "coherence" must not license touching unrelated code beyond what the shape needs.

## Function layout
Within a file: exported/public items first; callers before callees (top-down in call order); a single-use helper sits right after its caller. If an existing file already follows another consistent layout, keep it — don't reorder on your own.

## Technical writing style
For written technical output (docs, comments, commit / PR messages, explanations), use plain, direct language and the established engineering term. Avoid literary flourish, metaphor, and invented / translationese jargon that replaces a plain word (e.g. 旋钮 / 裁剪 / 选线). Be concrete: give the number, path, or error text, not an adjective.

## No plaintext secrets
Never display passwords, API keys, tokens, private keys, or other credentials in plaintext in a response — whether read from a file, printed by a command, pulled from an env var, or generated during the task. Redact the value (e.g. `API_KEY=***redacted***`) and say what was redacted rather than silently dropping it; after generating a secret, report where it was stored, not the value itself. Showing a specific value the user explicitly asks for is fine — the rule is against exposing secrets by default.

---
**Skills relied on** (synced by cc-switch into each app's skills dir): `architectural-coherence`, `skill-creator`, `docx`/`pdf`/`pptx`/`xlsx`.
