return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  config = function ()

    local wk = require("which-key")

    wk.setup({
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    })

    wk.add({
      { "<leader>b", group = "+buffer" },
      { "<leader>bh", "<cmd>bp<cr>", { silent = true }, desc = "move to the previous buffer" },
      { "<leader>bl", "<cmd>bn<cr>", { silent = true }, desc = "move to the next buffer" },
      { "<leader>b`", "<cmd>b#<cr>", { silent = true }, desc = "move to the next buffer" },
      { "<leader>bd", "<cmd>bp <bar> bd #<cr>", { silent = true }, desc = "delete buffer" },
    })
  end
}
