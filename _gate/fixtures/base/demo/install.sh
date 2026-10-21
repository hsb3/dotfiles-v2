#!/bin/bash
# install.sh: link the demo config into $HOME.
# requires: stow
set -euo pipefail

missing() {
  echo "missing prerequisite: $1 ($2)" >&2
  exit 3
}
command -v stow >/dev/null || missing stow "run bootstrap.sh"

here="$(cd "$(dirname "$0")" && pwd)"
stow --dir="$here" --target="$HOME" --no-folding --ignore='\.DS_Store' home
