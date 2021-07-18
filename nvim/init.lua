require("packer").startup(function()
  use "wbthomason/packer.nvim"
end)

vim.opt.expandtab = true  -- expand tabs into spaces
vim.opt.hidden = true  -- allow switching buffers without saving
vim.opt.wrap = false  -- disable text wrapping
