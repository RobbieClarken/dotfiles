#!/bin/bash

os=$(uname -s | tr 'A-Z' 'a-z' | sed 's/_.*//')

case "$os" in
  linux|cygwin)
    bash_file="$HOME/.bashrc"
  ;;
  darwin)
    bash_file="$HOME/.bash_profile"
  ;;
esac

ln -sf "$HOME/.dotfiles/bash_profile" "$bash_file"
ln -sf "$HOME/.dotfiles/gitconfig" "$HOME/.gitconfig"
ln -snf "$HOME/.dotfiles/vim" "$HOME/.vim"
ln -sf "$HOME/.vim/vimrc" "$HOME/.vimrc"
vim +BundleInstall +qall
