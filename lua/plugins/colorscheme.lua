return {
  "Mofiqul/dracula.nvim",
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    -- load the colorscheme here
    local dracula = require("dracula")
    local colors = dracula.colors()

    -- helpers from Tokyonight
    ---@param c  string
    local function hexToRgb(c)
      c = string.lower(c)
      return { tonumber(c:sub(2, 3), 16), tonumber(c:sub(4, 5), 16), tonumber(c:sub(6, 7), 16) }
    end

    ---@param foreground string foreground color
    ---@param background string background color
    ---@param alpha number|string number between 0 and 1. 0 results in bg, 1 results in fg
    local function blend(foreground, background, alpha)
      alpha = type(alpha) == "string" and (tonumber(alpha, 16) / 0xff) or alpha
      local bg = hexToRgb(background)
      local fg = hexToRgb(foreground)

      local blendChannel = function(i)
        local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
        return math.floor(math.min(math.max(0, ret), 255) + 0.5)
      end

      return string.format("#%02x%02x%02x", blendChannel(1), blendChannel(2), blendChannel(3))
    end

    local function darken(hex, amount, bg)
      return blend(hex, bg or colors.bg, amount)
    end

    dracula.setup {
      overrides = {
        CursorLineNr = { bold = false },

        Include = { fg = colors.pink },
        Statement = { fg = colors.pink },
        Define = { fg = colors.pink },
        PreProc = { fg = colors.pink },

        -- Diff
        DiffAdd = { bg = darken(colors.bright_green, 0.15) },
        --DiffDelete = { fg = colors.bright_red },
        DiffDelete = { fg = colors.comment },
        DiffChange = { bg = darken(colors.comment, 0.15) },
        DiffText = { bg = darken(colors.comment, 0.50) },

        -- NvimTree
        NvimTreeGitNew = { fg = colors.green },
        NvimTreeGitDirty = { fg = colors.cyan },
        NvimTreeGitDeleted = { fg = colors.red },
        NvimTreeGitMerge = { fg = colors.orange },

        -- lsp
        ['@type'] = { fg = colors.cyan, },
        ['@lsp.type.type'] = { fg = colors.cyan, italic = true },
        ['@type.builtin'] = { fg = colors.pink },
        ['@lsp.type.typeAlias'] = { link = '@lsp.type.type' },
        ['@lsp.type.class'] = { fg = colors.cyan },
        ['@lsp.typemod.class.defaultLibrary.cpp'] = { fg = colors.cyan, italic = true },
        ['@lsp.type.struct'] = { link = '@lsp.type.type' },
        ['@lsp.type.enum'] = { link = '@lsp.type.type' },
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
        ['@lsp.type.macro'] = { link = '@function.macro' },

        ['@punctuation.special'] = { fg = colors.fg },

        ['@punctuation.delimiter'] = { fg = colors.pink },

        ['@variable.builtin'] = { fg = colors.purple, italic = true },
        ['@lsp.type.variable'] = {},

        ['@lsp.type.keyword'] = { fg = colors.pink },
        ['@lsp.type.selfTypeKeyword'] = { fg = colors.purple, italic = true },

        ['@lsp.type.typeParameter'] = {},

        ['@constant'] = { fg = colors.purple, italic = false },

        ['@string.escape'] = { fg = colors.red },

        ['@label'] = {},

        ['@property'] = {},

        DiagnosticUnderlineError = { underline = false, undercurl = true, sp = colors.red },
        DiagnosticUnderlineWarn = { underline = false, undercurl = true, sp = colors.yellow },
        DiagnosticUnderlineInfo = { underline = false, undercurl = true, sp = colors.green },
        DiagnosticUnderlineHint = { underline = false, undercurl = true, sp = colors.cyan },
      }
    }

    vim.cmd [[colorscheme dracula]]
  end,
}
