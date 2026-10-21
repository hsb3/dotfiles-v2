#!/bin/bash
# install.sh: declare fnox in mise's global config if it is not declared yet, install it, generate its zsh completion, and add a global keychain provider.
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
[ -n "$(MISE_OFFLINE=1 mise ls --global fnox 2>/dev/null)" ] || mise use --global fnox@latest
MISE_OFFLINE=1 mise which fnox >/dev/null 2>&1 || mise install fnox || {
  echo "mise could not install fnox; rerun $here/install.sh" >&2
  exit 1
}
comp="$HOME/.local/share/zsh/site-functions/_fnox"
new="$(MISE_OFFLINE=1 mise exec fnox -- fnox completion zsh)"
[ "$(cat "$comp" 2>/dev/null)" = "$new" ] || {
  mkdir -p "${comp%/*}"
  printf '%s\n' "$new" >"$comp"
}
# fnox writes this file itself (and rewrites it on `fnox set --global`), so it is never
# linked. FNOX_CONFIG_DIR pins it to the path checked here whatever XDG_CONFIG_HOME says.
cfg="$HOME/.config/fnox/config.toml"
if ! { [ -f "$cfg" ] && MISE_OFFLINE=1 mise exec fnox -- fnox -c "$cfg" provider list | grep -qx keychain; }; then
  FNOX_CONFIG_DIR="$HOME/.config/fnox" MISE_OFFLINE=1 mise exec fnox -- fnox provider add keychain keychain --global
fi
