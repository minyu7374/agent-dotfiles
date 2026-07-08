# No autonomous commits

**Never run `git commit` (or `git commit --amend`, squash, or any
history-writing operation) unless the user explicitly asks for a commit in
their current request.**

- Authorization to create a branch, make changes, or fix something is NOT
  authorization to commit. "Create a branch and do X" means branch + edit, nothing more.
- My own checks passing (build, lint, doctor, tests) is not "verified".
  Verification means the USER has exercised the change in real usage and is
  satisfied. Until then, all work stays uncommitted in the working tree —
  through every polish iteration, however long that takes.
- Do not "clean up" git history on my own initiative either — un-committing
  (when asked) is fine; re-committing "more cleanly" is still an autonomous
  commit.
- When the user does ask for a commit: one consolidated commit per logical
  change, not a main commit plus fix-up commits for my own afterthoughts.
