#!/bin/bash
set -euo pipefail

echo "### 📝 Generation Summary" >> "$GITHUB_STEP_SUMMARY"
echo "" >> "$GITHUB_STEP_SUMMARY"
echo "Generated files:" >> "$GITHUB_STEP_SUMMARY"
echo "" >> "$GITHUB_STEP_SUMMARY"
ls -lh generated/ | tail -n +2 | awk '{print "- " $9}' >> "$GITHUB_STEP_SUMMARY" || echo "No files generated" >> "$GITHUB_STEP_SUMMARY"

