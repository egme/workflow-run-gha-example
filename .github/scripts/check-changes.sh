#!/bin/bash
set -euo pipefail

# Check if there are changes in the generated directory
# Exits with 0 if there are changes, 1 if no changes
git diff --exit-code generated/ || echo "has_changes=true" >> "$GITHUB_OUTPUT"

