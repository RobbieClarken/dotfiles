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

  -- fuzzy search all the things
  use {
    "nvim-telescope/telescope.nvim",
    requires = {{"nvim-lua/popup.nvim"}, {"nvim-lua/plenary.nvim"}}
  }
  use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }

end)

vim.opt.clipboard = "unnamed"  -- use system clipboard as main register for yank/put/delete
vim.opt.hidden = true  -- allow switching buffers without saving
vim.opt.wrap = false  -- disable text wrapping

vim.opt.expandtab = true  -- expand tabs into spaces
vim.opt.shiftwidth = 2  -- replace tabs with 2 spaces
vim.opt.tabstop = 2  -- display tabs with a width of two characters
vim.opt.listchars = "tab:└─"  -- use special characters to make tabs 
vim.opt.list = true  -- enable displaying tabs according to listchars setting

-- Disable swapfile messages about opening the file in multiple buffers;
-- wincent/terminus will automatically reload changed files on focus.
vim.opt.shortmess = vim.opt.shortmess + "A"


vim.g.mapleader = " "  -- use space bar as leader key
vim.api.nvim_set_keymap("n", "<space>", "<nop>", { noremap = true })  -- disable space as a command


-------------
-- KEYMAPS --
-------------

vim.api.nvim_set_keymap("n", "<leader><leader>", "<c-^>", { noremap = true })  -- alternate buffers

-- Use <c-l> to clear search highlighting, turn off spell checking and redraw the screen.
vim.api.nvim_set_keymap("n", "<C-l>", ":nohlsearch | set nospell<cr><c-l>", { noremap = true })


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

-- Prevent wikiwiki from creating a local `diary` folder when keymaps are run from inside a markdown file:
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
