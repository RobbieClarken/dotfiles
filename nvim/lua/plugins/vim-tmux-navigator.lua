-- https://github.com/christoomey/vim-tmux-navigator

return {
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
    },
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
    keys = {
      { "<m-h>", "<cmd>TmuxNavigateLeft<cr>" },
      { "<m-j>", "<cmd>TmuxNavigateDown<cr>" },
      { "<m-k>", "<cmd>TmuxNavigateUp<cr>" },
      { "<m-l>", "<cmd>TmuxNavigateRight<cr>" },
    },
  },
}
