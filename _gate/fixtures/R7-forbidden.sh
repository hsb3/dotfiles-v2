#!/bin/bash
# Fixture mutation (R7): a machine-tied absolute path.
# requires: none
set -euo pipefail

echo 'Configured for /Users/someone.' >>"$1/demo/README.md"
