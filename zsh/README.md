# zsh

## What

The login shell (stock on macOS). Owns `~/.zshenv`, `~/.zprofile` and `~/.zshrc`.

`.zshrc` sources every `~/.config/zsh/conf.d/*.zsh`. Other packages ship their shell
setup there (`starship.zsh`, `mise.zsh`, `helix.zsh`), so removing a package removes
its shell setup with it. This package ships `functions.zsh`: `mkcd <dir>`, `extract
<archive>` (tar, zip, gz, bz2, xz), `port <n>` (what holds a port) and `ports` (every
listener), built on stock macOS tools.

Before `compinit`, `.zshrc` adds completion directories to `fpath` when they exist:
Homebrew's `share/zsh/site-functions` (so nested non-login shells complete Homebrew tools
too), `opt/zsh-completions/share/zsh-completions` (zsh-plugins package), and `~/.local/share/zsh/site-functions`,
a real directory where the uv, bun and pnpm packages generate their completions. Completion
is case-insensitive with an arrow-key menu.

History keeps 1,000,000 timestamped lines in `~/.zsh_history`, shared across sessions, with
duplicates dropped. Lines over 200 characters stay in the current session only.

`.zprofile` puts Homebrew on `PATH`, then prepends `~/.local/bin` (the XDG user binary
directory, where `uv tool install` writes) and deduplicates `PATH`. The directory is not
created or filled by this repo.

## Install

`./install.sh` links the three files and `functions.zsh`. No Homebrew dependency: zsh ships with macOS.
An existing `~/.zshrc` (or the others) blocks the link; move it aside first.

## Customize

Machine-local shell setup goes in an untracked `~/.config/zsh/conf.d/local.zsh`.
The directory is real (not a link into this repo), so files added there stay local.

## Verify

`./verify.sh` checks every file under `home/` is linked here.
