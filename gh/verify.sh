#!/bin/bash
# verify.sh: check gh is installed and its git protocol is ssh (read-only).
# requires: brew gh
set -uo pipefail

missing() {
  echo "missing prerequisite: $1 ($2)" >&2
  exit 3
}
command -v brew >/dev/null || missing brew "run bootstrap.sh"
command -v gh >/dev/null || missing gh "run install.sh"

here="$(cd "$(dirname "$0")" && pwd)"
status=0
if ! HOMEBREW_NO_AUTO_UPDATE=1 brew bundle check --no-upgrade --file="$here/Brewfile" >/dev/null 2>&1; then
  echo "Brewfile dependencies not installed: brew bundle check --no-upgrade --file=$here/Brewfile" >&2
  status=1
fi
protocol="$(gh config get git_protocol)"
if [ "$protocol" != ssh ]; then
  echo "gh git_protocol is ${protocol:-unset}, expected ssh" >&2
  status=1
fi
exit "$status"
