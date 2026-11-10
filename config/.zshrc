export DOTFILES=~/.dotfiles

# Bash config
export LC_ALL=en_US.UTF-8
export HISTFILE=/Users/guilherme.lousada.ramos/.zsh_history
export HISTSIZE=100000000
export SAVEHIST=100000000
export EDITOR=nano
export LDFLAGS=-L/usr/local/opt/openssl/lib
export CPPFLAGS=-I/usr/local/opt/openssl/include
export WORK=~/Work

# ZSH Config
export ZSH=~/.oh-my-zsh
ZSH_THEME="simple"
plugins=(
  git
  # z
)

# export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/opt/homebrew/share/zsh-syntax-highlighting/highlighters
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# source /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source $ZSH/oh-my-zsh.sh
source <(kubectl completion zsh)
source <(fzf --zsh)

autoload -Uz compinit
compinit

# Go Setup
export GOPATH=$WORK/golang
export GOBIN=$GOPATH/bin
export GO111MODULE=on

# NVM Config
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# Path construction
export PATH="/opt/homebrew/opt/gnu-getopt/bin":$PATH      # brew install gnu-getopt
export PATH="/opt/homebrew/opt/make/libexec/gnubin":$PATH # brew install make
export PATH="/usr/local/opt/qt/bin":$PATH                 # brew install qt
export PATH=/opt/homebrew/bin:$PATH
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:$DOTFILES/.installs/bin
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:"$HOME/.pub-cache/bin" # FIXME(GR): Automate install of grpc for dart https://grpc.io/docs/quickstart/dart/
export PATH=$PATH:"/usr/local/opt/mysql-client/bin"

# Unix translation
export FLAGS_GETOPT_CMD="/usr/local/opt/gnu-getopt/bin/getopt"

# eza config
alias l='eza -l'
alias ls='eza -la'
alias lt='eza -l --tree -L 2'

# FASD config (Z like commands)
alias z='fasd_cd -d' # cd, same functionality as j in autojump
alias zz='fasd_cd -d -i'
fasd_cache="$HOME/.fasd-init-bash"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
  fasd --init posix-alias zsh-hook >|"$fasd_cache"
fi
source "$fasd_cache"
unset fasd_cache

# Git alias
alias gpr='git pull --rebase'

# Kubernetes alias
alias k='kubectl'
alias ks='kubectl config get-contexts'

# Kubernetes config
export KUBECONFIG="$(eza $HOME/.kube/config* | tr '\n' ':' | sed -e 's/:$//g')"

# Swagger
viewSwagger() {
  docker run -p 80:8080 -e SWAGGER_JSON=/tmp/{file} -v $(pwd):/tmp swaggerapi/swagger-ui
}

alias excalidraw='cd ~/.dotfiles/excalidraw && yarn && yarn start'

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f /Users/guilherme.lousada.ramos/.dart-cli-completion/zsh-config.zsh ]] && . /Users/guilherme.lousada.ramos/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# >>> dscore-cli section >>>
# Here we include the environment changes made by the dscore-cli tool.
#
# To disable (almost) all changes made by dscore-cli tool, comment out or
# remove the line below.
#
# Note: The changes made using package managers that existed in the system
#       before `dscore init` was run cannot be disabled.

source "/Users/guilherme.lousada.ramos/.dscore/.profile"

# <<< End of dscore-cli section >>>
export PATH="$HOME/.local/bin:$PATH"

eval "$(ssh-agent -s)"
eval "$(direnv hook zsh)"

# Google Cloud SDK (gcloud-cli cask): PATH and shell completion
GCLOUD_SDK="${HOMEBREW_PREFIX:-/opt/homebrew}/share/google-cloud-sdk"
[ -f "$GCLOUD_SDK/path.zsh.inc" ] && . "$GCLOUD_SDK/path.zsh.inc"
[ -f "$GCLOUD_SDK/completion.zsh.inc" ] && . "$GCLOUD_SDK/completion.zsh.inc"
unset GCLOUD_SDK
