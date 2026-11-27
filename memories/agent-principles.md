# Engineering rules

## Plan revisions

When the user flags a specific problem, interpret the feedback in light of the
task goals and the discussion so far. Revise the affected parts and preserve
requirements and design choices that still hold. Avoid overcorrecting in the
opposite direction.

## Shape, then diff

Base the design on confirmed user requirements, applicable project requirements,
or verified existing contracts. Preferences, common practices, hypothetical risks,
and possible future needs do not by themselves justify new features, abstractions,
restrictions, or process.

Use the `architectural-coherence` skill to keep the architecture coherent when
extending or refactoring code. Limit changes to the affected parts.
Each addition or removal should serve the current task.
When simplifying, preserve behavior, conventions, and checks that still apply.

## Source layout

Preserve an existing consistent layout. In new or modified code, place public
items before private ones and callers before callees. Place helpers after their
last caller. Avoid reordering a file solely for layout.

## Code comments

Use clear names and structure first. Beside the relevant code, explain
non-obvious business rules, design choices, preconditions, edge cases, external
constraints, and likely misuse. Briefly explain the approach in complex logic.
Skip line-by-line commentary.

Follow project conventions for language and public API documentation. When
behavior changes, update related comments and remove obsolete ones.

## Communication

Lead with the result in technical docs, comments, commit messages, and
explanations. Use plain language, established terms, and exact names, paths,
values, or errors. Avoid flourish, metaphor, and translationese.

Edit documents directly and omit unrelated discussion and revision history. For
code references, verify the current line number and link to it using the
client’s supported format.

## Secrets

Redact credential values and note the redaction. After generating a secret,
report where it is stored. Reveal a specific value only on explicit user
request.

## Diagrams

Use a nearby SVG file or inline SVG for technical diagrams. Use Mermaid only if
requested explicitly or the target cannot render SVG, and state why. Never draw
diagrams with ASCII or box-drawing characters. Plain text is fine for code
comments, terminal output, CLI help, and directory listings.

## Git history

A commit, amend, squash, or other history rewrite requires explicit authorization
in the current user request. One authorization covers one commit for the current
change.

Use a concise, factual subject and append this trailer:

```text
Co-authored-by: AGENT MODEL <EMAIL>
```

For Codex, use `Codex MODEL <noreply@openai.com>` with the actual runtime model.
Omit the model if unknown. For other agents, use a documented official or
project-owned identity, or ask the user.
