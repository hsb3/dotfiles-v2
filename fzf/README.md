# fzf

## What

fzf, the fuzzy finder, with its official zsh integration loaded from
`~/.config/zsh/conf.d/fzf.zsh` (loaded by the zsh package):

- `Ctrl-R` searches history;
- `Ctrl-T` inserts files;
- `Alt-C` changes directory;
- `**<Tab>` fuzzy-completes paths and arguments.

When `fd` is installed (the fd package), the hook sets `FZF_DEFAULT_COMMAND`,
`FZF_CTRL_T_COMMAND` and `FZF_ALT_C_COMMAND` to fd: files for plain `fzf` and `Ctrl-T`,
directories for `Alt-C`, hidden files included, `.git` excluded, symlinks followed (the
command from fzf's README). fd also skips anything `.gitignore` ignores, which fzf's
built-in walker does not. Without fd, fzf keeps its built-in walker.

## Why

Fuzzy search over history, files and directories from a few keys; other tools (fzf-tab, zoxide) build on it.

### Alternatives Considered

- skim: a Rust port with fewer integrations.
- Plain `Ctrl-R`: exact-substring matching only.

## Install

`./install.sh` installs `fzf` and links the hook. fd is not a dependency; install the
fd package to use it.

## Customize

Default options go in `FZF_DEFAULT_OPTS` (or a file named by `FZF_DEFAULT_OPTS_FILE`);
export them from the hook file. To turn off one binding, set its command to empty before
the `source` line, for example `FZF_ALT_C_COMMAND=`. Options: `man fzf`.

## Verify

`./verify.sh` checks the Brewfile is satisfied and the hook is linked.
