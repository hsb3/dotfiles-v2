# pnpm

## What

pnpm, the Node.js package manager, installed and versioned by mise (from the mise
package). `~/.config/zsh/conf.d/pnpm.zsh` exports `PNPM_HOME=~/Library/pnpm` (pnpm's
macOS default) and appends `$PNPM_HOME/bin`, where `pnpm add -g` links executables, to
the end of `PATH`, so global packages never shadow Homebrew or `~/.local/bin`.

## Why

For Node projects that use pnpm lockfiles: fast, and saves disk with a shared content store. mise pins its version.

### Alternatives Considered

- npm or yarn: slower, and duplicate packages on disk.
- corepack: being removed from Node.

## Install

`./install.sh` declares `pnpm = "latest"` in mise's global config with
`mise use --global pnpm@latest`, but only when no global config declares pnpm yet, runs
`mise install pnpm` if it is not installed, and links the hook. The declaration is not
linked: mise rewrites the file that declares a tool, so it lives in the real, untracked
`~/.config/mise/config.toml`.
It then writes the zsh completion from `pnpm completion zsh` to
`~/.local/share/zsh/site-functions/_pnpm`, rewriting the file only when the output
changes. The hook sources it, because the script registers itself with `compdef` instead of
completing on first load.

## Customize

Latest on first install; pin afterwards with `mise use --global pnpm@<version>`, which
`install.sh` then leaves alone. Settings go in `~/.config/pnpm/config.yaml` via
`pnpm config set`; pnpm 12 also writes login tokens to that file, so the directory stays
out of this repo.
Skip `pnpm setup` (it edits `~/.zshrc`, which is linked into this repo) and
`pnpm self-update` (mise owns the version).

## Verify

`./verify.sh` checks that a global mise config declares pnpm, that `mise which pnpm`
finds it, that the completion file exists, and that the hook is linked.
