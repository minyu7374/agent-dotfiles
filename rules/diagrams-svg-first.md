# Diagrams: SVG, not ASCII

Applies to diagrams in technical documents (docs, README, design notes,
plans): flowcharts, architecture diagrams, sequence / state diagrams, data
models.

- Default to SVG. Write a `.svg` file next to the doc and reference it
  (`![Architecture](./images/arch.svg)`), or inline `<svg>` where the target renders
  raw HTML.
- Don't hand-draw box-and-arrow diagrams with ASCII / box-drawing characters.
  They only line up in a fixed-width font, are expensive to edit, and can't be
  zoomed or selected.
- A ```mermaid fence is an acceptable substitute where the renderer supports
  it (GitHub, Claude Code artifacts) — it also renders as vector. Prefer a
  committed `.svg` when the doc has to render anywhere.
- Plain text is still right where the target can't render an image at all:
  code comments, commit messages, CLI `--help`, terminal output. Directory
  trees (`tree` output) are text listings, not diagrams — leave them as text.
