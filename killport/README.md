# killport

## What

killport, which kills the processes listening on a port: `killport 3000`, or several
ports at once. It handles a port held by more than one process (IPv4 and IPv6) and
Docker containers. To see what holds a port first, use `port <n>` from the zsh package.

## Install

`./install.sh` installs `killport`. Nothing is linked into `$HOME`.

## Customize

No config file. Options: `killport --help` (for example `--signal` and `--dry-run`).

## Verify

`./verify.sh` checks the Brewfile is satisfied.
