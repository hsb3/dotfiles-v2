#!/bin/bash
# Fixture mutation (R15): a prerequisite used before it is checked.
# requires: none
set -euo pipefail

f="$1/demo/install.sh"
keep="$(grep -v "^command -v stow" "$f")"
printf "%s\ncommand -v stow >/dev/null || missing stow \"run bootstrap.sh\"\n" "$keep" >"$f"
