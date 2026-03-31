vim.keymap.set("n", "<C-h>", "<CMD>bp<CR>", { silent = true })
vim.keymap.set("n", "<C-l>", "<CMD>bn<CR>", { silent = true })
vim.keymap.set("n", "<C-`>", "<CMD>b#<CR>", { silent = true })

vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lprev<CR>zz")
