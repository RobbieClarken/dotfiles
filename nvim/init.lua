-- Speed up loading Lua modules by enabling the experimental loader
if vim.loader then
  vim.loader.enable()
end

-------------
-- PLUGINS --
-------------

local packer_bootstrap
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
end

require("packer").startup(function(use)
  use "wbthomason/packer.nvim" -- allow packer to update itself
  use "wincent/terminus" -- mouse support, reload on focus, handle window resize
  use "christoomey/vim-tmux-navigator" -- enable navigating between vim splits and tmux panes
  use "tommcdo/vim-exchange" -- swap regions of text
  use "tpope/vim-abolish" -- add :%S/Foo/Bar/
  use "tpope/vim-commentary" -- easily comment/uncomment code
  use "tpope/vim-fugitive" -- git support
  use "tpope/vim-repeat" -- add . support to plugin commands
  use "tpope/vim-surround" --  change parentheses and quotes
  use "tpope/vim-unimpaired" -- handy bracket mappings
  use "vim-scripts/ReplaceWithRegister" -- replace text with what is in the register
  use "vimwiki/vimwiki" -- personal wiki and diary
  use "sirver/ultisnips" -- code snippets manager
  use "mattn/emmet-vim" -- generate html from css-like expressions
  use "chriskempson/base16-vim" -- add support for base16 colour schemes
  use "jparise/vim-graphql" -- syntax highlighting for GraphQL
  use "github/copilot.vim" -- add support for GitHub Copilot

  -- fuzzy search all the things
  use {
    "nvim-telescope/telescope.nvim",
    requires = { { "nvim-lua/popup.nvim" }, { "nvim-lua/plenary.nvim" } },
  }
  use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }

  use { "nvim-telescope/telescope-ui-select.nvim" } -- use telescope for lsp code actions menu

  -- use neovim as a language server
  -- (used to inject code actions provided by jose-elias-alvarez/typescript.nvim)
  use {
    "jose-elias-alvarez/null-ls.nvim",
    requires = { { "nvim-lua/plenary.nvim" } },
  }

  use {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  }
  use "jose-elias-alvarez/typescript.nvim" -- extra typescript lsp functionality
  use "pmizio/typescript-tools.nvim" -- replace typescript.nvim?
  use "dense-analysis/ale" -- asynchronous linter

  if packer_bootstrap then
    require("packer").sync()
  end
end)

----------------------
-- GENERAL SETTINGS --
----------------------

vim.opt.number = true -- show line numbers
vim.opt.ignorecase = true -- make search case-insensitive
vim.opt.smartcase = true -- if search term contains capital letter, make search case-sensitive
vim.opt.clipboard = "unnamed" -- use system clipboard as main register for yank/put/delete
vim.opt.hidden = true -- allow switching buffers without saving
vim.opt.wildmode = { "longest", "list" } -- Make tab in command-line mode behave like in bash
vim.opt.wrap = false -- disable text wrapping
vim.opt.formatoptions = "qj" -- don't auto text wrap; do remove comment leader when joining lines
vim.opt.textwidth = 90 -- used for formatting text with gq
vim.opt.colorcolumn = "90" -- discourage excessively long lines of code

vim.opt.expandtab = true -- expand tabs into spaces
vim.opt.shiftwidth = 2 -- replace tabs with 2 spaces
vim.opt.tabstop = 2 -- display tabs with a width of two characters
vim.opt.listchars = "tab:└─" -- use special characters to make tabs
vim.opt.list = true -- enable displaying tabs according to listchars setting

vim.opt.path = vim.opt.path + "**" -- Make :find and gf look in subdirectories

-- Disable swapfile messages about opening the file in multiple buffers;
-- wincent/terminus will automatically reload changed files on focus.
vim.opt.shortmess = vim.opt.shortmess + "A"

-- Configure to use base16 colour scheme.
vim.g.base16colorspace = 256
vim.opt.termguicolors = true
if vim.fn.filereadable(vim.fn.expand("~/.vimrc_background")) then
  vim.cmd("source ~/.vimrc_background")
end

vim.g.loaded_python_provider = 0 -- disable python 2 support
-- Look for python 3 dependencies in a virtual environment.
vim.g.python3_host_prog = "~/.local/share/nvim/python3-venv/bin/python3"

-- When reopening a file, jump to the last location.
vim.api.nvim_create_autocmd("BufReadPost", {
  command = [[if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]],
  group = vim.api.nvim_create_augroup("JumpToLastLocation", {}),
})

