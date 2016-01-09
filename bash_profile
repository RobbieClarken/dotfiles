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
machine=$(uname -m | sed 's/i686/x86/')

export EPICS_BASE=/opt/epics/base
case "$os" in
  linux)
    export EPICS_HOST_ARCH="$os-$machine"

    if hash setxkbmap 2>/dev/null; then
      # Remap caps lock to ctrl
      setxkbmap -option ctrl:nocaps
    fi
  ;;
  cygwin)
    export EPICS_HOST_ARCH="$os-$machine"
  ;;
  darwin)
    export EPICS_HOST_ARCH=darwin-x86
  ;;
esac

PATH=/usr/local/sbin:/usr/sbin:/sbin:$PATH
PATH=/usr/local/bin:$PATH
PATH=$EPICS_BASE/bin/$EPICS_HOST_ARCH:$PATH
PATH=/Applications/calibre.app/Contents/MacOS:$PATH
PATH=$PATH:$HOME/Developer/bin:$HOME/.dotfiles/bin
export PATH

if [ -f ~/.nvm/nvm.sh ]; then
  source ~/.nvm/nvm.sh
fi

if [ -f /usr/local/etc/bash_completion ]; then
  source /usr/local/etc/bash_completion
fi

# Aliases and functions

alias ll='ls -l'
alias la='ll -A'
alias l='ll -h'
alias grep='grep --color'
alias redis='redis-cli'
alias venv='source .venv/bin/activate'
alias venv3='source .venv3/bin/activate'
alias cenv='python -m virtualenv .venv; venv'
alias cenv3='python3 -m virtualenv .venv3; venv3'
alias nb='tmux new-window -n jupyter "source .venv3/bin/activate; jupyter notebook"'
alias scipy='pip install jupyter numpy scipy pandas matplotlib seaborn scikit-learn'

function calc { echo "scale=3;$@" | bc; }

g() {
  if [[ $# > 0 ]]; then
    git "$@"
  else
    git status --short --branch
  fi
}

function ssh-copy-key {
  ssh "$1" "cat >> ~/.ssh/authorized_keys" < ~/.ssh/id_rsa.pub
}

function usage {
  if [[ -z "$INTERNODE_USERNAME" ]]\
     || [[ -z "$INTERNODE_PASSWORD" ]]\
     || [[ -z "$INTERNODE_SERVICE_ID" ]]
  then
    echo "INTERNODE_USERNAME, INTERNODE_PASSWORD and INTERNODE_SERVICE_ID must be set"
    return 1
  fi
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

if [ -f ~/.bash_local ]; then
  source ~/.bash_local
fi
