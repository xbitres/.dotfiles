#!/bin/bash

nextbr=$(awk -F -v '{print $(NF-1)"-v"($NF + 1)}' <<< $(git rev-parse --abbrev-ref HEAD))
br=$(git rev-parse --abbrev-ref HEAD)
git branch "$nextbr" master
git checkout "$nextbr"
git pull --rebase origin master

[ "$1" = '-r' ] && git rebase "$br"

