return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      vim.keymap.set("n", "<c-p>", "<cmd>Telescope find_files hidden=true<cr>")
      require("telescope").setup {
        defaults = {
          mappings = {
            i = {
              ["<c-u>"] = false, -- delete to start of line from inside telescope filter input
            },
          },
        },
      }
      -- require("telescope").load_extension("ui-select")
    end,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("fzf") -- use fzf for fuzzy filtering
    end,
  },
}
