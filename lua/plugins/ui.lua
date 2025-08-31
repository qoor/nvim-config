return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",

    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,

    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },

  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        offsets = {
          {
            filetype = "neo-tree",
            text = "EXPLORER",
            highlight = " ",
            separator = true
          }
        }
      }
    }
  },

  {
    "Bekaboo/dropbar.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make"
      },
    },
    config = function()
      local dropbar_api = require('dropbar.api')
      vim.keymap.set('n', '<Leader>;', dropbar_api.pick, { desc = 'Pick symbols in winbar' })
      vim.keymap.set('n', '[;', dropbar_api.goto_context_start, { desc = 'Go to start of current context' })
      vim.keymap.set('n', '];', dropbar_api.select_next_context, { desc = 'Select next context' })

      local configs = require("dropbar.configs")
      configs.opts.icons.kinds.dir_icon = nil
    end
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", },
    opts = {
      extensions = { "neo-tree", "toggleterm", "nvim-dap-ui", "trouble" }
    }
  },

  {
    "RRethy/vim-illuminate",
    config = function()
      require("illuminate").configure({
        providers = {
          "lsp",
          "treesitter"
        }
      })
    end
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = { char = "▏" }
    }
  },

  {
    "lukas-reineke/virt-column.nvim",
    opts = {}
  },

  {
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
  },

  {
    "nvim-telescope/telescope.nvim",

    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/which-key.nvim",
    },

    opts = {
      defaults = {
        path_display = { "filename_first" },
      },
    },

    config = function(_, opts)
      require("telescope").setup(opts)

      require("which-key").add({
        { "<leader>f", group = "+file" },
        { "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>", desc = "find files" },
        { "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>", desc = "live grep" },
        { "<leader>fb", "<cmd>lua require('telescope.builtin').buffer()<cr>", desc = "buffers" },
        { "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>", desc = "help tags" },
      })
    end
  },

  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      "nvim-treesitter/nvim-treesitter",
      "neovim/nvim-lspconfig",
    },
    opts = {},
    config = function(_, opts)
      require("ufo").setup(opts)

      vim.keymap.set("n", "zR", require("ufo").openAllFolds)
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
      vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
      vim.keymap.set("n", "zm", require("ufo").closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "nvcheatsheet", "neo-tree", "NeogitStatus" },
        callback = function()
          require("ufo").detach()
          vim.opt_local.foldenable = false
          vim.opt_local.foldcolumn = '0'
        end
      })
    end
  },

  {
    "luukvbaal/statuscol.nvim",
    config = function()
      local builtin = require("statuscol.builtin")
      require("statuscol").setup({
        setopt = true,
        ft_ignore = { "neo-tree", "neotree", "NeogitStatus" },
        -- override the default list of segments with:
        -- number-less fold indicator, then signs, then line number & separator
        segments = {
          {
            sign = { namespace = { "diagnostic" }, maxwidth = 1 },
            click = "v:lua.ScSa"
          },
          {
            text = { builtin.lnumfunc },
            condition = { true, builtin.not_empty },
            click = "v:lua.ScLa",
          },
          {
            sign = { namespace = { "gitsign" }, maxwidth = 1, colwidth = 1 },
            click = "v:lua.ScSa"
          },
          { text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" },
          {
            sign = { name = { ".*" }, maxwidth = 1, colwidth = 1, auto = true },
            click = "v:lua.ScSa"
          },
        },
      })
    end,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    lazy = false, -- neo-tree will lazily load itself
    keys = {
      { "<leader>t", "<cmd>Neotree toggle<cr>", desc = "Neo-tree" }
    },
    ---@module 'neo-tree'
    ---@type neotree.Config
    opts = {
      close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
      open_files_do_not_replace_types = { "terminal", "trouble", "qf" }, -- when opening files, do not use windows containing these filetypes or buftypes
      default_component_configs = {
        indent = {
          indent_marker = "│",
          -- last_indent_marker = "└",
          last_indent_marker = "",
          with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
        },
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "",
          folder_empty_open = "",
          provider = function(icon, node, state) -- default icon provider utilizes nvim-web-devicons if available
            if node.type == "file" or node.type == "terminal" then
              local success, web_devicons = pcall(require, "nvim-web-devicons")
              local name = node.type == "terminal" and "terminal" or node.name
              if success then
                local devicon, hl = web_devicons.get_icon(name)
                icon.text = devicon or icon.text
                icon.highlight = hl or icon.highlight
              end
            end
          end,
          default = "*",
        },
        symlink_target = { enabled = true }
      },
      window = {
        position = "left",
        width = 35,
        mappings = {
          ["<cr>"] = "open_with_window_picker",
        }
      },
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          show_hidden_count = false,
          never_show = {
            ".git",
            ".DS_Store"
          }
        },
        follow_current_file = {
          enabled = false, -- This will find and focus the file in the active buffer every time
          --               -- the current file is changed while the tree is open.
        },
        group_empty_dirs = true, -- when true, empty folders will be grouped together
        use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
      },
    },
  },
  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neo-tree/neo-tree.nvim", -- makes sure that this loads after Neo-tree.
    },
    config = function()
      require("lsp-file-operations").setup()
    end,
  },
  {
    "s1n7ax/nvim-window-picker",
    version = "2.*",
    config = function()
      require("window-picker").setup({
        filter_rules = {
          include_current_win = false,
          autoselect_one = true,
          -- filter using buffer options
          bo = {
            -- if the file type is one of following, the window will be ignored
            filetype = { "neo-tree", "neo-tree-popup", "notify" },
            -- if the buffer type is one of following, the window will be ignored
            buftype = { "terminal", "quickfix" },
          },
        },
      })
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    -- load cmp on InsertEnter
    event = "InsertEnter",
    -- these dependencies will only be loaded when cmp loads
    -- dependencies are always lazy-loaded unless specified otherwise
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp",
      },

      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind.nvim",
      "folke/lazydev.nvim",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- local function has_words_before()
      --   unpack = unpack or table.unpack
      --   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      --   return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      -- end

      cmp.setup({
        snippet = {
          expand = function(args)
            -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            luasnip.lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-m>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
              -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
              -- they way you will only jump inside the snippet region
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            -- elseif has_words_before() then
            --   cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),

        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' }, -- For luasnip users.
          -- { name = 'ultisnips' }, -- For ultisnips users.
          -- { name = 'snippy' }, -- For snippy users.
        }, {
          { name = 'buffer' },
          { name = 'lazydev', group_index = 0 }
        }),


        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            return require("lspkind").cmp_format({ mode = "symbol", preset = "codicons" })(entry, vim_item)
          end,
        },
      })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })
    end
  }
}
