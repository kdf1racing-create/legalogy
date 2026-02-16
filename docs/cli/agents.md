---
summary: "CLI reference for `legalogy agents` (list/add/delete/set identity)"
read_when:
  - You want multiple isolated agents (workspaces + routing + auth)
title: "agents"
---

# `legalogy agents`

Manage isolated agents (workspaces + auth + routing).

Related:

- Multi-agent routing: [Multi-Agent Routing](/concepts/multi-agent)
- Agent workspace: [Agent workspace](/concepts/agent-workspace)

## Examples

```bash
legalogy agents list
legalogy agents add work --workspace ~/.legalogy/workspace-work
legalogy agents set-identity --workspace ~/.legalogy/workspace --from-identity
legalogy agents set-identity --agent main --avatar avatars/legalogy.png
legalogy agents delete work
```

## Identity files

Each agent workspace can include an `IDENTITY.md` at the workspace root:

- Example path: `~/.legalogy/workspace/IDENTITY.md`
- `set-identity --from-identity` reads from the workspace root (or an explicit `--identity-file`)

Avatar paths resolve relative to the workspace root.

## Set identity

`set-identity` writes fields into `agents.list[].identity`:

- `name`
- `theme`
- `emoji`
- `avatar` (workspace-relative path, http(s) URL, or data URI)

Load from `IDENTITY.md`:

```bash
legalogy agents set-identity --workspace ~/.legalogy/workspace --from-identity
```

Override fields explicitly:

```bash
legalogy agents set-identity --agent main --name "Legalogy" --emoji "🦞" --avatar avatars/legalogy.png
```

Config sample:

```json5
{
  agents: {
    list: [
      {
        id: "main",
        identity: {
          name: "Legalogy",
          theme: "space lobster",
          emoji: "🦞",
          avatar: "avatars/legalogy.png",
        },
      },
    ],
  },
}
```
