#!/bin/bash
# install.sh: install git with Homebrew, link its shared config, and include it from ~/.gitconfig.
# requires: brew stow git
set -euo pipefail

missing() {
  echo "missing prerequisite: $1 ($2)" >&2
  exit 3
}
command -v brew >/dev/null || missing brew "run bootstrap.sh"
command -v stow >/dev/null || missing stow "run bootstrap.sh"
command -v git >/dev/null || missing git "run bootstrap.sh"

here="$(cd "$(dirname "$0")" && pwd)"
brew bundle check --file="$here/Brewfile" >/dev/null 2>&1 ||
  brew bundle install --no-upgrade --file="$here/Brewfile"
stow --dir="$here" --target="$HOME" --no-folding --ignore='\.DS_Store' home
# `git config --global` writes to ~/.gitconfig, a real file outside the repo; the linked
# file is only ever included, so git never writes through the link into the repo.
shared="$HOME/.config/git/dotfiles.gitconfig"
grep -qxF "$shared" <<<"$(git config --global --get-all include.path)" ||
  git config --global --add include.path "$shared"
