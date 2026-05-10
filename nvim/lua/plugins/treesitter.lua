-- nvim-treesitter master branch is archived and incompatible with Neovim 0.12+.
-- The `main` branch is the maintained rewrite with the new API.
return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{ "windwp/nvim-ts-autotag", opts = {} },
	},
	config = function()
		-- main branch API: require("nvim-treesitter").setup(), not configs.setup()
		require("nvim-treesitter").setup({
			ensure_install = {
				"json",
				"yaml",
				"markdown",
				"markdown_inline",
				"bash",
				"lua",
				"vim",
				"dockerfile",
				"gitignore",
				"vimdoc",
				"c",
				"rust",
			},
		})
		-- incremental selection (still supported in main)
		vim.keymap.set("n", "<C-space>", ":TSIncrementalSelectionInit<CR>", { silent = true })
	end,
}
