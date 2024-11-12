return {
  "stevearc/conform.nvim",

  event = { "BufWritePre" },
  cmd = { "ConformInfo" },

  config = function()
    local util = require("conform.util")

    require("conform").setup({
      formatters_by_ft = {
        c = { "clang-format" },
        cpp = { "clang-format" },
        lua = { "stylua" },
      },

      -- format_on_save = function(bufnr)
      --   -- Disable "format_on_save lsp_fallback" for languages that don't
      --   -- have a well standardized coding style. You can add additional
      --   -- languages here or re-enable it for the disabled ones.
      --   local disable_filetypes = { c = true, cpp = true }
      --   return {
      --     timeout_ms = 500,
      --     lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
      --   }
      -- end,

      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        -- local disable_filetypes = { c = true, cpp = true }
        -- return { timeout_ms = 500, lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype] }
        return { timeout_ms = 500, lsp_fallback = false }
      end,

      formatters = {
        ["clang-format"] = {
          cwd = util.root_file({ ".editorconfig", ".clang-format" }),
          require_cwd = true
        }
      }

    })
  end,

  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, {
      desc = "Disable autoformat-on-save",
      bang = true,
    })
    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
      desc = "Re-enable autoformat-on-save",
    })
  end
}
