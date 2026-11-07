# eza

## What

eza, a modern `ls` with colours, git status and tree view, with its default theme. One
alias, from `~/.config/zsh/conf.d/eza.zsh` (loaded by the zsh package): `ll` runs
`eza -la --icons=auto --git`. `ls` stays the system `ls`.

## Install

`./install.sh` installs `eza` and links the hook.

## Customize

eza reads a theme from `~/.config/eza/theme.yml` (`man eza`, `EZA_CONFIG_DIR`). To share
one, add it under `home/.config/eza/` and add the Stow line to `install.sh`. Further
aliases go in the hook file, `home/.config/zsh/conf.d/eza.zsh`, behind its
`command -v eza` guard.

## Verify

`./verify.sh` checks the Brewfile is satisfied and the hook is linked.
