## Installation

```bash
ln -s ~/.dotfiles/nvim ~/.config/nvim
git clone https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

python3 -m venv ~/.local/share/nvim/python3-venv
~/.local/share/nvim/python3-venv/bin/pip install pynvim

nvim +PackerSync
```

### Language servers, linters and fixers

```bash
nvim +'MasonInstall typescript-language-server'
npm install -g pyright prettier
pipx install black flake8
rustup +nightly component add rustfmt rust-analyzer-preview
ln -s ~/.rustup/toolchains/nightly-aarch64-apple-darwin/bin/rust-analyzer ~/.local/bin/
```
