#!/bin/bash
# verify.sh: check uv is declared in mise's global config, installed, and its zsh completion generated (read-only).
# requires: mise
set -uo pipefail

missing() {
  echo "missing prerequisite: $1 ($2)" >&2
  exit 3
}
command -v mise >/dev/null || missing mise "run bootstrap.sh"

here="$(cd "$(dirname "$0")" && pwd)"
if [ -z "$(MISE_OFFLINE=1 mise ls --global uv 2>/dev/null)" ]; then
  echo "uv is not declared in mise's global config: run $here/install.sh" >&2
  exit 1
fi
if ! MISE_OFFLINE=1 mise which uv >/dev/null 2>&1; then
  echo "uv is declared but not installed: run $here/install.sh" >&2
  exit 1
fi
if [ ! -s "$HOME/.local/share/zsh/site-functions/_uv" ]; then
  echo "uv's zsh completion is missing: run $here/install.sh" >&2
  exit 1
fi
