
# Environment variables

export EDITOR=vim

export HISTCONTROL=ignoreboth
export HISTSIZE=10000
export HISTFILESIZE=10000

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;36m\]\w\[\033[00m\]\n\$ '

unset SSH_ASKPASS

os=$(uname -s | tr 'A-Z' 'a-z' | sed 's/_.*//')
machine=$(uname -m | sed 's/i686/x86/')

case "$os" in
  linux|cygwin)
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
PATH=$EPICS_BASE/bin/$EPICS_HOST_ARCH:$PATH
export PATH

if [ -f ~/.bash_local ]; then
  source ~/.bash_local
fi

if [ -f ~/.dotfiles/nvm/nvm.sh ]; then
  source ~/.dotfiles/nvm/nvm.sh
fi

# Aliases and functions

alias ll='ls -l'
alias grep='grep --color'
alias venv='source venv/bin/activate'

function calc { echo "scale=3;$@" | bc; }

function usage {
  # The following constants must be defined:
  # INTERNODE_SERVICE_ID
  # INTERNODE_USERNAME
  # INTERNODE_PASSWORD
  bytes_per_GB=1073741824
  seconds_per_day=86400
  url="https://customer-webtools-api.internode.on.net/api/v1.5/$INTERNODE_SERVICE_ID/usage"
  xml=$(curl -s -u "$INTERNODE_USERNAME:$INTERNODE_PASSWORD" $url | tr -d '\n')
  quota=$(echo "$xml" | sed -E 's/.*quota="([0-9]*)".*/\1/')
  traffic=$(echo "$xml" | sed -E 's/.*>([0-9]*)<\/traffic>.*/\1/')
  remaining=$(calc "$quota-$traffic")
  remaining_GB=$(calc $remaining/$bytes_per_GB)
  rollover=$(echo "$xml" | sed -E 's/.*rollover="([0-9\-]*)".*/\1/')
  rollover_s=$(date -j -f '%Y-%m-%d %H:%M:%S' "$rollover 00:00:00" '+%s')
  now_s=$(date '+%s')
  days=$(calc "($rollover_s-$now_s)/$seconds_per_day")
  echo "Used: $(calc 100*$traffic/$quota)%"
  echo "Remaining: $remaining_GB GB ($(calc $remaining_GB/$days) GB/day)"
  echo "Rollover: $rollover ($days days)"
}
