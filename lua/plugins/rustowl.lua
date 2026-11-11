-- RustOwl: visualize ownership & lifetimes in Rust.
return {
    "cordx56/rustowl",
    version = "*", -- latest stable
    build = "cargo install rustowl",
    lazy = false, -- plugin lazy-loads itself on Rust files
    opts = {
        auto_enable = false, -- toggle on demand with <leader>ro
        idle_time = 500,
        -- Not in the plugin's defaults, but rustowl v0.4.0 emits it
        highlight_styles = {
            lifetime = "underline",
        },
        -- Underline colors (must be #rrggbb)
        colors = {
            lifetime = "#00cc00", -- end of a variable's lifetime
            definitely_live = "#00cc00", -- variable is alive (lifetime)
            maybe_initialized = "#00cc00", -- may be alive / partially initialized
            imm_borrow = "#0000cc", -- immutable borrow (&T)
            mut_borrow = "#cc00cc", -- mutable borrow (&mut T)
            move = "#cccc00", -- value moved
            call = "#cccc00", -- moved into a function call
            shared_mut = "#cc0000", -- shared and mutable at once (error)
            outlive = "#cc0000", -- borrow outlives its owner (error)
        },
        client = {
            on_attach = function(_, buffer)
                vim.keymap.set("n", "<leader>ro", function()
                    require("rustowl").toggle(buffer)
                end, { buffer = buffer, desc = "Toggle RustOwl" })
            end,
        },
    },
}
