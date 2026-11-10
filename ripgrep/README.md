# ripgrep

## What

ripgrep (`rg`), a recursive search tool that respects `.gitignore`, with its default
settings. ripgrep reads a config file only when `RIPGREP_CONFIG_PATH` is set, and this
package sets nothing, so no config file is linked.

## Why

Much faster than grep, recursive by default, and skips `.gitignore`d files.

### Alternatives Considered

- grep: slow on big trees, no ignore rules.
- The Silver Searcher (ag): slower, and no longer maintained.

## Install

`./install.sh` installs `ripgrep`. Nothing is linked into `$HOME`.

## Customize

To share flags, add `home/.config/ripgrep/config` (one flag per line), add the Stow line
to `install.sh`, and ship
`home/.config/zsh/conf.d/ripgrep.zsh` exporting `RIPGREP_CONFIG_PATH` to that file.
`man rg` documents the config format.

## Verify

`./verify.sh` checks the Brewfile is satisfied.
