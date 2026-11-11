#!/bin/bash

base=$("$(dirname "$0")/default-branch.sh")

nextbr=$(awk -F -v '{print $(NF-1)"-v"($NF + 1)}' <<< $(git rev-parse --abbrev-ref HEAD))
br=$(git rev-parse --abbrev-ref HEAD)
git pull --rebase origin "$base"
git branch "$nextbr" "$br"
git rebase "$nextbr" "$base"
git checkout "$nextbr"
