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
  
4. Log out and log back in again.
5. Apply a [base16](http://chriskempson.com/projects/base16/) theme using
   [base16-shell](https://github.com/chriskempson/base16-shell). Eg:

  ```
  base16_unikitty-dark
  ```

## Acknowledgements

Tmux theme lifted from [nicknisi/dotfiles](https://github.com/nicknisi/dotfiles).
