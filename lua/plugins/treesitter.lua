return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "lua", "typescript", "javascript", "rust", "sql", "angular", "python" },
            highlight = {
                enable = true,
            },
        })
    end
}
