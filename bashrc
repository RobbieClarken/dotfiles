# Enable ctrl-s and ctrl-q
stty -ixon -ixoff

GIT_PROMPT_THEME=Custom
# shellcheck source=.dotfiles/bash-git-prompt/gitprompt.sh
source ~/.dotfiles/bash-git-prompt/gitprompt.sh

if [ -f /usr/local/etc/bash_completion ]; then
  source /usr/local/etc/bash_completion
fi

if [[ -f ~/.fzf.bash ]]; then

  # shellcheck source=.fzf.bash
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
alias gri='rg -i'

alias ccut='cookiecutter gh:RobbieClarken/cookiecutter-python-min'

alias dc='cd'
alias oepn='open'
alias vmi='vim'

alias r='pipenv run'
alias rp='pipenv run python'

case "$(uname)" in
  Darwin*)
    alias chrome="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
    ;;
  Linux*)
    alias pbcopy='xsel -bi'
    alias pbpaste='xsel -bo'
    ;;
esac


g () {
  if (( $# > 0 )); then
    git "$@"
  else
    git status --short --branch
  fi
}

tm () {
  # if user leaves tmux by exiting bash automatically reattach to next session
  while tmux attach | { read -r msg; [[ $msg == *exited* ]]; }; do :; done
}

pipvenv () {
  PIPENV_VENV_IN_PROJECT=1 pipenv "$@"
}

f8 () {
  mapfile -t files < <(flake8 -q)
  if (( ${#files[@]} > 0 )); then vim "${files[@]}"; fi
}

if hash __git_wrap__git_main 2>/dev/null; then
  complete -o bashdefault -o default -o nospace -F __git_wrap__git_main g
fi

if hash _docker 2>/dev/null; then
  complete -F _docker d
fi

if [ -f ~/.bashrc.local ]; then
  # shellcheck source=.bashrc.local
  source ~/.bashrc.local
fi
