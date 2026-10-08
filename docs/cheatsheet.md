# Cheatsheet

## Everyday (Mac)

| Goal | Do |
|---|---|
| Search history | `Ctrl+R`, type, `↑↓`, `Tab` = edit first, `Enter` = run, `Esc` = leave |
| Search only this folder's history | press `Ctrl+R` again while searching to cycle scope |
| Jump to folder | `z name`, `z a b` (both words), `zi` (menu), `z -` (previous) |
| List files | `ls`, `ll` (details + Git status), `ls --tree -L 2` |
| Read a file | `bcat file`, `bat file` (pager, `q` to quit), `bat -r 10:30 file` |
| Stats about your habits | `atuin stats` |
| Import old history once | `atuin import zsh` |

## Lazygit (`lg`, inside a git project)

Panels: `1` Status · `2` Files · `3` Branches · `4` Commits · `5` Stash. Move with `←` `→`.

| Key | Action |
|---|---|
| `Space` | stage / unstage the selected file |
| `a` | stage / unstage all |
| `c` | commit |
| `P` / `p` | push / pull |
| `d` (Files) | discard options — careful, it throws work away |
| `n` / `Space` (Branches) | new branch / checkout |
| `?` | help for the current panel |
| `q` | quit |

If lazygit asks *"Create a new git repository?"* you are not inside a project. Answer **N**.

## tmux on the server (prefix = `Ctrl-a`)

Press `Ctrl` + `a` together, **release both**, then press the next key.

| Goal | Keys |
|---|---|
| Leave, keep everything running | `Ctrl-a` `d` |
| List / re-enter sessions | `tmux ls` · `tmux attach -t panel` |
| Split side-by-side / stacked | `Ctrl-a` `\|` · `Ctrl-a` `-` |
| Move between panes | `Ctrl-h/j/k/l` (no prefix) or click |
| Zoom one pane / unzoom | `Ctrl-a` `z` |
| New window · next · previous | `Ctrl-a` `c` · `Shift-→` · `Shift-←` |
| Browse all windows with preview | `Ctrl-a` `w` |
| Browse sessions | `Ctrl-a` `s` |
| Scroll back | `Ctrl-a` `[` then arrows/PgUp, `q` to exit |
| Reload config | `Ctrl-a` `r` |

**Golden rule:** to leave, detach (`Ctrl-a d`). Typing `exit` ends the session and whatever is running in it.

## panel

```bash
panel                         # 4 empty shells
panel -c                      # start `claude` in all 4
panel -c ~/api ~/web - -      # one folder per pane ("-" = home)
```
