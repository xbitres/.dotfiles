#!/bin/bash
# Restore an archive made by migrate/export.sh on a new Mac. Run it from the
# extracted folder:  ./dotfiles-migrate-<date>/restore.sh
# Existing files are moved to <file>.backup.<timestamp>, never overwritten.
set -euo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)"
TARGET="$HOME/.dotfiles"
STAMP="$(date +%Y%m%d%H%M%S)"

backup() {
    if [ -e "$1" ] || [ -L "$1" ]; then
        mv "$1" "$1.backup.$STAMP"
        echo "backup   $1 -> $1.backup.$STAMP"
    fi
}

# 1. Dotfiles repo -> ~/.dotfiles
backup "$TARGET"
cp -Rp "$SRC/dotfiles" "$TARGET"
echo "restored $TARGET"

# 2. Home files (~/.zshrc.local, ~/.gitconfig.local, ~/.ssh/...)
cd "$SRC/home"
find . -type f | sed 's|^\./||' | while read -r rel; do
    dst="$HOME/$rel"
    if [ -f "$dst" ] && cmp -s "$rel" "$dst"; then
        echo "same     $dst"
        continue
    fi
    mkdir -p "$(dirname "$dst")"
    backup "$dst"
    cp -p "$rel" "$dst"
    echo "restored $dst"
done

# 3. SSH permissions: directories 700, private files 600, public keys 644
if [ -d "$HOME/.ssh" ]; then
    find "$HOME/.ssh" -type d -exec chmod 700 {} +
    find "$HOME/.ssh" -type f ! -name '*.pub' -exec chmod 600 {} +
    find "$HOME/.ssh" -type f -name '*.pub' -exec chmod 644 {} +
fi

cat <<'NEXT'

Done. Next:
  1. ~/.dotfiles/install.sh
  2. Load SSH keys into the Keychain once:
       ssh-add --apple-use-keychain ~/.ssh/<key>
  3. Delete the downloaded archive and the extracted folder; they contain
     private keys (the copy in 1Password stays).
NEXT
