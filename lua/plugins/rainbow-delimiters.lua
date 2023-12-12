return {
  "HiPhish/rainbow-delimiters.nvim",

  config = function ()
    require("rainbow-delimiters.setup").setup({
      highlight = {
        "BracketHighlightForeground1",
        "BracketHighlightForeground2",
        "BracketHighlightForeground3",
        "BracketHighlightForeground4",
        "BracketHighlightForeground5",
        "BracketHighlightForeground6"
    }
  })
  end
}
