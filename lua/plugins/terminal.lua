return {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    { "<leader>s", "<cmd>ToggleTerm<CR>", desc = "Toggle shell" },
    { "<ESC>", "<C-\\><C-n>", mode = "t", noremap = true },
  },
  dependencies = {
    "nvim-tree/nvim-tree.lua",
  },
  opts = {
    size = function(term)
      if term.direction == "horizontal" then
        return 15
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
    on_open = function(terminal)
      local nvimtree = require("nvim-tree.api")
      local nvimtree_view = require("nvim-tree.view")

      if nvimtree_view.is_visible() and terminal.direction == "horizontal" then
        local nvimtree_width = vim.fn.winwidth(nvimtree_view.get_winnr())
        nvimtree.tree.toggle()
        nvimtree_view.View.width = nvimtree_width
        nvimtree.tree.toggle({find_file = false, focus = false})
      end

      vim.defer_fn(function()
        vim.wo[terminal.window].winbar = ""
      end, 0)
    end
  },
}
