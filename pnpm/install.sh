#!/bin/bash
# install.sh: declare pnpm in mise's global config if it is not declared yet, install it, and link its PATH hook.
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
[ -n "$(MISE_OFFLINE=1 mise ls --global pnpm 2>/dev/null)" ] || mise use --global pnpm@latest
MISE_OFFLINE=1 mise which pnpm >/dev/null 2>&1 || mise install pnpm || {
  echo "mise could not install pnpm; rerun $here/install.sh" >&2
  exit 1
}
stow --dir="$here" --target="$HOME" --no-folding --ignore='\.DS_Store' home
