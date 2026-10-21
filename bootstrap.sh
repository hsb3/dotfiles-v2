#!/bin/bash
# bootstrap.sh: install the managers every package depends on: Command Line Tools, Homebrew, Stow, mise.
# requires: none
set -uo pipefail

[ $# -eq 0 ] || {
  echo "usage: bootstrap.sh" >&2
  exit 2
}
here="$(cd "$(dirname "$0")" && pwd)"

if ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install
  echo "rerun bootstrap.sh after the installer finishes" >&2
  exit 1
fi
echo "ok command-line-tools"

find_brew() {
  for b in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    [ -x "$b" ] && echo "$b" && return 0
  done
  return 1
}
if ! brew="$(find_brew)"; then
  # Homebrew's documented installer; it prompts for the account password.
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || exit 1
  brew="$(find_brew)" || {
    echo "Homebrew's installer finished but brew was not found" >&2
    exit 1
  }
fi
echo "ok homebrew"

for formula in stow mise; do
  "$brew" list --formula "$formula" >/dev/null 2>&1 || "$brew" install "$formula" || exit 1
  echo "ok $formula"
done

if /usr/bin/git -C "$here" rev-parse --git-dir >/dev/null 2>&1; then
  /usr/bin/git -C "$here" config core.hooksPath .githooks || exit 1
  echo "ok git-hooks"
fi
echo "next: ./install.sh"
