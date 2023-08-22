return {
  "Mofiqul/dracula.nvim",
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    -- load the colorscheme here
    local dracula = require("dracula")
    local colors = dracula.colors()

    dracula.setup {
      overrides = {
        -- NvimTree
        NvimTreeGitNew = { fg = colors.green },
        NvimTreeGitDirty = { fg = colors.cyan },
        NvimTreeGitDeleted = { fg = colors.red },
        NvimTreeGitMerge = { fg = colors.orange },

        -- lsp
        ['@lsp.type.type'] = { fg = colors.cyan, italic = true },
        ['@lsp.type.typeAlias'] = { link = '@lsp.type.type' },
        ['@lsp.type.struct'] = { link = '@lsp.type.type' },
        ['@lsp.type.enum'] = { link = '@lsp.type.type' },
        ['@lsp.type.enumMember'] = { fg = colors.fg, italic = true },
        ['@lsp.type.interface'] = { link = '@lsp.type.type' },

        ['@field'] = { fg = colors.fg },
        ['@lsp.type.property'] = { link = '@field' },

        ['@keyword.function'] = { fg = colors.pink },
        ['@function.builtin'] = {},

        ['@parameter'] = { fg = colors.orange, italic = true },
        ['@parameter.reference'] = { link = '@parameter' },
        ['@lsp.type.parameter'] = { link = '@parameter' },

        ['@namespace'] = { fg = colors.fg },
        ['@lsp.type.namespace'] = { link = '@namespace' },

        ['@function.macro'] = { fg = colors.green },
        ['@lsp.type.macro.rust'] = { link = '@function.macro' },

        ['@punctuation.special'] = { fg = colors.fg },

        ['@punctuation.delimiter'] = { fg = colors.pink },

        ['@variable.builtin'] = { fg = colors.pink, italic = true },
        ['@lsp.type.variable'] = {},

        ['@lsp.type.selfKeyword'] = { fg = colors.pink, italic = true },
        ['@lsp.type.selfTypeKeyword'] = { fg = colors.pink, italic = true },

        ['@lsp.type.keyword'] = { fg = colors.pink },

        ['@lsp.type.typeParameter'] = {},

        ['@constant'] = { fg = colors.purple, italic = false },
      }
    }

    vim.cmd [[colorscheme dracula]]
  end,
}
