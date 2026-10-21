#!/bin/bash
# install.sh: declare bun in mise's global config if it is not declared yet, install it, generate its zsh completion, and link its PATH hook.
# requires: mise stow
set -euo pipefail

missing() {
  echo "missing prerequisite: $1 ($2)" >&2
  exit 3
}
command -v mise >/dev/null || missing mise "run bootstrap.sh"
command -v stow >/dev/null || missing stow "run bootstrap.sh"

here="$(cd "$(dirname "$0")" && pwd)"
# mise rewrites whichever global file declares a tool, so the declaration lives in the
# real ~/.config/mise/config.toml, never in a file linked from this repo.
[ -n "$(MISE_OFFLINE=1 mise ls --global bun 2>/dev/null)" ] || mise use --global bun@latest
MISE_OFFLINE=1 mise which bun >/dev/null 2>&1 || mise install bun || {
  echo "mise could not install bun; rerun $here/install.sh" >&2
  exit 1
}
comp="$HOME/.local/share/zsh/site-functions/_bun"
# bun picks the script from SHELL, and links a stray bunx into ~/.local/bin or ~/.bun/bin
# when bunx is not on PATH; mise exec puts it there.
new="$(SHELL=zsh MISE_OFFLINE=1 mise exec bun -- bun completions)"
[ "$(cat "$comp" 2>/dev/null)" = "$new" ] || {
  mkdir -p "${comp%/*}"
  printf '%s\n' "$new" >"$comp"
}
stow --dir="$here" --target="$HOME" --no-folding --ignore='\.DS_Store' home
