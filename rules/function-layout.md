# Function layout within a file

Applies to every source file you create or modify, in any language with top-level functions (Python, TS/JS, Go, Rust, …).

1. **Public API first.** Exported/`pub`/capitalized-in-Go/`__all__` items go at the top, after imports and module constants — they are the reading entry points.
2. **Callers before callees.** If A calls B, B is defined below A; helpers and low-level code sink toward the bottom. So reading top-down moves from "what the file offers" → "how it works" → "mechanics", never the reverse.
3. **Helper under its caller.** A single-use helper goes immediately after its caller; a shared one after the last of its callers.

This rules out: privates-first "because defined first", alphabetizing, and grouping all `_private` functions away from the code that uses them.

**New files:** follow the above. **Existing files:** if already consistent (this layout or another), preserve it — never silently reorder a file, that's a noisy diff. For your edit, match the surrounding style and flag the inconsistency, or ask whether to reorder separately.
