#!/bin/bash
set -e

export DOTFILES="${DOTFILES:-$(cd "$(dirname "$0")" && pwd)}"

# Symlink $DOTFILES/config/<file> to ~/<target> (default: ~/<file>). Safe to
# re-run: existing correct links are left alone, other files are backed up.
link() {
    local src="$DOTFILES/config/$1"
    local dst="$HOME/${2:-$1}"
    mkdir -p "$(dirname "$dst")"

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
link ghostty/config .config/ghostty/config

# ~/.zshrc.local is machine-specific: copy the template once, never overwrite.
if [ ! -e "$HOME/.zshrc.local" ]; then
    cp "$DOTFILES/config/.zshrc.local.example" "$HOME/.zshrc.local"
    echo "created $HOME/.zshrc.local (from template)"
else
    echo "ok      $HOME/.zshrc.local (kept, machine-local)"
fi
