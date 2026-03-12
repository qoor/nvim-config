local usergroup = vim.api.nvim_create_augroup('UserDefined', {})

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

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('HighlightYank', {}),
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',
      timeout = 40,
    })
  end,
})

-- vim.api.nvim_create_autocmd({"BufWritePre"}, {
--   group = usergroup,
--   pattern = "*",
--   command = [[%s/\s\+$//e]],
-- })
