#!/bin/bash
# install.sh: install language servers, formatters and debug adapters with Homebrew and mise, and link the js-debug launcher.
# requires: brew stow mise
set -euo pipefail

missing() {
  echo "missing prerequisite: $1 ($2)" >&2
  exit 3
}
command -v brew >/dev/null || missing brew "run bootstrap.sh"
command -v stow >/dev/null || missing stow "run bootstrap.sh"
command -v mise >/dev/null || missing mise "run bootstrap.sh"

here="$(cd "$(dirname "$0")" && pwd)"
HOMEBREW_NO_AUTO_UPDATE=1 brew bundle check --no-upgrade --file="$here/Brewfile" >/dev/null 2>&1 ||
  brew bundle install --no-upgrade --file="$here/Brewfile"
# Neither debug adapter has a Homebrew formula. As in the uv package, the declarations
# live in the real ~/.config/mise/config.toml, which mise rewrites.
for tool in pipx:debugpy 'github:microsoft/vscode-js-debug[asset_pattern=js-debug-dap-*.tar.gz]'; do
  name="${tool%%\[*}"
  [ -n "$(MISE_OFFLINE=1 mise ls --global "$name" 2>/dev/null)" ] || mise use --global "$tool@latest"
  MISE_OFFLINE=1 mise where "$name" >/dev/null 2>&1 || mise install "$name" || {
    echo "mise could not install $name; rerun $here/install.sh" >&2
    exit 1
  }
done
stow --dir="$here" --target="$HOME" --no-folding --ignore='\.DS_Store' home
