return {
  "sindrets/diffview.nvim",
  lazy = false,
  command = "DiffviewOpen",
  init = function()
    vim.opt.fillchars:append { diff = "╱" }
  end
}
