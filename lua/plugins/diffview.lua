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
    wk.register({
      ["<leader>"] = {
        d = {
          name = "+diffview",

          d = { "<cmd>DiffviewOpen<cr>", "enter diffview" },
          q = { "<cmd>DiffviewClose<cr>", "quit diffview" }
        }
      }
    })

  end
}
