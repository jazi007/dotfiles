return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status") -- to configure lazy pending updates count

		local tailing_space = function()
			local space = vim.fn.search([[\s\+$]], "nwc")
			return space ~= 0 and " " .. space or ""
		end
		-- configure lualine with modified theme
		lualine.setup({
			options = {
				theme = "nord",
			},
			sections = {
				lualine_x = {
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = "#ff9e64" },
					},
					{ tailing_space },
					{ "searchcount" },
					{ "encoding" },
					{ "fileformat" },
					{ "filetype" },
				},
			},
		})
	end,
}
