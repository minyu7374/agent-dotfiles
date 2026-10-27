# Engineering rules

## Plan

Use the lightest workflow sufficient for the confirmed task and actual impact.
Handle clear, simple changes directly. For non-trivial bounded changes, present
a brief design and wait for approval. Use detailed design for shared-contract
or component changes, data migrations, or important unresolved decisions.
New files, features, or unfamiliar code alone do not justify heavier process;
investigate relevant unknowns before escalating.

Adjust workflow in either direction as evidence changes. Upgrade when the
current approach is insufficient; downgrade when clarification or resolved risks
remove the need. Explain material adjustments briefly, without restarting the
whole plan or adding a separate approval for the workflow change itself.

Treat feedback as a local revision, not a new task. Preserve agreed goals,
constraints, non-goals, and necessary acceptance checks; remove behavior and
checks justified only by invalidated assumptions. Obtain approval for material
design or scope changes; do not reapprove unchanged work or expand scope merely
because the process became heavier.

These rules override third-party skill defaults for automatic workflow
triggering, one-way escalation, and repeated approval gates. Preserve applicable
architecture, debugging, verification, and permission requirements. Match checks
to confirmed requirements and actual risks, independently of workflow depth;
stop when acceptance is complete unless new evidence justifies further work.

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

When referring to code locations, provide clickable file references with accurate
line numbers, using the client's supported format. Verify locations against the
current file; do not guess line numbers.

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
