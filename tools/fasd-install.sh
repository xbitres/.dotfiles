#!/bin/sh
git clone https://github.com/whjvenyl/fasd.git .download/fasd

mkdir -p .installs/fasd
(cd $DOTFILES/.download/fasd && PREFIX=$DOTFILES/.installs/fasd make install)
mv $DOTFILES/.installs/fasd/bin/fasd $DOTFILES/.installs/bin/fasd 

eval "$(fasd --init auto)"