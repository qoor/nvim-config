return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "which-key.nvim",
    "lazydev.nvim",
    "cmp-nvim-lsp",
    "Issafalcon/lsp-overloads.nvim",
    "MysticalDevil/inlay-hints.nvim",
  },
  config = function ()
    local lspconfig = require("lspconfig")
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    local servers = { "lua_ls", "rust_analyzer", "clangd", "cmake" }

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
        wk.add({
          buffer = ev.buf,

          { "<leader>l", group = "+lsp" },
          { "<leader>la", group = "+code actions" },
          { "<leader>laa", function () vim.lsp.buf.code_action() end, desc = "code actions" },
          { "<leader>lg", group = "+goto" },
          { "<leader>lgr", function () vim.lsp.buf.references() end, desc = "find references" },
          { "<leader>lgt", function () vim.lsp.buf.type_definition() end, desc = "find type definitions" },
          { "<leader>lr", group = "+refactor" },
          { "<leader>lrr", function () vim.lsp.buf.rename() end, desc = "rename" },
          { "<leader>lw", group = "+workspaces" },
          { "<leader>lwl",
            function()
              print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, desc = "list workspace folders" },
          { "<leader>lwr", "<cmd>LspRestart<cr>", desc = "restart language server" },
          { "<leader>l=", group = "+formatting" },
          { "<leader>l==", function () vim.lsp.buf.format { async = true } end, desc = "rename" },
        })

        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client then
          if client.supports_method("textDocument/signatureHelp") then
            require("lsp-overloads").setup(client, {
              keymaps = {
                close_signature = "<C-e>",
              }
            })
          end
          if client.supports_method("textDocument/inlayHint") then
            require("inlay-hints").on_attach(client, ev.buf)
          end
        end

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
