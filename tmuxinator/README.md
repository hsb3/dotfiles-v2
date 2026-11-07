# tmuxinator

## What

tmuxinator, which starts tmux sessions from YAML project files. Homebrew also installs
its zsh completion and tmux. No project files are linked: they describe local
checkouts, so they stay machine-local.

## Install

`./install.sh` installs `tmuxinator`. Nothing is linked into `$HOME`.

## Customize

Projects live in `~/.config/tmuxinator/<name>.yml`. `tmuxinator new <name>` creates one
and opens it in `$EDITOR`; `tmuxinator start <name>` runs it. To share a project file,
add it under `home/.config/tmuxinator/` and add the Stow line to `install.sh`.

## Verify

`./verify.sh` checks the Brewfile is satisfied.
