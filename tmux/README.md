# tmux

## What

The tmux terminal multiplexer, with its default config (prefix `C-b`). No config file is
linked. Truecolor works inside tmux under Ghostty because tmux reads the outer
terminal's `xterm-ghostty` terminfo, which declares it.

## Why

Keeps sessions alive when the terminal closes, and splits panes the same way on every machine and over SSH.

### Alternatives Considered

- Zellij: friendlier, but less widely available on remote hosts.
- Ghostty's own splits: lost when the window closes, and not available over SSH.

## Install

`./install.sh` installs `tmux`. Nothing is linked into `$HOME`.

## Customize

tmux reads `~/.config/tmux/tmux.conf` (the zsh package sets `XDG_CONFIG_HOME`). To share
settings, add the file under `home/.config/tmux/` and add the Stow line to `install.sh`
. `tmux show-options -g` lists the current values; reload a running server
with `tmux source-file ~/.config/tmux/tmux.conf`.

## Verify

`./verify.sh` checks the Brewfile is satisfied.
