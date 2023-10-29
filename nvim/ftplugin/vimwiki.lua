vim.keymap.set("i", "<s-tab>", "<Plug>VimwikiTablePrevCell", { buffer = 0 })
vim.keymap.set(
  "i",
  "<tab>",
  "copilot#Accept('<c-r>=vimwiki#tbl#kbd_tab()<cr>')",
  { buffer = 0, silent = true, expr = true, replace_keycodes = false }
)
