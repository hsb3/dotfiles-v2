# starship

## What

The Starship prompt. Config in `~/.config/starship.toml`; the zsh hook in
`~/.config/zsh/conf.d/starship.zsh` (loaded by the zsh package).

## Why

One fast prompt configured in TOML, showing git and runtime versions with no per-shell setup.

### Alternatives Considered

- powerlevel10k: zsh-only, and in maintenance mode.
- pure, or a hand-written `PROMPT`: less context, more to maintain.

## Install

`./install.sh` installs `starship` and links both files.

## Customize

Edit `home/.config/starship.toml`. Presets: `starship preset --list`.

## Verify

`./verify.sh` checks the Brewfile is satisfied and both files are linked.
