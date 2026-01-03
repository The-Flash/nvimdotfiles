vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>")

-- Splits
vim.keymap.set("n", "<leader>sv", "<C-w>v") -- split window vertically
vim.keymap.set("n", "<leader>sh", "<C-w>s") -- split
vim.keymap.set("n", "<leader>se", "<C-w>=") -- make split windows equal width & height
vim.keymap.set("n", "<leader>sx", ":close<CR>") -- close current split window
-- navigate between splits
vim.keymap.set("n", "<C-h>", "<C-w>h") -- move to left split
vim.keymap.set("n", "<C-j>", "<C-w>j") -- move to bottom split
vim.keymap.set("n", "<C-k>", "<C-w>k") -- move to top split
vim.keymap.set("n", "<C-l>", "<C-w>l") -- move to right split
