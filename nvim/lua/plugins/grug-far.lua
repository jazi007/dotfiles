return {
	"MagicDuck/grug-far.nvim",
	cmd = "GrugFar",
	keys = {
		{
			"<leader>sr",
			function()
				local grug = require("grug-far")
				-- Pre-fill with word under cursor in normal mode
				local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
				grug.open({
					transient           = true,
					prefills = {
						search      = vim.fn.expand("<cword>"),
						filesFilter = ext and ext ~= "" and ("*." .. ext) or nil,
					},
				})
			end,
			mode = { "n", "v" },
			desc = "Search & Replace (project)",
		},
	},
	opts = {
		headerMaxWidth = 80,
	},
}
