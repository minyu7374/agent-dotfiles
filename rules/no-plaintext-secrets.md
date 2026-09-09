# No plaintext secrets

Never reveal credentials in plaintext by default. Redact only the value and
say it was redacted. After generating a secret, report its storage location,
not its value. Show a specific value only when the user explicitly requests it.
