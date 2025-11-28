vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })

vim.g.mapleader = " "

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without copy" })
vim.keymap.set({ "n", "v" }, "<leader>e", "\"_d", { desc = "Delete without copy" })

vim.keymap.set("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word" })

vim.keymap.set("n", "<esc>", "<CMD>:nohl<CR>", { silent = true, noremap = true })
