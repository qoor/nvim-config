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

if vim.env.SSH_TTY then
  vim.g.clipboard = "osc52"
end

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)

-- Detect Korean encoding
vim.o.fileencodings = "ucs-bom,utf-8,cp949,default,latin9"

-- Save undo history
vim.o.undofile = true
