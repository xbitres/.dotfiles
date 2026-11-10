#!/bin/bash
set -e

if [ -d "${ZSH:-$HOME/.oh-my-zsh}" ]; then
    echo "oh-my-zsh already installed, skipping"
    exit 0
fi

# --unattended: don't switch shell or start zsh (would block install.sh)
# --keep-zshrc: don't replace ~/.zshrc (link.sh manages it)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
