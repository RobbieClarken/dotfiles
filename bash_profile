# Environment variables

export EDITOR=vim

export HISTCONTROL=ignoreboth
export HISTSIZE=100000
export HISTFILESIZE=100000

unset SSH_ASKPASS

export CLICOLOR=1

BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

os=$(uname -s | tr 'A-Z' 'a-z' | sed 's/_.*//')
case "$os" in
  linux)
    machine=$(uname -m | sed 's/i686/x86/')
    export EPICS_HOST_ARCH="$os-$machine"

    if hash setxkbmap 2>/dev/null; then
      # Remap caps lock to ctrl
      setxkbmap -option ctrl:nocaps
    fi
  ;;
  darwin)
    export EPICS_HOST_ARCH=darwin-x86
  ;;
esac

export EPICS_BASE=/opt/epics/base
export GOPATH="$HOME/Developer/Go"
export N_PREFIX=$HOME/.local

PATH="/usr/local/bin:/usr/local/sbin:/usr/sbin:/sbin:$PATH"
PATH="$EPICS_BASE/bin/$EPICS_HOST_ARCH:$PATH"
PATH="$HOME/Developer/bin:$PATH"
PATH="$HOME/.dotfiles/bin:$PATH"
PATH=".git/safe/../../bin:$PATH"
PATH="$GOPATH/bin:$PATH"
PATH="$N_PREFIX/n/bin:$PATH"
PATH="/Library/TeX/Distributions/.DefaultTeX/Contents/Programs/x86_64:$PATH"
PATH="$HOME/.local/bin:$PATH"
PATH="$HOME/.cargo/bin:$PATH"
PATH="/opt/squashfuse/bin:$PATH"
PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export PATH

MANPATH="/usr/local/share/man:$MANPATH"
MANPATH="/opt/squashfuse/share/man:$MANPATH"
MANPATH="/opt/tmux/share/man:$MANPATH"
MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
export MANPATH

# Run pipenv shell in fancy mode so we get the right version of bash
export PIPENV_SHELL_FANCY=1

if [ -f ~/.bash_profile.local ]; then
  source ~/.bash_profile.local
fi

if [[ -f $HOME/.bashrc ]]; then
  source $HOME/.bashrc
fi
