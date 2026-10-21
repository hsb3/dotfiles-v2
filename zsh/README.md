# zsh

## What

The login shell (stock on macOS). Owns `~/.zshenv`, `~/.zprofile` and `~/.zshrc`.

`.zshrc` sources every `~/.config/zsh/conf.d/*.zsh`. Other packages ship their shell
setup there (`starship.zsh`, `mise.zsh`, `helix.zsh`), so removing a package removes
its shell setup with it.

## Install

`./install.sh` links the three files. No Homebrew dependency: zsh ships with macOS.
An existing `~/.zshrc` (or the others) blocks the link; move it aside first.

## Customize

Machine-local shell setup goes in an untracked `~/.config/zsh/conf.d/local.zsh`.
The directory is real (not a link into this repo), so files added there stay local.

## Verify

`./verify.sh` checks the three files are linked here.
