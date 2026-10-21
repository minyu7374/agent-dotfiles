# Repository instructions

This repository manages shared configuration for five coding assistants.
Use the lightest workflow that fits the requested change and its actual impact.

- Read [README.md](README.md) before structural changes.
- Install external plugins through each assistant's native manager; record their
  sources and commands in [open-source.md](open-source.md), without vendoring.
- Keep shared rules aligned between `rules/` and `memories/agent-principles.md`.
  Use [apps/](apps/) for the applicable destinations.
- `scripts/sync.sh` manages custom assets and Claude/CodeBuddy public settings.
  Provider/model settings and OpenCode JSON/JSONC stay under native management.
- Run the checks in `README.md` for script/configuration changes. Test sync changes
  in a disposable environment, including a second run for idempotence.
- Editing a snapshot does not apply it. Report synchronization and client reload
  status separately.
