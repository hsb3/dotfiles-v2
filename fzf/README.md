# fzf

## What

fzf, the fuzzy finder, with its official zsh integration loaded from
`~/.config/zsh/conf.d/fzf.zsh` (loaded by the zsh package):

- `Ctrl-R` searches history;
- `Ctrl-T` inserts files;
- `Alt-C` changes directory;
- `**<Tab>` fuzzy-completes paths and arguments.

## Install

`./install.sh` installs `fzf` and links the hook.

## Customize

Default options go in `FZF_DEFAULT_OPTS` (or a file named by `FZF_DEFAULT_OPTS_FILE`);
export them from the hook file. To turn off one binding, set its command to empty before
the `source` line, for example `FZF_ALT_C_COMMAND=`. Options: `man fzf`.

## Verify

`./verify.sh` checks the Brewfile is satisfied and the hook is linked.
