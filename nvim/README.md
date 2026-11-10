# nvim

## What

Neovim (`nvim`), with its default config. Helix stays the editor in `EDITOR`; this
package only makes `nvim` available. Neovim has no built-in onedark, so no theme is set.

## Why

Available for tools and habits that expect Vim keys, and for trying configs, while Helix stays the default editor.

### Alternatives Considered

- Vim: older, with no built-in LSP.
- Making Neovim the main editor: needs a plugin setup Helix does without.

## Install

`./install.sh` installs `neovim`. Nothing is linked into `$HOME`.

## Customize

Neovim reads `~/.config/nvim/init.lua` (`:echo stdpath("config")`). To share a config,
add it under `home/.config/nvim/` and add the Stow line to `install.sh`.
Plugin managers write lockfiles (such as `lazy-lock.json`) next to `init.lua`; with
`--no-folding` they land in the real directory, not in this repo, unless the lockfile
itself is committed under `home/`.

## Verify

`./verify.sh` checks the Brewfile is satisfied.
