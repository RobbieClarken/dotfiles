export EDITOR=vim

export HISTCONTROL=ignoreboth
export HISTSIZE=100000
export HISTFILESIZE=100000

unset SSH_ASKPASS

export CLICOLOR=1

BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] \
  && [ -s "$BASE16_SHELL/profile_helper.sh" ] \
  && eval "$("$BASE16_SHELL/profile_helper.sh")"

export GOPATH=$HOME/Developer/Go
export N_PREFIX=$HOME/.local/n

PATH=/usr/local/bin:/usr/local/sbin:/usr/sbin:/sbin:$PATH
PATH=$HOME/Developer/bin:$PATH
PATH=$HOME/.dotfiles/bin:$PATH
PATH=.git/safe/../../bin:$PATH
PATH=$GOPATH/bin:$PATH
PATH=$N_PREFIX/bin:$PATH
PATH=/Library/TeX/Distributions/.DefaultTeX/Contents/Programs/x86_64:$PATH
PATH=$HOME/.local/bin:$PATH
PATH=$HOME/.cargo/bin:$PATH
PATH=$HOME/.poetry/bin:$PATH
PATH=/opt/squashfuse/bin:$PATH
PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH
export PATH

MANPATH=/usr/local/share/man:$MANPATH
MANPATH=/opt/squashfuse/share/man:$MANPATH
MANPATH=/opt/tmux/share/man:$MANPATH
MANPATH=/usr/local/opt/coreutils/libexec/gnuman:$MANPATH
export MANPATH

# Run pipenv shell in fancy mode so we get the right version of bash
export PIPENV_SHELL_FANCY=1

if [[ $(uname) == "Linux" ]] && hash setxkbmap 2>/dev/null; then
  # Remap caps lock to ctrl
  setxkbmap -option ctrl:nocaps
fi

if hash pyenv 2>/dev/null; then
  eval "$(pyenv init -)"
fi

if [ -f ~/.bash_profile.local ]; then
  # shellcheck source=.bash_profile.local
  source ~/.bash_profile.local
fi

if [[ -f ~/.bashrc ]]; then
  # shellcheck source=.bashrc
  source ~/.bashrc
fi
