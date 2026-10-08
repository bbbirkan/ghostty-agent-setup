#!/bin/bash
# Mac installer. Safe to re-run. Backs up anything it would overwrite.
#   ./install.sh --dry-run    show what would happen, change nothing
#   ./install.sh              do it
set -e
DRY=0; [ "$1" = "--dry-run" ] && DRY=1
HERE="$(cd "$(dirname "$0")" && pwd)"
STAMP=$(date +%Y%m%d-%H%M%S)

run() { if [ "$DRY" = 1 ]; then echo "[dry-run] $*"; else eval "$@"; fi; }

link() {  # link <repo file> <destination>
  src="$HERE/$1"; dst="$2"
  run "mkdir -p \"$(dirname "$dst")\""
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    echo "backup: $dst -> $dst.bak-$STAMP"; run "mv \"$dst\" \"$dst.bak-$STAMP\""
  fi
  run "ln -sfn \"$src\" \"$dst\""
  echo "linked: $dst"
}

command -v brew >/dev/null || { echo "Homebrew not found: https://brew.sh"; exit 1; }
echo "==> Installing tools"
run "brew install atuin zoxide eza bat lazygit tmux fzf"
run "brew install --cask ghostty || true"

echo "==> Linking config files"
link ghostty/config            "$HOME/.config/ghostty/config"
link atuin/config.toml         "$HOME/.config/atuin/config.toml"
link shell/terminal-stack.zsh  "$HOME/.config/terminal-stack.zsh"

LINE='[ -f ~/.config/terminal-stack.zsh ] && source ~/.config/terminal-stack.zsh'
if ! grep -qF "terminal-stack.zsh" "$HOME/.zshrc" 2>/dev/null; then
  echo "==> Adding one line to ~/.zshrc"
  run "echo '$LINE' >> \"$HOME/.zshrc\""
fi

echo
echo "Done. Open a NEW terminal window (or run: exec zsh), then try:"
echo "  ll        colorful file list"
echo "  Ctrl+R    search your command history"
echo "  lg        git panel (inside a git project)"
