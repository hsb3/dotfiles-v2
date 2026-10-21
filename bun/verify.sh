#!/bin/bash
# verify.sh: check bun is declared in mise's global config and installed (read-only).
# requires: mise
set -uo pipefail

missing() {
  echo "missing prerequisite: $1 ($2)" >&2
  exit 3
}
command -v mise >/dev/null || missing mise "run bootstrap.sh"

here="$(cd "$(dirname "$0")" && pwd)"
if [ -z "$(MISE_OFFLINE=1 mise ls --global bun 2>/dev/null)" ]; then
  echo "bun is not declared in mise's global config: run $here/install.sh" >&2
  exit 1
fi
if ! MISE_OFFLINE=1 mise which bun >/dev/null 2>&1; then
  echo "bun is declared but not installed: run $here/install.sh" >&2
  exit 1
fi
