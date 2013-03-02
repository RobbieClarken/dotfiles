alias ll='ls -l'
alias grep='grep --color'
alias ipython='ipython --pylab'

export HISTCONTROL=ignoreboth
export HISTSIZE=10000

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

export EPICS_BASE=/Library/EPICS/Base
export EPICS_HOST_ARCH=darwin-x86

unset SSH_ASKPASS

PATH=/usr/local/share/python:$PATH
PATH=$EPICS_BASE/bin/$EPICS_HOST_ARCH:$PATH
export PATH=$PATH
