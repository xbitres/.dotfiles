#!/bin/bash
# Use Colima as the Docker engine (instead of Docker Desktop) and make the
# Homebrew docker CLI plugins (buildx, compose) work. Safe to re-run.
#
# Colima VM size for a new VM (an existing VM keeps its settings; change them
# with `colima stop && colima start --cpu N --memory N`):
COLIMA_CPUS="${COLIMA_CPUS:-4}"
COLIMA_MEMORY="${COLIMA_MEMORY:-8}"   # GiB
COLIMA_DISK="${COLIMA_DISK:-100}"     # GiB
set -e

for b in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    [ -x "$b" ] && eval "$("$b" shellenv)" && break
done
for cmd in brew colima docker jq; do
    command -v "$cmd" >/dev/null || { echo "missing $cmd: run brew/install.sh first" >&2; exit 1; }
done

if [ -d "/Applications/Docker.app" ]; then
    echo "note     Docker Desktop is still installed; quit it, or uninstall it, to avoid conflicts"
fi

# --- ~/.docker/config.json ----------------------------------------------------
# docker writes to this file itself (logins, contexts), so it is merged, not linked.
#  - cliPluginsExtraDirs: where Homebrew installs docker-buildx and docker-compose
#  - credsStore: macOS Keychain (docker-credential-helper). Docker Desktop's
#    "desktop" helper stops working once Desktop is gone.
DOCKER_CONFIG_DIR="${DOCKER_CONFIG:-$HOME/.docker}"
CONFIG_JSON="$DOCKER_CONFIG_DIR/config.json"
PLUGINS_DIR="$HOMEBREW_PREFIX/lib/docker/cli-plugins"
mkdir -p "$DOCKER_CONFIG_DIR"
[ -s "$CONFIG_JSON" ] || echo '{}' > "$CONFIG_JSON"

tmp="$(mktemp)"
jq --arg dir "$PLUGINS_DIR" '
    .cliPluginsExtraDirs = ((.cliPluginsExtraDirs // []) + [$dir] | unique)
    | if (.credsStore // "desktop") == "desktop" then .credsStore = "osxkeychain" else . end
' "$CONFIG_JSON" > "$tmp"
if cmp -s "$tmp" "$CONFIG_JSON"; then
    rm "$tmp"
    echo "ok       $CONFIG_JSON"
else
    cp "$CONFIG_JSON" "$CONFIG_JSON.backup.$(date +%Y%m%d%H%M%S)"
    mv "$tmp" "$CONFIG_JSON"
    echo "updated  $CONFIG_JSON (plugin dir, Keychain credentials)"
fi

# Docker Desktop leaves symlinks in ~/.docker/cli-plugins pointing into
# Docker.app. They are searched before cliPluginsExtraDirs, so a dangling one
# hides the Homebrew buildx/compose. Remove only the broken ones.
if [ -d "$DOCKER_CONFIG_DIR/cli-plugins" ]; then
    for p in "$DOCKER_CONFIG_DIR/cli-plugins"/*; do
        if [ -L "$p" ] && [ ! -e "$p" ]; then
            rm "$p"
            echo "removed  $p (broken Docker Desktop link)"
        fi
    done
fi

# --- Colima -------------------------------------------------------------------
# Runs as a Homebrew service so it starts again at every login.
if colima status >/dev/null 2>&1; then
    echo "ok       colima is running"
else
    if [ ! -d "$HOME/.colima/default" ] && [ ! -d "${XDG_CONFIG_HOME:-$HOME/.config}/colima/default" ]; then
        # First run: create the VM with our settings. On Apple Silicon, Rosetta
        # makes linux/amd64 containers and buildx builds much faster.
        args=(--cpu "$COLIMA_CPUS" --memory "$COLIMA_MEMORY" --disk "$COLIMA_DISK" --vm-type vz)
        [ "$(uname -m)" = "arm64" ] && args+=(--vz-rosetta)
        echo "creating colima VM (${args[*]})"
        colima start "${args[@]}"
        colima stop   # hand it over to the service below
    fi
    brew services start colima
    echo -n "waiting  for docker"
    for _ in $(seq 60); do
        docker --context colima info >/dev/null 2>&1 && break
        echo -n "."; sleep 2
    done
    echo
fi

if ! brew services list | grep -q '^colima .*started'; then
    echo "note     colima is not a login service; run: colima stop && brew services start colima"
fi

docker context use colima >/dev/null
echo "ok       docker context: colima"

# --- Checks -------------------------------------------------------------------
docker info --format 'ok       docker engine {{.ServerVersion}} ({{.OSType}}/{{.Architecture}})'
docker buildx version | sed 's/^/ok       /'
docker compose version | sed 's/^/ok       /'
docker buildx inspect --bootstrap >/dev/null && echo "ok       buildx builder: $(docker buildx inspect | awk '/^Name:/{print $2; exit}')"
