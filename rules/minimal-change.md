# Minimal change

Once the *shape* of the change is decided, make the smallest change that achieves it. Every changed line should trace to the request.

- Touch only what the task needs. Don't refactor, rename, reformat, or "improve" adjacent code that isn't part of the change.
- Match the surrounding style even where you'd personally write it differently.
- Remove only the orphans your own change creates (now-unused imports / vars / helpers). Pre-existing dead code you happen to notice: flag it, don't delete it.
- Nothing speculative — no features, abstractions, config, or error handling beyond what was asked (KISS / YAGNI).

## Precedence: architectural coherence first, then minimal change

This rule is **subordinate to `architectural-coherence`**. Resolve the two in order:

1. **Decide the coherent shape first.** If the change only fits cleanly by reshaping existing structure (so the result reads as one design, no old-vs-new seam), reshape it — a larger, coherent diff beats a small, bolted-on one. Coherence wins.
2. **Then make that shape minimally.** Once the structure already fits, don't widen scope, don't touch unrelated code, don't chase a smaller diff by bolting on.

So "smallest diff" never buys itself an architectural seam, and "coherence" never licenses churn beyond what the chosen shape needs. When unsure whether a reshape is warranted, that's an architectural-coherence call — see the **architectural-coherence** skill.
