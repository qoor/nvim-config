  vim.keymap.set("n", "<C-h>", "<CMD>bp<CR>", { silent = true })
  vim.keymap.set("n", "<C-l>", "<CMD>bn<CR>", { silent = true })
  vim.keymap.set("n", "<C-`>", "<CMD>b#<CR>", { silent = true })

  vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
