#!/bin/bash
# Fixture mutation (R3): a file outside the root allowlist.
# requires: none
set -euo pipefail

touch "$1/notes.txt"
