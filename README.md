## Installation

1. Clone into your home directory:

  ```bash
  git clone --recursive https://github.com/RobbieClarken/dotfiles ~/.dotfiles
  ```

2. Read `~/.dotfiles/install.sh` and make sure you understand what it is going to
   do because it will override existing dotfiles.
3. Run the install script (*warning*: this will override existing dotfiles):

  ```bash
  ~/.dotfiles/install
  ```

4. Enable italic fonts in the terminal by running:

  ```
  cat <<EOF > tmux.terminfo
  tmux|tmux terminal multiplexer,
    sitm=\E[3m, ritm=\E[23m,
    smso=\E[7m, rmso=\E[27m,
    use=screen,
  EOF

  cat <<EOF > tmux-256color.terminfo
  tmux-256color|tmux with 256 colors,
    sitm=\E[3m, ritm=\E[23m,
    smso=\E[7m, rmso=\E[27m,
    use=screen-256color,
  EOF

  cat <<EOF > xterm-256color.terminfo
  xterm-256color|xterm with 256 colors and italic,
    sitm=\E[3m, ritm=\E[23m,
    use=xterm-256color,
  EOF

  tic -o ~/.terminfo tmux.terminfo
  tic -o ~/.terminfo tmux-256color.terminfo
  tic -o ~/.terminfo xterm-256color.terminfo
  ```

5. Log out and log back in again.
6. Apply a [base16](http://chriskempson.com/projects/base16/) theme using
   [base16-shell](https://github.com/chriskempson/base16-shell). Eg:

  ```
  base16_unikitty-dark
  ```

## Acknowledgements

Tmux theme lifted from [nicknisi/dotfiles](https://github.com/nicknisi/dotfiles).
