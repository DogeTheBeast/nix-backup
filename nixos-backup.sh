#!/usr/bin/env bash
set -e

REPO_DIR="/home/doge/nixos-config/"

cd "$REPO_DIR"

# Add all changes
git add -A

# Only commit if there are changes
if ! git diff --cached --quiet; then
    git commit -m "Auto backup: $(date '+%Y-%m-%d %H:%M:%S')"
    git push origin main
fi
