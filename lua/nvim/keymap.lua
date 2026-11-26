vim.keymap.set("n", "<C-h>", "<CMD>bp<CR>", { silent = true })
vim.keymap.set("n", "<C-l>", "<CMD>bn<CR>", { silent = true })
vim.keymap.set("n", "<C-`>", "<CMD>b#<CR>", { silent = true })

vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
-- herdr-sessionizer: fzf needs a terminal (`:!` has none), and a herdr tab would move
-- every attached client, so run the picker in an nvim terminal tab that closes when it exits.
-- vim.keymap.set("n", "<C-f>", function()
--     vim.cmd("tab terminal herdr-sessionizer")
--     vim.cmd("autocmd TermClose <buffer> ++once bdelete!")
--     vim.cmd("startinsert")
-- end)

vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<ESC>h", "<cmd>silent !tmux neww tmux-sessionizer -s 0<CR>")
