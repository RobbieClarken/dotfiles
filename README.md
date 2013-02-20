Installation
------------

```bash
git clone https://github.com/RobbieClarken/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
git submodule init
git submodule update
# Follow instructions in vim/README.md
ln -s ~/.dotfiles/bash_profile ~/.bash_profile
git config --global core.excludesfile ~/.dotfiles/gitignore_global
open monokai.terminal/Monokai.terminal
```
