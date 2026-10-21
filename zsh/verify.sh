#!/bin/bash
# verify.sh: check the zsh config is linked into $HOME (zsh itself ships with macOS; read-only).
# requires: none
set -uo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
status=0
while IFS= read -r f; do
  rel="${f#"$here/home/"}"
  if [ "$(readlink -f "$HOME/$rel" 2>/dev/null)" != "$(readlink -f "$f")" ]; then
    echo "not linked: ~/$rel" >&2
    status=1
  fi
done < <(find "$here/home" -type f ! -name .DS_Store)
exit "$status"
