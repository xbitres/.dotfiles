#!/bin/bash
# Colima instead of Docker Desktop, with Homebrew's buildx and compose plugins. Safe to re-run.
set -e
eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"

[ -d /Applications/Docker.app ] && echo "Docker Desktop is still installed: uninstall it to avoid conflicts"

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

# Run Colima now and at every login; it switches docker to the colima context.
brew services start colima
