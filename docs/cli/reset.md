---
summary: "CLI reference for `legalogy reset` (reset local state/config)"
read_when:
  - You want to wipe local state while keeping the CLI installed
  - You want a dry-run of what would be removed
title: "reset"
---

# `legalogy reset`

Reset local config/state (keeps the CLI installed).

```bash
legalogy reset
legalogy reset --dry-run
legalogy reset --scope config+creds+sessions --yes --non-interactive
```
