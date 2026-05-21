return {
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
            require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "rust_analyzer", "ts_ls", "eslint", "angularls", "pyright" },
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
                    ["angularls"] = function()
                        local mason_registry = require("mason-registry")
                        local angularls_path = mason_registry.get_package("angular-language-server"):get_install_path()
                        local cmd = {
                            "ngserver",
                            "--stdio",
                            "--tsProbeLocations",
                            table.concat({ angularls_path, vim.fn.getcwd() }, ","),
                            "--ngProbeLocations",
                            table.concat({
                                angularls_path .. "/node_modules/@angular/language-server",
                                angularls_path,
                            }, ","),
                        }
                        lspconfig.angularls.setup({
                            capabilities = capabilities,
                            cmd = cmd,
                            on_new_config = function(new_config, new_root_dir)
                                new_config.cmd = {
                                    "ngserver",
                                    "--stdio",
                                    "--tsProbeLocations",
                                    table.concat({ angularls_path, new_root_dir }, ","),
                                    "--ngProbeLocations",
                                    table.concat({
                                        angularls_path .. "/node_modules/@angular/language-server",
                                        angularls_path,
                                    }, ","),
                                }
                            end,
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
