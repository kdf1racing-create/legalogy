---
summary: "CLI reference for `legalogy voicecall` (voice-call plugin command surface)"
read_when:
  - You use the voice-call plugin and want the CLI entry points
  - You want quick examples for `voicecall call|continue|status|tail|expose`
title: "voicecall"
---

# `legalogy voicecall`

`voicecall` is a plugin-provided command. It only appears if the voice-call plugin is installed and enabled.

Primary doc:

- Voice-call plugin: [Voice Call](/plugins/voice-call)

## Common commands

```bash
legalogy voicecall status --call-id <id>
legalogy voicecall call --to "+15555550123" --message "Hello" --mode notify
legalogy voicecall continue --call-id <id> --message "Any questions?"
legalogy voicecall end --call-id <id>
```

## Exposing webhooks (Tailscale)

```bash
legalogy voicecall expose --mode serve
legalogy voicecall expose --mode funnel
legalogy voicecall unexpose
```

Security note: only expose the webhook endpoint to networks you trust. Prefer Tailscale Serve over Funnel when possible.
