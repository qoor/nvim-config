-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

--vim.cmd("language en_US")

vim.opt.number = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.expandtab = true

vim.opt.showmatch = true

vim.opt.title = true
vim.opt.titlestring = [[%t%m (%F)]]

vim.opt.termguicolors = true

vim.opt.mouse = "a"

vim.opt.cmdheight = 2

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

-- Don't pass messages to |ins-completion-menu|.
vim.opt.shortmess:append("c")

vim.opt.cursorline = true

vim.opt.exrc = true

vim.opt.cino = "N-s,g0"

-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
vim.opt.updatetime = 50

if vim.env.SSH_TTY then
  vim.g.clipboard = "osc52"
end

-- Detect Korean encoding
vim.o.fileencodings = "ucs-bom,utf-8,cp949,default,latin9"

-- Save undo history
vim.o.undofile = true

vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:,diff:╱]]
vim.o.foldcolumn = '1'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.foldminlines = 1

vim.o.wrap = false

-- Enable spell when opening Markdown file
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.md", "*.markdown" },
  callback = function()
    vim.opt_local.spell = true
  end,
})
