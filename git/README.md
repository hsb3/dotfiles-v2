# git

## What

Git from Homebrew (newer than the Command Line Tools copy), shared settings in
`~/.config/git/dotfiles.gitconfig`, and the global ignore file `~/.config/git/ignore`.

## Why

Homebrew's git is newer than the Command Line Tools copy. Shared settings go in an included file, so `~/.gitconfig` stays free for identity and machine-local values.

### Alternatives Considered

- The Command Line Tools git: lags upstream by months.
- Linking `~/.gitconfig` itself: `git config --global` would then write into this repo.

## Install

`./install.sh` installs `git`, links both files, and adds one line to `~/.gitconfig`:
`include.path = <home>/.config/git/dotfiles.gitconfig`. `~/.gitconfig` stays a real,
untracked file, so `git config --global` (and tools that call it) never write into
this repo.

## Customize

Shared settings: edit `home/.config/git/dotfiles.gitconfig`. Identity and anything
machine-specific: `git config --global user.name "<name>"` and
`git config --global user.email "<email>"`, which land in `~/.gitconfig`.

## Verify

`./verify.sh` checks the Brewfile is satisfied, both files are linked, and
`~/.gitconfig` includes the shared file.
