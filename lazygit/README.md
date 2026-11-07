# lazygit

## What

The lazygit terminal UI for git, with its default config. No config file is linked:
lazygit picks its Helix editor preset from `EDITOR=hx` (set by the helix package).

## Install

`./install.sh` installs `lazygit`. Nothing is linked into `$HOME`.

## Customize

lazygit reads `~/.config/lazygit/config.yml` (the zsh package sets `XDG_CONFIG_HOME`).
To share settings, add the file under `home/.config/lazygit/` and add the Stow line to
`install.sh`. lazygit rewrites `config.yml` when it migrates deprecated
keys, so keep it to the current schema: `lazygit --config` prints the defaults.

## Verify

`./verify.sh` checks the Brewfile is satisfied.
