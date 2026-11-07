# fd

## What

fd, a fast `find` alternative that respects `.gitignore`, with its default settings. fd
has no config file, so nothing is linked.

## Install

`./install.sh` installs `fd`. Nothing is linked into `$HOME`.

## Customize

fd reads an optional global ignore file, `~/.config/fd/ignore` (gitignore syntax). To
share one, add it under `home/.config/fd/` and add the Stow line to `install.sh`
. Flags otherwise go on the command line or in a shell alias.

## Verify

`./verify.sh` checks the Brewfile is satisfied.
