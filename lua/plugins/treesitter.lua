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
    local ensure_installed = { "vimdoc", "luadoc", "vim", "lua", "markdown", "json", "c", "cpp", "rust", "python" }
    require('nvim-treesitter').install(ensure_installed)

    local start_ts = function(lang)
      if not vim.tbl_contains(require('nvim-treesitter.config').get_available(), lang) then return end
      vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      --vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      vim.treesitter.start()
    end

    vim.api.nvim_create_autocmd('FileType', {
      pattern = '*',
      callback = function(event)
        local filetype = event.match
        local lang = vim.treesitter.language.get_lang(filetype)
        if not vim.tbl_contains(ensure_installed, lang) then
          require('nvim-treesitter').install(lang):await(function() start_ts(lang) end)
        else
          start_ts(lang)
        end
      end,
    })
  end,
}
