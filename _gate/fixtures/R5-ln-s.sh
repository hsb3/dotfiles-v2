#!/bin/bash
# Fixture mutation (R5): linking with ln -s instead of stow.
# requires: none
set -euo pipefail

echo "ln -s \"\$here/home/.demorc\" \"\$HOME/.demorc2\"" >>"$1/demo/install.sh"
