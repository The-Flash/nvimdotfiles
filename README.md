# nvim dotfiles

Personal Neovim configuration built for **Neovim 0.12+**.

## Requirements

- [Neovim](https://neovim.io/) >= 0.12
- `git` (for lazy.nvim and git-worktree)
- A [Nerd Font](https://www.nerdfonts.com/) (for icons in lualine and Neo-tree)
- [`ripgrep`](https://github.com/BurntSushi/ripgrep) (for Telescope live grep)
- `node` (for GitHub Copilot)

## Installation

```sh
git clone https://github.com/The-Flash/nvimdotfiles ~/.config/nvim
nvim
```

[lazy.nvim](https://github.com/folke/lazy.nvim) will bootstrap itself and install all plugins on first launch. Treesitter parsers are updated automatically via the `build = ":TSUpdate"` hook.

## Structure

````
~/.config/nvim/
├── init.lua                  # Entry point, loads lazy.nvim and all modules
├── lazy-lock.json            # Plugin version lockfile
└── lua/
    ├── vim-options.lua       # Editor options, tabs, clipboard, Neovim 0.12 shims
    ├── keymaps.lua           # All keymaps (non-plugin)
    ├── plugins.lua           # Plugin list loaded by lazy.nvim
    └── plugins/              # Per-plugin config files
        ├── completions.lua   # nvim-cmp + LuaSnip
        ├── copilot.lua       # GitHub Copilot
        ├── lsp.lua           # LSP config
        ├── lualine.lua       # Status line
        ├── mason.lua         # Mason + mason-lspconfig + server setup
        ├── neo-tree.lua      # File explorer
        ├── telescope.lua     # Fuzzy finder + git-worktree extension
        ├── toggleterm.lua    # Floating terminal
        ├── treesitter.lua    # Syntax highlighting
        ├── comment.lua       # Comment toggling
        ├── conform.lua       # Auto-formatting
        └── ufo.lua           # Code folding (nvim-ufo)```

## Plugins

| Plugin                                                                                                                       | Purpose                                      |
| ---------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------- |
| [lazy.nvim](https://github.com/folke/lazy.nvim)                                                                              | Plugin manager                               |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)                                                        | Syntax highlighting and parsing              |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)                                                           | Fuzzy finder for files, grep, LSP            |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) + [LuaSnip](https://github.com/L3MON4D3/LuaSnip)                             | Autocompletion + snippets                    |
| [mason.nvim](https://github.com/mason-org/mason.nvim) + [mason-lspconfig](https://github.com/mason-org/mason-lspconfig.nvim) | LSP/linter installer and manager             |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)                                                                   | LSP client configuration                     |
| [conform.nvim](https://github.com/stevearc/conform.nvim)                                                                     | Auto-formatting on save (Prettier, stylua, ruff, rustfmt) |
| [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim)                                                              | File explorer sidebar/float                  |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)                                                                 | Status line                                  |
| [copilot.vim](https://github.com/github/copilot.vim)                                                                         | GitHub Copilot inline suggestions            |
| [CopilotChat.nvim](https://github.com/CopilotC-Nvim/CopilotChat.nvim)                                                        | GitHub Copilot chat interface                |
| [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim)                                                                | Floating terminal toggle                     |
| [Comment.nvim](https://github.com/numToStr/Comment.nvim)                                                                     | Comment toggling                             |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs)                                                                   | Auto-close brackets and quotes               |
| [git-worktree.nvim](https://github.com/ThePrimeagen/git-worktree.nvim)                                                       | Git worktree management                      |
| [telescope-ui-select.nvim](https://github.com/nvim-telescope/telescope-ui-select.nvim)                                       | Telescope-powered `vim.ui.select`            |
| [nvim-ufo](https://github.com/kevinhwang91/nvim-ufo)                                                                         | Code folding with treesitter + virtual text  |
| [panda-vim](https://github.com/markvincze/panda-vim)                                                                         | Color scheme                                 |

## LSP / Languages

The following language servers are auto-installed via Mason:

| Server          | Language                    |
| --------------- | --------------------------- |
| `lua_ls`        | Lua                         |
| `ts_ls`         | TypeScript / JavaScript     |
| `rust_analyzer` | Rust                        |
| `ruff`          | Python (linting/formatting) |
| `pyright`       | Python (type checking)      |

## Keymaps

> **Leader key is `Space`**

### LSP

| Key          | Action                                     |
| ------------ | ------------------------------------------ |
| `K`          | Hover documentation                        |
| `gl`         | Open diagnostic float (full error message) |
| `gd`         | Go to definition                           |
| `gi`         | Go to implementation                       |
| `<leader>rn` | Rename symbol                              |
| `<leader>ca` | Code action                                |
| `<leader>oi` | Organize imports                           |

### File Search (Telescope)

| Key                    | Action     |
| ---------------------- | ---------- |
| `<leader>ff` / `<C-p>` | Find files |
| `<leader>fg`           | Live grep  |

### File Explorer (Neo-tree)

| Key         | Action                       |
| ----------- | ---------------------------- |
| `<leader>m` | Toggle file explorer (float) |

### Formatting

| Key          | Action                          |
| ------------ | ------------------------------- |
| `<leader>f`  | Format buffer (async, on-demand) |

> Files also auto-format on save for supported filetypes.

### Folding

| Key  | Action               |
| ---- | -------------------- |
| `zR` | Open all folds       |
| `zM` | Close all folds      |
| `za` | Toggle fold at cursor |

> Folding is treesitter-aware. Collapsed blocks show `[+N lines]` virtual text.

### Splits

| Key           | Action                  |
| ------------- | ----------------------- |
| `<leader>sv`  | Split vertically        |
| `<leader>sh`  | Split horizontally      |
| `<leader>se`  | Equalise split sizes    |
| `<leader>sx`  | Close current split     |
| `<C-h/j/k/l>` | Navigate between splits |

### Terminal

| Key     | Action                   |
| ------- | ------------------------ |
| `<C-t>` | Toggle floating terminal |

### Commenting

| Key              | Action                         |
| ---------------- | ------------------------------ |
| `<C-/>` (normal) | Toggle comment on current line |
| `<C-/>` (visual) | Toggle comment on selection    |

> Note: terminals send `Ctrl+/` as `<C-_>`. The keymap is bound to `<C-_>` internally.

### Git Worktrees

| Key           | Action                    |
| ------------- | ------------------------- |
| `<leader>gws` | List and switch worktrees |
| `<leader>gwc` | Create a new worktree     |

## Neovim 0.12 Compatibility Notes

Neovim 0.12 removed several APIs that some plugins depend on. The following shims are defined in `lua/vim-options.lua` to maintain compatibility while plugins update:

- **`nvim-treesitter.parsers`** — replaced by `vim.treesitter.get_parser` and `vim.treesitter.language.get_lang`. A fake module is registered via `package.preload` so Telescope's previewer doesn't crash.
- **`nvim-treesitter.configs`** — replaced by `require("nvim-treesitter").setup()`. A fake module is registered so Telescope's `is_enabled` and `get_module` calls are safe.
````
