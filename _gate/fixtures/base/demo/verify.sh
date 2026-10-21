#!/bin/bash
# verify.sh: check the demo config is linked into $HOME (read-only).
# requires: none
set -euo pipefail

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
