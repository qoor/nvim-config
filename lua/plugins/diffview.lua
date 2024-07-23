return {
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
}
