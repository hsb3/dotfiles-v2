#!/bin/bash
# install.sh: install tmuxinator with Homebrew.
# requires: brew
set -euo pipefail

missing() {
  echo "missing prerequisite: $1 ($2)" >&2
  exit 3
}
command -v brew >/dev/null || missing brew "run bootstrap.sh"

here="$(cd "$(dirname "$0")" && pwd)"
brew bundle check --file="$here/Brewfile" >/dev/null 2>&1 ||
  brew bundle install --no-upgrade --file="$here/Brewfile"
