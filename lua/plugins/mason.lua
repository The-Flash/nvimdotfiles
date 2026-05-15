return {
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			ensure_installed = { "lua_ls", "rust_analyzer", "ts_ls", "pyright", "ruff" },
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
                },
			})
		end,
	},
	{
		"mason-org/mason.nvim",
		opts = {},
	},
}
