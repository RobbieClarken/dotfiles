#!/bin/bash

keep_git_user="$1"
if [[ -z "$keep_git_user" ]]
then
  read -p "Keep git user settings for Robbie Clarken (y/n)? "
  keep_git_user="$REPLY"
fi

os=$(uname -s | tr 'A-Z' 'a-z' | sed 's/_.*//')
case "$os" in
  linux|cygwin)
    bash_file="$HOME/.bashrc"
  ;;
  darwin)
    bash_file="$HOME/.bash_profile"
  ;;
  *)
    echo "Unrecognized operating system."
    exit 1
  ;;
esac

ln -sf "$HOME/.dotfiles/bash_profile" "$bash_file"
ln -sf "$HOME/.dotfiles/git/gitconfig" "$HOME/.gitconfig"
if [[ "$keep_git_user" != "y" ]]
then
  git config --global --remove-section user
fi
if [[ -e "$HOME/.vim" ]]
then
  rm -rf "$HOME/.vim"
fi
ln -snf "$HOME/.dotfiles/git-prompt-colors.sh" "$HOME/.git-prompt-colors.sh"
ln -snf "$HOME/.dotfiles/tmux" "$HOME/.tmux"
ln -snf "$HOME/.tmux/tmux.conf" "$HOME/.tmux.conf"
ln -snf "$HOME/.dotfiles/vim" "$HOME/.vim"
ln -sf "$HOME/.vim/vimrc" "$HOME/.vimrc"
vim +PluginInstall +qall
