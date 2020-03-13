export DOTFILES=~/.dotfiles

# Bash config
export LC_ALL=en_US.UTF-8
export HISTFILE=/Users/guilhermeramos/.zsh_history
export HISTSIZE=1000000
export SAVEHIST=1000000
export EDITOR=nano
export LDFLAGS=-L/usr/local/opt/openssl/lib
export CPPFLAGS=-I/usr/local/opt/openssl/include

# ZSH Config
export ZSH=~/.oh-my-zsh
ZSH_THEME="avit"
plugins=(
    git
    zsh-syntax-highlighting
    zsh-autosuggestions
    colorize
    history-substring-search
)
source $ZSH/oh-my-zsh.sh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source <(kubectl completion zsh)

# Fuzzy finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Environment varibles
export GOROOT=/usr/local/opt/go/libexec

# Path construction
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:~/.local/bin
export PATH="/usr/local/opt/gnu-getopt/bin:$PATH" # brew install gnu-getopt
export PATH="/usr/local/opt/qt/bin:$PATH" # brew install qt

# Unix translation
export FLAGS_GETOPT_CMD="$(brew --prefix gnu-getopt)/bin/getopt"

# Exa config
alias l='exa -l'
alias ls='exa -la'
alias lt='exa -l --tree -L 2'

# FASD config
alias z='fasd_cd -d'     # cd, same functionality as j in autojump
eval "$(fasd --init posix-alias zsh-hook)"

# Git alias
alias gpr='git pull --rebase'

# Kubernetes alias
alias k='kubectl'
alias ks='kubectl config get-contexts'

# Go alias
alias gogen='cd service && go generate main.go && cd ..'
alias gob='cd service && go generate main.go && cd ..'

# DLT Viewer
# TODO: Automatize the install of the dlt_viewer
export DLT_VIEWER_SRC=~/DLTViewer/dlt-viewer
alias dltviewer='open -a $DLT_VIEWER_SRC/build/bin/DLT\ Viewer.app'

# Kubernetes config
export KUBECONFIG="$(exa $HOME/.kube/config* | tr '\n' ':' | sed -e 's/:$//g')"

# NIX
source /Users/guilhermeramos/.nix-profile/etc/profile.d/nix.sh

# Swagger
viewSwagger() {
    docker run -p 80:8080 -e SWAGGER_JSON=/tmp/{file} -v $(pwd):/tmp swaggerapi/swagger-ui
}