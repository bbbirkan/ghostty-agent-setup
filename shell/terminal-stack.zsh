# terminal-stack.zsh — source this from ~/.zshrc
#   [ -f ~/.config/terminal-stack.zsh ] && source ~/.config/terminal-stack.zsh
#
# Only loads in an interactive shell that is NOT an agent's shell.
# Claude Code sets CLAUDECODE=1 for its own commands, so agents keep seeing
# plain `ls` / `cat` output and nothing they parse changes.
if [[ -o interactive && -z "$CLAUDECODE" ]]; then
  if command -v eza >/dev/null; then
    alias ls="eza --icons --group-directories-first"
    alias ll="eza -la --icons --git --group-directories-first"
  fi
  command -v bat     >/dev/null && alias bcat="bat --paging=never"   # `cat` stays untouched on purpose
  command -v lazygit >/dev/null && alias lg="lazygit"
  command -v zoxide  >/dev/null && eval "$(zoxide init zsh)"          # z <dir>, zi = pick with fzf
  command -v atuin   >/dev/null && eval "$(atuin init zsh)"           # Ctrl+R = atuin search
fi

# Optional: run `panel` on your server from your Mac.
# Set SERVER to an ssh host alias from ~/.ssh/config, then uncomment:
# SERVER=myserver
# panel() { ssh -t "$SERVER" panel "$@"; }
