#!/bin/bash
# install.sh: install gh with Homebrew and set its git protocol to ssh.
# requires: brew gh
set -euo pipefail

missing() {
  echo "missing prerequisite: $1 ($2)" >&2
  exit 3
}
command -v brew >/dev/null || missing brew "run bootstrap.sh"

here="$(cd "$(dirname "$0")" && pwd)"
HOMEBREW_NO_AUTO_UPDATE=1 brew bundle check --no-upgrade --file="$here/Brewfile" >/dev/null 2>&1 ||
  brew bundle install --no-upgrade --file="$here/Brewfile"
command -v gh >/dev/null || missing gh "brew bundle install --file=$here/Brewfile"
# gh rewrites its own config.yml, so the value is set in place rather than linked.
[ "$(gh config get git_protocol)" = ssh ] || gh config set git_protocol ssh
