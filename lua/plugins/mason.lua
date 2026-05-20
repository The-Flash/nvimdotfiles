return {
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			ensure_installed = { "lua_ls", "rust_analyzer", "ts_ls", "eslint", "pyright", "ruff" },
		},
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
            require("mason-lspconfig").setup({
				default_handler = function(server_name)
					lspconfig[server_name].setup({
						capabilities = capabilities,
					})
				end,
                handlers = {
                    ["pyright"] = function()
                        lspconfig.pyright.setup({
                            capabilities = capabilities,
                       })
                    end,
                    ["lua_ls"] = function()
                        lspconfig.lua_ls.setup({
                            capabilities = capabilities,
                            settings = {
                                Lua = {
                                    runtime = {
                                        version = "LuaJIT",
                                    },
                                    workspace = {
                                        checkThirdParty = false,
                                        library = vim.api.nvim_get_runtime_file("", true),
                                    },
                                    diagnostics = {
                                        globals = { "vim" },
                                    },
                                    telemetry = {
                                        enable = false,
                                    },
                                },
                            },
                        })
                    end,
                    ["eslint"] = function()
                        lspconfig.eslint.setup({
                            capabilities = capabilities,
                            settings = {
                                eslint = {
                                    workingDirectory = { mode = "auto" },
                                },
                            },
                            on_attach = function(_, bufnr)
                                vim.api.nvim_create_autocmd("BufWritePre", {
                                    buffer = bufnr,
                                    callback = function()
                                        vim.cmd("EslintFixAll")
                                    end,
                                })
                            end,
                        })
                    end,
                },
			})
		end,
	},
	{
		"mason-org/mason.nvim",
		opts = {},
	},
}
