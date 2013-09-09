
# Environment variables

export EDITOR=vim

export HISTCONTROL=ignoreboth
export HISTSIZE=10000

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;36m\]\w\[\033[00m\]\$ '

unset SSH_ASKPASS

os=$(uname -s | tr 'A-Z' 'a-z' | sed 's/_.*//')
machine=$(uname -m | sed 's/i686/x86/')

case "$os" in
  linux|cygwin)
    if [ -f "${HOME}/.bashrc" ]; then
      source "${HOME}/.bashrc"
    fi
    export EPICS_BASE=/opt/epics/base
    export EPICS_HOST_ARCH="$os-$machine"
  ;;
  darwin)
    export EPICS_BASE=/Library/EPICS/Base
    export EPICS_HOST_ARCH=darwin-x86
  ;;
esac

PATH=/usr/local/sbin:/usr/sbin:/sbin:$PATH
PATH=/usr/local/bin:$PATH
PATH=/usr/local/share/python:$PATH
PATH=/usr/local/Cellar/ruby/latest/bin:$PATH
PATH=$EPICS_BASE/bin/$EPICS_HOST_ARCH:$PATH
export PATH

if [ -f ~/.dotfiles/nvm/nvm.sh ]; then
  source ~/.dotfiles/nvm/nvm.sh
fi

# Aliases and functions

alias ll='ls -l'
alias grep='grep --color'
calc() { echo "scale=3;$@" | bc; }
