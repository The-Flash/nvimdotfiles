-- RustOwl: visualize ownership & lifetimes in Rust.
-- Binary lives in ~/.rustowl (installed by the official installer, which also
-- sets up the pinned toolchain it needs; `cargo install rustowl` won't build on stable).
local rustowl_dir = vim.fn.expand("~/.rustowl")
if not vim.env.PATH:find(rustowl_dir, 1, true) then
    vim.env.PATH = rustowl_dir .. ":" .. vim.env.PATH
end

return {
    "cordx56/rustowl",
    version = "*", -- latest stable
    build = function()
        local out = vim.fn.system({
            "sh",
            "-c",
            "curl -fsSL https://raw.githubusercontent.com/cordx56/rustowl/refs/heads/main/scripts/installer | sh",
        })
        if vim.v.shell_error ~= 0 then
            error("RustOwl install failed:\n" .. out)
        end
    end,
    lazy = false, -- plugin lazy-loads itself on Rust files
    opts = {
        auto_enable = false, -- toggle on demand with <leader>ro
        idle_time = 500,
        client = {
            on_attach = function(_, buffer)
                vim.keymap.set("n", "<leader>ro", function()
                    require("rustowl").toggle(buffer)
                end, { buffer = buffer, desc = "Toggle RustOwl" })
            end,
        },
    },
}
