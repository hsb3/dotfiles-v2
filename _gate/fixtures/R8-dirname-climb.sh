#!/bin/bash
# Fixture mutation (R8): reaching a sibling package through dirname.
# requires: none
set -euo pipefail

echo "cat \"\$(dirname \"\$here\")/other/file\"" >>"$1/demo/install.sh"
