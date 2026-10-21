#!/bin/bash
# Fixture mutation (R12): a README with a renamed section.
# requires: none
set -euo pipefail

sed -i '' 's/^## Customize$/## Options/' "$1/demo/README.md"
