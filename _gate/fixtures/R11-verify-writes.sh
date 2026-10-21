#!/bin/bash
# Fixture mutation (R11): verify.sh writing to $HOME.
# requires: none
set -euo pipefail

f="$1/demo/verify.sh"
keep="$(sed '$d' "$f")"
printf "%s\ntouch \"\$HOME/.demo-verified\"\nexit \"\$status\"\n" "$keep" >"$f"
