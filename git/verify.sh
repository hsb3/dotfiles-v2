#!/bin/bash
# verify.sh: check git is installed, its config is linked, and ~/.gitconfig includes it (read-only).
# requires: brew git
set -uo pipefail

missing() {
  echo "missing prerequisite: $1 ($2)" >&2
  exit 3
}
command -v brew >/dev/null || missing brew "run bootstrap.sh"
command -v git >/dev/null || missing git "run bootstrap.sh"

here="$(cd "$(dirname "$0")" && pwd)"
status=0
if ! brew bundle check --file="$here/Brewfile" >/dev/null 2>&1; then
  echo "Brewfile dependencies not installed: brew bundle check --file=$here/Brewfile" >&2
  status=1
fi
while IFS= read -r f; do
  rel="${f#"$here/home/"}"
  if [ "$(readlink -f "$HOME/$rel" 2>/dev/null)" != "$(readlink -f "$f")" ]; then
    echo "not linked: ~/$rel" >&2
    status=1
  fi
done < <(find "$here/home" -type f ! -name .DS_Store)
shared="$HOME/.config/git/dotfiles.gitconfig"
if ! grep -qxF "$shared" <<<"$(git config --global --get-all include.path)"; then
  echo "$HOME/.gitconfig does not include $shared" >&2
  status=1
fi
exit "$status"
