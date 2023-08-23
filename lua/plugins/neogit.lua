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
  config = function ()
    require("neogit").setup {
      kind = "split"
    }
  end
}
