return {
  "folke/trouble.nvim",
  dependencies = {
    "folke/which-key.nvim",
  },
  opts = {}, -- for default options, refer to the configuration section for custom setup.
  config = function(_, opts)
    require("trouble").setup(opts)

    local wk = require("which-key")
    wk.add({
      { "<leader>x", group = "+problem" },
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "show problems" },
      { "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "show current buffer problems" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "show problem symbols" },
      { "<leader>xw", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "show workspace problems" },
      { "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "show location list" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "show quickfix list" },
    })
  end
}
