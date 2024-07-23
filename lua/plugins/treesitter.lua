return {
  "nvim-treesitter/nvim-treesitter",
  build = function()
    require("nvim-treesitter.install").update({ with_sync = true })
  end,
  config = function()
    require("nvim-treesitter.configs").setup {
      highlight = { enable = true },
      ensure_installed = { "vimdoc", "luadoc", "vim", "lua", "markdown" },
    }
  end
}
