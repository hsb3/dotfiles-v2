#!/bin/bash
# verify.sh: check pnpm is declared in mise's global config, installed, and its hook linked (read-only).
# requires: mise
set -uo pipefail

missing() {
  echo "missing prerequisite: $1 ($2)" >&2
  exit 3
}
command -v mise >/dev/null || missing mise "run bootstrap.sh"

here="$(cd "$(dirname "$0")" && pwd)"
if [ -z "$(MISE_OFFLINE=1 mise ls --global pnpm 2>/dev/null)" ]; then
  echo "pnpm is not declared in mise's global config: run $here/install.sh" >&2
  exit 1
fi
status=0
if ! MISE_OFFLINE=1 mise which pnpm >/dev/null 2>&1; then
  echo "pnpm is declared but not installed: run $here/install.sh" >&2
  status=1
fi
while IFS= read -r f; do
  rel="${f#"$here/home/"}"
  if [ "$(readlink -f "$HOME/$rel" 2>/dev/null)" != "$(readlink -f "$f")" ]; then
    echo "not linked: ~/$rel" >&2
    status=1
  fi
done < <(find "$here/home" -type f ! -name .DS_Store)
exit "$status"
