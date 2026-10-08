# Readable output: themes, font size and contrast in Ghostty

Agents print a lot. If your eyes are tired after an hour, fix four things, in this order of impact.

| What | Why it matters | Setting |
|---|---|---|
| **Theme** (colours) | Biggest effect. Low-contrast themes make long output hard to read | `theme` |
| **Font size** | Reading long diffs and logs | `font-size` |
| **Minimum contrast** | Rescues grey-on-grey text (lazygit and others) | `minimum-contrast` |
| **Line spacing / weight** | Cramped or thin text | `adjust-cell-height`, `font-thicken` |

Open your settings with `Cmd+,`, edit, save, then reload with `Cmd+Shift+,`. Changes apply instantly.
Delete the file to go back to Ghostty's defaults.

## 1. Pick a theme

Ghostty ships with hundreds of themes. Browse them with a live preview:

```bash
/Applications/Ghostty.app/Contents/MacOS/ghostty +list-themes
```

`↑` `↓` to browse, `q` to quit. Then set it in the config: `theme = <name>`.

| Theme | Good for |
|---|---|
| `Catppuccin Mocha` | Soft dark theme, easy on the eyes (this repo's default) |
| `GitHub Dark High Contrast` | **Most readable.** Strong contrast for long sessions |
| `GitHub Dark Colorblind` | Red/green colour blindness |
| `Gruvbox Dark Hard` | Warm tones, gentle at night |
| `Catppuccin Latte`, `GitHub Light High Contrast` | Light backgrounds |

Follow macOS light/dark mode automatically:

```
theme = light:Catppuccin Latte,dark:Catppuccin Mocha
```

## 2. Size, contrast, spacing

```
font-size = 15              # default is 13; 15-16 is comfortable. Cmd+ and Cmd- zoom live, Cmd+0 resets
minimum-contrast = 3        # 1 = off. 1.1 only fixes invisible text, 3+ fixes hard-to-read text
adjust-cell-height = 10%    # a little air between lines
font-thicken = true         # slightly bolder strokes; helps most on light themes
```

`minimum-contrast` is the most useful one for agent work: many terminal tools print dim grey on a
dark background. With `3` they become readable without changing your whole theme. Very high values
push colours towards pure black/white, so start at 3.

## 3. A ready-made readable setup

```
theme = GitHub Dark High Contrast
font-size = 15
minimum-contrast = 3
adjust-cell-height = 10%
```

These lines are also in [`ghostty/config`](../ghostty/config) as commented-out options. Remove the leading `# ` to enable.

## 4. Fonts and icons

Ghostty has a good default font, so you do not need to choose one. If `ls` shows empty boxes (☐) instead of file icons,
your font lacks icon glyphs: install a Nerd Font (`brew install --cask font-jetbrains-mono-nerd-font`) and set
`font-family = "JetBrainsMono Nerd Font"`.

## Check your version

Option names can change between releases. List every option your Ghostty supports, with docs:

```bash
/Applications/Ghostty.app/Contents/MacOS/ghostty +show-config --default --docs | less
```

(The names above were checked against Ghostty 1.3.1.)
