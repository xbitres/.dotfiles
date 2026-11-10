#!/bin/sh
set -e

: "${DOTFILES:?DOTFILES must be set (run via install.sh)}"

rm -rf "$DOTFILES/.download/fasd"
git clone https://github.com/whjvenyl/fasd.git "$DOTFILES/.download/fasd"

mkdir -p "$DOTFILES/.installs/fasd" "$DOTFILES/.installs/bin"
(cd "$DOTFILES/.download/fasd" && PREFIX="$DOTFILES/.installs/fasd" make install)
mv "$DOTFILES/.installs/fasd/bin/fasd" "$DOTFILES/.installs/bin/fasd"
# Shell init for fasd is done in config/.zshrc.