-- Enable readline commands in command mode
vim.keymap.set("c", "<c-a>", "<home>")
vim.keymap.set("c", "<c-e>", "<end>")

-- Store large relative jumps in jumplist
vim.keymap.set("n", "k", [[(v:count > 5 ? "m'" . v:count : '') . 'k']], { expr = true })
vim.keymap.set("n", "j", [[(v:count > 5 ? "m'" . v:count : '') . 'j']], { expr = true })

-- Briefly highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  command = [[lua vim.highlight.on_yank()]],
  group = vim.api.nvim_create_augroup("HighlightOnYank", {}),
})

-- Configure :gr to use ripgrep if it is available.
if vim.fn.executable("rg") then
  vim.opt.grepprg = "rg --vimgrep --smart-case"
  vim.opt.grepformat = "%f:%l:%c:%m"
end

vim.g.mapleader = " " -- use space bar as leader key
vim.keymap.set("n", "<space>", "<nop>") -- disable space as a command

-- prevent a preview buffer from opening when using omni completion
vim.opt.completeopt = { "menu", "menuone" }

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

vim.g.vimwiki_list = { { path = "~/Documents/notes/", syntax = "markdown", ext = ".md" } }

-- Disable vimwiki's insert mode tab key mapping because it blocks the use of tab for
-- copilot suggestion acceptance. We re-enable tab for table cell navigation in a
-- copilot compatible way in ftplugin/vimwiki.lua.
vim.g.vimwiki_key_mappings = { table_mappings = 0 }

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
        ["<c-u>"] = false, -- delete to start of line from inside telescope filter input
      },
    },
  },
}
require("telescope").load_extension("fzf") -- use fzf for fuzzy filtering
require("telescope").load_extension("ui-select")

vim.keymap.set("n", "<c-p>", "<cmd>Telescope find_files hidden=true<cr>")

-------------------------------------------
---- williamboman/mason-lspconfig.nvim ----
-------------------------------------------

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "pyright",
    "rust_analyzer",
    "tsserver",
  },
})

-------------------------------
---- neovim/nvim-lspconfig ----
-------------------------------

local on_attach = function(_, bufnr)
  vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
  local opts = { buffer = bufnr }
  vim.keymap.set("n", "<c-]>", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<leader>gt", vim.lsp.buf.type_definition, opts)
  vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  vim.diagnostic.disable(bufnr)
end

local lspconfig = require("lspconfig")
lspconfig.pyright.setup({ on_attach = on_attach })
lspconfig.rust_analyzer.setup({ on_attach = on_attach })
lspconfig.lua_ls.setup({
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    vim.diagnostic.enable(bufnr)
  end,
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = { library = { vim.env.VIMRUNTIME } },
    },
  },
})
lspconfig.denols.setup({
  on_attach = on_attach,
  root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
})

-----------------------------------------
---- jose-elias-alvarez/null-ls.nvim ----
-----------------------------------------

require("null-ls").setup({
  sources = {
    -- add code actions provided by jose-elias-alvarez/typescript.nvim
    require("typescript.extensions.null-ls.code-actions"),
  },
})

require("typescript-tools").setup({
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    local opts = { buffer = bufnr }
    vim.keymap.set("n", "<leader>ri", "<cmd>TSToolsAddMissingImports<cr><cmd>ALEFix<cr>", opts)
    vim.keymap.set("n", "<leader>ru", "<cmd>TSToolsRemoveUnusedImports<cr><cmd>ALEFix<cr>", opts)
    vim.diagnostic.enable(bufnr)
  end,
})

--------------------------------------------
---- jose-elias-alvarez/typescript.nvim ----
--------------------------------------------

-- require("typescript").setup({
--   server = { -- pass options to lspconfig's setup method
--     on_attach = function(client, bufnr)
--       on_attach(client, bufnr)
--       local opts = { buffer = bufnr }
--       vim.keymap.set("n", "<leader>ri", "<cmd>TypescriptAddMissingImports<cr><cmd>ALEFix<cr>", opts)
--       vim.keymap.set("n", "<leader>ru", "<cmd>TypescriptRemoveUnused<cr><cmd>ALEFix<cr>", opts)
--     end,
--     root_dir = lspconfig.util.root_pattern("package.json"),
--     single_file_support = false,
--   },
-- })

----------------------------
---- dense-analysis/ale ----
----------------------------

