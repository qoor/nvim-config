-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

--vim.cmd("language en_US")

vim.opt.number = true
vim.opt.numberwidth = 6

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.showmatch = true

vim.opt.title = true
vim.opt.titlestring = [[%t%m (%F)]]

vim.opt.termguicolors = true

vim.opt.mouse = "a"

vim.opt.cmdheight = 2

vim.opt.signcolumn = "yes"

-- Don't pass messages to |ins-completion-menu|.
vim.opt.shortmess:append("c")

vim.opt.cursorline = true

vim.opt.exrc = true

vim.opt.cino = "N-s,g0"

vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
vim.opt.updatetime = 150

-- Share the clipboard between OS and neovim
vim.opt.clipboard = "unnamedplus"
