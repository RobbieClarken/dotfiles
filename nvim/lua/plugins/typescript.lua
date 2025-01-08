return {
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  config = function()
    require("typescript-tools").setup {
      on_attach = function(_, bufnr)
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

        vim.keymap.set("n", "<leader>ri", "<cmd>TSToolsAddMissingImports<cr>", opts)
        vim.keymap.set("n", "<leader>ru", "<cmd>TSToolsRemoveUnusedImports<cr>", opts)
      end,
    }
  end,
}
