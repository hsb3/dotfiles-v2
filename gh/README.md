# gh

## What

The GitHub CLI, set to clone and push over SSH (`git_protocol ssh`). Everything else is
gh's default; gh opens `$EDITOR` (Helix) for text.

## Why

PRs, issues, CI runs and the API from the terminal, logged in once.

### Alternatives Considered

- hub: deprecated in favour of gh.
- The web UI: leaves the terminal.

## Install

`./install.sh` installs `gh`, then runs `gh config set git_protocol ssh` only if the
current value differs. Nothing is linked: gh rewrites its own
`~/.config/gh/config.yml`, and `hosts.yml` holds login tokens, so neither file belongs
in this repo. Log in once per machine with `gh auth login`.

## Customize

Change settings with `gh config set <key> <value>`; list them with `gh config list`.
To make a setting shared, add the same check-then-set line to `install.sh` and a
read-back to `verify.sh`.

## Verify

`./verify.sh` checks the Brewfile is satisfied and `gh config get git_protocol` is
`ssh`.
