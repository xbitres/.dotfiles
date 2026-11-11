#!/bin/bash
# Make Ghostty the default terminal for what macOS lets an app claim.
# Ghostty registers for Unix executables (double-clicking one in Finder runs
# it in Ghostty). It also registers for folders, which is deliberately NOT
# set here: that would make Finder open every folder in Ghostty.
set -e

GHOSTTY=com.mitchellh.ghostty

if ! command -v duti >/dev/null; then
    echo "duti not installed (brew install duti)" >&2
    exit 1
fi

duti -s "$GHOSTTY" public.unix-executable all
echo "Ghostty set as default for: public.unix-executable"
