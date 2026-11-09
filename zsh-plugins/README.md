# zsh-plugins

## What

Interactive zsh add-ons from Homebrew, loaded by `~/.config/zsh/conf.d/zsh-plugins.zsh`:

- `zsh-completions`: extra completion definitions (the zsh package adds its directory to
  `fpath` before `compinit`);
- `fzf-tab`: Tab opens an fzf picker over the completions; `cd <Tab>` previews with eza;
- `zsh-autosuggestions`: grey suggestion from history as you type; → accepts it;
- `zsh-syntax-highlighting`: colours the command line; unknown commands show red.

The file name sorts after every other `conf.d` file, so syntax highlighting loads last,
as it requires. Each plugin loads only if its formula is installed.

## Install

`./install.sh` installs the four formulae and links the loader.

## Customize

Edit `home/.config/zsh/conf.d/zsh-plugins.zsh`. fzf-tab settings are `zstyle ':fzf-tab:*'`
lines (see https://github.com/Aloxaf/fzf-tab); autosuggestion settings are `ZSH_AUTOSUGGEST_*`
variables, set before its `source` line.

## Verify

`./verify.sh` checks the Brewfile is satisfied and the loader is linked.
