-------------
-- PLUGINS --
-------------

require("packer").startup(function()
  use "wbthomason/packer.nvim"  -- allow packer to update itself
  use "wincent/terminus"  -- mouse support, reload on focus, handle window resize
  use "christoomey/vim-tmux-navigator"  -- enable navigating between vim splits and tmux panes
  use "tommcdo/vim-exchange"  -- swap regions of text
  use "tpope/vim-commentary"  -- easily comment/uncomment code
  use "tpope/vim-fugitive"  -- git support
  use "tpope/vim-repeat"  -- add . support to plugin commands
  use "tpope/vim-surround"  --  change parentheses and quotes
  use "tpope/vim-unimpaired"  -- handy bracket mappings
  use "vim-scripts/ReplaceWithRegister"  -- replace text with what is in the register
  use "vimwiki/vimwiki"  -- personal wiki and diary
  use "chriskempson/base16-vim"  -- add support for base16 colour schemes

  -- fuzzy search all the things
  use {
    "nvim-telescope/telescope.nvim",
    requires = {{"nvim-lua/popup.nvim"}, {"nvim-lua/plenary.nvim"}}
  }
  use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }

  use "neovim/nvim-lspconfig"  -- configuration for built-in lsp client
  use "dense-analysis/ale"  -- asynchronous linter
end)


----------------------
-- GENERAL SETTINGS --
----------------------

vim.opt.number = true  -- show line numbers
vim.opt.ignorecase = true  -- make search case-insensitive
vim.opt.smartcase = true  -- if search term contains capital letter, make search case-sensitive
vim.opt.clipboard = "unnamed"  -- use system clipboard as main register for yank/put/delete
vim.opt.hidden = true  -- allow switching buffers without saving
vim.opt.wrap = false  -- disable text wrapping
vim.opt.textwidth = 90  -- used for formatting text with gq

vim.opt.expandtab = true  -- expand tabs into spaces
vim.opt.shiftwidth = 2  -- replace tabs with 2 spaces
vim.opt.tabstop = 2  -- display tabs with a width of two characters
vim.opt.listchars = "tab:└─"  -- use special characters to make tabs 
vim.opt.list = true  -- enable displaying tabs according to listchars setting

-- Disable swapfile messages about opening the file in multiple buffers;
-- wincent/terminus will automatically reload changed files on focus.
vim.opt.shortmess = vim.opt.shortmess + "A"

-- Configure to use base16 colour scheme.
vim.g.base16colorspace = 256
if vim.fn.filereadable(vim.fn.expand("~/.bashrc")) then
  vim.cmd("source ~/.vimrc_background")
end


vim.g.loaded_python_provider = 0
vim.g.python3_host_prog = "~/.local/share/nvim/python3-venv/bin/python3"


-------------
-- KEYMAPS --
-------------

vim.g.mapleader = " "  -- use space bar as leader key
vim.api.nvim_set_keymap("n", "<space>", "<nop>", { noremap = true })  -- disable space as a command

vim.api.nvim_set_keymap("n", "<leader><leader>", "<c-^>", { noremap = true })  -- alternate buffers

-- Use <c-l> to clear search highlighting, turn off spell checking and redraw the screen.
vim.api.nvim_set_keymap("n", "<C-l>", ":nohlsearch | set nospell<cr><c-l>", { noremap = true })

-- Enable navigating through ale / vimwiki location lists using arrow keys.
vim.api.nvim_set_keymap("n", "<left>", ":lpfile<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<right>", ":lnfile<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<up>", ":lprevious<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<down>", ":lnext<cr>", { noremap = true })


-----------------------
-- CUSTOMISE PLUGINS --
-----------------------

----------------------------------------
---- christoomey/vim-tmux-navigator ----
----------------------------------------

vim.g.tmux_navigator_no_mappings = true
vim.api.nvim_set_keymap("n", "<m-h>", ":TmuxNavigateLeft<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<m-j>", ":TmuxNavigateDown<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<m-k>", ":TmuxNavigateUp<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<m-l>", ":TmuxNavigateRight<cr>", { noremap = true, silent = true })

-------------------------
---- vimwiki/vimwiki ----
-------------------------

vim.g.vimwiki_list = {{ path = "~/Dropbox/Notes/", syntax = "markdown", ext = ".md" }}

-- Prevent wikiwiki from creating a local `diary` folder when keymaps are run from inside
-- a markdown file:
vim.api.nvim_set_keymap("n", "<leader>w<leader>w", ":VimwikiMakeDiaryNote 1<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>wi", ":VimwikiDiaryIndex 1<cr>", { noremap = true, silent = true })

---------------------------------------
---- nvim-telescope/telescope.nvim ----
---------------------------------------

require("telescope").setup {
  defaults = {
    mappings = {
      i = {
        ["<c-u>"] = false,  -- delete to start of line from inside telescope filter input
      },
    },
  },
}
require("telescope").load_extension("fzf")  -- use fzf for fuzzy filtering

vim.api.nvim_set_keymap("n", "<c-p>", "<cmd>Telescope find_files<cr>", { noremap = true })

-------------------------------
---- neovim/nvim-lspconfig ----
-------------------------------

require("lspconfig").pyright.setup {
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local opts = { noremap=true, silent=true }
    buf_set_keymap("n", "<c-]>", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
    buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
    buf_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
    buf_set_keymap("n", "<leader>rf", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
  end
}

-- Don't display diagnostics using lsp because pyright generates annoying
-- hints which cannot be disabled through pyright or neovim lsp:
-- https://github.com/neovim/nvim-lspconfig/issues/726
-- https://github.com/microsoft/pyright/issues/1541
vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end

----------------------------
---- dense-analysis/ale ----
----------------------------

vim.g.ale_sign_error = "✗✗"  -- make error indicator look prettier
-- The g:ale_sign_column_always should prevent the text jumping but it is currently not
-- working for neovim v0.5 due to a bug: https://github.com/dense-analysis/ale/issues/3801
vim.g.ale_sign_column_always = 1  -- prevent text jumping around
vim.g.ale_linters = {
  python = { "flake8", "mypy" },
}
vim.g.ale_fixers = {
  python = { "black" },
}
vim.g.ale_pattern_options = {
  -- Disable ale on markdown files because it interferes with vimwiki searches populating
  -- the location list.
  [".md$"] = { ale_linters = {}, ale_fixers = {} },
}

vim.api.nvim_set_keymap("n", "<leader>p", ":ALEFix<cr>", { noremap = true, silent = true })
