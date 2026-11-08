#!/bin/bash
# verify.sh: check the language servers and debug adapters are installed and the js-debug launcher is linked (read-only).
# requires: brew mise
set -uo pipefail

missing() {
  echo "missing prerequisite: $1 ($2)" >&2
  exit 3
}
command -v brew >/dev/null || missing brew "run bootstrap.sh"
command -v mise >/dev/null || missing mise "run bootstrap.sh"

here="$(cd "$(dirname "$0")" && pwd)"
status=0
if ! HOMEBREW_NO_AUTO_UPDATE=1 brew bundle check --no-upgrade --file="$here/Brewfile" >/dev/null 2>&1; then
  echo "Brewfile dependencies not installed: brew bundle check --no-upgrade --file=$here/Brewfile" >&2
  status=1
fi
for name in pipx:debugpy github:microsoft/vscode-js-debug; do
  if [ -z "$(MISE_OFFLINE=1 mise ls --global "$name" 2>/dev/null)" ]; then
    echo "$name is not declared in mise's global config: run $here/install.sh" >&2
    status=1
  elif ! MISE_OFFLINE=1 mise where "$name" >/dev/null 2>&1; then
    echo "$name is declared but not installed: run $here/install.sh" >&2
    status=1
  fi
done
while IFS= read -r f; do
  rel="${f#"$here/home/"}"
  if [ "$(readlink -f "$HOME/$rel" 2>/dev/null)" != "$(readlink -f "$f")" ]; then
    echo "not linked: ~/$rel" >&2
    status=1
  fi
done < <(find "$here/home" -type f ! -name .DS_Store)
exit "$status"
