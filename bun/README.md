# bun

## What

Bun, the JavaScript runtime, package manager and test runner, installed and versioned by
mise (from the mise package).

## Install

`./install.sh` declares `bun = "latest"` in mise's global config with
`mise use --global bun@latest`, but only when no global config declares bun yet, then
runs `mise install bun`. Nothing is linked: mise rewrites the file that declares a tool,
so the declaration lives in the real, untracked `~/.config/mise/config.toml`.

## Customize

Latest on first install; pin afterwards with `mise use --global bun@<version>`, which
`install.sh` then leaves alone. Bun's global settings go in
`~/.config/.bunfig.toml` (with `XDG_CONFIG_HOME` set). Packages installed with
`bun add -g` put executables in `~/.bun/bin`, which is not on `PATH`.

## Verify

`./verify.sh` checks that a global mise config declares bun and that `mise which bun`
finds it.
