# Notifications: know when an agent finished or is waiting

Agents run for minutes. You should not have to watch them. `scripts/agent-notify` tells you:

- ✅ **done** (only if the turn took at least 45 seconds, so quick replies stay quiet)
- ⏳ **waiting**: a permission prompt or a question for you

| Where the agent runs | You get |
|---|---|
| Your Mac | A macOS notification with a sound |
| A Linux server | A Telegram message |

## Install

```bash
# Mac
mkdir -p ~/.claude/scripts && cp scripts/agent-notify ~/.claude/scripts/agent-notify.py
# Linux server
sudo install -m755 scripts/agent-notify /usr/local/bin/agent-notify
```

## Telegram (for servers)

1. In Telegram, talk to **@BotFather**, create a bot, copy the token.
2. Send your new bot any message, then find your chat id (for example via the bot's `getUpdates` page).
3. Store both **outside the script**:

```bash
mkdir -p ~/.config/agent-notify && chmod 700 ~/.config/agent-notify
cat > ~/.config/agent-notify/env <<'ENV'
TELEGRAM_BOT_TOKEN=123456:your-token
TELEGRAM_CHAT_ID=123456789
ENV
chmod 600 ~/.config/agent-notify/env
```

## Connect it to Claude Code

Add the command to three hook events in `~/.claude/settings.json`. Keep any hooks you already have;
just add a new entry to each list. Example for the server:

```json
{
  "hooks": {
    "UserPromptSubmit": [{ "hooks": [{ "type": "command", "command": "/usr/local/bin/agent-notify" }] }],
    "Stop":             [{ "hooks": [{ "type": "command", "command": "/usr/local/bin/agent-notify" }] }],
    "Notification":     [{ "hooks": [{ "type": "command", "command": "/usr/local/bin/agent-notify" }] }]
  }
}
```

On a Mac use `python3 ~/.claude/scripts/agent-notify.py` as the command. Restart running Claude sessions
so they pick the settings up.

## Test it without Claude

```bash
echo '{"hook_event_name":"Notification","session_id":"t","cwd":"/x/demo","message":"Test"}' | agent-notify
# no notification? print what it would send instead:
echo '{"hook_event_name":"Notification","session_id":"t","cwd":"/x/demo","message":"Test"}' | AGENT_NOTIFY_DRY=1 agent-notify
```

## Settings

| Variable | Default | Meaning |
|---|---|---|
| `AGENT_NOTIFY_MIN_SECONDS` | `45` | Shorter turns do not trigger "done" |
| `AGENT_NOTIFY_CHANNEL` | `desktop` on macOS, `telegram` elsewhere | Force a channel |
| `AGENT_NOTIFY_DRY` | unset | Print instead of sending |

On macOS the first notification may need permission: System Settings → Notifications.

## Safety

It never blocks the agent (sending happens in a background child; all errors are swallowed) and the
Telegram token never lives in the script or in git.
