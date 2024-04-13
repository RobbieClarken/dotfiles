if shopt -q login_shell; then
  # Enable ctrl-s and ctrl-q
  stty -ixon -ixoff
fi

BASE16_SHELL=$HOME/.config/base16-shell/
# shellcheck source=/dev/null
[ -n "$PS1" ] \
  && [ -s "$BASE16_SHELL/profile_helper.sh" ] \
  && source "$BASE16_SHELL/profile_helper.sh"

# shellcheck disable=SC2034
GIT_PROMPT_THEME=Custom
# shellcheck source=/dev/null
. ~/.dotfiles/bash-git-prompt/gitprompt.sh

if [ -f "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]; then
  # shellcheck source=/dev/null
  . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
fi

if command -v zoxide >/dev/null; then
  eval "$(zoxide init bash)"
fi

if [ -f ~/.opam/opam-init/init.sh ]; then
  # shellcheck source=/dev/null
  . ~/.opam/opam-init/init.sh
fi

if [ -f ~/.ghcup/env ]; then
  # shellcheck source=/dev/null
  . ~/.ghcup/env
fi

if [[ -f ~/.fzf.bash ]]; then

  # shellcheck source=/dev/null
  . ~/.fzf.bash

  export FZF_DEFAULT_COMMAND='fd --type f --hidden'
  export FZF_CTRL_T_COMMAND='fd --hidden'
  export FZF_ALT_C_COMMAND='fd --type d --exclude Library'
  bind -x '"\C-q": fzf-file-widget'
  bind '"\C-t": transpose-chars'

  _fzf_compgen_path() {
    fd --hidden --follow . "$1"
  }

  _fzf_compgen_dir() {
    fd --type d --hidden --follow . "$1"
  }

fi

# enable gpg to prompt for password
GPG_TTY=$(tty)
export GPG_TTY

# Aliases and functions

alias ll='ls -lG --color=auto --group-directories-first'
alias l='ll -h'
alias la='ll -a'
alias lr='ls -lG --color=auto -rt'
alias grep='grep --color=auto'
alias gri='rg -i'
alias tmp='pushd "$(mktemp -d)"'
alias pytmp='pushd "$(mktemp -d)" && python3 -m venv .venv && source .venv/bin/activate'
alias ungron='gron --ungron'

alias ccut='cookiecutter gh:RobbieClarken/cookiecutter-python-min'

alias dc='cd'
alias oepn='open'
alias vmi='vim'

pwdc () {
  if (( $# > 0 )); then
    the_path=$PWD/$1
  else
    the_path=$PWD
  fi
  echo "$the_path"
  echo -n "$the_path" | pbcopy
}

alias kx=kubectx
alias kns=kubens
alias knss='kubens kube-system'
alias knsd='kubens default'
alias ktail=kubetail
alias kga='kubectl get --all-namespaces daemonset,ingress,all'

kgaa () {
  local -r resource_types=(
    apiservices
    certificatesigningrequests
    clusterrolebindings
    clusterroles
    configmaps
    controllerrevisions
    cronjobs
    customresourcedefinition
    daemonsets
    deployments
    endpoints
    horizontalpodautoscalers
    ingresses
    jobs
    limitranges
    namespaces
    networkpolicies
    nodes
    persistentvolumeclaims
    persistentvolumes
    poddisruptionbudget
    pods
    podsecuritypolicies
    podtemplates
    replicasets
    replicationcontrollers
    resourcequotas
    rolebindings
    roles
    secrets
    serviceaccounts
    services
    statefulsets
    storageclasses
  )
  kubectl get --all-namespaces "$(echo "${resource_types[*]}" | tr ' ' ,)" "$@"
}

case "$(uname)" in
  Darwin*)
    alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'
    ;;
  Linux*)
    alias pbcopy='xsel -bi'
    alias pbpaste='xsel -bo'
    ;;
esac


g () {
  if (( $# == 1 )) && [[ $1 == "pull" ]]; then
    # Prevent conflict with bash-git-prompt resulting in the error:
    # "fatal: Cannot rebase onto multiple branches"
    sh -c 'git pull'
  elif (( $# > 0 )); then
    git "$@"
  else
    git status --short --branch
  fi
}

k () {
  if (( $# > 0 )); then
    kubectl "$@"
  else
    kubectl get daemonset,ingress,all
  fi
}

tm () {
  tmux "$@"
  # if user leaves tmux by exiting bash automatically reattach to next session
  while tmux attach | { read -r msg; [[ $msg == *exited* ]]; }; do :; done
}

tox () {
  # require confirmation before recreating a tox environment to avoid accidentally doing
  # so when recalling commands from history
  if [[ -n ${VIRTUAL_ENV:-} ]]; then
    echo "virtual env detected: aborting."
    return 1
  fi
  if [[ $* =~ (^| )-[a-zA-Z]*r ]]; then
    read -rp 'tox env will be recreated. Hit enter to continue or ctrl-c to cancel. '
  fi
  $(type -fp tox) "$@"
}

pipf () {
  PIP_REQUIRE_VIRTUALENV=0 pip "$@"
}

pipvenv () {
  PIPENV_VENV_IN_PROJECT=1 pipenv "$@"
}

f8 () {
  mapfile -t files < <(flake8 -q)
  if (( ${#files[@]} > 0 )); then vim "${files[@]}"; fi
}

mkcd () {
  mkdir -p "$1"
  # shellcheck disable=SC2164
  cd "$1"
}

cm () {
  git add --all
  git status
  git commit -m "$*"
}

cmi () {
  cm "Initial commit"
}

vwhich () { vim "$(command -v "$@")"; }
complete -c vwhich

token () {
  bytes=${1:-8}
  python3 -c "import secrets; print(secrets.token_hex($bytes))"
}

if hash __git_wrap__git_main 2>/dev/null; then
  complete -o bashdefault -o default -o nospace -F __git_wrap__git_main g
fi

if hash _rg 2>/dev/null; then
  complete -o bashdefault -o default -F _rg gr
fi

if hash _docker 2>/dev/null; then
  complete -F _docker d
fi

if hash __start_kubectl 2>/dev/null; then
  complete -o default -F __start_kubectl k
fi

if hash _kube_contexts 2>/dev/null; then
  complete -F _kube_contexts kx
fi

if hash _kubetail 2>/dev/null; then
  complete -F _kubetail ktail
fi

if [ -f ~/.bashrc.local ]; then
  # shellcheck source=/dev/null
  . ~/.bashrc.local
fi
