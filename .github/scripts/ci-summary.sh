#!/bin/bash
set -euo pipefail

# Expects VALIDATION_STATUS as an environment variable
echo "### 🧪 CI Validation Report" >> "$GITHUB_STEP_SUMMARY"
echo "" >> "$GITHUB_STEP_SUMMARY"

if [ "${VALIDATION_STATUS:-}" = "passed" ]; then
  echo "✅ **Status: PASSED**" >> "$GITHUB_STEP_SUMMARY"
else
  echo "❌ **Status: FAILED**" >> "$GITHUB_STEP_SUMMARY"
fi

echo "" >> "$GITHUB_STEP_SUMMARY"
echo "#### Generated Files" >> "$GITHUB_STEP_SUMMARY"
echo "" >> "$GITHUB_STEP_SUMMARY"

if [ -d "generated" ]; then
  for file in generated/*.md; do
    if [ -f "$file" ]; then
      filename=$(basename "$file")
      hash=$(echo "$filename" | grep -oP '_\K[a-f0-9]{32}(?=\.md$)' || echo "unknown")
      echo "- \`$filename\` (MD5: \`${hash:0:8}...\`)" >> "$GITHUB_STEP_SUMMARY"
    fi
  done
fi

echo "" >> "$GITHUB_STEP_SUMMARY"
echo "---" >> "$GITHUB_STEP_SUMMARY"
echo "*Triggered by workflow run: ${WORKFLOW_RUN_ID:-unknown}*" >> "$GITHUB_STEP_SUMMARY"

