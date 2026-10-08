# Server guide (Ubuntu 24.04, tested by hand)

Goal: your agents run on a server inside tmux; your Mac is only a window onto them.

## 1. Tools

```bash
sudo apt-get update
sudo apt-get install -y tmux eza bat fzf zoxide git
sudo ln -sf /usr/bin/batcat /usr/local/bin/bat      # Ubuntu names it batcat

# lazygit (latest release binary)
V=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep -Po '"tag_name": *"v\K[^"]*')
curl -sLo /tmp/lg.tgz "https://github.com/jesseduffield/lazygit/releases/download/v${V}/lazygit_${V}_Linux_x86_64.tar.gz"
sudo tar xf /tmp/lg.tgz -C /usr/local/bin lazygit

# atuin (the installer script can fail silently — grab the binary instead)
V=$(curl -s https://api.github.com/repos/atuinsh/atuin/releases/latest | grep -Po '"tag_name": *"v\K[^"]*')
curl -sLo /tmp/at.tgz "https://github.com/atuinsh/atuin/releases/download/v${V}/atuin-x86_64-unknown-linux-gnu.tar.gz"
tar xf /tmp/at.tgz -C /tmp && sudo install -m755 /tmp/atuin-x86_64-unknown-linux-gnu/atuin /usr/local/bin/atuin
curl -sLo ~/.bash-preexec.sh https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh
```

> `eza` may not be in older Ubuntu releases. If `apt` can't find it, see the eza install docs.

## 2. Config

```bash
cp ~/.bashrc ~/.bashrc.bak                       # always back up first
cat shell/terminal-stack.bash >> ~/.bashrc
mkdir -p ~/.config/atuin && cp atuin/config.toml ~/.config/atuin/
cp tmux/tmux.conf ~/.tmux.conf
sudo install -m755 scripts/panel /usr/local/bin/panel
```

## 3. Make Ghostty and the server get along

`ghostty/config` already contains `shell-integration-features = ssh-terminfo,ssh-env`.
When you `ssh` in, Ghostty copies its terminal definition to the server. Without it you may see
`unsuitable terminal` from tmux or lazygit.

## 4. Use it

```bash
ssh myserver
panel -c ~/project-a ~/project-b - -
# Ctrl-a d  to leave. Close the laptop. Later: ssh myserver, then: panel
```

Optional shortcut on your Mac (in `~/.config/terminal-stack.zsh`):

```bash
SERVER=myserver
panel() { ssh -t "$SERVER" panel "$@"; }
```

## Roll back

```bash
cp ~/.bashrc.bak ~/.bashrc
```
