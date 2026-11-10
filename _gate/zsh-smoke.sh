#!/bin/bash
# zsh-smoke.sh: start the installed interactive zsh on a pseudo-terminal; any output fails (a compinit abort, a plugin error).
# requires: none
set -uo pipefail

# script(1) gives zsh the terminal an interactive shell expects; it echoes the closed stdin as ^D.
out="$(script -q /dev/null zsh -i -c exit </dev/null 2>&1 | tr -d '\b\r' | sed 's/\^D//g')"
if [ -n "$out" ]; then
  printf 'interactive zsh printed:\n%s\n' "$out" >&2
  exit 1
fi
echo "interactive zsh started clean"
