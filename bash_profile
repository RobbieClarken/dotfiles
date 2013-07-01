alias ll='ls -l'
alias grep='grep --color'
alias ipython='ipython --pylab'

export EDITOR=vim

export HISTCONTROL=ignoreboth
export HISTSIZE=10000

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

os=$(uname -s | tr 'A-Z' 'a-z')
machine=$(uname -m)

case "$os" in
  linux)

    if [ -f "${HOME}/.bashrc" ] ; then
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

unset SSH_ASKPASS

PATH=/usr/local/sbin:/usr/sbin:/sbin:$PATH
PATH=/usr/local/bin:$PATH
PATH=/usr/local/share/python:$PATH
PATH=$EPICS_BASE/bin/$EPICS_HOST_ARCH:$PATH
export PATH

. ~/.dotfiles/nvm/nvm.sh
