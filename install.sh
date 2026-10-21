#!/bin/bash
# install.sh: run each listed package's install.sh, in packages order.
# requires: brew stow mise
set -uo pipefail

missing() {
  echo "missing prerequisite: $1 ($2)" >&2
  exit 3
}
# A terminal opened before bootstrap.sh finished has no Homebrew on PATH yet.
for p in /usr/local/bin /opt/homebrew/bin; do
  [ -x "$p/brew" ] && PATH="$p:$PATH"
done
export PATH
command -v brew >/dev/null || missing brew "run bootstrap.sh"
command -v stow >/dev/null || missing stow "run bootstrap.sh"
command -v mise >/dev/null || missing mise "run bootstrap.sh"

here="$(cd "$(dirname "$0")" && pwd)"
action=install
usage() {
  echo "usage: $action.sh [package...]" >&2
  exit 2
}
[ -f "$here/packages" ] || {
  echo "no packages file in $here" >&2
  exit 1
}
# Stow reads ~/.stowrc; an --adopt or --override there would undo R5's guarantees.
[ ! -e "$HOME/.stowrc" ] || {
  echo "refusing to run with $HOME/.stowrc present; move it aside" >&2
  exit 1
}
all="$(sed -e 's/#.*//' -e 's/[[:space:]]//g' "$here/packages" | grep -v '^$')"
for a in "$@"; do
  case "$a" in
    -h | --help)
      echo "usage: $action.sh [package...]"
      exit 0
      ;;
    -*)
      echo "unknown flag: $a" >&2
      usage
      ;;
  esac
  grep -qxF -- "$a" <<<"$all" || {
    echo "unknown package: $a" >&2
    usage
  }
done

ok=0
failed=0
for p in $all; do
  if [ $# -gt 0 ]; then
    case " $* " in *" $p "*) ;; *) continue ;; esac
  fi
  # Package stdout goes straight to stderr; package stderr is kept for the FAIL reason.
  err="$("$here/$p/$action.sh" 2>&1 >&2)"
  rc=$?
  [ -z "$err" ] || printf '%s\n' "$err" >&2
  if [ "$rc" -eq 0 ]; then
    echo "ok $p"
    ok=$((ok + 1))
    continue
  fi
  reason="$(grep -m 1 -o '^missing prerequisite: [^ ]*' <<<"$err")"
  [ -n "$reason" ] || reason="$(grep -m 1 -o 'existing target [^ ]*' <<<"$err" | sed 's/^existing target /conflicts with existing ~\//')"
  [ -n "$reason" ] || reason="$(grep -v '^[[:space:]]*$' <<<"$err" | tail -n 1)"
  echo "FAIL $p: ${reason:-exit $rc}"
  failed=$((failed + 1))
done
echo "$ok ok, $failed failed"
[ "$failed" -eq 0 ]
