#!/bin/bash

export DOTFILES=~/.dotfiles

ln -s $DOTFILES/config/.gitconfig ~/.gitconfig 
ln -s $DOTFILES/config/.nanorc ~/.nanorc 
ln -s $DOTFILES/config/.zshrc ~/.zshrc 