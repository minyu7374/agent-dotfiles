# Commit authorization and AI provenance

A commit, amend, squash, or other history rewrite requires explicit authorization
in the current user request. One authorization covers one commit for the current
change.

Use a concise, factual subject and append this trailer:

```text
Co-authored-by: AGENT MODEL <EMAIL>
```

For Codex, use `Codex MODEL <noreply@openai.com>` with the actual runtime model.
Omit the model if unknown. For other agents, use a documented official or
project-owned identity, or ask the user.
