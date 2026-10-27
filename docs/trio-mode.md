# Trio mode: one lead, two sandboxes, one repo

Caravan mode runs agents in **different projects**. Trio mode is for **one project**: a LEAD agent
splits the work, and two agents (A and B) do it in their own copy of the repo, side by side.

```
┌──────────────── Ghostty ── ssh ─► server ─► tmux "trio" ────────────────┐
│  LEAD (account 1)    │  A (account 2)        │  B (account 3)            │
│  ~/.trio/w/lead      │  ~/.trio/w/a          │  ~/.trio/w/b              │
│  branch trio-lead    │  branch trio-a        │  branch trio-b            │
│  splits + merges     │  works, commits       │  works, commits           │
└──────────── all three read/append ~/.trio/BOARD.md ─────────────────────┘
```

## Why it does not collide
- **Own worktree per pane** — same repo, separate folders and branches. A and B cannot overwrite each other.
- **Own Claude account per pane (optional)** — each pane has its own `CLAUDE_CONFIG_DIR` (`~/.trio/claude-lead|a|b`).
  Type `/login` once in a pane and pick an account; that pane stays on it. Your normal `~/.claude` login is untouched.
  Settings, skills, agents and plugins are shared via symlinks, so every pane behaves the same.
- **One board** — `~/.trio/BOARD.md`, append-only. The lead writes `## To A: …` / `## To B: …` with file names;
  agents append `started` / `done` lines. Everyone reads it before a task.

## Start
```bash
cd ~/my-project && trio        # on the server; same command re-attaches
```
From your Mac (one line in `~/.config/terminal-stack.zsh`):
```bash
trio() { ssh -t myserver "bash -lc 'trio $*'"; }
```
First time only: `/login` in each pane. Then talk to the LEAD; it hands work to A and B through the board.

Tiny test (cheap — use `/model haiku` first):
- LEAD: `Append to the board: "To A: write a.txt containing A. To B: write b.txt containing B." Answer in one word.`
- A and B: `Read the board, do your task, append "- done". Answer in one word.`
- LEAD: `Read the board: are A and B done? One sentence.`

## Ship
The lead merges `trio-a` and `trio-b` into `trio-lead`, builds and tests. You push or open a PR from there
(the lead does not push without your OK).

## Close — idle agents cost memory
Three idle Claude Code panes use roughly **2 GB RAM** and some CPU (measured), but no tokens.
- `trio close` stops all three. Logins stay in `~/.trio/claude-*`; `trio` brings them back without `/login`.
- `Ctrl-a d` (or `Ctrl-b d`) only leaves; the agents keep running.
- Watchdog (closes it when nobody is attached and no pane's screen changed for 2 hours — the status line is ignored):
  ```cron
  */30 * * * * /usr/local/bin/trio watchdog     # TRIO_IDLE_HOURS=4 to change the limit
  ```

## Honest limits
- The board is read when an agent starts or finishes a task; agents are not interrupted mid-task by new lines.
- Several accounts for one person: check your provider's terms. Trio also works with **one** account in all
  three panes — you still get the sandboxes, the quota is just shared.
