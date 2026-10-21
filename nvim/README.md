# nvim

## What

Neovim (`nvim`), with its default config. Helix stays the editor in `EDITOR`; this
package only makes `nvim` available. Neovim has no built-in onedark, so no theme is set.

## Install

`./install.sh` installs `neovim`. Nothing is linked into `$HOME`.

## Customize

Neovim reads `~/.config/nvim/init.lua` (`:echo stdpath("config")`). To share a config,
add it under `home/.config/nvim/` and add the Stow line to `install.sh` (RULES.md R5).
Plugin managers write lockfiles (such as `lazy-lock.json`) next to `init.lua`; with
`--no-folding` they land in the real directory, not in this repo, unless the lockfile
itself is committed under `home/`.

## Verify

`./verify.sh` checks the Brewfile is satisfied.
