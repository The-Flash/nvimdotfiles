return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local opts = {
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
        telescope.setup(opts)
        local gitworktree = require("git-worktree")
        gitworktree.setup()
        telescope.load_extension("ui-select")
        telescope.load_extension("git_worktree")

        local builtin = require("telescope.builtin")

        vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
        vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Telescope find files" })
        vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
    end
}
