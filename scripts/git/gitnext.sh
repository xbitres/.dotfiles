#!/bin/bash

nextbr=$(awk -F -v '{print $(NF-1)"-v"($NF + 1)}' <<< $(git rev-parse --abbrev-ref HEAD))
br=$(git rev-parse --abbrev-ref HEAD)
git pull --rebase origin master
git branch "$nextbr" "$br"
git rebase "$nextbr" master
git checkout "$nextbr"
