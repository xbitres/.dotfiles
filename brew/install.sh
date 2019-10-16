#!/bin/bash

# Install brew
cd ~
which -s brew
if [[ $? != 0 ]] ; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    brew update
fi

# Install dependencies
brew install autoconf
brew install automake
brew install azure-cli
brew install base64
brew install bash-completion
brew install c-ares
brew install cmake
brew install composer
brew install coreutils
brew install exa
brew install fasd
brew install gdbm
brew install gettext
brew install gflags
brew install ghc
brew install git-crypt
brew install gnu-getopt
brew install gnu-sed
brew install gnu-tar
brew install go
brew install alecthomas/tap/gometalinter
brew install grpc
brew install haskell-stack
brew install jq
brew install derailed/k9s/k9s
brew install kubernetes-cli
brew install libevent
brew install libogg
brew install libvorbis
brew install moreutils
brew install nano
brew install ncurses
brew install oniguruma
brew install openal-soft
brew install openssl
brew install openssl@1.1
brew install p7zip
brew install pcre
brew install pkg-config
brew install protobuf
brew install python
brew install python@2
brew install qt
brew install readline
brew install sqlite
brew install terraform
brew install tmux
brew install vsts-cli
brew install watch
brew install xz
brew install yq
brew install zsh
brew install zsh-completions

brew cask install docker
brew cask install iterm2

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
