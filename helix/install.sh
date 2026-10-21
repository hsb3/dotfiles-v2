#!/bin/bash
# install.sh: install helix with Homebrew and link its config into $HOME.
# requires: brew stow
set -euo pipefail

missing() {
  echo "missing prerequisite: $1 ($2)" >&2
  exit 3
}
command -v brew >/dev/null || missing brew "run bootstrap.sh"
command -v stow >/dev/null || missing stow "run bootstrap.sh"

here="$(cd "$(dirname "$0")" && pwd)"
HOMEBREW_NO_AUTO_UPDATE=1 brew bundle check --no-upgrade --file="$here/Brewfile" >/dev/null 2>&1 ||
  brew bundle install --no-upgrade --file="$here/Brewfile"
stow --dir="$here" --target="$HOME" --no-folding --ignore='\.DS_Store' home
