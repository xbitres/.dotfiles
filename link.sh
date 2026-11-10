#!/bin/bash
set -e

export DOTFILES="${DOTFILES:-$(cd "$(dirname "$0")" && pwd)}"

# Symlink $DOTFILES/config/<file> to ~/<file>. Safe to re-run: existing
# correct links are left alone, other existing files are backed up.
link() {
    local src="$DOTFILES/config/$1"
    local dst="$HOME/$1"

    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
        echo "ok      $dst"
        return
    fi
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        local backup="$dst.backup.$(date +%Y%m%d%H%M%S)"
        mv "$dst" "$backup"
        echo "backup  $dst -> $backup"
    fi
    ln -s "$src" "$dst"
    echo "linked  $dst -> $src"
}

link .gitconfig
link .nanorc
link .zshrc
