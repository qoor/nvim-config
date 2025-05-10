vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })

vim.g.mapleader = " "

vim.keymap.set("n", "<C-h>", "<CMD>bp<CR>", { silent = true })
vim.keymap.set("n", "<C-l>", "<CMD>bn<CR>", { silent = true })
vim.keymap.set("n", "<C-`>", "<CMD>b#<CR>", { silent = true })
vim.keymap.set("n", "<esc>", "<CMD>:nohl<CR>", { silent = true, noremap = true })

--vim.keymap.set("n", "<C-d>", "<CMD>b# <BAR> bd #<CR>", { silent = true })
