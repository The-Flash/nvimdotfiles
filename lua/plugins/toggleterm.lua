return {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        require("toggleterm").setup({
            open_mapping = [[<C-t>]],
            direction = "float",
            float_opts = {
                border = "curved",
            },
        })

        -- Open file path (with optional :line:col) under cursor from terminal output.
        -- gF handles "file:line" format natively; <C-\><C-n> exits terminal mode first.
        vim.api.nvim_create_autocmd("TermOpen", {
            pattern = "term://*toggleterm*",
            callback = function(ev)
                local opts = { buffer = ev.buf, silent = true }
                -- terminal mode: exit to normal, then open file+line
                vim.keymap.set("t", "gf", [[<C-\><C-n>gF]], opts)
                -- normal mode: in case the user has already exited terminal mode
                vim.keymap.set("n", "gf", "gF", opts)
            end,
        })
    end,
}
