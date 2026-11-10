# helix

## What

The Helix editor (`hx`), set as `EDITOR` and `VISUAL` via
`~/.config/zsh/conf.d/helix.zsh`. Config in `~/.config/helix/config.toml`; per-language
servers, formatters and debuggers in `languages.toml`, using what the language-servers
package installs.

## Why

A modal editor that works without plugins: LSP, tree-sitter and multiple cursors are built in, and the config is a few lines of TOML.

### Alternatives Considered

- Neovim: as capable, but needs a plugin setup to match (installed separately as the nvim package).
- Vim: older defaults, no built-in LSP.

## Install

`./install.sh` installs `helix` and links the config files.

## Customize

Edit `home/.config/helix/config.toml` or `languages.toml`. Check the setup with `hx --health`.

## Verify

`./verify.sh` checks the Brewfile is satisfied and the config files are linked.
