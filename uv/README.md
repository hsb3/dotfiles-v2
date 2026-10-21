# uv

## What

uv, the Python package and project manager, installed and versioned by mise (from the
mise package). Tools installed with `uv tool install` land in `~/.local/bin`.

## Install

`./install.sh` declares `uv = "latest"` in mise's global config with
`mise use --global uv@latest`, but only when no global config declares uv yet, then runs
`mise install uv`. Nothing is linked: mise rewrites the file that declares a tool, so the
declaration lives in the real, untracked `~/.config/mise/config.toml`.

## Customize

Latest on first install; pin afterwards with `mise use --global uv@<version>`, which
`install.sh` then leaves alone. uv's own settings go in `~/.config/uv/uv.toml`.
Do not run `uv tool update-shell` or `uv python update-shell`, or append the completion
line from uv's install docs to `~/.zshrc`: `~/.zshrc` is linked into this repo.

## Verify

`./verify.sh` checks that a global mise config declares uv and that `mise which uv`
finds it.
