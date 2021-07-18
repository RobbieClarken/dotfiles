require("packer").startup(function()
  use "wbthomason/packer.nvim"  -- allow packer to update itself
  use "wincent/terminus"  -- mouse support, reload on focus, handle window resize
  use "christoomey/vim-tmux-navigator"  -- enable navigating between vim splits and tmux panes
end)

vim.opt.expandtab = true  -- expand tabs into spaces
vim.opt.hidden = true  -- allow switching buffers without saving
vim.opt.wrap = false  -- disable text wrapping

-- Disable swapfile messages about opening the file in multiple buffers;
-- wincent/terminus will automatically reload changed files on focus.
vim.opt.shortmess = vim.opt.shortmess + "A"

-----------------------
-- CUSTOMISE PLUGINS --
-----------------------

-- christoomey/vim-tmux-navigator --
vim.g.tmux_navigator_no_mappings = true
vim.api.nvim_set_keymap("n", "<m-h>", ":TmuxNavigateLeft<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<m-j>", ":TmuxNavigateDown<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<m-k>", ":TmuxNavigateUp<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<m-l>", ":TmuxNavigateRight<cr>", { noremap = true, silent = true })
