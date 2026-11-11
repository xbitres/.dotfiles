#!/bin/bash
# Print the repository's default branch: origin/HEAD if known, else main or master.
branch=$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null | sed 's|^origin/||')
if [ -z "$branch" ]; then
    for candidate in main master; do
        if git show-ref --verify --quiet "refs/heads/$candidate" || git show-ref --verify --quiet "refs/remotes/origin/$candidate"; then
            branch=$candidate
            break
        fi
    done
fi
[ -n "$branch" ] || { echo "could not determine default branch" >&2; exit 1; }
echo "$branch"
