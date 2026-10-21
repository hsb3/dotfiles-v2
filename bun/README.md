# bun

## What

Bun, the JavaScript runtime, package manager and test runner, installed and versioned by
mise (from the mise package). `~/.config/zsh/conf.d/bun.zsh` appends `~/.bun/bin`, where
`bun add -g` links executables (`install.globalBinDir`), to the end of `PATH` once that
directory exists, so global packages never shadow Homebrew or `~/.local/bin`.

## Install

`./install.sh` declares `bun = "latest"` in mise's global config with
`mise use --global bun@latest`, but only when no global config declares bun yet, then
runs `mise install bun`, and links the hook. The declaration is not linked: mise rewrites
the file that declares a tool, so it lives in the real, untracked
`~/.config/mise/config.toml`.

## Customize

Latest on first install; pin afterwards with `mise use --global bun@<version>`, which
`install.sh` then leaves alone. Global package-manager settings go in
`~/.config/.bunfig.toml` (with `XDG_CONFIG_HOME` set). Skip the "Add Bun to your PATH"
step in Bun's install docs (it edits `~/.zshrc`, which is linked into this repo) and
`bun upgrade` (mise owns the version).

## Verify

`./verify.sh` checks that a global mise config declares bun, that `mise which bun` finds
it, and that the hook is linked.
