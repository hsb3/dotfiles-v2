# zed

## What

The Zed editor (Homebrew cask, which also installs the `zed` command-line launcher).
Helix stays the editor in `EDITOR`. No settings are linked: Zed rewrites its own
`~/.config/zed/settings.json` from the Settings Editor and theme picker, so a linked file
would be edited inside this repo.

## Why

A fast GUI editor with built-in LSP and collaboration, for work that is easier outside the terminal.

### Alternatives Considered

- VS Code: heavier, and settings would need syncing.
- Cursor: a VS Code fork with the same weight.

## Install

`./install.sh` installs the `zed` cask. Nothing is linked into `$HOME`.

## Customize

Zed has no command-line setter, so set these once per machine in Zed itself
(`Cmd+,` opens settings; `Cmd+K Cmd+T` picks a theme), matching the rest of this repo:

- theme: `One Dark` (built in);
- `buffer_font_family`: `JetBrainsMono Nerd Font` (installed by the ghostty package).

## Verify

`./verify.sh` checks the Brewfile is satisfied.
