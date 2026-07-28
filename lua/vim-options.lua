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

-- Folding (required by nvim-ufo)
vim.o.foldcolumn = "1"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Auto-reload files changed outside Neovim.
vim.o.autoread = true

local uv = vim.uv or vim.loop
local autoread_group = vim.api.nvim_create_augroup("autoread_watch", { clear = true })
local watchers = {}

local stop_watcher
local start_watcher

local function is_regular_file_buffer(bufnr)
    if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) then
        return false
    end

    if vim.bo[bufnr].buftype ~= "" then
        return false
    end

    local name = vim.api.nvim_buf_get_name(bufnr)
    if name == "" then
        return false
    end

    local stat = uv.fs_stat(name)
    return stat ~= nil and stat.type == "file"
end

local function checktime_buffer(bufnr)
    if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) then
        stop_watcher(bufnr)
        return
    end

    if vim.bo[bufnr].modified then
        return
    end

    vim.cmd(("silent! checktime %d"):format(bufnr))
end

local function watch_path(bufnr)
    local name = vim.api.nvim_buf_get_name(bufnr)
    local real = uv.fs_realpath(name)
    return real or vim.fn.fnamemodify(name, ":p")
end

stop_watcher = function(bufnr)
    local state = watchers[bufnr]
    if not state then
        return
    end

    watchers[bufnr] = nil

    if state.handle then
        pcall(function()
            state.handle:stop()
        end)
        pcall(function()
            state.handle:close()
        end)
    end
end

local function start_poll_watcher(bufnr, path)
    local handle = uv.new_fs_poll()
    if not handle then
        return
    end

    local state = {
        handle = handle,
        path = path,
        kind = "fs_poll",
    }
    watchers[bufnr] = state

    local ok = pcall(function()
        handle:start(path, 200, vim.schedule_wrap(function(err)
            if watchers[bufnr] ~= state then
                return
            end

            if err then
                stop_watcher(bufnr)
                return
            end

            checktime_buffer(bufnr)
        end))
    end)

    if not ok then
        stop_watcher(bufnr)
    end
end

start_watcher = function(bufnr)
    stop_watcher(bufnr)

    if not is_regular_file_buffer(bufnr) then
        return
    end

    local path = watch_path(bufnr)
    local handle = uv.new_fs_event()
    if not handle then
        start_poll_watcher(bufnr, path)
        return
    end

    local state = {
        handle = handle,
        path = path,
        kind = "fs_event",
    }
    watchers[bufnr] = state

    local ok = pcall(function()
        handle:start(path, {}, vim.schedule_wrap(function(err, _, events)
            if watchers[bufnr] ~= state then
                return
            end

            if err then
                stop_watcher(bufnr)
                start_poll_watcher(bufnr, path)
                return
            end

            checktime_buffer(bufnr)

            local current_path = watch_path(bufnr)
            if current_path ~= state.path or (events and events.rename) then
                start_watcher(bufnr)
            end
        end))
    end)

    if not ok then
        stop_watcher(bufnr)
        start_poll_watcher(bufnr, path)
    end
end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufFilePost", "BufWritePost" }, {
    group = autoread_group,
    callback = function(args)
        start_watcher(args.buf)
    end,
})

vim.api.nvim_create_autocmd({ "BufUnload", "BufDelete", "BufWipeout" }, {
    group = autoread_group,
    callback = function(args)
        stop_watcher(args.buf)
    end,
})

-- Keep a lightweight fallback for environments where file watcher events are missed.
vim.api.nvim_create_autocmd("FocusGained", {
    group = autoread_group,
    pattern = "*",
    callback = function()
        if vim.fn.mode() ~= "c" then
            vim.cmd("silent! checktime")
        end
    end,
})

for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    start_watcher(bufnr)
end
