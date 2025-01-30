export EDITOR=vim

export HISTCONTROL=ignoreboth
export HISTSIZE=100000
export HISTFILESIZE=100000

unset SSH_ASKPASS

export CLICOLOR=1

export GOPATH="$HOME/Developer/go"
export N_PREFIX="$HOME/.local/n"

if [ -f /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [ -f /opt/homebrew/bin/luarocks ]; then
  eval "$(luarocks path)"
fi

PATH=/usr/local/bin:/usr/local/sbin:/usr/sbin:/sbin:$PATH
PATH=$HOME/Developer/bin:$PATH
PATH=$HOME/.dotfiles/bin:$PATH
PATH=$GOPATH/bin:$PATH
PATH=/Library/TeX/Distributions/.DefaultTeX/Contents/Programs/x86_64:$PATH
PATH=$HOME/.local/bin:$PATH
PATH=$HOME/.poetry/bin:$PATH
PATH=$HOME/.deno/bin:$PATH
PATH=/opt/squashfuse/bin:$PATH
PATH=$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH
PATH=$HOMEBREW_PREFIX/opt/gawk/libexec/gnubin:$PATH
PATH=$HOMEBREW_PREFIX/opt/grep/libexec/gnubin:$PATH
PATH=$N_PREFIX/bin:$PATH
export PATH

MANPATH=/usr/local/share/man:$MANPATH
MANPATH=/opt/squashfuse/share/man:$MANPATH
MANPATH=$HOMEBREW_PREFIX/opt/coreutils/libexec/gnuman:$MANPATH
export MANPATH

export PIP_REQUIRE_VIRTUALENV=1

export HOMEBREW_NO_INSTALL_CLEANUP=1

if [ "$(uname)" = "Linux" ] && hash setxkbmap 2>/dev/null; then
  # Remap caps lock to ctrl
  setxkbmap -option ctrl:nocaps
fi

if hash pyenv 2>/dev/null; then
  eval "$(pyenv init -)"
fi

if [ -f ~/.bash_profile.local ]; then
  # shellcheck source=/dev/null
  . ~/.bash_profile.local
fi

if [ -f ~/.bashrc ]; then
  # shellcheck source=/dev/null
  . ~/.bashrc
fi

if [ -f ~/.cargo/env ]; then
  . ~/.cargo/env
fi
