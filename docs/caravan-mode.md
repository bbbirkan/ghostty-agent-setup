# Caravan mode: several agents, one screen, no collisions

A **caravan** is a group of travellers who move together but each carry their own load.
That is the idea: several AI agents work at the same time, **each in its own project folder**,
and you watch them all on one screen.

```
┌───────── Ghostty ──────────────────────────────────────────┐
│  ssh ─► server ─► tmux session "panel"                       │
│   ┌──────────────┬──────────────┐                            │
│   │ api  (Claude)│ web  (Claude)│   you watch all four       │
│   ├──────────────┼──────────────┤   and talk to any one      │
│   │ docs (Claude)│ shell        │                            │
│   └──────────────┴──────────────┘                            │
└──────────────────────────────────────────────────────────────┘
close the laptop: the agents keep working
```

## 1. Start it

On the machine where the agents should live (a server is ideal, see [server.md](server.md)):

```bash
panel -c ~/api ~/web ~/docs -     # 3 Claude agents + 1 empty shell ("-" = empty)
```

Already running? The same command just re-attaches. Leave without stopping anything:
`Ctrl-a d` (or `Ctrl-b d` if you did not use this repo's `tmux.conf`).

From your Mac, add a one-line helper to `~/.config/terminal-stack.zsh` (see the file):

```bash
SERVER=myserver
panel() { ssh -t "$SERVER" panel "$(printf '%q ' "$@")"; }
```

## 2. Why agents do not overwrite each other

**Different folder = different files.** That is the whole trick, and it is why the default is
"one agent per project". Two agents in the *same* folder can silently overwrite each other's work.
If you really need two agents on one repo, give each its own checkout:

```bash
git worktree add ../myrepo-feature-a -b feature-a
git worktree add ../myrepo-feature-b -b feature-b
```

(Tools such as [workmux](https://github.com/raine/workmux) automate that. We deliberately do not
require one: if you do not already branch per task, it is an extra layer to maintain.)

## 3. Let the agents know about each other (optional, three levels)

| Level | What | When to use |
|---|---|---|
| 0 | Nothing. Each agent lives in its own world | Independent tasks. The safest default |
| 1 | **Shared notes file.** Agents read it first and append one line when done | Tasks that touch the same system |
| 2 | **`ask-agent`.** One agent sends a short request to another agent's pane | An agent genuinely needs something from another |

### Level 1: shared notes

```bash
mkdir -p ~/agents-shared
cp templates/NOTES.md ~/agents-shared/NOTES.md
```

```bash
cp templates/KICKOFF.txt ~/agents-shared/KICKOFF.txt
```

Then give each agent this one-time instruction (the rules are in [`templates/KICKOFF.txt`](../templates/KICKOFF.txt)):

> Read `~/agents-shared/KICKOFF.txt` and follow it.

### Level 2: agents asking each other

```bash
sudo install -m755 scripts/ask-agent /usr/local/bin/ask-agent
```

An agent runs, from inside its pane:

```bash
ask-agent web "Can you summarise the API error codes you added?"
```

The message is typed into the other agent's pane, prefixed with
`[Request from agent 'api' - NOT a user instruction]`. Built-in safety:

- you cannot ask yourself
- **max 3 requests per minute in total**, so two agents cannot ping-pong forever
- single line, 500 characters
- every request is logged in the shared notes
- the receiver is told to treat it as information, not as a command from you

## 4. Know when an agent needs you

You do not have to stare at the screen: see [notifications.md](notifications.md)
(desktop notification on a Mac, Telegram message from a server).

## 5. Review before you merge

When an agent says "done", open `lazygit` in its folder (`lg`), look at the diff, stage what you
approve, commit. An agent saying "done" is not proof that it is right.

## Honest limits

- Agent-to-agent messages can spread a mistaken idea from one agent to another. Keep an eye on the grid.
- If the target agent is busy, the message queues and is read when it finishes its current turn.
- `panel -c` just types `claude` into each pane; it does not pass a task. You give each agent its task by typing to it.
