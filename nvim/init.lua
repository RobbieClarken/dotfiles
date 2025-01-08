require("config.lazy")

vim.opt.number = true -- show line numbers
vim.opt.ignorecase = true -- make search case-insensitive
vim.opt.smartcase = true -- if search term contains capital letter, make search case-sensitive
vim.opt.clipboard = "unnamed" -- use system clipboard as main register for yank/put/delete
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

-- Enable readline commands in command mode
vim.keymap.set("c", "<c-a>", "<home>")
vim.keymap.set("c", "<c-e>", "<end>")

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

-- Use <c-l> to clear search highlighting, turn off spell checking and redraw the screen.
vim.keymap.set("n", "<c-l>", "<cmd>nohlsearch | set nospell<cr><c-l>")

-- When reopening a file, jump to the last location.
vim.api.nvim_create_autocmd("BufReadPost", {
  command = [[if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]],
  group = vim.api.nvim_create_augroup("JumpToLastLocation", {}),
})

-- Enable navigating through quickfix lists using shift/alt + arrow keys.
vim.keymap.set("n", "<s-left>", "<cmd>cpfile<cr>zz")
vim.keymap.set("n", "<s-right>", "<cmd>cnfile<cr>zz")
vim.keymap.set("n", "<s-up>", "<cmd>cprevious<cr>zz")
vim.keymap.set("n", "<s-down>", "<cmd>cnext<cr>zz")

vim.keymap.set("ca", "rg", "gr")
vim.keymap.set("n", "<leader><leader>", "<c-^>") -- alternate buffers

-- Disable swapfile messages about opening the file in multiple buffers.
vim.opt.shortmess = vim.opt.shortmess + "A"

local rbc = require("rbc")
vim.keymap.set("n", "<leader>f", rbc.copy_path)
vim.keymap.set("n", "<leader>t", rbc.build_test_command)
vim.keymap.set("n", "yoa", rbc.copilot_toggle)

vim.keymap.set("n", "<leader>p", function()
  vim.cmd("!pre-commit run --files %")
end)
