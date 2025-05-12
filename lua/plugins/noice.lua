return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
    },
    cmdline = {
      enabled = true,
      view = "cmdline"
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      lsp_doc_border = false,
    }
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    "rcarriga/nvim-notify",
    "hrsh7th/nvim-cmp",
  },
  config = function(_, opts)
    require("noice").setup(opts)
    require("notify").setup({
      background_colour = "#000000",
      merge_duplicates = false,
    })
  end
}
