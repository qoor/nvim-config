return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "which-key.nvim",
    "neodev.nvim",
    "cmp-nvim-lsp"
  },
  config = function ()
    local lspconfig = require("lspconfig")
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    local servers = { "lua_ls", "rust_analyzer", "clangd" }

    local settings = {
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

    for _, server in pairs(servers) do
      Opts = { capabilities = capabilities }

      --server = vim.split(server, "@")[1]

      if settings[server] then
        Opts = vim.tbl_deep_extend("force", settings[server], Opts)
      end

      lspconfig[server].setup(Opts)
    end

    -- Use LspAttach autocommand to only map the following keys
    -- after the language server attaches to the current buffer
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

        local signs = {
          { name = "DiagnosticSignError", text = "" },
          { name = "DiagnosticSignWarn", text = "" },
          { name = "DiagnosticSignHint", text = "" },
          { name = "DiagnosticSignInfo", text = "" },
        }

        for _, sign in ipairs(signs) do
          vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
        end

        local config = {
          -- enable virtual text
          virtual_text = true,
          -- show signs
          signs = {
            active = signs,
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

        vim.diagnostic.config(config)

        local wk = require("which-key")
        wk.register({
          ["<leader>"] = {
            l = {
              name = "+lsp",

              a = {
                name = "+code actions",

                a = { vim.lsp.buf.code_action, "code actions" }
              },
              g = {
                name = "+goto",

                r = { vim.lsp.buf.references, "find references" },
                t = { vim.lsp.buf.type_definition, "find type definitions" }
              },
              r = {
                name = "+refactor",

                r = { vim.lsp.buf.rename, "rename" }
              },
              w = {
                name = "+workspaces",

                l = { function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "list workspace folders" }
              },
              ["="] = {
                name = "+formatting",

                ["="] = { function () vim.lsp.buf.format { async = true } end, "format buffer" }
              }
            }
          }
        }, { buffer = ev.buf })

      end,
    })

    local formatting_group = vim.api.nvim_create_augroup("LspFormatting", {})
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.rs",
      group = formatting_group,
      callback = function()
        vim.lsp.buf.format({ async = false })
      end
    })
  end
}
