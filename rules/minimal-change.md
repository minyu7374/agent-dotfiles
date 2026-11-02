# Minimal change

Bound design by the confirmed task before choosing an implementation. Added
behavior, abstractions, compatibility, defensive logic, or process must serve a
current requirement, an established contract, or an evidenced problem. General
best practices and hypothetical benefits alone do not justify added complexity.
Architectural coherence applies within this boundary.

After choosing a coherent design, change only what it requires. Match nearby
style; do not refactor, rename, reformat, or add speculative behavior outside
scope. Remove only orphans created by the change and flag pre-existing dead
code instead of deleting it.

Additions and removals both need a task-relevant reason. When simplifying,
remove complexity without a current justification while preserving still-required
behavior, conventions, and checks. Line count, file count, and abstraction count
alone do not decide what to keep.
