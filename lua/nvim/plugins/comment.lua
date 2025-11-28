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
    opts = { snippet_engine = "luasnip" }
  },
}
