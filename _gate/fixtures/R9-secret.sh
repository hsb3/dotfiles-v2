#!/bin/bash
# Fixture mutation (R9): a token-shaped secret, assembled at run time so the repo holds none.
# requires: none
set -euo pipefail

printf 'token = "%s%s"\n' ghp_ a1B2c3D4e5F6g7H8i9J0k1L2m3N4o5P6q7R8 >>"$1/demo/home/.demorc"
