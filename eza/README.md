# eza

## What

eza, a modern `ls` with colours, git status and tree view, with its default theme. No
config file and no aliases: `ls` stays the system `ls`.

## Install

`./install.sh` installs `eza`. Nothing is linked into `$HOME`.

## Customize

eza reads a theme from `~/.config/eza/theme.yml` (`man eza`, `EZA_CONFIG_DIR`). To share
one, add it under `home/.config/eza/` and add the Stow line to `install.sh`. Aliases
such as `ls` → `eza` belong in a hook file,
`home/.config/zsh/conf.d/eza.zsh`, guarded by `command -v eza`.

## Verify

`./verify.sh` checks the Brewfile is satisfied.
