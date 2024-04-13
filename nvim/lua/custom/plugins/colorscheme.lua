return {
	"shaunsingh/nord.nvim",
	priority = 1000,
	config = function()
		vim.o.termguicolors = true
		vim.g.nord_contrast = true
		vim.g.nord_borders = false
		vim.g.nord_disable_background = false
		vim.g.nord_italic = false
		vim.g.nord_uniform_diff_background = true
		vim.g.nord_bold = false
		require("nord").set()
		vim.cmd("colorscheme nord")
	end,
}
