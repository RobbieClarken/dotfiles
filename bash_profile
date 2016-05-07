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

PATH="/usr/local/bin:/usr/local/sbin:/usr/sbin:/sbin:$PATH"
PATH="$EPICS_BASE/bin/$EPICS_HOST_ARCH:$PATH"
PATH="/Applications/calibre.app/Contents/MacOS:$PATH"
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

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if hash pyenv 2>/dev/null; then
  eval "$(pyenv init -)"
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
alias cenv3='python3 -m venv .venv3; venv3; python -m pip install -U pip'
alias nb='tmux new-window -n jupyter "source .venv3/bin/activate; jupyter notebook"'
alias scipy='pip install jupyter numpy scipy pandas matplotlib seaborn scikit-learn'

alias dc='cd'
alias oepn='open'
alias vmi='vim'

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

if [ -f ~/.bash_local ]; then
  source ~/.bash_local
fi

