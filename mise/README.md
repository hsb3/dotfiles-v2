# mise

## What

mise, the runtime version manager. This package only activates it in zsh via
`~/.config/zsh/conf.d/mise.zsh`. `bootstrap.sh` also installs mise, because it is a
manager other packages may rely on.

## Why

One manager for every language runtime and many CLIs, pinned per project, and fast because it uses shims.

### Alternatives Considered

- asdf: same model, slower, and needs a plugin per tool.
- nvm, pyenv and the like: one tool per language.
- Homebrew alone: one version per tool, upgraded globally.

## Install

`./install.sh` ensures `mise` is installed and links the zsh hook.

## Customize

Global tools are machine state, not repo state: `mise use -g node@lts` writes
`~/.config/mise/config.toml`, which is deliberately untracked so mise can rewrite it.

## Verify

`./verify.sh` checks the Brewfile is satisfied and the hook is linked.
