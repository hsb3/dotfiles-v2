#!/bin/bash
# Fixture mutation (R4): a script whose line 1 is not #!/bin/bash.
# requires: none
set -euo pipefail

sed -i '' '1s|.*|#!/usr/bin/env bash|' "$1/demo/verify.sh"
