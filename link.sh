#!/bin/bash
# Link tracked config files into $HOME. Safe to re-run.
set -e

export DOTFILES="${DOTFILES:-$(cd "$(dirname "$0")" && pwd)}"
CONFIG="$DOTFILES/config"

# link <file under config/> [target under $HOME, default: same path]
# Existing correct links are left alone; anything else is backed up first.
link() {
    local src="$CONFIG/$1"
    local dst="$HOME/${2:-$1}"
    mkdir -p "$(dirname "$dst")"

    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
        echo "ok       $dst"
        return
    fi
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        local backup
        backup="$dst.backup.$(date +%Y%m%d%H%M%S)"
        mv "$dst" "$backup"
        echo "backup   $dst -> $backup"
    fi
    ln -s "$src" "$dst"
    echo "linked   $dst -> $src"
}

# seed <template under config/> <target under $HOME>
# Machine-local files: copy the template once, never overwrite.
seed() {
    local dst="$HOME/$2"
    if [ -e "$dst" ]; then
        echo "kept     $dst (machine-local)"
    else
        mkdir -p "$(dirname "$dst")"
        cp "$CONFIG/$1" "$dst"
        echo "created  $dst (from template, edit it)"
    fi
}

# adopt <file under config/> <target under $HOME>
# For app settings that are not in the repo yet: on first run, copy the
# existing file into the repo (commit it afterwards), then link it.
adopt() {
    local src="$CONFIG/$1"
    local dst="$HOME/$2"
    if [ ! -e "$src" ]; then
        if [ -f "$dst" ] && [ ! -L "$dst" ]; then
            mkdir -p "$(dirname "$src")"
            cp "$dst" "$src"
            echo "adopted  $dst -> $src (commit it)"
        else
            echo "skipped  $dst (no file to adopt yet)"
            return
        fi
    fi
    link "$1" "$2"
}

# Shell, git, editor
link .zshrc
seed .zshrc.local.example .zshrc.local
link .gitconfig
seed .gitconfig.local.example .gitconfig.local
link .nanorc

# SSH: keep an existing config working by moving it to config.local
mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
if [ -f "$HOME/.ssh/config" ] && [ ! -L "$HOME/.ssh/config" ] && [ ! -e "$HOME/.ssh/config.local" ]; then
    mv "$HOME/.ssh/config" "$HOME/.ssh/config.local"
    echo "moved    ~/.ssh/config -> ~/.ssh/config.local"
fi
link ssh/config .ssh/config
seed ssh/config.local.example .ssh/config.local

# Terminal
link ghostty/config .config/ghostty/config

# VS Code Insiders
VSCODE_USER="Library/Application Support/Code - Insiders/User"
adopt vscode/settings.json "$VSCODE_USER/settings.json"
adopt vscode/keybindings.json "$VSCODE_USER/keybindings.json"
