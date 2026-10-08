# Ghostty Agent Setup

A calm, fast terminal setup for people who run AI coding agents (Claude Code, Codex, Gemini CLI…) —
explained so that **you do not need to know anything about terminals** to use it.

> **The one-line version:** Ghostty is the window. A handful of small tools make that window friendlier.
> `tmux` on a server keeps your agents alive when you close your laptop.

---

## The "explain it to my grandma" version

Imagine a **workshop**:

| In the workshop | In this setup | What it does for you |
|---|---|---|
| The room you stand in | **Ghostty** | A fast, clean terminal window |
| A notebook that remembers every job you did | **atuin** | Press `Ctrl+R`, type a few letters, find any old command |
| A teleporter between rooms | **zoxide** | `z api` jumps to your `api` folder from anywhere |
| Labels and colors on the shelves | **eza**, **bat** | `ls` and file-reading with colors and icons |
| A picture-book for Git | **lazygit** | Save and upload your work with a menu instead of memorized commands |
| A workshop that never closes at night | **tmux** (on a server) | Your agent keeps working after you shut the laptop |

You open **one** app (Ghostty). Everything else lives inside it.

---

## Why Ghostty — and why not the others?

Short answer: **it is the fastest, plainest, and most dependable option, and it asks nothing of you.**

| Option | Verdict for agent work | Why |
|---|---|---|
| **Ghostty** ✅ | **Use this** | Native, GPU-accelerated, open source (macOS + Linux), splits and tabs built in, almost no config needed |
| iTerm2 | Fine, but no reason to switch | Mature and feature-rich, but heavier, and it adds nothing Ghostty + tmux does not already cover |
| cmux | Optional, only for its **browser pane** | macOS-only and young. Its free tier overlaps with Ghostty + tmux; its paid cloud tier (listed at $40/mo when we checked) solves "keep agents running while I'm away" — which a cheap VPS plus tmux already does. Its one thing Ghostty cannot do is show a web page next to the terminal (see below) |
| Warp | Skip | Account-based and built around cloud AI features. If your shell history contains tokens and passwords, keep it local (check Warp's current policy yourself) |
| Nushell | Skip as login shell | Different syntax from zsh/bash; many tools' init scripts (`eval "$(…)"`) and agent shell commands assume POSIX |
| Workmux, Hunk | Later | Useful once you run **several agents in the same repo**. Until then, plain `git worktree` is enough |

The deeper reasoning is in [`docs/why-these-tools.md`](docs/why-these-tools.md).

---

## What about a browser?

**Ghostty has no built-in browser** (its feature docs mention none). That is the main thing cmux adds.
If you build web apps and keep refreshing `localhost:3000`, you have three good options, from simplest:

1. **Use your normal browser next to Ghostty.** On macOS, tile the two windows side by side (drag a window to the screen edge, or hold the green button). Zero setup, and you keep your extensions and devtools.
2. **Let the agent drive a browser.** Tools such as [agent-browser](https://github.com/vercel-labs/agent-browser) or Claude in Chrome let an agent open pages, click, and take screenshots while you stay in Ghostty.
3. **Try cmux just for web projects.** It is free to run locally; keep Ghostty for everything else.

Text-mode browsers (`w3m`, `lynx`) work inside any terminal, but they do not run modern JavaScript apps.

---

## What is inside

```
ghostty/config            Ghostty settings (theme, fonts, safe-close, remote-friendly)
shell/terminal-stack.zsh  Aliases + zoxide + atuin for your Mac (zsh)
shell/terminal-stack.bash Same idea for a Linux server (bash)
tmux/tmux.conf            Server tmux: Ctrl-a prefix, mouse on, easy splits
atuin/config.toml         Local-only history that never records secrets
scripts/panel             One command → a 2x2 grid of agents on your server
install.sh                Mac installer (supports --dry-run)
docs/                     Cheatsheet, server guide, troubleshooting
```

### Built to be safe around agents

- **Agents are not affected.** Aliases load only when `CLAUDECODE` is **unset**. Claude Code sets it for its own commands, so agents keep seeing plain `ls`/`cat` output. That is why `cat` is untouched and the colorful one is called `bcat`.
- **Secrets stay out of history.** Atuin sync is **off**, and commands containing `password`, `token=`, `api_key`, `sk-…`, `sshpass` are never recorded.
- **Nothing is overwritten silently.** `install.sh` backs up any existing file first.

---

## Install (Mac) — three steps

1. Install [Homebrew](https://brew.sh) if you do not have it.
2. In Terminal:
   ```bash
   git clone https://github.com/bbbirkan/ghostty-agent-setup.git
   cd ghostty-agent-setup
   bash install.sh --dry-run   # look first
   bash install.sh             # then do it
   ```
3. Open a **new** Ghostty window. Try `ll`, then `Ctrl+R`.

Want to undo it? Delete the symlinks in `~/.config/` and the one line the installer added to `~/.zshrc`
(it is marked with `terminal-stack`). Backups are next to the originals, ending in `.bak-<date>`.

---

## Daily use (the whole cheatsheet fits here)

| I want to… | Type / press |
|---|---|
| Find an old command | `Ctrl` + `R`, type a few letters, `Tab` to edit or `Enter` to run |
| Jump to a folder | `z api` (needs one normal `cd` into it first); `zi` to pick from a list |
| List files nicely | `ls` / `ll` |
| Read a file with colors | `bcat file.py` |
| Git, with a menu | `lg` inside a git project (`?` = help, `q` = quit) |
| Run 4 agents at once (server) | `panel -c ~/api ~/web ~/docs ~/ops` |
| Leave a server session running | `Ctrl-a` then `d` — **never** type `exit` |

More: [`docs/cheatsheet.md`](docs/cheatsheet.md).

---

## Using it with a server (the part that keeps agents alive)

Your laptop sleeps; a server does not. Run agents **on the server inside tmux** and your Mac becomes just a window:

```
Mac (Ghostty) ──ssh──►  Server: tmux session "panel"
   close laptop ✖                 └─ agents keep running ✓
   come back, `panel` ──────────► same screen, same progress
```

Step-by-step (install the tools on Ubuntu, copy `tmux.conf`, add `panel`): [`docs/server.md`](docs/server.md).

---

## Honest limits

- **macOS-first.** `install.sh` is for Mac. The server instructions were verified by hand on **Ubuntu 24.04**; other distros need small package-name changes.
- `panel -c` simply types `claude` into each pane. Do not point two agents at the **same folder** — they can overwrite each other's files.
- Lazygit 0.66 offered to create a git repo (and then crashed) when launched **outside** a git project. Answer **N** and `cd` into a project first.

---

## Contributing & license

Issues and pull requests are welcome — especially for Linux desktops and other shells.
Released under the [MIT License](LICENSE).
