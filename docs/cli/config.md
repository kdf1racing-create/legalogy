---
summary: "CLI reference for `legalogy config` (get/set/unset config values)"
read_when:
  - You want to read or edit config non-interactively
title: "config"
---

# `legalogy config`

Config helpers: get/set/unset values by path. Run without a subcommand to open
the configure wizard (same as `legalogy configure`).

## Examples

```bash
legalogy config get browser.executablePath
legalogy config set browser.executablePath "/usr/bin/google-chrome"
legalogy config set agents.defaults.heartbeat.every "2h"
legalogy config set agents.list[0].tools.exec.node "node-id-or-name"
legalogy config unset tools.web.search.apiKey
```

## Paths

Paths use dot or bracket notation:

```bash
legalogy config get agents.defaults.workspace
legalogy config get agents.list[0].id
```

Use the agent list index to target a specific agent:

```bash
legalogy config get agents.list
legalogy config set agents.list[1].tools.exec.node "node-id-or-name"
```

## Values

Values are parsed as JSON5 when possible; otherwise they are treated as strings.
Use `--json` to require JSON5 parsing.

```bash
legalogy config set agents.defaults.heartbeat.every "0m"
legalogy config set gateway.port 19001 --json
legalogy config set channels.whatsapp.groups '["*"]' --json
```

Restart the gateway after edits.
