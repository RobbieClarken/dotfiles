-------------
-- PLUGINS --
-------------

local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  })
end

require("packer").startup(function()
  use "wbthomason/packer.nvim"  -- allow packer to update itself
  use "wincent/terminus"  -- mouse support, reload on focus, handle window resize
  use "christoomey/vim-tmux-navigator"  -- enable navigating between vim splits and tmux panes
  use "tommcdo/vim-exchange"  -- swap regions of text
  use "tpope/vim-abolish"  -- add :%S/Foo/Bar/
  use "tpope/vim-commentary"  -- easily comment/uncomment code
  use "tpope/vim-fugitive"  -- git support
  use "tpope/vim-repeat"  -- add . support to plugin commands
  use "tpope/vim-surround"  --  change parentheses and quotes
  use "tpope/vim-unimpaired"  -- handy bracket mappings
  use "vim-scripts/ReplaceWithRegister"  -- replace text with what is in the register
  use "vimwiki/vimwiki"  -- personal wiki and diary
  use "sirver/ultisnips"  -- code snippets manager
  use "chriskempson/base16-vim"  -- add support for base16 colour schemes
  use "jparise/vim-graphql"  -- syntax highlighting for GraphQL

  -- fuzzy search all the things
  use {
    "nvim-telescope/telescope.nvim",
    requires = {{"nvim-lua/popup.nvim"}, {"nvim-lua/plenary.nvim"}}
  }
  use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }

  use "neovim/nvim-lspconfig"  -- configuration for built-in lsp client
  use "jose-elias-alvarez/typescript.nvim"  -- extra typescript lsp functionality
  use "dense-analysis/ale"  -- asynchronous linter

  if packer_bootstrap then
    require('packer').sync()
  end
end)

----------------------
-- GENERAL SETTINGS --
----------------------

vim.opt.number = true  -- show line numbers
vim.opt.ignorecase = true  -- make search case-insensitive
vim.opt.smartcase = true  -- if search term contains capital letter, make search case-sensitive
vim.opt.clipboard = "unnamed"  -- use system clipboard as main register for yank/put/delete
vim.opt.hidden = true  -- allow switching buffers without saving
vim.opt.wildmode = { "longest", "list" }  -- Make tab in command-line mode behave like in bash
vim.opt.wrap = false  -- disable text wrapping
vim.opt.formatoptions = "qj"  -- don't auto text wrap; do remove comment leader when joining lines
vim.opt.textwidth = 90  -- used for formatting text with gq
vim.opt.colorcolumn = "90"  -- discourage excessively long lines of code

vim.opt.expandtab = true  -- expand tabs into spaces
vim.opt.shiftwidth = 2  -- replace tabs with 2 spaces
vim.opt.tabstop = 2  -- display tabs with a width of two characters
vim.opt.listchars = "tab:└─"  -- use special characters to make tabs 
vim.opt.list = true  -- enable displaying tabs according to listchars setting

vim.opt.path = vim.opt.path + "**"  -- Make :find and gf look in subdirectories

-- Disable swapfile messages about opening the file in multiple buffers;
-- wincent/terminus will automatically reload changed files on focus.
vim.opt.shortmess = vim.opt.shortmess + "A"

-- Configure to use base16 colour scheme.
vim.g.base16colorspace = 256
vim.opt.termguicolors = true
if vim.fn.filereadable(vim.fn.expand("~/.vimrc_background")) then
  vim.cmd("source ~/.vimrc_background")
end

vim.g.loaded_python_provider = 0  -- disable python 2 support
-- Look for python 3 dependencies in a virtual environment.
vim.g.python3_host_prog = "~/.local/share/nvim/python3-venv/bin/python3"

-- When reopening a file, jump to the last location.
vim.api.nvim_create_autocmd(
  "BufReadPost",
  {
    command = [[if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]],
    group = vim.api.nvim_create_augroup("JumpToLastLocation", {}),
  }
)

-- Enable readline commands in command mode
vim.keymap.set("c", "<c-a>", "<home>")
vim.keymap.set("c", "<c-e>", "<end>")

-- Store large relative jumps in jumplist
vim.keymap.set("n", "k", [[(v:count > 5 ? "m'" . v:count : '') . 'k']], { expr = true })
vim.keymap.set("n", "j", [[(v:count > 5 ? "m'" . v:count : '') . 'j']], { expr = true })

-- Briefly highlight yanked text
vim.api.nvim_create_autocmd(
  "TextYankPost",
  {
    command = [[lua vim.highlight.on_yank()]],
    group = vim.api.nvim_create_augroup("HighlightOnYank", {}),
  }
)

-- Configure :gr to use ripgrep if it is available.
if vim.fn.executable("rg") then
  vim.opt.grepprg = "rg --vimgrep --smart-case"
  vim.opt.grepformat = "%f:%l:%c:%m"
end

vim.g.mapleader = " "  -- use space bar as leader key
vim.keymap.set("n", "<space>", "<nop>")  -- disable space as a command

-- prevent a preview buffer from opening when using omni completion
vim.opt.completeopt = {"menu", 'menuone'}

vim.g.python3_host_prog = "~/.local/nvim-venv3/bin/python3"

