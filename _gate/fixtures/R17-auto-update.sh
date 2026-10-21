#!/bin/bash
# Fixture mutation (R17): checking the Brewfile without HOMEBREW_NO_AUTO_UPDATE=1.
# requires: none
set -euo pipefail

f="$1/demo/install.sh"
sed -i '' -e '3s/.*/# requires: stow brew/' -e '/command -v stow/a\
command -v brew >/dev/null || missing brew "run bootstrap.sh"
' "$f"
printf '%s\n' "brew bundle check --no-upgrade --file=\"\$here/Brewfile\" >/dev/null || true" >>"$f"
