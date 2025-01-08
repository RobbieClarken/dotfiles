-------------------------
---- vimwiki/vimwiki ----
-------------------------

-- personal wiki and diary
return {
  {
    "vimwiki/vimwiki",
    init = function()
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
    end,
  },
}
