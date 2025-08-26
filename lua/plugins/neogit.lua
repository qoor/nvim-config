return {
  "NeogitOrg/neogit",
  cmd = "Neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",         -- required
    "nvim-telescope/telescope.nvim", -- optional
    "sindrets/diffview.nvim",        -- optional
  },
  keys = {
    { "<leader>g", "<cmd>Neogit cwd=%:p:h<cr>", desc = "Neogit" }
  },
  opts = {
    graph_style = "unicode",
    kind = "split",

    integrations = {
      telescope = true,
      diffview = true,
    },
  }
}
