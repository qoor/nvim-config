vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.cindent = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)
