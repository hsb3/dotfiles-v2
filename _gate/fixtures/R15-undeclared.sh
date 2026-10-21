#!/bin/bash
# Fixture mutation (R15): running brew without declaring it.
# requires: none
set -euo pipefail

f="$1/demo/verify.sh"
keep="$(sed '$d' "$f")"
printf "%s\nbrew list --formula >/dev/null\nexit \"\$status\"\n" "$keep" >"$f"
