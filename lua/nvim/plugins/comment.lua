return {
  {
    "numToStr/Comment.nvim",
    lazy = false,
    opts = {},
  },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      signs = false, -- show icons in the signs column
      highlight = {
        keyword = "bg",
        after = "",
      }
    }
  },

  {
    "danymat/neogen",
    dependencies = {
      "L3MON4D3/LuaSnip",
    },
    opts = { snippet_engine = "luasnip" },
    config = function(_, opts)
      require("neogen").setup(opts)

      require("which-key").add({
        { "<leader>c", group = "+comment" },
        { "<leader>cc", "<cmd>Neogen<cr>", { silent = true }, desc = "generate annotation comment" },
      })
    end
  },
}
