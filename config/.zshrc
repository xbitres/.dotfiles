export DOTFILES=~/.dotfiles

# Bash config
export LC_ALL=en_US.UTF-8
export HISTFILE=/Users/guilhermeramos/.zsh_history
export HISTSIZE=1000000
export SAVEHIST=1000000
export EDITOR=nano
export LDFLAGS=-L/usr/local/opt/openssl/lib
export CPPFLAGS=-I/usr/local/opt/openssl/include
export WORK=~/Work

# Java Config
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-14.jdk/Contents/Home/
export JDK_HOME=JAVA_HOME

# ZSH Config
export ZSH=~/.oh-my-zsh
ZSH_THEME="wezm"
plugins=(
    git
    zsh-autosuggestions
    colorize
    zsh-syntax-highlighting
)
source $ZSH/oh-my-zsh.sh
source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source <(kubectl completion zsh)

autoload -Uz compinit
compinit

# Go Setup
export GOROOT=/usr/local/opt/go/libexec
export GOPATH=$WORK/golang
export GOBIN=$GOPATH/bin
export GO111MODULE=on

# Path construction
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:~/.local/bin
export PATH="/usr/local/opt/gnu-getopt/bin:$PATH" # brew install gnu-getopt
export PATH="/usr/local/opt/make/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/gettext/bin:$PATH"
export PATH="/usr/local/opt/qt/bin:$PATH" # brew install qt
export PATH=$PATH:/usr/local/flutter/bin # FIXME(GR): Automate flutter install
export PATH="$PATH":"$HOME/.pub-cache/bin" # FIXME(GR): Automate install of grpc for dart https://grpc.io/docs/quickstart/dart/
export PATH=$PATH:$GOPATH/bin
export PATH="/usr/local/opt/mysql-client/bin:$PATH"
export PATH=$PATH:$HOME/.cargo/env

# Unix translation
export FLAGS_GETOPT_CMD="/usr/local/opt/gnu-getopt/bin/getopt"

# Exa config
alias l='exa -l'
alias ls='exa -la'
alias lt='exa -l --tree -L 2'

# FASD config (Z like commands)
alias z='fasd_cd -d'     # cd, same functionality as j in autojump
alias zz='fasd_cd -d -i'
fasd_cache="$HOME/.fasd-init-bash"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
  fasd --init posix-alias zsh-hook >| "$fasd_cache"
fi
source "$fasd_cache"
unset fasd_cache

# Fuzzy Search setup
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Git alias
alias gpr='git pull --rebase'

# Kubernetes alias
alias k='kubectl'
alias ks='kubectl config get-contexts'

# Kubernetes config
export KUBECONFIG="$(exa $HOME/.kube/config* | tr '\n' ':' | sed -e 's/:$//g')"

# Swagger
viewSwagger() {
    docker run -p 80:8080 -e SWAGGER_JSON=/tmp/{file} -v $(pwd):/tmp swaggerapi/swagger-ui
}

# Load zsh plugin last
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

alias excalidraw='cd ~/.dotfiles/excalidraw && yarn && yarn start'
