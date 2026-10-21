#!/bin/bash
# verify.sh: check fnox is declared in mise's global config, installed, its zsh completion generated, and its keychain provider configured (read-only).
# requires: mise
set -uo pipefail

missing() {
  echo "missing prerequisite: $1 ($2)" >&2
  exit 3
}
command -v mise >/dev/null || missing mise "run bootstrap.sh"

here="$(cd "$(dirname "$0")" && pwd)"
if [ -z "$(MISE_OFFLINE=1 mise ls --global fnox 2>/dev/null)" ]; then
  echo "fnox is not declared in mise's global config: run $here/install.sh" >&2
  exit 1
fi
if ! MISE_OFFLINE=1 mise which fnox >/dev/null 2>&1; then
  echo "fnox is declared but not installed: run $here/install.sh" >&2
  exit 1
fi
status=0
if [ ! -s "$HOME/.local/share/zsh/site-functions/_fnox" ]; then
  echo "fnox's zsh completion is missing: run $here/install.sh" >&2
  status=1
fi
# Reads the config file only; nothing here reaches the Keychain.
if ! MISE_OFFLINE=1 mise exec fnox -- fnox -c "$HOME/.config/fnox/config.toml" provider list 2>/dev/null | grep -qx keychain; then
  echo "no keychain provider in ~/.config/fnox/config.toml: run $here/install.sh" >&2
  status=1
fi
exit "$status"
