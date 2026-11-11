#!/bin/bash
# Delete local branches already merged into the default branch.
set -e

base=$("$(dirname "$0")/default-branch.sh")
current=$(git branch --show-current)

git fetch --all --prune
git branch --merged="$base" --format='%(refname:short)' | while read -r branch; do
    [ "$branch" = "$base" ] || [ "$branch" = "$current" ] || git branch -d "$branch"
done
