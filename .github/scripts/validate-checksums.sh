#!/bin/bash
set -euo pipefail

echo "🔍 Validating MD5 checksums in generated files..."

validation_failed=0
file_count=0

# Check if generated directory exists
if [ ! -d "generated" ]; then
  echo "❌ Error: 'generated' directory does not exist!"
  exit 1
fi

# Validate each file in generated directory
for generated_file in generated/*.md; do
  if [ -f "$generated_file" ]; then
    file_count=$((file_count + 1))
    
    # Extract filename and hash from the generated file
    filename=$(basename "$generated_file")
    base_name=$(echo "$filename" | sed 's/_[a-f0-9]\{32\}\.md$//')
    hash_in_filename=$(echo "$filename" | grep -oP '_\K[a-f0-9]{32}(?=\.md$)')
    
    if [ -z "$hash_in_filename" ]; then
      echo "❌ Error: File '$filename' does not have a valid MD5 hash in its name"
      validation_failed=1
      continue
    fi
    
    # Calculate actual MD5 hash of the file content
    actual_hash=$(md5sum "$generated_file" | awk '{print $1}')
    
    # Compare hashes
    if [ "$hash_in_filename" = "$actual_hash" ]; then
      echo "✅ Valid: $filename (hash matches)"
    else
      echo "❌ Invalid: $filename"
      echo "   Expected hash: $hash_in_filename"
      echo "   Actual hash:   $actual_hash"
      validation_failed=1
    fi
  fi
done

echo ""
echo "📊 Validation Summary:"
echo "   Files validated: $file_count"

if [ $validation_failed -eq 1 ]; then
  echo "   Status: ❌ FAILED"
  echo "validation_status=failed" >> "$GITHUB_OUTPUT"
  exit 1
else
  echo "   Status: ✅ PASSED"
  echo "validation_status=passed" >> "$GITHUB_OUTPUT"
fi

