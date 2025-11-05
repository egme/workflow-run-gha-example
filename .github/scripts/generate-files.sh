#!/bin/bash
set -euo pipefail

echo "🔄 Generating files from sources..."

# Create generated directory if it doesn't exist
mkdir -p generated

# Remove old generated files
rm -f generated/*

# Process each markdown file in sources
for source_file in sources/*.md; do
  if [ -f "$source_file" ]; then
    # Get the base filename without extension
    base_name=$(basename "$source_file" .md)
    
    # Calculate MD5 hash of the file content
    md5_hash=$(md5sum "$source_file" | awk '{print $1}')
    
    # Create the generated filename with hash
    generated_file="generated/${base_name}_${md5_hash}.md"
    
    # Copy the source file to generated with the new name
    cp "$source_file" "$generated_file"
    
    echo "✅ Generated: $generated_file"
  fi
done

echo "📊 Generation complete!"