-----------------------
-- CUSTOMISE PLUGINS --
-----------------------

----------------------------------------
---- christoomey/vim-tmux-navigator ----
----------------------------------------

vim.g.tmux_navigator_no_mappings = true
vim.keymap.set("n", "<m-h>", "<cmd>TmuxNavigateLeft<cr>")
vim.keymap.set("n", "<m-j>", "<cmd>TmuxNavigateDown<cr>")
vim.keymap.set("n", "<m-k>", "<cmd>TmuxNavigateUp<cr>")
vim.keymap.set("n", "<m-l>", "<cmd>TmuxNavigateRight<cr>")

-------------------------
---- vimwiki/vimwiki ----
-------------------------

vim.g.vimwiki_list = {{ path = "~/Documents/notes/", syntax = "markdown", ext = ".md" }}

-- Prevent wikiwiki from creating a local `diary` folder when keymaps are run from inside
-- a markdown file:
vim.keymap.set("n", "<leader>w<leader>w", "<cmd>VimwikiMakeDiaryNote 1<cr>")
vim.keymap.set("n", "<leader>wi", "<cmd>VimwikiDiaryIndex 1<cr>")
vim.keymap.set("n", "<leader>ww", "<cmd>VimwikiIndex 1<cr>")

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

vim.keymap.set("n", "<c-p>", "<cmd>Telescope find_files<cr>")

-------------------------------
---- neovim/nvim-lspconfig ----
-------------------------------

require("lspconfig").pyright.setup(
    {
      on_attach = function(client, bufnr)
        vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
        local opts = { buffer=0 }
        vim.keymap.set("n", "<c-]>", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>rf", vim.lsp.buf.references, opts)
      end
    }
)

--------------------------------------------
---- jose-elias-alvarez/typescript.nvim ----
--------------------------------------------

-- requires `npm install -g typescript-language-server`
require("typescript").setup({
  server = { -- pass options to lspconfig's setup method
    on_attach = function(client, bufnr)
      vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
      local opts = { buffer=0 }
      vim.keymap.set("n", "<c-]>", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
      vim.keymap.set("n", "<leader>ri", "<cmd>TypescriptAddMissingImports<cr>", opts)
      vim.keymap.set("n", "<leader>rf", vim.lsp.buf.references, opts)
      vim.keymap.set("n", "<leader>gt", vim.lsp.buf.type_definition, opts)
      vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, opts)
    end
  },
})

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
vim.g.ale_javascript_prettier_use_global = 1  -- use globally installed prettier
vim.g.ale_javascript_eslint_suppress_missing_config = 1  -- suppress warning about missing config
vim.keymap.set("n", "<leader>p", "<cmd>ALEFix<cr>")
vim.g.ale_linters = {
  python = { "flake8", "mypy" },
  graphql = {},
}
vim.g.ale_fixers = {
  python = { "black" },
  html = { "prettier" },
  css = { "prettier" },
  javascript = { "prettier", "eslint" },
  typescript = { "prettier", "eslint" },
  typescriptreact = { "prettier", "eslint" },
}
vim.g.ale_pattern_options = {
  -- Disable ale on markdown files because it interferes with vimwiki searches populating
  -- the location list.
  [".md$"] = { ale_linters = {}, ale_fixers = {} },
}

----------------------------
---- sirver/ultisnips ----
----------------------------

vim.g.UltiSnipsSnippetDirectories = { vim.fn.stdpath("config").."/ultisnips" }

-------------
-- KEYMAPS --
-------------

-- Enable reloading config with <leader>R.
vim.keymap.set(
  "n",
  "<leader>R",
  "<cmd>lua package.loaded.rbc = nil<cr><cmd>source ~/.config/nvim/init.lua<cr><cmd>echo 'config reloaded'<cr>"
)

vim.keymap.set("n", "<leader><leader>", "<c-^>")  -- alternate buffers

-- Use <c-l> to clear search highlighting, turn off spell checking and redraw the screen.
vim.keymap.set("n", "<C-l>", "<cmd>nohlsearch | set nospell<cr><c-l>")

-- Enable navigating through ale / vimwiki location lists using arrow keys.
vim.keymap.set("n", "<left>", "<cmd>lpfile<cr>")
vim.keymap.set("n", "<right>", "<cmd>lnfile<cr>")
vim.keymap.set("n", "<up>", "<cmd>lprevious<cr>")
vim.keymap.set("n", "<down>", "<cmd>lnext<cr>")

-- Enable navigating through quickfix lists using shift/alt + arrow keys.
vim.keymap.set("n", "<s-left>", "<cmd>cpfile<cr>")
vim.keymap.set("n", "<s-right>", "<cmd>cnfile<cr>")
vim.keymap.set("n", "<s-up>", "<cmd>cprevious<cr>")
vim.keymap.set("n", "<s-down>", "<cmd>cnext<cr>")

vim.keymap.set("n", "<leader>f", "<cmd>lua require('rbc').copy_path()<cr>")
vim.keymap.set("n", "<leader>gg", "<cmd>lua require('rbc').copy_python_path()<cr>")
vim.keymap.set("n", "<leader>t", "<cmd>lua require('rbc').build_pytest_command()<cr>")
