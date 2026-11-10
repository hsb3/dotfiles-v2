# uv

## What

uv, the Python package and project manager, installed and versioned by mise (from the
mise package). Tools installed with `uv tool install` land in `~/.local/bin`.

## Why

Python versions, venvs, dependencies and CLI tools in one fast tool. mise pins its version.

### Alternatives Considered

- pip with venv: slow, with no lockfile.
- poetry or pipenv: slower, and cover only part of what uv does.
- Homebrew: one global version instead of mise's pin.

## Install

`./install.sh` declares `uv = "latest"` in mise's global config with
`mise use --global uv@latest`, but only when no global config declares uv yet, then runs
`mise install uv`. Nothing is linked: mise rewrites the file that declares a tool, so the
declaration lives in the real, untracked `~/.config/mise/config.toml`.
It then writes the zsh completion from `uv generate-shell-completion zsh` to
`~/.local/share/zsh/site-functions/_uv`, rewriting the file only when the output
changes.

## Customize

Latest on first install; pin afterwards with `mise use --global uv@<version>`, which
`install.sh` then leaves alone. uv's own settings go in `~/.config/uv/uv.toml`.
Do not run `uv tool update-shell` or `uv python update-shell`, or append the completion
line from uv's install docs to `~/.zshrc`: `~/.zshrc` is linked into this repo.

## Verify

`./verify.sh` checks that a global mise config declares uv, that `mise which uv` finds
it, and that the completion file exists.
