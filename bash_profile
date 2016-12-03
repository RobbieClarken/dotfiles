# Environment variables

export EDITOR=vim

export HISTCONTROL=ignoreboth
export HISTSIZE=10000
export HISTFILESIZE=10000

export TERM=xterm-256color # Needed for tmux on linux
export CLICOLOR=1

GIT_PROMPT_THEME=Custom
source "$HOME/.dotfiles/bash-git-prompt/gitprompt.sh"

unset SSH_ASKPASS

os=$(uname -s | tr 'A-Z' 'a-z' | sed 's/_.*//')

export EPICS_BASE=/opt/epics/base
case "$os" in
  linux)
    machine=$(uname -m | sed 's/i686/x86/')
    export EPICS_HOST_ARCH="$os-$machine"

    if hash setxkbmap 2>/dev/null; then
      # Remap caps lock to ctrl
      setxkbmap -option ctrl:nocaps
    fi
  ;;
  darwin)
    export EPICS_HOST_ARCH=darwin-x86
  ;;
esac

PATH="/usr/local/bin:/usr/local/sbin:/usr/sbin:/sbin:$PATH"
PATH="$EPICS_BASE/bin/$EPICS_HOST_ARCH:$PATH"
PATH="$HOME/Developer/bin:$PATH"
PATH="$HOME/.dotfiles/bin:$PATH"
PATH=".git/safe/../../bin:$PATH"
export PATH

if [ -f ~/.nvm/nvm.sh ]; then
  source ~/.nvm/nvm.sh
fi

if [ -f /usr/local/etc/bash_completion ]; then
  source /usr/local/etc/bash_completion
fi

# Aliases and functions

alias ll='ls -laG'
alias l='ll -h'
alias grep='grep --color'
alias venv='source .venv/bin/activate'
alias venv3='source .venv3/bin/activate'
alias cenv='python -m virtualenv .venv; venv'
alias cenv3='python3 -m venv .venv3; venv3; python -m pip install -U pip'
alias ccut='cookiecutter gh:RobbieClarken/cookiecutter-python-min'

alias dc='cd'
alias oepn='open'
alias vmi='vim'

calc () { echo "scale=3;$@" | bc; }

g () {
  if [[ $# > 0 ]]; then
    git "$@"
  else
    git status --short --branch
  fi
}

ssh-copy-key () {
  ssh "$1" "cat >> ~/.ssh/authorized_keys" < ~/.ssh/id_rsa.pub
}

f8 () {
  files=$(flake8 -q)
  if [ "$files" ]; then vim $files; fi
}

if [ -f ~/.bash_local ]; then
  source ~/.bash_local
fi
