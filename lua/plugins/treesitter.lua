return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter").setup({
            ensure_installed = { "lua", "typescript", "javascript", "rust", "sql", "angular", "python", "cpp", "c" },
        })
    end
}
