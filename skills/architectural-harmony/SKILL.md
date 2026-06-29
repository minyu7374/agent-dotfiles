---
name: architectural-harmony
description: Use when adding a feature to existing code, integrating a new backend/provider/variant, or refactoring — especially the moment you're tempted to drop new code beside the old and wire them together. Ensures the result reads as one coherent design, not a visible old-vs-new seam.
---

# Architectural Harmony

**Core principle:** after a change lands, the code should read as if the whole thing had been designed that way from the start — no visible seam between "old" and "new."

## When this applies

Adding a capability to an existing module, introducing a second (third…) implementation behind an abstraction, extending a package. The danger moment is when the fastest path is to bolt new code *next to* the old and connect them.

## The trap

Minimizing the diff is a virtue **only when the existing structure already accommodates the change.** When it doesn't, a minimal-diff patch leaves a seam:

- the original case stays privileged (special-cased), while the new one looks grafted on;
- an abstraction gets added as an afterthought that one old type just "happens to satisfy";
- naming, file layout, and constant placement diverge between the old part and the new part.

A future reader then sees "someone added X later," not one design. Reducing churn is reasonable; patching *purely* to reduce churn is not.

## What to do instead

Before writing, ask: **if this capability had been required on day one, what would this package / file / type look like?** Build toward that shape, then make the change fit it.

You're creating harmony — not a patch — when:

- **The abstraction is the spine.** Interface/base type is the organizing center; implementations are equal peers under it. None is the "real" one the others were retrofitted around.
- **Parallel things look parallel.** Sibling implementations share constructor shape, naming convention, where constants live, and how files are split. A newcomer can't tell which came first.
- **Tangled concerns get separated** when the change exposes them (don't keep two responsibilities fused in one file just because they already were).
- **Names and file boundaries match the new reality** — rename and move when the old names now misdescribe things, rather than preserving them to shrink the diff.

## Scope discipline

This is not license to rewrite the world. Refactor what the change *touches* plus what's needed to seat it cleanly — not unrelated code. And a harmonious structure is a lean one: don't add speculative generality, extra layers, or defensive compatibility the task doesn't need. Coherence and restraint pull together, not apart.

## Before finishing, check

- Does anything read as "added later"? — an interface that fits only one implementation, the original path special-cased, sibling files named/organized inconsistently, leftover names that no longer fit.
- Would you draw this same structure if starting fresh today? If not, adjust until you would.
