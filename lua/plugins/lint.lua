return {
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            local lint = require("lint")

            lint.linters_by_ft = {
                javascript = { "eslint_d" },
                typescript = { "eslint_d" },
                javascriptreact = { "eslint_d" },
                typescriptreact = { "eslint_d" },
            }

            -- Ensure eslint_d is installed via Mason
            local ok, registry = pcall(require, "mason-registry")
            if ok then
                registry.refresh(function()
                    if not registry.is_installed("eslint_d") then
                        vim.cmd("MasonInstall eslint_d")
                    end
                end)
            end

            vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
                group = vim.api.nvim_create_augroup("nvim_lint", { clear = true }),
                callback = function()
                    local supported = {
                        javascript = true,
                        typescript = true,
                        javascriptreact = true,
                        typescriptreact = true,
                    }
                    if supported[vim.bo.filetype] then
                        lint.try_lint()
                    end
                end,
            })
        end,
    },
}
