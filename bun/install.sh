#!/bin/bash
# install.sh: declare bun in mise's global config if it is not declared yet, then install it.
# requires: mise
set -euo pipefail

missing() {
  echo "missing prerequisite: $1 ($2)" >&2
  exit 3
}
command -v mise >/dev/null || missing mise "run bootstrap.sh"

here="$(cd "$(dirname "$0")" && pwd)"
# mise rewrites whichever global file declares a tool, so the declaration lives in the
# real ~/.config/mise/config.toml, never in a file linked from this repo.
[ -n "$(MISE_OFFLINE=1 mise ls --global bun 2>/dev/null)" ] || mise use --global bun@latest
mise install bun || {
  echo "mise could not install bun; rerun $here/install.sh" >&2
  exit 1
}
