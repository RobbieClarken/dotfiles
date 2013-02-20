Installation
------------

```bash
git clone https://github.com/RobbieClarken/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
git config --global core.excludesfile gitignore_global
git submodule init
git submodule update
ln -s bash_profile ~/.bash_profile
ln -s vim ~/.vim
ln -s vim/vimrc ~/.vimrc
open monokai.terminal/Monokai.terminal
```
