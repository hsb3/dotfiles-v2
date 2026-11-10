#!/bin/bash
# Fixture mutation (R18): a Brewfile entry the README never names.
# requires: none
set -euo pipefail

echo 'brew "undocumented-formula"' >"$1/demo/Brewfile"
