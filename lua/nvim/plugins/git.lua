return {
  {
    "sindrets/diffview.nvim",
    lazy = false,
    command = "DiffviewOpen",
    dependencies = { "which-key.nvim" },
    init = function()
      require("which-key").add({
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
    "f-person/git-blame.nvim",
    -- load the plugin at startup
    event = "VeryLazy",
    -- Because of the keys part, you will be lazy loading this plugin.
    -- The plugin will only load once one of the keys is used.
    -- If you want to load the plugin at startup, add something like event = "VeryLazy",
    -- or lazy = false. One of both options will work.
    opts = {
      -- your configuration comes here
      -- for example
      enabled = true,  -- if you want to enable the plugin
      -- message_template = " <summary> • <date> • <author> • <<sha>>", -- template for the blame message, check the Message template section for more options
      message_template = "     <author>, <date> • <summary>", -- template for the blame message, check the Message template section for more options
      message_when_not_committed = "     You, <date> • Uncommitted changes",
      -- date_format = "%m-%d-%Y %H:%M:%S", -- template for the date, check Date format section for more options
      date_format = "%r", -- template for the date, check Date format section for more options
      virtual_text_column = 1,  -- virtual text start column, check Start virtual text at column section for more options
      highlight_group = "GitBlameVirtualText"
    },
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
