#!/bin/bash
# Fixture mutation (R6): a shellcheck finding.
# requires: none
set -euo pipefail

echo "for f in \$(ls); do echo \"\$f\"; done" >>"$1/demo/install.sh"
