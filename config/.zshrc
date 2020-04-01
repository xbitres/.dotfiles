export DOTFILES=~/.dotfiles

# Bash config
export LC_ALL=en_US.UTF-8
export HISTFILE=/Users/guilhermeramos/.zsh_history
export HISTSIZE=1000000
export SAVEHIST=1000000
export EDITOR=nano
export LDFLAGS=-L/usr/local/opt/openssl/lib
export CPPFLAGS=-I/usr/local/opt/openssl/include

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
    history-substring-search
    zsh-syntax-highlighting
)
source $ZSH/oh-my-zsh.sh
source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh
source <(kubectl completion zsh)

# Environment varibles
export GOROOT=/usr/local/opt/go/libexec
export GOPATH=$HOME/golang

# Path construction
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:~/.local/bin
export PATH="/usr/local/opt/gnu-getopt/bin:$PATH" # brew install gnu-getopt
export PATH="/usr/local/opt/qt/bin:$PATH" # brew install qt
export PATH=$PATH:/usr/local/flutter/bin # FIXME(GR): Automate flutter install
export PATH=$PATH:$GOPATH/bin

# Unix translation
export FLAGS_GETOPT_CMD="/usr/local/opt/gnu-getopt/bin/getopt"

# Exa config
alias l='exa -l'
alias ls='exa -la'
alias lt='exa -l --tree -L 2'

# FASD config
alias z='fasd_cd -d'     # cd, same functionality as j in autojump
fasd_cache="$HOME/.fasd-init-bash"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
  fasd --init posix-alias zsh-hook >| "$fasd_cache"
fi
source "$fasd_cache"
unset fasd_cache

# Git alias
alias gpr='git pull --rebase'

# Kubernetes alias
alias k='kubectl'
alias ks='kubectl config get-contexts'

# Kubernetes config
export KUBECONFIG="$(exa $HOME/.kube/config* | tr '\n' ':' | sed -e 's/:$//g')"

# NIX
source /Users/guilhermeramos/.nix-profile/etc/profile.d/nix.sh

# Swagger
viewSwagger() {
    docker run -p 80:8080 -e SWAGGER_JSON=/tmp/{file} -v $(pwd):/tmp swaggerapi/swagger-ui
}

# Load zsh plugin last
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Deprecated
# This is the deprecated zone of programs that are no longer used

# DLT Viewer
export DLT_VIEWER_SRC=/usr/local/dlt-viewer
alias dltviewer='open -a $DLT_VIEWER_SRC/build/bin/DLT\ Viewer.app'