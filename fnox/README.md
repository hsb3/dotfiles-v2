# fnox

## What

fnox, the secret manager from mise's author (MIT), installed and versioned by mise. Values
live in the macOS Keychain through fnox's `keychain` provider; the config holds only
names. There is no shell hook and no `fnox activate`: secrets reach a command only through
`fnox exec`, so they never sit in the shell's environment.

## Why

Secrets live in the Keychain and reach only the command that needs them; the config in git holds names, never values.

### Alternatives Considered

- `.env` files: plaintext on disk.
- 1Password CLI: needs an account and a desktop app.
- `security` calls in shell rc files: secrets end up in every process's environment.

## Install

`./install.sh` declares `fnox = "latest"` in mise's global config (only when none
declares it), installs it, writes its zsh completion to
`~/.local/share/zsh/site-functions/_fnox`, adds a global `keychain` provider if missing,
and adds two top-level lines fnox has no command for: `default_provider = "keychain"`
(else `fnox set` without `--provider` stores the value in the config in plain text) and
`if_missing = "error"` (else a secret the Keychain refuses is skipped with a warning, so
the failure looks like a bad key). `~/.config/fnox/config.toml` is real and untracked:
fnox rewrites it on every `fnox set --global`. None of this touches the Keychain.

## Customize

- Add a secret: `fnox set NAME --provider keychain --global`. It prompts for the value
  (hidden), stores it in the Keychain under service `fnox`, account `NAME`, and records
  the name in `~/.config/fnox/config.toml`.
- Run with secrets: `fnox exec --only NAME -- <cmd> [args]` exports that secret to that
  command only; repeat `--only` for more. Without `--only`, the command gets every secret
  in the config, and tools that find a provider API key in their environment use it (and
  bill against it). fnox options go before `--`.
- Keychain prompts: macOS may ask to allow fnox to read each item, one at a time.
  "Always Allow" covers the current binary; a new fnox version from mise can ask again.
- Only the macOS login (GUI) session can read the Keychain. A shell started over SSH, or
  by a terminal server that was started over SSH, gets `User interaction is not allowed`
  (`launchctl managername` prints `Background` there, `Aqua` in a GUI terminal); run fnox
  from a GUI terminal, or restart that server from one.
- Never store anything named `__fnox_test__`: `fnox provider test keychain` overwrites
  and then deletes an item with that name.
- Items stored by other tools or under another service are not read: `fnox set` again.
- Switch to 1Password later by replacing the `[providers.keychain]` block in
  `~/.config/fnox/config.toml` with a `type = "1password"` one named `keychain`
  (secrets refer to the provider by name). 1Password is read-only to fnox, so the items
  must exist there first, and each secret's `value` must name the 1Password item
  (`item` or `item/field`); see fnox's 1Password provider docs.

## Verify

`./verify.sh` checks that a global mise config declares fnox, that `mise which fnox`
finds it, that the completion file exists, and that the global config has the `keychain`
provider, `default_provider = "keychain"` and `if_missing = "error"`. It reads only the
config file.
