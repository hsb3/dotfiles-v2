# helix

## What

The Helix editor (`hx`), set as `EDITOR` and `VISUAL` via
`~/.config/zsh/conf.d/helix.zsh`. Config in `~/.config/helix/config.toml`; per-language
servers, formatters and debuggers in `languages.toml`, using what the language-servers
package installs.

## Install

`./install.sh` installs `helix` and links the config files.

## Customize

Edit `home/.config/helix/config.toml` or `languages.toml`. Check the setup with `hx --health`.

## Verify

`./verify.sh` checks the Brewfile is satisfied and the config files are linked.
