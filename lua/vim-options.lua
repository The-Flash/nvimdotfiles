-- Compatibility shims for Neovim 0.12: nvim-treesitter.parsers/configs were removed
package.preload["nvim-treesitter.parsers"] = function()
    return {
        ft_to_lang = function(ft)
            local ok, lang = pcall(vim.treesitter.language.get_lang, ft)
            return (ok and lang) or ft
        end,
        get_parser = function(bufnr, lang)
            return vim.treesitter.get_parser(bufnr, lang)
        end,
    }
end

package.preload["nvim-treesitter.configs"] = function()
    return {
        is_enabled = function(module, lang, bufnr)
            if module == "highlight" then
                local ok, parser = pcall(vim.treesitter.get_parser, bufnr, lang)
                return ok and parser ~= nil
            end
            return false
        end,
        get_module = function(_)
            return { additional_vim_regex_highlighting = false }
        end,
    }
end

vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set number")
vim.cmd("set relativenumber")
vim.o.clipboard = "unnamedplus"
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>sf", ":w<enter>", { desc = "Save current buffer" })
