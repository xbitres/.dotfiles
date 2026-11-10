#!/bin/bash
set -e

# Run from the repo root regardless of where the script is invoked from.
export DOTFILES="$(cd "$(dirname "$0")" && pwd)"
cd "$DOTFILES"

chmod +x brew/install.sh zsh/install.sh link.sh tools/*-install.sh

./brew/install.sh
./zsh/install.sh
# ./tools/nvm-install.sh
# ./tools/excalidraw-install.sh
./tools/fasd-install.sh
# ./tools/nano-install.sh
./link.sh
