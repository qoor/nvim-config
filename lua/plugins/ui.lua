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
            filetype = "NvimTree",
            text = " ",
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
      extensions = { "nvim-tree" }
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
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons", },
    keys = {
      { "<leader>t", "<cmd>NvimTreeToggle<cr>", desc = "NvimTree" }
    },
    opts = {
      hijack_netrw = false,
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- default mappings
        api.config.mappings.default_on_attach(bufnr)

        -- custom mappings
        vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent,        opts('Up'))
        vim.keymap.set('n', '?',     api.tree.toggle_help,                  opts('Help'))

      end,
      sync_root_with_cwd = true,
      filters = {
        git_ignored = false,
        custom = { "^.git$" }
      },
      renderer = {
        highlight_git = true,
        indent_markers = {
          enable = true,
          icons = {
            corner = "╵"
          }
        },
        icons = {
          show = {
            folder = false
          },
          glyphs = {
            folder = {
              arrow_closed = "",
              arrow_open = "",
            }
          },
          git_placement = "after"
        },
        root_folder_label = vim.fs.basename,
        group_empty = vim.fs.basename,
      },
      diagnostics = {
        enable = true,
        show_on_dirs = true
      },
    },
    config = function(_, opts)
      require("nvim-tree").setup(opts)

      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function(data)
          -- buffer is a directory
          local directory = vim.fn.isdirectory(data.file) == 1

          if not directory then
            return
          end

          -- delete directory buffer and set buffer on the main window
          local wins = vim.api.nvim_list_wins()
          for _, w in ipairs(wins) do
            if vim.api.nvim_win_get_config(w).relative == '' then
              local buf = vim.api.nvim_win_get_buf(w)

              -- create a new, empty buffer
              local new_buf = vim.api.nvim_create_buf(true, false)

              vim.api.nvim_win_set_buf(w, new_buf)
              pcall(vim.api.nvim_buf_delete, buf, { force = true })
            end
          end

          -- change to the directory
          vim.cmd.cd(data.file)

          -- open the tree
          require("nvim-tree.api").tree.open()
        end
      })

      vim.api.nvim_create_autocmd("QuitPre", {
        callback = function()
          local tree_wins = {}
          local floating_wins = {}
          local wins = vim.api.nvim_list_wins()
          for _, w in ipairs(wins) do
            local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
            if bufname:match("NvimTree_") ~= nil then
              table.insert(tree_wins, w)
            end
            if vim.api.nvim_win_get_config(w).relative ~= '' then
              table.insert(floating_wins, w)
            end
          end
          if 1 == #wins - #floating_wins - #tree_wins then
            -- Should quit, so we close all invalid windows.
            for _, w in ipairs(tree_wins) do
              vim.api.nvim_win_close(w, true)
            end
          end
        end
      })
      vim.api.nvim_create_autocmd("BufEnter", {
        nested = true,
        callback = function()
          local api = require('nvim-tree.api')

          -- Only 1 window with nvim-tree left: we probably closed a file buffer
          if #vim.api.nvim_list_wins() == 1 and api.tree.is_tree_buf() then
            -- Required to let the close event complete. An error is thrown without this.
            vim.defer_fn(function()
              -- close nvim-tree: will go to the last hidden buffer used before closing
              api.tree.toggle({find_file = true, focus = true})
              -- re-open nivm-tree
              api.tree.toggle({find_file = true, focus = true})
              -- nvim-tree is still the active window. Go to the previous window.
              vim.cmd("wincmd p")
            end, 0)
          end
        end
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
