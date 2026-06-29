# Architectural Coherence

After a change lands, the code should read as if it had been designed that way from the start — no visible seam between "old" and "new".

When adding to or extending existing code, build toward the shape the module *would* have if the feature had been required on day one. Minimizing the diff is right only when the existing structure already fits the change; don't bolt new code beside the old just to keep the diff small.

For the full playbook — the patch-style trap, the signals of harmony vs. bolt-on, scope discipline, and the finish checklist — use the **architectural-harmony** skill.
