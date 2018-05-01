# Enable ctrl-s and ctrl-q
stty -ixon -ixoff

GIT_PROMPT_THEME=Custom
source "$HOME/.dotfiles/bash-git-prompt/gitprompt.sh"

if [ -f /usr/local/etc/bash_completion ]; then
  source /usr/local/etc/bash_completion
fi

# nvm is slow to initialise so we defer doing so until it is needed
# https://github.com/creationix/nvm/issues/1277#issuecomment-356309457
if [ -s "$HOME/.nvm/nvm.sh" ] && [ ! "$(type -t __init_nvm)" = function ]; then
  export NVM_DIR="$HOME/.nvm"
  declare -a __node_commands=(nvm node npm npx yarn gulp grunt webpack)
  __init_nvm () {
    for cmd in "${__node_commands[@]}"; do unalias $cmd; done
    source "$NVM_DIR"/nvm.sh
    [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
    unset __node_commands
    unset -f __init_nvm
  }
  for cmd in "${__node_commands[@]}"; do alias $cmd='__init_nvm && '$cmd; done
fi

if [ -f ~/.fzf.bash ]; then

  source ~/.fzf.bash

  export FZF_DEFAULT_COMMAND='fd --type f --hidden'
  export FZF_CTRL_T_COMMAND='fd --hidden'
  export FZF_ALT_C_COMMAND='fd --type d'
  bind -x '"\C-q": fzf-file-widget'
  bind '"\C-t": transpose-chars'

  _fzf_compgen_path() {
    fd --hidden --follow . "$1"
  }

  _fzf_compgen_dir() {
    fd --type d --hidden --follow . "$1"
  }

fi

# Aliases and functions

alias ll='ls -lG --color=auto --group-directories-first'
alias l='ll -h'
alias la='ll -a'
alias grep='grep --color=auto'
alias gr=rg
alias gri='rg -i'

alias ccut='cookiecutter gh:RobbieClarken/cookiecutter-python-min'

alias dc='cd'
alias oepn='open'
alias vmi='vim'

alias r='pipenv run'
alias rp='pipenv run python'

case "$(uname)" in
  Darwin*)
    alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
    ;;
  Linux*)
    alias pbcopy='xsel -bi'
    alias pbpaste='xsel -bo'
    ;;
esac


calc () { echo "scale=3;$@" | bc; }

g () {
  if [[ $# > 0 ]]; then
    git "$@"
  else
    git status --short --branch
  fi
}

f8 () {
  files=$(flake8 -q)
  if [ "$files" ]; then vim $files; fi
}

if hash __git_wrap__git_main 2>/dev/null; then
  complete -o bashdefault -o default -o nospace -F __git_wrap__git_main g
fi

if hash _docker 2>/dev/null; then
  complete -F _docker d
fi

if [ -f ~/.bashrc.local ]; then
  source ~/.bashrc.local
fi
