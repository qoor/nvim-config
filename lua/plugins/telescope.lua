return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "folke/which-key.nvim",
  },

  config = function ()
    local wk = require("which-key")
    wk.add({
      { "<leader>f", group = "+file" },
      { "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>", desc = "find files" },
      { "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>", desc = "live grep" },
      { "<leader>fb", "<cmd>lua require('telescope.builtin').buffer()<cr>", desc = "buffers" },
      { "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>", desc = "help tags" },
    })
  end
}
