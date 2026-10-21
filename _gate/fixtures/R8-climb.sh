#!/bin/bash
# Fixture mutation (R8): a package script reaching outside its package.
# requires: none
set -euo pipefail

echo "cat \"\$here/../other/file\"" >>"$1/demo/install.sh"
