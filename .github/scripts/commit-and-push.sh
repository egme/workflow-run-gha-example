#!/bin/bash
set -euo pipefail

git config user.name "github-actions[bot]"
git config user.email "github-actions[bot]@users.noreply.github.com"

git add generated/
git commit -m "🤖 Auto-generate files with MD5 hashes [skip ci]"
git push

