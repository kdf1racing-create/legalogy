---
summary: "CLI reference for `legalogy logs` (tail gateway logs via RPC)"
read_when:
  - You need to tail Gateway logs remotely (without SSH)
  - You want JSON log lines for tooling
title: "logs"
---

# `legalogy logs`

Tail Gateway file logs over RPC (works in remote mode).

Related:

- Logging overview: [Logging](/logging)

## Examples

```bash
legalogy logs
legalogy logs --follow
legalogy logs --json
legalogy logs --limit 500
legalogy logs --local-time
legalogy logs --follow --local-time
```

Use `--local-time` to render timestamps in your local timezone.
