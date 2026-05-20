return {
	{
		"https://github.com/neovim/nvim-lspconfig",
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
    {
        's1n7ax/nvim-window-picker',
        name = 'window-picker',
        event = 'VeryLazy',
        version = '2.*',
        config = function()
            require'window-picker'.setup()
        end,
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        dependencies = {
          { "nvim-lua/plenary.nvim", branch = "master" },
        },
        build = "make tiktoken",
        opts = {
          -- See Configuration section for options
        },
      },
  {
    "ThePrimeagen/git-worktree.nvim"
  },
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    opts = {
      contrast = "hard",
    },
  }
}
