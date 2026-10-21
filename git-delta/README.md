# git-delta

## What

delta, a syntax-highlighting pager for `git diff`, `log`, `show` and `add -p`. Its git
settings live in `~/.config/git/delta.gitconfig`:

- `core.pager` and `interactive.diffFilter` route git through delta;
- `delta.navigate` jumps between files with `n`/`N`;
- `delta.syntax-theme = TwoDark` (the Atom One Dark port, matching bat).

## Install

`./install.sh` installs `git-delta`, links the file, and adds one line to `~/.gitconfig`:
`include.path = <home>/.config/git/delta.gitconfig`. `~/.gitconfig` stays a real,
untracked file, as in the git package.

## Customize

Edit `home/.config/git/delta.gitconfig`. `delta --help` lists the options;
`delta --show-syntax-themes --dark` previews themes. To stop using delta, remove the
include line from `~/.gitconfig`.

## Verify

`./verify.sh` checks the Brewfile is satisfied, the file is linked, and `~/.gitconfig`
includes it.
