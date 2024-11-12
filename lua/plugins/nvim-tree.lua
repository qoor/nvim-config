local function open_nvim_tree(data)

  -- buffer is a [No Name]
  local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1

  if not no_name and not directory then
    return
  end

  -- change to the directory
  if directory then
    vim.cmd.cd(data.file)
  end

  -- open the tree
  require("nvim-tree.api").tree.open()
end

local function my_on_attach(bufnr)
  local api = require("nvim-tree.api")

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent,        opts('Up'))
  vim.keymap.set('n', '?',     api.tree.toggle_help,                  opts('Help'))
end

local function root_label(path)
  return vim.fs.basename(path)
end

return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<leader>t", "<cmd>NvimTreeToggle<cr>", desc = "NvimTree" }
  },
  config = function()
    require("nvim-tree").setup {
      hijack_netrw = false,
      on_attach = my_on_attach,
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
          git_placement = "after"
        },
        root_folder_label = root_label,
        group_empty = root_label
      },
      diagnostics = {
        enable = true,
        show_on_dirs = true
      },
    }

    vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

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
  end,
}
