#!/bin/bash
# Fixture mutation (R6): a bash 4 case modifier that /bin/bash -n accepts.
# requires: none
set -euo pipefail

echo "echo \"\${HOME""^}\"" >>"$1/demo/install.sh"
