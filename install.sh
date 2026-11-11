#!/bin/bash
set -e

# Run from the repo root regardless of where the script is invoked from.
DOTFILES="$(cd "$(dirname "$0")" && pwd)"
export DOTFILES
cd "$DOTFILES"

chmod +x brew/install.sh zsh/install.sh link.sh macos/*.sh

./brew/install.sh
./zsh/install.sh
./link.sh
./macos/default-apps.sh
