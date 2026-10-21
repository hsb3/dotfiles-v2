# fnox

## What

fnox, the secret manager from mise's author (MIT), installed and versioned by mise. Values
live in the macOS Keychain through fnox's `keychain` provider; the config holds only
names. There is no shell hook and no `fnox activate`: secrets reach a command only through
`fnox exec`, so they never sit in the shell's environment.

## Install

`./install.sh` declares `fnox = "latest"` in mise's global config (only when no global
config declares it), installs it, writes its zsh completion to
`~/.local/share/zsh/site-functions/_fnox`, and runs
`fnox provider add keychain keychain --global` when `~/.config/fnox/config.toml` has no
`keychain` provider. That file is real and untracked: fnox writes it, and rewrites it on
every `fnox set --global`. None of this touches the Keychain.

## Customize

- Add a secret: `fnox set NAME --provider keychain --global`. It prompts for the value
  (hidden), stores it in the Keychain under service `fnox`, account `NAME`, and records
  the name in `~/.config/fnox/config.toml`.
- Run with secrets: `fnox exec -- <cmd> [args]` exports each secret to that command only.
  fnox options go before `--`.
- Keychain prompts: macOS may ask to allow fnox to read each item, one at a time.
  "Always Allow" covers the current binary; a new fnox version from mise can ask again.
- Never store anything named `__fnox_test__`: `fnox provider test keychain` overwrites
  and then deletes an item with that name.
- Items stored by other tools (or under another service name) are not read; enter each
  value again with `fnox set`.
- Switch to 1Password later by replacing the `[providers.keychain]` block in
  `~/.config/fnox/config.toml` with a `type = "1password"` one named `keychain`
  (secrets refer to the provider by name). 1Password is read-only to fnox, so the items
  must exist there first, and each secret's `value` must name the 1Password item
  (`item` or `item/field`); see fnox's 1Password provider docs.

## Verify

`./verify.sh` checks that a global mise config declares fnox, that `mise which fnox`
finds it, that the completion file exists, and that `fnox provider list` on the global
config shows `keychain`. Listing reads only the config file.
