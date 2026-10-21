# Plan calibration

## Choose a proportional workflow

Use the lightest workflow sufficient for the confirmed task, actual impact,
and available evidence:

- Direct work: clear, simple changes with little design choice; implement and
  verify without a separate design document or approval gate.
- Brief design: non-trivial changes with bounded impact; explain the design,
  scope, and verification in chat and wait for approval.
- Detailed design: changes to shared contracts or component relationships,
  data migrations, or important unresolved decisions; document the affected
  design and implementation steps and review the material decisions.

A new function, file, feature, or unfamiliar code does not by itself require
a heavier workflow. Investigate the relevant unknowns first; ask only when a
missing product decision materially affects the design. Document length and
approval steps should follow actual decision needs, not a fixed itinerary.

## Adjust in either direction

Upgrade when new evidence shows the current design or workflow is insufficient.
Downgrade when clarification, disproved assumptions, or resolved risks make
the extra process unnecessary. Explain only the material change and its reason;
do not restart planning or repeat the full task description at every adjustment.

When revising a proposal after feedback, treat the feedback as evidence about
the proposal, not as a new task. Identify the invalidated assumption and keep
the agreed goal, constraints, non-goals, and necessary acceptance checks.
Remove process, behavior, and checks justified only by the invalidated assumption.

Change only the affected parts. If a wider redesign or scope change is needed,
explain why the local revision is insufficient and obtain approval for that
change. A workflow adjustment alone does not need a separate approval; do not
ask again for unchanged, approved work.

## Keep design coherent and scope bounded

Judge simplicity by the resulting structure, not only the diff size, file count,
or number of abstractions. Reshape the affected design when current requirements
need it to remove special cases, parallel paths, or duplication. Do not add
behavior, dependencies, compatibility, or abstractions for hypothetical needs.
Heavier process does not authorize broader implementation.

Handle high-impact actions with the required authorization and checks separately
from workflow depth. Verification must match the confirmed requirements and
actual risks; complete the agreed acceptance checks, then stop unless new
evidence justifies more work.

These project rules take precedence over third-party skill defaults for
automatic workflow triggering, one-way escalation, and repeated approval gates.
Keep applicable architectural-coherence, debugging, verification, and permission
requirements; apply them in proportion to the task and the user's instructions.
