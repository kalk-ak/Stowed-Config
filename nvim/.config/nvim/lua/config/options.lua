-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.relativenumber = true

-- Set tab-related options
vim.opt.expandtab = false -- Use real tab characters
vim.opt.tabstop = 4 -- A tab is 4 columns wide
vim.opt.shiftwidth = 4 -- Indent by 4 columns for auto-indent

-- Disable the mouse in insert mode
vim.opt.mouse = "nvc"

-- Make the clipboard of the system and Neovim different
vim.o.clipboard = ""

-- Set spelling checkeing options
vim.opt.spell = true
vim.opt.spelllang = "en_us" -- Or "en_gb", "de", "fr", etc.

vim.o.scrolloff = 10
