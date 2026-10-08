# Why these tools (and not others)

The rule behind every choice: **fix a specific pain, add as little as possible, never break the agent.**

## The pains, and what fixes them

| Pain | Tool | Notes |
|---|---|---|
| "What was that long command I ran last week?" | **atuin** | SQLite history with fuzzy search. Sync off, secrets filtered |
| "I keep typing long paths" | **zoxide** | Learns the folders you use. Must visit a folder once with `cd` before `z` knows it |
| "Everything is one color" | **eza**, **bat** | Aliases only — `cat` stays real `cat` for scripts and agents |
| "I can't remember Git commands" | **lazygit** | Menu-driven; every key is discoverable with `?` |
| "My agent died when my laptop slept" | **tmux** on a server | The session lives on the server; you just look in through a window |

## Why the terminal app is Ghostty

- Native UI on macOS and Linux, GPU rendering, tabs and splits built in.
- Almost no configuration required; ours is ~10 lines.
- Open source and local. No account, no cloud.

## Why not the alternatives (as of October 2026)

- **iTerm2** — excellent and mature, but heavier. Switching gains nothing for this workflow.
- **cmux** — a Ghostty-based macOS app with vertical tabs, notifications and a browser pane.
  Interesting, but young, macOS-only, and its main paid feature (cloud machines that keep running
  while you are away) duplicates what a cheap server with tmux gives you.
- **Warp** — account-based, centered on hosted AI features. Check its current terms yourself
  if your history contains secrets.
- **Nushell as the login shell** — wonderful for tables and JSON, but its syntax differs from
  zsh/bash, so many tools' init snippets and agent-run commands don't work. Use `nu` as a subshell instead.
- **A browser next to the terminal** — Ghostty has none. Tile your normal browser beside it, let an agent drive a browser, or use cmux for web projects only (see the README).
- **Workmux / Hunk** — worth adding when several agents work in the *same repository*.
  Until then `git worktree add ../repo-task -b task` is enough.

Claims about other products can go stale. If you spot one that has, please open an issue.

## Why `cat` and `ls` are not simply replaced

Agents run shell commands and read the output. Coloured, icon-decorated output can confuse them.
So aliases load only when the `CLAUDECODE` variable is unset (human-opened shells), and the pretty
`cat` is a separate command: `bcat`.
