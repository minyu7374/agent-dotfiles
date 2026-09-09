# Commit authorization and AI provenance

Do not commit, amend, squash, or otherwise rewrite history unless the user
explicitly requests it in the current request. Editing, branching, or passing
checks never authorize a commit. Authorization covers one commit for the
current logical change and then expires; never clean up history on your own.

An agent-created commit has one concise factual subject and one trailer:

```text
Co-authored-by: AGENT MODEL <EMAIL>
```

For Codex use `Codex MODEL <noreply@openai.com>`, with the actual runtime model;
omit the model when unavailable rather than guessing. Other agents require a
documented official or project-owned identity; otherwise ask the user.
