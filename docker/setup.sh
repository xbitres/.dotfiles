#!/bin/bash
# Colima instead of Docker Desktop, with Homebrew's buildx and compose plugins. Safe to re-run.
set -e
eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"

[ -d /Applications/Docker.app ] && echo "Docker Desktop is still installed: uninstall it to avoid conflicts"

# Also in the Brewfile; installed here too so this script works on its own. Quick if present.
brew install --quiet colima docker docker-buildx docker-compose docker-credential-helper jq
command -v docker >/dev/null || { echo "docker is installed but not linked: run brew link --overwrite docker" >&2; exit 1; }

# Let docker find Homebrew's plugins and keep logins in the Keychain (replacing
# Docker Desktop's helper). Drop plugin links left pointing into Docker.app.
config="$HOME/.docker/config.json"
mkdir -p ~/.docker/cli-plugins
[ -s "$config" ] || echo '{}' > "$config"
jq --arg dir "$HOMEBREW_PREFIX/lib/docker/cli-plugins" '
    .cliPluginsExtraDirs = ((.cliPluginsExtraDirs // []) + [$dir] | unique)
    | if (.credsStore // "desktop") == "desktop" then .credsStore = "osxkeychain" end
' "$config" > "$config.tmp" && mv "$config.tmp" "$config"
find ~/.docker/cli-plugins -type l ! -exec test -e {} \; -delete

# First run: create the VM. Rosetta speeds up amd64 images on Apple Silicon.
if ! colima list 2>/dev/null | grep -q '^default '; then
    colima start --cpu 4 --memory 8 --disk 100 --vm-type vz $([ "$(uname -m)" = arm64 ] && echo --vz-rosetta)
    colima stop
fi

# Run Colima now and at every login, and point docker at it (away from Docker Desktop's context).
brew services start colima
docker context use colima
