#!/bin/bash

git branch -d $(git branch --merged=master | grep -v master)
git fetch --prune
