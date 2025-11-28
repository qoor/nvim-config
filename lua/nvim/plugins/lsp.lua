return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings

  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      -- options
    },
  },

  {
    "ray-x/lsp_signature.nvim",
    event = "InsertEnter",
    opts = {
      bind = true,
      hint_enable = false,
      max_height = 64,
      handler_opts = {
        border = "single"   -- double, rounded, single, shadow, none, or a table of borders
      },
    },
  },

  {
    "nvimdev/lspsaga.nvim",
    dependencies = { "neovim/nvim-lspconfig", },
    opts = {
      lightbulb = { sign = false, virtual_text = true, sign_priority = 60 },
      rename = {
        in_select = false,
        keys = {
          quit = "<C-c>"
        }
      },
      symbol_in_winbar = { enable = false }
    },
    config = function(_, opts)
      require("lspsaga").setup(opts)

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(ev)
          require("which-key").add({
            buffer = ev.buf,

            { "<leader>laa", "<cmd>:Lspsaga code_action<cr>", desc = "code actions" },
            { "<leader>lrr", "<cmd>:Lspsaga rename<cr>", desc = "rename" },
            { "<leader>lgh", "<cmd>:Lspsaga incoming_calls<cr>", desc = "show incoming call hierarchy" },
            { "<leader>lgo", "<cmd>:Lspsaga outgoing_calls<cr>", desc = "show outgoing call hierarchy" },
          })
        end
      })
    end
  },

  {
    "mason-org/mason.nvim",
    opts = {}
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "which-key.nvim",
      "lazydev.nvim",
      "cmp-nvim-lsp",
      "conform.nvim",
      --"Issafalcon/lsp-overloads.nvim",
      "MysticalDevil/inlay-hints.nvim",
      "nvim-telescope/telescope.nvim"
    },
    config = function()
      local capabilities = vim.tbl_deep_extend(
        "force", {},
        vim.lsp.protocol.make_client_capabilities(),
        require('cmp_nvim_lsp').default_capabilities())

      local servers = {
        clangd = {
          cmd = { "clangd", "--background-index", "--completion-style=detailed", "--clang-tidy" }
        },
        cmake = {},

        gopls = {},

        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace"
              }
            }
          }
        },
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = {
                command = "clippy"
              }
            }
          }
        }
      }

      for server, opts in pairs(servers) do
        opts.capabilities = capabilities
        vim.lsp.config(server, opts)
        vim.lsp.enable(server)
      end

      local diagnostic_config = {
        -- enable virtual text
        virtual_text = { prefix = "" },
        -- show signs
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "",
            [vim.diagnostic.severity.INFO] = "",
          },
        },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
          suffix = "",
        },
      }

      vim.diagnostic.config(diagnostic_config)

      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local builtin = require("telescope.builtin")

          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', builtin.lsp_definitions, opts)
          --vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gi', builtin.lsp_implementations, opts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('n', 'gr', builtin.lsp_references, opts)

          require("which-key").add({
            buffer = ev.buf,

            { "<leader>l",   group = "+lsp" },

            { "<leader>la",  group = "+code actions" },
            { "<leader>laa", function() vim.lsp.buf.code_action() end, desc = "code actions" },

            { "<leader>lg",  group = "+goto" },
            { "<leader>lga", function() builtin.lsp_dynamic_workspace_symbols() end, desc = "find all meaningful symbols" },
            { "<leader>lgr", function() builtin.lsp_references() end, desc = "find references" },
            { "<leader>lgt", function() builtin.lsp_type_definitions() end, desc = "find type definitions" },

            { "<leader>lr",  group = "+refactor" },
            { "<leader>lrr", function() vim.lsp.buf.rename() end, desc = "rename" },

            { "<leader>lw",  group = "+workspaces" },
            { "<leader>lwd", "<cmd>LspInfo<cr>", desc = "describe current language server" },
            { "<leader>lwl",
              function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, desc = "list workspace folders" },
            { "<leader>lwq", "<cmd>LspStop<cr>", desc = "stop language server" },
            { "<leader>lwr", "<cmd>LspRestart<cr>", desc = "restart language server" },
            { "<leader>lws", "<cmd>LspStart<cr>", desc = "start language server" },

            { "<leader>l=",  group = "+formatting" },
            { "<leader>l==",
              function() require("conform").format { lsp_fallback = true, async = false, timeout_ms = 500 } end,
              desc = "format", mode = { "n", "v" } },
          })

          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client and client:supports_method("textDocument/inlayHint") then
            require("inlay-hints").on_attach(client, ev.buf)
          end
        end,
      })

      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.rs",
        group = vim.api.nvim_create_augroup("LspFormatting", {}),
        callback = function() vim.lsp.buf.format({ async = false }) end
      })
    end
  }
}
