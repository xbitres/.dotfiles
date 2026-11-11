#!/bin/bash
# Package this dotfiles repo plus the machine-local setup (git, SSH, zsh)
# into one encrypted, compressed archive for moving to a new Mac.
#
#   ./migrate/export.sh [output-dir]     (default output-dir: ~/Desktop)
#
# The archive is NOT encrypted and contains SSH private keys: keep it in
# 1Password (or another secure store) and delete local copies after use.
# See README "Moving to a new laptop".
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"
OUT_DIR="${1:-$HOME/Desktop}"
NAME="dotfiles-migrate-$(date +%Y%m%d-%H%M%S)"
OUT="$OUT_DIR/$NAME.tar.gz"

STAGE="$(mktemp -d)"   # created with mode 700
trap 'rm -rf "$STAGE"' EXIT
ROOT="$STAGE/$NAME"
mkdir -p "$ROOT/home"

included=()
add_home() {   # add_home <path relative to $HOME>; directories: regular files only
    local rel="$1" file
    if [ -d "$HOME/$rel" ]; then
        while IFS= read -r file; do
            mkdir -p "$ROOT/home/$(dirname "$file")"
            cp -p "$HOME/$file" "$ROOT/home/$file"
        done < <(cd "$HOME" && find "$rel" -type f)
    else
        mkdir -p "$ROOT/home/$(dirname "$rel")"
        cp -p "$HOME/$rel" "$ROOT/home/$rel"
    fi
    # shellcheck disable=SC2088  # literal ~ for display
    included+=("~/$rel")
}

# 1. The dotfiles repo, including .git (uncommitted changes and local
#    branches come along).
cp -Rp "$DOTFILES" "$ROOT/dotfiles"

# 2. Machine-local zsh and git config
for f in .zshrc.local .gitconfig.local; do
    [ -f "$HOME/$f" ] && add_home "$f"
done

# 3. Extra git config files that ~/.gitconfig.local includes (e.g. includeIf)
if [ -f "$HOME/.gitconfig.local" ]; then
    git config --file "$HOME/.gitconfig.local" --get-regexp '^include(if\..*)?\.path$' 2>/dev/null \
        | while read -r _ path; do echo "${path/#\~/$HOME}"; done \
        | while read -r path; do
            case "$path" in "$HOME"/*) [ -f "$path" ] && echo "${path#"$HOME"/}" ;; esac
          done > "$STAGE/git-includes" || true
    while read -r rel; do add_home "$rel"; done < "$STAGE/git-includes"
fi

# 4. ~/.ssh: keys, known_hosts, config.local. Skips the linked config
#    (recreated by link.sh), backups and agent sockets.
if [ -d "$HOME/.ssh" ]; then
    for entry in "$HOME/.ssh"/* "$HOME/.ssh"/.[!.]*; do
        [ -e "$entry" ] || continue
        [ -L "$entry" ] && continue
        [ -S "$entry" ] && continue
        case "$entry" in *.backup.*) continue ;; esac
        add_home ".ssh/$(basename "$entry")"
    done
fi

# Restore script at the top level, plus a manifest
cp -p "$DOTFILES/migrate/restore.sh" "$ROOT/restore.sh"
{
    echo "Created: $(date)"
    echo "From:    $(scutil --get ComputerName 2>/dev/null || hostname)"
    echo
    echo "Home files:"
    printf '  %s\n' "${included[@]}"
} > "$ROOT/MANIFEST.txt"

# Compress; readable by the owner only
mkdir -p "$OUT_DIR"
(umask 077 && tar -czf "$OUT" -C "$STAGE" "$NAME")

echo
echo "Created $OUT ($(du -h "$OUT" | cut -f1))"
echo "Included:"
echo "  ~/.dotfiles (with .git)"
printf '  %s\n' "${included[@]}"
echo
echo "Not encrypted, contains private keys: store it in 1Password, then delete it here."
echo
echo "On the new Mac:"
echo "  tar -xzf $NAME.tar.gz && ./$NAME/restore.sh"
