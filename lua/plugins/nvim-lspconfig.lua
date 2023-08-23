return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "neodev.nvim"
  },
  config = function ()
    local lspconfig = require("lspconfig")

    lspconfig.lua_ls.setup {
      settings = {
        Lua = {
          completion = {
            callSnippet = "Replace"
          }
        }
      },
      on_init = function(client)
        local path = client.workspace_folders[1].name
        if not vim.loop.fs_stat(path..'/.luarc.json') and not vim.loop.fs_stat(path..'/.luarc.jsonc') then
          client.config.settings = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
              version = 'LuaJIT'
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
              library = { vim.env.VIMRUNTIME }
              -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
              -- library = vim.api.nvim_get_runtime_file("", true)
            }
          })

          client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
        end
        return true
      end
    }

    lspconfig.rust_analyzer.setup {
      settings = {
        ['rust-analyzer'] = {},
      },
    }

    lspconfig.clangd.setup {}

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
