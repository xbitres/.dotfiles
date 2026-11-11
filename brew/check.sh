#!/bin/bash
# Show drift between brew/Brewfile and what is installed.
# Read-only: update the Brewfile by hand (it carries description comments).
set -e

BREWFILE="$(cd "$(dirname "$0")" && pwd)/Brewfile"

echo "==> In the Brewfile but missing or outdated:"
brew bundle check --file="$BREWFILE" --verbose || true

echo
echo "==> Installed but not in the Brewfile (remove with: brew bundle cleanup --file=\"$BREWFILE\" --force):"
brew bundle cleanup --file="$BREWFILE" || true
