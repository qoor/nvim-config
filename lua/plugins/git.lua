return {
  {
    "sindrets/diffview.nvim",
    lazy = false,
    command = "DiffviewOpen",
    dependencies = {
      "which-key.nvim"
    },
    init = function()
      vim.opt.fillchars:append { diff = "╱" }

      local wk = require("which-key")
      wk.add({
        { "<leader>v", group = "+diffview" },
        { "<leader>vv", "<cmd>DiffviewOpen<cr>", desc = "enter diffview" },
        { "<leader>vq", "<cmd>DiffviewClose<cr>", desc = "quit diffview" },
      })

    end
  },

  {
    "lewis6991/gitsigns.nvim",
    opts = {}
  },

  {
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
  },
}
