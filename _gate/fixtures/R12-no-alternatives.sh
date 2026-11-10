#!/bin/bash
# Fixture mutation (R12): a Why section without Alternatives Considered.
# requires: none
set -euo pipefail

sed -i '' '/^### Alternatives Considered$/d' "$1/demo/README.md"
