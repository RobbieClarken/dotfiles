## Installation

```bash
ln -s ~/.dotfiles/nvim ~/.config/nvim
git clone https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

python3 -m venv ~/.local/share/nvim/python3-venv
~/.local/share/nvim/python3-venv/bin/pip install pynvim

nvim +PackerSync
```

### Linters and fixers

```bash
nvim --headless -c 'MasonInstall prettier black flake8' -c qall
rustup component add rustfmt
```
