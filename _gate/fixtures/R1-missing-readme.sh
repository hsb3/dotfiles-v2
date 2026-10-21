#!/bin/bash
# Fixture mutation (R1): a package without its README.
# requires: none
set -euo pipefail

rm "$1/demo/README.md"
