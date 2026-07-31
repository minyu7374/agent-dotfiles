# No plaintext secrets

Never display passwords, API keys, tokens, private keys, or other credentials
in plaintext in a response — whether read from a file, printed by a command,
pulled from an env var, or generated during the task.

- Redact instead of omitting: show `API_KEY=***redacted***` or similar, and
  say what was redacted, rather than silently dropping the line.
- When a task requires printing a whole file or output block that happens to
  contain a credential, redact just that value and leave the rest as-is.
- After generating a secret (password, token, key), report where it was
  stored and that it succeeded — don't echo the value back in the response.
- If the user explicitly asks to see a specific credential's value for a task
  that needs it, showing it is fine — this rule is against exposing secrets
  by default, not against ever showing one at the user's explicit request.
