vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set number")

vim.g.mapleader = " "

-- Bootstap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
        local lazyrepo = "https://github.com/folke/lazy.nvim.git"
        local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
        if vim.v.shell_error ~= 0 then
                vim.api.nvim_echo({
                        { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
                        { out, "WarningMsg" },
                        { "\nPress any key to exit..." },
                }, true, {})
                vim.fn.getchar()
                os.exit(1)
        end
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
        {
                "nvim-telescope/telescope.nvim",
                tag = "0.1.8",
                dependencies = { "nvim-lua/plenary.nvim" },
        },
        { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
        {
                "nvim-lualine/lualine.nvim",
                dependencies = { "nvim-tree/nvim-web-devicons" },
        },
        {
                "mason-org/mason.nvim",
                opts = {},
        },
        {
                "mason-org/mason-lspconfig.nvim",
                opts = {
                        ensure_installed = { "lua_ls", "rust_analyzer", "ts_ls" },
                },
                dependencies = {
                        { "mason-org/mason.nvim", opts = {} },
                        "neovim/nvim-lspconfig",
                },
        },
        {
                "https://github.com/neovim/nvim-lspconfig",
        },
        {
                "nvim-telescope/telescope-ui-select.nvim",
        },
        {
                "nvimtools/none-ls.nvim",
        },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
    },
    {
        "L3MON4D3/LuaSnip",
    },
   {
        "nvimtools/none-ls-extras.nvim",
    }
}
local opts = {}

require("lazy").setup(plugins, opts)
local telescopeOpts = {
        defaults = {
                file_ignore_patterns = {
                        "node_modules/",
                        "target/",
                        "%.git/",
                        "%.env",
                },
        },
        extensions = {
                ["ui-select"] = {
                        require("telescope.themes").get_dropdown({}),
                },
        },
}
local telescope = require("telescope")
telescope.setup(telescopeOpts)
telescope.load_extension("ui-select")

local builtin = require("telescope.builtin")

require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "typescript", "javascript", "rust", "sql", "angular", "python" },
        highlight = {
                enable = true,
        },
})

require("lualine").setup({
        options = {
                icons_enabled = true,
                theme = "auto",
        },
})

-- LSP Config
vim.lsp.enable("lua_ls")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("ts_ls")
vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})

-- Null LS
local null_ls = require("null-ls")
null_ls.setup({
    dependencies = {
        "nvimtools/none-ls-extras.nvim"
    },
        sources = {
                null_ls.builtins.formatting.stylua,
                null_ls.builtins.formatting.prettier,
        null_ls.builtins.code_actions.gitsigns,
        },
})
vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})

-- Keymaps
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>sf", ":w<enter>", { desc = "Save current buffer"})
