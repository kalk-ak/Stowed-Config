-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Set a keymap for 'Y' to yank the entire line to the system clipboard
vim.keymap.set("n", "Y", '"+yyy"', { desc = "Yank Line to System Clipboard" })

-- Visual mode: Y copies selection to system clipboard (like `y`)
vim.keymap.set("v", "Y", '"+y', { desc = "Yank selection to system clipboard" })
