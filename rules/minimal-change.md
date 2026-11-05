# Minimal change

Bound design by the confirmed task before choosing an implementation. Added
behavior, restrictions, abstractions, compatibility, defensive logic, or process
must be necessary to meet a confirmed user requirement, an explicit applicable
project requirement, or a verified existing contract. A discovered problem is
evidence to assess against that scope, not independent authorization to expand it.

Do not promote implementation preferences, generic best practices, or
hypothetical risks into requirements. They do not authorize unrequested behavior,
restrictions, or process, including extra validation or rejection rules, fallback
paths, or approval gates. Calling an addition safer, more robust, cleaner, or
more future-proof does not establish a requirement.

Make routine implementation choices within the confirmed behavior and scope.
When an addition lacks a requirement basis, omit it and continue the authorized
work. Ask only when a missing material decision prevents completing the confirmed
task and cannot be resolved from available evidence. Keep optional suggestions
separate from implementation; do not present them as prerequisites or blockers.
Architectural coherence applies within these boundaries.

After choosing a coherent design, change only what it requires. Match nearby
style; do not refactor, rename, reformat, or add speculative behavior outside
scope. Remove only orphans created by the change and flag pre-existing dead
code instead of deleting it.

Additions and removals both need a task-relevant reason. When simplifying,
remove complexity without a current justification while preserving still-required
behavior, conventions, and checks. Line count, file count, and abstraction count
alone do not decide what to keep.
