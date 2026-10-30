local M = {}

function M.setup(worktree)
    -- The plugin's create function fetches, sets an upstream, and rebases before
    -- switching. A failed fetch leaves a successfully created worktree behind.
    -- Keep Telescope's picker, but create locally and switch only on success.
    worktree.create_worktree = function(path, branch)
        worktree.setup_git_info()
        local root = worktree.get_root()
        if not root then
            vim.notify("Cannot create a worktree outside a Git repository", vim.log.levels.ERROR)
            return
        end

        local destination = worktree.get_worktree_path(path)
        local existing = vim.system({
            "git", "show-ref", "--verify", "--quiet", "refs/heads/" .. branch,
        }, { cwd = root }):wait()
        if existing.code ~= 0 and existing.code ~= 1 then
            vim.notify(existing.stderr, vim.log.levels.ERROR)
            return
        end

        local command = { "git", "worktree", "add" }
        if existing.code == 1 then
            vim.list_extend(command, { "-b", branch, "--", destination })
        else
            vim.list_extend(command, { "--", destination, branch })
        end

        vim.system(command, { cwd = root, text = true }, function(result)
            vim.schedule(function()
                if result.code ~= 0 then
                    vim.notify("Could not create worktree:\n" .. result.stderr, vim.log.levels.ERROR)
                    return
                end
                worktree.switch_worktree(destination)
            end)
        end)
    end
end

return M
