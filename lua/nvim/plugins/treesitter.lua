return {
  "nvim-treesitter/nvim-treesitter",

  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter-context",
      opts = { max_lines = 5 }
    },
    "Joakker/lua-json5",
  },

  lazy = false,
  branch = "main",
  build = ":TSUpdate",

  config = function ()
    local ensure_installed = { "vimdoc", "luadoc", "vim", "lua", "markdown", "markdown_inline", "json", "c", "cpp", "doxygen", "rust", "python", "diff" }
    require('nvim-treesitter').install(ensure_installed)

    local start_ts = function(lang)
      if not vim.tbl_contains(require('nvim-treesitter.config').get_available(), lang) then return end
      vim.wo.foldmethod = 'expr'
      vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      --vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      vim.treesitter.start()
    end

    vim.api.nvim_create_autocmd('FileType', {
      pattern = '*',
      callback = function(event)
        local treesitter = require("nvim-treesitter")

        local filetype = event.match
        local lang = vim.treesitter.language.get_lang(filetype)
        if not lang then
          return
        end

        if not vim.list_contains(require("nvim-treesitter").get_available(), lang) then
          return
        end

        if not vim.list_contains(treesitter.get_installed(), lang) then
          treesitter.install(lang):await(function() start_ts(lang) end)
        else
          start_ts(lang)
        end
      end,
    })
  end,
}
