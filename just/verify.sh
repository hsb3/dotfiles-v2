#!/bin/bash
# verify.sh: check just is installed (read-only).
# requires: brew
set -uo pipefail

missing() {
  echo "missing prerequisite: $1 ($2)" >&2
  exit 3
}
command -v brew >/dev/null || missing brew "run bootstrap.sh"

here="$(cd "$(dirname "$0")" && pwd)"
if ! HOMEBREW_NO_AUTO_UPDATE=1 brew bundle check --no-upgrade --file="$here/Brewfile" >/dev/null 2>&1; then
  echo "Brewfile dependencies not installed: brew bundle check --no-upgrade --file=$here/Brewfile" >&2
  exit 1
fi
