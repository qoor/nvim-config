vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })

vim.g.mapleader = " "

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>d", "\"_d")

vim.keymap.set("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("n", "<C-h>", "<CMD>bp<CR>", { silent = true })
vim.keymap.set("n", "<C-l>", "<CMD>bn<CR>", { silent = true })
vim.keymap.set("n", "<C-`>", "<CMD>b#<CR>", { silent = true })
vim.keymap.set("n", "<esc>", "<CMD>:nohl<CR>", { silent = true, noremap = true })

--vim.keymap.set("n", "<C-d>", "<CMD>b# <BAR> bd #<CR>", { silent = true })
