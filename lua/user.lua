if not vim.g.vscode then
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)

  require("config")
  require("keymap")

  require("lazy").setup("plugins",
  {
    install = { colorscheme = { "dracula" } },
    checker = {
      enabled = true,
      check_pinned = true
    },
    change_detection = { notify = false }
  })
else
  vim.opt.cino = "N-s,g0"

  vim.opt.ignorecase = true
  vim.opt.smartcase = true

  -- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
  -- delays and poor user experience.
  vim.opt.updatetime = 150

  -- Share the clipboard between OS and neovim
  vim.opt.clipboard = "unnamedplus"
  
  vim.keymap.set("t", "<ESC>", "<C-\\><C-n>", { noremap = true })
end
