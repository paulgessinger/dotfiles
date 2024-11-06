-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-p>", builtin.find_files, {})
vim.keymap.set("n", ";", builtin.buffers, {})

vim.keymap.set("n", "<leader>qa", vim.lsp.buf.code_action)
vim.keymap.set("n", "gl", vim.diagnostic.open_float, {})

vim.keymap.del("n", "<S-h>")
vim.keymap.del("n", "<S-l>")
