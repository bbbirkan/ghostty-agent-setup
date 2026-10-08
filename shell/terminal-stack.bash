# terminal-stack.bash — append to ~/.bashrc on a Linux server (tested on Ubuntu 24.04)
# Interactive human sessions only; agent shells (CLAUDECODE set) are left alone.
if [[ $- == *i* && -z "$CLAUDECODE" ]]; then
  alias ls="eza --group-directories-first"          # no --icons: server fonts are unknown
  alias ll="eza -la --git --group-directories-first"
  alias lg="lazygit"
  alias bcat="bat --paging=never"
  [ -f /usr/share/doc/fzf/examples/key-bindings.bash ] && source /usr/share/doc/fzf/examples/key-bindings.bash
  [ -f ~/.bash-preexec.sh ] && source ~/.bash-preexec.sh   # atuin needs this in bash
  command -v atuin   >/dev/null && eval "$(atuin init bash)"
  command -v zoxide  >/dev/null && eval "$(zoxide init bash)"
fi
