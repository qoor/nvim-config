local function open_nvim_tree(data)
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
          glyphs = {
            folder = {
              arrow_closed = "",
              arrow_open = "",
            }
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
}
