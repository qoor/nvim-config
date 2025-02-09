return {
  "nvimdev/lspsaga.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
  },

  config = function()
    require("lspsaga").setup({
      lightbulb = {
        sign = true
      },
      rename = {
        in_select = false,
        keys = {
          quit = "<C-c>"
        }
      },
      symbol_in_winbar = {
        enable = false
      }
    })

    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(ev)
        local wk = require("which-key")
        wk.add({
          buffer = ev.buf,

          { "<leader>laa", "<cmd>:Lspsaga code_action<cr>", desc = "code actions" },
          { "<leader>lrr", "<cmd>:Lspsaga rename<cr>", desc = "rename" },
          { "<leader>lgh", "<cmd>:Lspsaga incoming_calls<cr>", desc = "show incoming call hierarchy" },
          { "<leader>lgo", "<cmd>:Lspsaga outgoing_calls<cr>", desc = "show outgoing call hierarchy" },
        })
      end
    })
  end
}
