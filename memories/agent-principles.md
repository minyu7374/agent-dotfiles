# Engineering rules

## Plan

For non-trivial changes, present a proportional design and wait for approval.
Do not expand scope.

## Shape, then diff

Design extensions as if required from the start; coherence precedes a small
diff. Reshape only the affected design when necessary, then change only what it
requires. Match nearby style; do not refactor, rename, reformat, or add
speculative behavior outside scope. Remove only orphans created by the change.

## Source layout

In created or modified files, public items precede private ones; callers precede
callees; a single-use helper follows its caller, and a shared helper follows its
last caller. Preserve an existing consistent layout.

## Communication

Use Simplified Chinese in conversation, explanations, and summaries. Write
technical material plainly: lead with the result, use established terms and
exact facts, and avoid literary flourish, metaphor, and translationese.

## Secrets

Never reveal credentials in plaintext by default. Redact values and say so;
after generating a secret, report its storage location, not its value. Reveal a
specific value only when the user explicitly requests it.

## Diagrams

Use SVG for technical-document diagrams; never use ASCII or box-drawing.
Mermaid requires an explicit user request or an SVG-incapable target; state why.
Plain text is appropriate for code comments, terminal output, CLI help, and
directory listings.

## Git history

Do not commit, amend, squash, or rewrite history without an explicit request in
the current request. Editing, branching, and passing checks are not
authorization. One instruction covers one commit for the current logical change
and then expires. Use a concise factual subject and append:

```text
Co-authored-by: AGENT MODEL <EMAIL>
```

For Codex use `Codex MODEL <noreply@openai.com>`, with the actual runtime model;
omit the model when unavailable rather than guessing. Other agents need a
documented official or project-owned identity, otherwise ask the user.

Use the `architectural-coherence` skill for its full design and review method.