vim.g.ale_floating_preview = 1 -- use floating window to display hover information
vim.g.ale_sign_error = "✗✗" -- make error indicator look prettier
vim.g.ale_sign_column_always = 1 -- prevent text jumping around
vim.g.ale_javascript_prettier_use_global = 1 -- use globally installed prettier
vim.g.ale_javascript_eslint_suppress_missing_config = 1 -- suppress warning about missing config
vim.g.ale_rust_cargo_use_clippy = 1
vim.g.ale_use_neovim_diagnostics_api = 0
vim.g.ale_disable_lsp = 0
vim.keymap.set("n", "<leader>p", "<cmd>ALEFix<cr>")
vim.g.ale_linters = {
  graphql = {},
  html = {},
  javascript = { "eslint" },
  python = { "flake8", "mypy" },
  rust = { "cargo" },
  typescript = { "eslint", "tsserver" },
  typescriptreact = { "eslint", "tsserver" },
}
vim.g.ale_fixers = {
  css = { "prettier" },
  html = { "prettier" },
  javascript = { "eslint", "prettier" },
  lua = { "stylua" },
  python = { "black" },
  -- if rust rustfmt is not working create a `.rustfmt.toml` file with `edition = "2021"`
  -- (set edition to what is in `Cargo.toml`)
  rust = { "rustfmt" },
  typescript = { "eslint", "prettier" },
  typescriptreact = { "eslint", "prettier" },
}
vim.g.ale_pattern_options = {
  -- Disable ale on markdown files because it interferes with vimwiki searches populating
  -- the location list.
  [".md$"] = { ale_linters = {}, ale_fixers = {} },
}
vim.keymap.set("n", "<leader>d", "<cmd>ALEDetail<cr>") -- alternate buffers

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  group = vim.api.nvim_create_augroup("Deno", {}),
  pattern = { "*.ts" },
  callback = function()
    if vim.fn.filereadable("deno.json") == 1 then
      vim.b.ale_linters = { typescript = { "deno" } }
      vim.b.ale_fixers = { typescript = { "deno" } }
    end
  end,
})

----------------------------
---- sirver/ultisnips ----
----------------------------

vim.g.UltiSnipsSnippetDirectories = { vim.fn.stdpath("config") .. "/ultisnips" }

-------------------------
---- mattn/emmet-vim ----
-------------------------

vim.g.user_emmet_expandabbr_key = "<c-e>"

-------------
-- KEYMAPS --
-------------

-- Enable reloading config with <leader>R.
vim.keymap.set(
  "n",
  "<leader>R",
  "<cmd>lua package.loaded.rbc = nil<cr><cmd>source ~/.config/nvim/init.lua<cr><cmd>echo 'config reloaded'<cr>"
)

vim.keymap.set("n", "<leader><leader>", "<c-^>") -- alternate buffers

-- Use <c-l> to clear search highlighting, turn off spell checking and redraw the screen.
vim.keymap.set("n", "<c-l>", "<cmd>nohlsearch | set nospell<cr><c-l>")

-- Enable navigating through ale / vimwiki location lists using arrow keys.
vim.keymap.set("n", "<left>", "<cmd>lpfile<cr>")
vim.keymap.set("n", "<right>", "<cmd>lnfile<cr>")
vim.keymap.set("n", "<up>", "<cmd>lprevious<cr>")
vim.keymap.set("n", "<down>", "<cmd>lnext<cr>")

-- Enable navigating through quickfix lists using shift/alt + arrow keys.
vim.keymap.set("n", "<s-left>", "<cmd>cpfile<cr>zz")
vim.keymap.set("n", "<s-right>", "<cmd>cnfile<cr>zz")
vim.keymap.set("n", "<s-up>", "<cmd>cprevious<cr>zz")
vim.keymap.set("n", "<s-down>", "<cmd>cnext<cr>zz")

local rbc = require("rbc")
vim.keymap.set("n", "<leader>f", rbc.copy_path)
vim.keymap.set("n", "<leader>t", rbc.build_test_command)
vim.keymap.set("n", "yoa", rbc.copilot_toggle)

vim.keymap.set("n", "<leader>T", "<cmd>Telescope<cr>")

-- Select what was just pasted.
vim.keymap.set("n", "gp", "`[v`]")

-- Make * and # respect smartcase
-- https://vi.stackexchange.com/a/4055
vim.keymap.set(
  "n",
  "*",
  ":let @/='\\C\\<' . expand('<cword>') . '\\>'<cr>:let v:searchforward=1<cr>n"
)
vim.keymap.set(
  "n",
  "#",
  ":let @/='\\C\\<' . expand('<cword>') . '\\>'<cr>:let v:searchforward=0<cr>n"
)
