return {
	"echasnovski/mini.surround",
	version = "*",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		-- Use `gz` prefix to avoid conflicts with substitute.nvim's `s` mapping.
		--
		-- Keymaps:
		--   gza  — add surround          (e.g. gzaiw" wraps word in quotes)
		--   gzd  — delete surround       (e.g. gzd" removes surrounding quotes)
		--   gzr  — replace surround      (e.g. gzr"' swaps " for ')
		--   gzf  — find right surround
		--   gzF  — find left surround
		--   gzh  — highlight surround
		--   gzn  — update n_lines
		--
		-- Works with: (, ), [, ], {, }, <, >, ", ', `, t (HTML tag), f (function)
		mappings = {
			add            = "gza",
			delete         = "gzd",
			find           = "gzf",
			find_left      = "gzF",
			highlight      = "gzh",
			replace        = "gzr",
			update_n_lines = "gzn",
		},
		-- Number of lines within which surrounding is searched
		n_lines = 20,
		-- How to search for surrounding (use 'cover_or_next' for operator-pending)
		search_method = "cover_or_next",
	},
}
