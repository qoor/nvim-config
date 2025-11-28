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
        CursorLine = { bg = darken(colors.black, 0.5), },
        ColorColumn = { bg = colors.selection, },

        SpellBad = { underline = false, undercurl = true, sp = colors.red },

        IlluminatedWordText = { bg = colors.selection },
        IlluminatedWordRead = { bg = colors.selection },
        IlluminatedWordWrite = { bg = colors.selection },

        Include = { fg = colors.pink },
        Statement = { fg = colors.pink },
        Define = { fg = colors.pink },
        PreProc = { fg = colors.green },
        Keyword = { fg = colors.pink },
        Special = { fg = colors.red },
        Operator = { fg = colors.pink },
        Identifier = { fg = colors.fg },
        Exception = { fg = colors.pink, },

        -- Diff
        DiffAdd = { bg = darken(colors.bright_green, 0.15) },
        --DiffDelete = { fg = colors.bright_red },
        DiffDelete = { fg = colors.comment },
        DiffChange = { bg = darken(colors.comment, 0.15) },
        DiffText = { bg = darken(colors.comment, 0.50) },

        -- NvimTree
        NvimTreeFolderArrowOpen = { fg = colors.fg },
        NvimTreeFolderArrowClosed = { fg = colors.fg },
        NvimTreeGitNew = { fg = colors.green },
        NvimTreeGitDirty = { fg = colors.cyan },
        NvimTreeGitDeleted = { fg = colors.red },
        NvimTreeGitMerge = { fg = colors.orange },

        -- Neo-tree
        NeoTreeCursorLine = { bg = colors.selection },
        NeoTreeDirectoryIcon = { fg = colors.fg },
        NeoTreeGitAdded = { fg = colors.green },
        NeoTreeGitModified = { fg = colors.cyan },
        NeoTreeGitDeleted = { fg = colors.red },
        NeoTreeGitConflict = { fg = colors.orange },

        GitBlameVirtualText = { fg = darken(colors.white, 0.35), bg = darken(colors.black, 0.5) },

        -- lsp
        ['@type'] = { fg = colors.cyan, },
        ['@lsp.type.type'] = { fg = colors.cyan, italic = true },
        ['@type.builtin'] = { fg = colors.pink },
        ['@type.builtin.rust'] = { link = "@lsp.type.type" },
        ['@lsp.type.typeAlias'] = { link = '@lsp.type.type' },
        ['@lsp.type.class'] = { fg = colors.cyan },
        ['@lsp.typemod.class.defaultLibrary.cpp'] = { fg = colors.cyan, italic = true },
        ['@lsp.type.struct'] = { link = '@lsp.type.type' },
        ['@lsp.type.enum'] = { link = '@lsp.type.type' },
        ['@lsp.type.enumMember'] = { fg = colors.fg, italic = true },
        ['@lsp.type.interface'] = { link = '@lsp.type.type' },
        ['@lsp.mod.mutable.rust'] = { underline = true },

        ['@field'] = { fg = colors.fg },
        ['@lsp.type.property'] = { link = '@field' },

        ['@keyword.function'] = { fg = colors.pink },
        ['@function.builtin'] = {},

        ['@parameter'] = { fg = colors.orange, italic = true },
        ['@parameter.reference'] = { link = '@parameter' },
        ['@lsp.type.parameter'] = { link = '@parameter' },
        ['@variable.parameter'] = { link = '@parameter' },

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

        ['@character'] = { link = "@string" },
        ['@string.escape'] = { fg = colors.pink },

        ['@label'] = {},

        ['@property'] = {},
        ['@property.json'] = { fg = colors.cyan },

        ['@lsp.typemod.variable.defaultLibrary'] = { fg = colors.purple },
        ['@lsp.typemod.function.defaultLibrary'] = { fg = colors.cyan },

        ['@keyword.exception'] = { fg = colors.pink },

        -- Markdown
        ['@markup.raw'] = { link = 'Text' },
        ['@markup.raw.markdown_inline'] = { fg = colors.green },
        ['@markup.heading.1.markdown'] = { fg = colors.purple, bold = true },
        ['@markup.heading.2.markdown'] = { fg = colors.purple, bold = true },
        ['@markup.heading.3.markdown'] = { fg = colors.purple, bold = true },

        DiagnosticUnderlineError = { underline = false, undercurl = true, sp = colors.red },
        DiagnosticUnderlineWarn = { underline = false, undercurl = true, sp = colors.yellow },
        DiagnosticUnderlineInfo = { underline = false, undercurl = true, sp = colors.green },
        DiagnosticUnderlineHint = { underline = false, undercurl = true, sp = colors.cyan },

        CmpItemAbbr = { fg = colors.fg },
        CmpItemAbbrMatchFuzzy = { fg = colors.cyan },
        CmpItemKindFile = { fg = "#ffffff" },
        CmpItemKindModule = { fg = "#ffffff" },
        CmpItemKindNamespace = { fg = "#ac8fe4" },
        CmpItemKindPackage = { fg = "#ffffff" },
        CmpItemKindClass = { fg = "#ee9d28" },
        CmpItemKindMethod = { fg = "#b180d7" },
        CmpItemKindProperty = { fg = "#ffffff" },
        CmpItemKindField = { fg = "#75beff" },
        CmpItemKindConstructor = { fg = "#b180d7" },
        CmpItemKindEnum = { fg = "#ee9d28" },
        CmpItemKindInterface = { fg = "#75beff" },
        CmpItemKindFunction = { fg = "#b180d7" },
        CmpItemKindVariable = { fg = "#75beff" },
        CmpItemKindConstant = { fg = "#ffffff" },
        CmpItemKindString = { fg = "#ffffff" },
        CmpItemKindNumber = { fg = "#ffffff" },
        CmpItemKindBoolean = { fg = "#ffffff" },
        CmpItemKindArray = { fg = "#ffffff" },
        CmpItemKindObject = { fg = "#ffffff" },
        CmpItemKindKey = { fg = "#ffffff" },
        --CmpItemKindnull = { fg = "#ac8fe4" },
        CmpItemKindEnumMember = { fg = "#75beff" },
        CmpItemKindStruct = { fg = "#ac8fe4" },
        CmpItemKindEvent = { fg = "#ee9d28" },
        CmpItemKindOperator = { fg = "#ffffff" },
        CmpItemKindTypeParameter = { fg = "#ffffff" },

        DiffviewFolderSign = { link = "NvimTreeFolderIcon" },
        diffAdded = { fg = colors.green, bold = true },
        diffChanged = { fg = colors.cyan, bold = true },
        diffRemoved = { fg = colors.red, bold = true },

        BracketHighlightForeground1 = { fg = colors.fg },
        BracketHighlightForeground2 = { fg = colors.pink },
        BracketHighlightForeground3 = { fg = colors.cyan },
        BracketHighlightForeground4 = { fg = colors.green },
        BracketHighlightForeground5 = { fg = colors.purple },
        BracketHighlightForeground6 = { fg = colors.orange },

        -- dropbar.nvim
        DropBarIconKindFile = { fg = "#ffffff" },
        DropBarIconKindModule = { fg = "#ffffff" },
        DropBarIconKindPackage = { fg = "#ffffff" },
        DropBarIconKindClass = { fg = "#ee9d28" },
        DropBarIconKindMethod = { fg = "#b180d7" },
        DropBarIconKindProperty = { fg = "#ffffff" },
        DropBarIconKindField = { fg = "#75beff" },
        DropBarIconKindConstructor = { fg = "#b180d7" },
        DropBarIconKindEnum = { fg = "#ee9d28" },
        DropBarIconKindInterface = { fg = "#75beff" },
        DropBarIconKindFunction = { fg = "#b180d7" },
        DropBarIconKindVariable = { fg = "#75beff" },
        DropBarIconKindConstant = { fg = "#ffffff" },
        DropBarIconKindString = { fg = "#ffffff" },
        DropBarIconKindNumber = { fg = "#ffffff" },
        DropBarIconKindBoolean = { fg = "#ffffff" },
        DropBarIconKindArray = { fg = "#ffffff" },
        DropBarIconKindObject = { fg = "#ffffff" },
        DropBarIconKindKey = { fg = "#ffffff" },
        DropBarIconKindEnumMember = { fg = "#75beff" },
        DropBarIconKindStruct = { fg = "#ac8fe4" },
        DropBarIconKindEvent = { fg = "#ee9d28" },
        DropBarIconKindOperator = { fg = "#ffffff" },
        DropBarIconKindTypeParameter = { fg = "#ffffff" },
        --context_null = { fg = "#ac8fe4" },
        --context_namespace = { fg = "#ac8fe4" },

        -- nvim-treesitter-context
        TreesitterContextBottom = { underline = true, sp = "Grey" },
        TreesitterContextLineNumberBottom = { underline = true, sp = "Grey" },

        DapBreakpoint = { fg = "#dc1400" },

        -- Neogit
        -- NeogitDiffAdd = { fg = colors.bright_green, bg = colors.menu },
        -- NeogitDiffDelete = { fg = colors.bright_red, bg = colors.menu },
        -- NeogitDiffContext = { fg = colors.comment, bg = colors.visual },
        -- NeogitDiffAddHighlight = { fg = colors.green, bg = colors.bg },
        -- NeogitDiffDeleteHighlight = { fg = colors.red, bg = colors.bg },
        -- NeogitDiffContextHighlight = { fg = colors.comment, bg = colors.visual },
        -- NeogitDiffAddCursor = { fg = colors.green, bg = colors.selection },
        -- NeogitDiffDeleteCursor = { fg = colors.red, bg = colors.selection },
        -- NeogitDiffContextCursor = { fg = colors.comment, bg = colors.selection },
        NeogitDiffAdd = {},
        NeogitDiffDelete = {},
        NeogitDiffContext = {},
        NeogitDiffAddHighlight = {},
        NeogitDiffDeleteHighlight = {},
        NeogitDiffContextHighlight = {},
        NeogitDiffAddCursor = {},
        NeogitDiffDeleteCursor = {},
        NeogitDiffContextCursor = { link = "CursorLine" },
      }
    }

    vim.cmd [[colorscheme dracula]]
  end,
}
