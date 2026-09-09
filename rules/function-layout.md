# Function layout

In created or modified source files: public items precede private ones; callers
precede callees; a single-use helper follows its caller, and a shared helper
follows its last caller. Preserve an existing consistent layout; do not reorder
a file solely for this rule.
