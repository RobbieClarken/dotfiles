# Environment variables

export EDITOR=vim

export HISTCONTROL=ignoreboth
export HISTSIZE=100000
export HISTFILESIZE=100000

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
    alias pbcopy='xsel -bi'
    alias pbpaste='xsel -bo'
  ;;
  darwin)
    export EPICS_HOST_ARCH=darwin-x86
  ;;
esac

export GOPATH="$HOME/Developer/Go"

PATH="/usr/local/bin:/usr/local/sbin:/usr/sbin:/sbin:$PATH"
PATH="$EPICS_BASE/bin/$EPICS_HOST_ARCH:$PATH"
PATH="$HOME/Developer/bin:$PATH"
PATH="$HOME/.dotfiles/bin:$PATH"
PATH=".git/safe/../../bin:$PATH"
PATH="$PATH:/opt/miniconda/bin"
PATH="$GOPATH/bin:$PATH"
PATH="$PATH:/Library/TeX/Distributions/.DefaultTeX/Contents/Programs/x86_64"
PATH="$HOME/.local/bin:$PATH"
PATH="$HOME/.cargo/bin:$PATH"
export PATH

if [ -f ~/.nvm/nvm.sh ]; then
  source ~/.nvm/nvm.sh
fi

if [ -f /usr/local/etc/bash_completion ]; then
  source /usr/local/etc/bash_completion
fi

# Aliases and functions

alias ll='ls -lG'
alias l='ll -h'
alias la='ll -a'
alias grep='grep --color'
alias rgf='rg --files -g'
alias gr=rg
alias gri='rg -i'

alias venv='source .venv/bin/activate'
alias cenv='python3 -m venv .venv && venv && python -m pip install -U pip'
alias ccut='cookiecutter gh:RobbieClarken/cookiecutter-python-min'

alias dc='cd'
alias oepn='open'
alias vmi='vim'

alias r='pipenv run'
alias rp='pipenv run python'

calc () { echo "scale=3;$@" | bc; }

g () {
  if [[ $# > 0 ]]; then
    git "$@"
  else
    git status --short --branch
  fi
}

ssh-copy-key () {
  ssh "$@" "cat >> ~/.ssh/authorized_keys" < ~/.ssh/id_rsa.pub
}

f8 () {
  files=$(flake8 -q)
  if [ "$files" ]; then vim $files; fi
}

if [ -f ~/.bash_local ]; then
  source ~/.bash_local
fi

alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"

if [ -f ~/.fzf.bash ]; then

  source ~/.fzf.bash

  export FZF_DEFAULT_COMMAND='fd --type f --hidden'
  export FZF_CTRL_T_COMMAND='fd --hidden'
  export FZF_DEFAULT_COMMAND='fd --type f --hidden'
  export FZF_CTRL_T_COMMAND='fd --hidden'
  export FZF_ALT_C_COMMAND='fd --type d'
  bind -x '"\C-x\C-t": fzf-file-widget'
  bind '"\C-t": transpose-chars'

  _fzf_compgen_path() {
    fd --hidden --follow . "$1"
  }

  _fzf_compgen_dir() {
    fd --type d --hidden --follow . "$1"
  }

fi

# Enable ctrl-s and ctrl-q
stty -ixon -ixoff
