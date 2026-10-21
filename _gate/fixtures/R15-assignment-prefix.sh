#!/bin/bash
# Fixture mutation (R15): running shellcheck behind an assignment prefix without declaring it.
# requires: none
set -euo pipefail

f="$1/demo/verify.sh"
keep="$(sed '$d' "$f")"
printf "%s\nLC_ALL=C shellcheck --version >/dev/null\nexit \"\$status\"\n" "$keep" >"$f"
