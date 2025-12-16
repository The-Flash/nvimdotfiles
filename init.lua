-- Bootstap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)
require("vim-options")
require("keymaps")
require("lazy").setup("plugins")

-- Null LS
local null_ls = require("null-ls")
null_ls.setup({
    dependencies = {
        "nvimtools/none-ls-extras.nvim"
    },
    sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.prettier,
    },
})
vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})

-- Diagnostics
vim.diagnostic.config({
  virtual_text = {
    source = "always",
    prefix = "●",      -- could be "■", "▎", "x"
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

