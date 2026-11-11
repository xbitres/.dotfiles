export DOTFILES=~/.dotfiles

# --- Homebrew ---------------------------------------------------------------
# Sets HOMEBREW_PREFIX and puts brew on PATH (Apple Silicon, then Intel).
for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  [ -x "$brew_bin" ] && eval "$("$brew_bin" shellenv)" && break
done
unset brew_bin

# --- Environment ------------------------------------------------------------
export LC_ALL=en_US.UTF-8
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=100000000
export SAVEHIST=100000000
export EDITOR=nano
export WORK=~/Work

# Go (installed via Homebrew; GOROOT is detected automatically)
export GOPATH=$WORK/golang
export GOBIN=$GOPATH/bin

# --- PATH -------------------------------------------------------------------
export PATH="$HOMEBREW_PREFIX/opt/gnu-getopt/bin:$PATH"       # GNU getopt instead of BSD
export PATH="$HOMEBREW_PREFIX/opt/make/libexec/gnubin:$PATH"  # GNU make as `make`
export PATH="$HOMEBREW_PREFIX/opt/libpq/bin:$PATH"            # psql (keg-only)
export PATH="$HOMEBREW_PREFIX/opt/mysql-client/bin:$PATH"     # mysql (keg-only)
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:$DOTFILES/scripts/proto"                   # base64urldecode.go, used by protod
export PATH="$PATH:$GOBIN"
export PATH="$PATH:$HOME/.pub-cache/bin" # FIXME(GR): Automate install of grpc for dart https://grpc.io/docs/quickstart/dart/

export FLAGS_GETOPT_CMD="$HOMEBREW_PREFIX/opt/gnu-getopt/bin/getopt"

# --- Oh My Zsh --------------------------------------------------------------
# Homebrew-installed completions must be on FPATH before oh-my-zsh runs compinit.
FPATH="$HOMEBREW_PREFIX/share/zsh/site-functions:$FPATH"

export ZSH=~/.oh-my-zsh
ZSH_THEME="simple"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# --- Tools and completions --------------------------------------------------
source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
# source "$HOMEBREW_PREFIX/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
command -v kubectl >/dev/null && source <(kubectl completion zsh)
command -v fzf >/dev/null && source <(fzf --zsh)
command -v direnv >/dev/null && eval "$(direnv hook zsh)"

# NVM (Homebrew)
export NVM_DIR="$HOME/.nvm"
[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && . "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && . "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"

# Google Cloud SDK (gcloud-cli cask): PATH and shell completion
GCLOUD_SDK="$HOMEBREW_PREFIX/share/google-cloud-sdk"
[ -f "$GCLOUD_SDK/path.zsh.inc" ] && . "$GCLOUD_SDK/path.zsh.inc"
[ -f "$GCLOUD_SDK/completion.zsh.inc" ] && . "$GCLOUD_SDK/completion.zsh.inc"
unset GCLOUD_SDK

# zoxide (z-like directory jumping): `z foo` jumps, `zi foo` picks interactively with fzf
if command -v zoxide >/dev/null; then
  eval "$(zoxide init zsh)"
  alias zz='zi'
fi

# --- Kubernetes -------------------------------------------------------------
# Merge every ~/.kube/config* file into KUBECONFIG.
kubeconfigs=($HOME/.kube/config*(N))
(( ${#kubeconfigs} )) && export KUBECONFIG="${(j.:.)kubeconfigs}"
unset kubeconfigs

alias k='kubectl'
alias ks='kubectl config get-contexts'

# --- Aliases and functions --------------------------------------------------
alias l='eza -l'
alias ls='eza -la'
alias lt='eza -l --tree -L 2'

alias gpr='git pull --rebase'

source "$DOTFILES/scripts/k8s/kpf.sh"         # kpf <service> <ports> <context> <namespace>
source "$DOTFILES/scripts/proto/functions.sh" # protod, textformat2json

# Serve an OpenAPI/Swagger file with Swagger UI on http://localhost:80
viewSwagger() {
  local file="${1:?usage: viewSwagger <openapi.json|yaml>}"
  docker run --rm -p 80:8080 \
    -e SWAGGER_JSON="/tmp/$(basename "$file")" \
    -v "$(cd "$(dirname "$file")" && pwd)":/tmp \
    swaggerapi/swagger-ui
}

# --- Must stay last -----------------------------------------------------------
# zsh-syntax-highlighting must be sourced after all other widgets.
source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Machine-local config, not tracked in git. Loaded last so it can override
# anything above. Template: $DOTFILES/config/.zshrc.local.example
if [ -f "$HOME/.zshrc.local" ]; then source "$HOME/.zshrc.local"; fi
