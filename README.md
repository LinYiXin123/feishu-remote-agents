# Feishu Remote Agents Backup

This repository stores the reusable parts of the local Feishu remote-agent setup on drive `F:`.

## What is included

- `AGENTS.md` and `CLAUDE.md` runtime rules
- startup and watcher scripts
- file sending helper script
- a sanitized config template
- restore instructions

## What is not included

- live session data
- logs
- uploaded attachments
- app secrets, API keys, or local auth tokens

## Restore after reinstall

1. Restore these folders to the same drive layout if possible:
   - `F:\远程连接agent`
   - `F:\cc-agent`
   - `F:\cc-global`
   - `F:\claude-global`
2. Copy `cc-config\\config.template.toml` to `F:\cc-agent\cc-config\config.toml`.
3. Fill in your Feishu app IDs, app secrets, and model API keys.
4. Run:

```powershell
powershell -ExecutionPolicy Bypass -File F:\cc-agent\start-cc-connect.ps1
```

5. Confirm `cc-connect` is online and then test each bot in Feishu.

## Notes

- Current auto-start is configured through the Windows Startup folder shortcut.
- A scheduled-task startup path would be stronger, but it requires Windows admin rights.
- File sending is designed to use the current `CC_SESSION_KEY` when triggered from inside a bot session.

