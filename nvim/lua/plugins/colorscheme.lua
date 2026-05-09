return {
	"gbprod/nord.nvim",
	priority = 1000,
	opts = {
		style = "nordic", -- 'nord' | 'night' | 'nordic'
		transparent = false,
		terminal_colors = true,
		dim_inactive = false,
		styles = {
			bodies = { italic = false },
			comments = { italic = true },
			keywords = { bold = false },
		},
		on_highlights = function(highlights, colors)
			-- Keep inlay hints visible (same tweak as before)
			highlights.LspInlayHint = { fg = colors.polar_night.brightest }
		end,
	},
	config = function(_, opts)
		require("nord").setup(opts)
		vim.cmd("colorscheme nord")
	end,
}
