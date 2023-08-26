return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "neodev.nvim",
    "cmp-nvim-lsp"
  },
  config = function ()
    local lspconfig = require("lspconfig")
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    lspconfig.lua_ls.setup {
      settings = {
        Lua = {
          completion = {
            callSnippet = "Replace"
          }
        }
      }
    }

    lspconfig.rust_analyzer.setup {
      capabilities = capabilities,
      settings = {
        ['rust-analyzer'] = {},
      },
    }

    lspconfig.clangd.setup {
      capabilities = capabilities
    }

    -- Use LspAttach autocommand to only map the following keys
    -- after the language server attaches to the current buffer
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = ev.buf, })
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = ev.buf, })
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = ev.buf })
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = ev.buf })
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { buffer = ev.buf })
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = ev.buf })

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
  end
}
