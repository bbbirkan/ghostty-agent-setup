# Troubleshooting

| Symptom | Likely cause | Fix |
|---|---|---|
| `command not found: z / lg / eza` | New tools not loaded | Open a new window, or `exec zsh` |
| `ls` shows ☐ boxes instead of icons | Font lacks icons | `brew install --cask font-jetbrains-mono-nerd-font`, then set it in Ghostty (`font-family = JetBrainsMono Nerd Font`) |
| `Ctrl+R` shows the old search | atuin not loaded | `exec zsh`; check `grep terminal-stack ~/.zshrc` |
| `z folder` → no match | zoxide has not seen it | `cd` into it once |
| `cd: no such file` with a spaced name | Space in a folder name | Quote it: `cd ~/Desktop/"My Folder "` or press `Tab` |
| lazygit asks to create a repo, then crashes | You are not inside a git project | Answer **N**; `cd` into a project |
| tmux: "unsuitable terminal" / odd colors on server | Server lacks Ghostty's terminfo | Keep `shell-integration-features = ssh-terminfo,ssh-env`, reconnect |
| Screen looks frozen in tmux | You are in scroll mode | Press `q` |
| `brew install` says "not writable" | Homebrew folder permissions | `sudo chown -R $(whoami) /opt/homebrew` |
| Two agents trashed each other's files | Same folder | One folder (or `git worktree`) per agent |

## Undo everything

- Mac: remove the `terminal-stack` line from `~/.zshrc`; delete the symlinks in `~/.config/`;
  restore any `*.bak-<date>` files.
- Server: `cp ~/.bashrc.bak ~/.bashrc`.
