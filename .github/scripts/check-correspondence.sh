#!/bin/bash
set -euo pipefail

echo ""
echo "🔗 Checking correspondence between source and generated files..."

correspondence_failed=0

# Check that each source file has a corresponding generated file
for source_file in sources/*.md; do
  if [ -f "$source_file" ]; then
    base_name=$(basename "$source_file" .md)
    md5_hash=$(md5sum "$source_file" | awk '{print $1}')
    expected_generated="generated/${base_name}_${md5_hash}.md"
    
    if [ -f "$expected_generated" ]; then
      echo "✅ Source '$source_file' has matching generated file"
    else
      echo "❌ Source '$source_file' is missing corresponding generated file: $expected_generated"
      correspondence_failed=1
    fi
  fi
done

# Check for orphaned generated files
for generated_file in generated/*.md; do
  if [ -f "$generated_file" ]; then
    filename=$(basename "$generated_file")
    base_name=$(echo "$filename" | sed 's/_[a-f0-9]\{32\}\.md$//')
    source_file="sources/${base_name}.md"
    
    if [ ! -f "$source_file" ]; then
      echo "⚠️  Warning: Generated file '$filename' has no corresponding source file"
    fi
  fi
done

if [ $correspondence_failed -eq 1 ]; then
  echo ""
  echo "❌ Correspondence check failed"
  exit 1
fi

echo ""
echo "✅ All correspondence checks passed"

