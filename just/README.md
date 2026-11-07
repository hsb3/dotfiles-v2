# just

## What

just, a command runner for project recipes in a `justfile`. No global justfile and no
shell hook: zsh completion comes from Homebrew's `site-functions`.

## Install

`./install.sh` installs `just`. Nothing is linked into `$HOME`.

## Customize

Recipes live in each project's `justfile`. A global justfile, run with `just -g`, goes in
`~/.config/just/justfile`; to share one, add it under `home/.config/just/` and add the
Stow line to `install.sh`. Syntax: `just --help` and the just manual.

## Verify

`./verify.sh` checks the Brewfile is satisfied.
