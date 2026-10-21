# zoxide

## What

zoxide, a `cd` that learns frequent directories, with its official zsh integration
loaded from `~/.config/zsh/conf.d/zoxide.zsh` (loaded by the zsh package):

- `z <part>` jumps to the best match;
- `zi <part>` picks interactively with fzf.

`cd` itself is unchanged.

## Install

`./install.sh` installs `zoxide` and links the hook.

## Customize

Flags go on the init line in the hook file, for example `zoxide init zsh --cmd cd` to
replace `cd`. Settings use `_ZO_*` environment variables, exported before that line.
Options: `zoxide init --help`. The database is machine-local, outside this repo.

## Verify

`./verify.sh` checks the Brewfile is satisfied and the hook is linked.
