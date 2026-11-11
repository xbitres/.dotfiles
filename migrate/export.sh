#!/bin/bash
# Pack the dotfiles and the local git/ssh/zsh files into one archive,
# to move them to a new laptop. See README, "Moving to a new laptop".
#
# Usage: ~/.dotfiles/migrate/export.sh [output-folder]   (default: ~/Desktop)
#
# The archive is NOT encrypted and contains your SSH private keys.
set -euo pipefail

# Paths inside your home folder to include. Add more here if needed.
FILES=(.dotfiles .zshrc.local .gitconfig.local .ssh Documents/Wallpapers)

out="${1:-$HOME/Desktop}/dotfiles-migrate-$(date +%Y-%m-%d).tar.gz"

cd "$HOME"
existing=()
for f in "${FILES[@]}"; do
    [ -e "$f" ] && existing+=("$f")
done

# ~/.ssh/config is a link into the repo; link.sh recreates it.
umask 077   # archive readable by you only
tar -czf "$out" --exclude '.ssh/config' --exclude '*.backup.*' "${existing[@]}"

echo "Created $out"
printf '  contains ~/%s\n' "${existing[@]}"
echo "Not encrypted, contains SSH private keys: put it in 1Password, then delete this file."
