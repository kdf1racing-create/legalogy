---
summary: "Uninstall Legalogy completely (CLI, service, state, workspace)"
read_when:
  - You want to remove Legalogy from a machine
  - The gateway service is still running after uninstall
title: "Uninstall"
---

# Uninstall

Two paths:

- **Easy path** if `legalogy` is still installed.
- **Manual service removal** if the CLI is gone but the service is still running.

## Easy path (CLI still installed)

Recommended: use the built-in uninstaller:

```bash
legalogy uninstall
```

Non-interactive (automation / npx):

```bash
legalogy uninstall --all --yes --non-interactive
npx -y legalogy uninstall --all --yes --non-interactive
```

Manual steps (same result):

1. Stop the gateway service:

```bash
legalogy gateway stop
```

2. Uninstall the gateway service (launchd/systemd/schtasks):

```bash
legalogy gateway uninstall
```

3. Delete state + config:

```bash
rm -rf "${LEGALOGY_STATE_DIR:-$HOME/.legalogy}"
```

If you set `LEGALOGY_CONFIG_PATH` to a custom location outside the state dir, delete that file too.

4. Delete your workspace (optional, removes agent files):

```bash
rm -rf ~/.legalogy/workspace
```

5. Remove the CLI install (pick the one you used):

```bash
npm rm -g legalogy
pnpm remove -g legalogy
bun remove -g legalogy
```

6. If you installed the macOS app:

```bash
rm -rf /Applications/Legalogy.app
```

Notes:

- If you used profiles (`--profile` / `LEGALOGY_PROFILE`), repeat step 3 for each state dir (defaults are `~/.legalogy-<profile>`).
- In remote mode, the state dir lives on the **gateway host**, so run steps 1-4 there too.

## Manual service removal (CLI not installed)

Use this if the gateway service keeps running but `legalogy` is missing.

### macOS (launchd)

Default label is `bot.molt.gateway` (or `bot.molt.<profile>`; legacy `com.legalogy.*` may still exist):

```bash
launchctl bootout gui/$UID/bot.molt.gateway
rm -f ~/Library/LaunchAgents/bot.molt.gateway.plist
```

If you used a profile, replace the label and plist name with `bot.molt.<profile>`. Remove any legacy `com.legalogy.*` plists if present.

### Linux (systemd user unit)

Default unit name is `legalogy-gateway.service` (or `legalogy-gateway-<profile>.service`):

```bash
systemctl --user disable --now legalogy-gateway.service
rm -f ~/.config/systemd/user/legalogy-gateway.service
systemctl --user daemon-reload
```

### Windows (Scheduled Task)

Default task name is `Legalogy Gateway` (or `Legalogy Gateway (<profile>)`).
The task script lives under your state dir.

```powershell
schtasks /Delete /F /TN "Legalogy Gateway"
Remove-Item -Force "$env:USERPROFILE\.legalogy\gateway.cmd"
```

If you used a profile, delete the matching task name and `~\.legalogy-<profile>\gateway.cmd`.

## Normal install vs source checkout

### Normal install (install.sh / npm / pnpm / bun)

If you used `https://legalogy.ai/install.sh` or `install.ps1`, the CLI was installed with `npm install -g legalogy@latest`.
Remove it with `npm rm -g legalogy` (or `pnpm remove -g` / `bun remove -g` if you installed that way).

### Source checkout (git clone)

If you run from a repo checkout (`git clone` + `legalogy ...` / `bun run legalogy ...`):

1. Uninstall the gateway service **before** deleting the repo (use the easy path above or manual service removal).
2. Delete the repo directory.
3. Remove state + workspace as shown above.
