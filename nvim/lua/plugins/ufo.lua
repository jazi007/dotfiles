return {
	"kevinhwang91/nvim-ufo",
	dependencies = { "kevinhwang91/promise-async" },
	event = { "BufReadPost" },
	keys = {
		{ "zR", function() require("ufo").openAllFolds()  end, desc = "Open all folds" },
		{ "zM", function() require("ufo").closeAllFolds() end, desc = "Close all folds" },
		{ "zK", function()
			local winid = require("ufo").peekFoldedLinesUnderCursor()
			if not winid then vim.lsp.buf.hover() end
		end, desc = "Peek fold / hover" },
	},
	opts = {
		-- Provider priority: LSP first (best semantics), then treesitter, then indent
		provider_selector = function(bufnr, filetype, buftype)
			local lsp_map = {
				lua    = { "lsp", "treesitter" },
				rust   = { "lsp", "treesitter" },
				python = { "lsp", "treesitter" },
				c      = { "lsp", "treesitter" },
				cpp    = { "lsp", "treesitter" },
				go     = { "lsp", "treesitter" },
			}
			return lsp_map[filetype] or { "treesitter", "indent" }
		end,

		-- Show folded line count: "⋯ 12 lines"
		fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
			local newVirtText = {}
			local suffix = (" ⋯ %d lines "):format(endLnum - lnum)
			local sufWidth = vim.fn.strdisplaywidth(suffix)
			local targetWidth = width - sufWidth
			local curWidth = 0
			for _, chunk in ipairs(virtText) do
				local chunkText = chunk[1]
				local chunkWidth = vim.fn.strdisplaywidth(chunkText)
				if targetWidth > curWidth + chunkWidth then
					table.insert(newVirtText, chunk)
				else
					chunkText = truncate(chunkText, targetWidth - curWidth)
					table.insert(newVirtText, { chunkText, chunk[2] })
					chunkWidth = vim.fn.strdisplaywidth(chunkText)
					if curWidth + chunkWidth < targetWidth then
						suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
					end
					break
				end
				curWidth = curWidth + chunkWidth
			end
			table.insert(newVirtText, { suffix, "MoreMsg" })
			return newVirtText
		end,
	},
	config = function(_, opts)
		-- Required: tell nvim to use ufo's provider instead of foldmethod
		vim.o.foldcolumn    = "1"
		vim.o.foldlevel     = 99 -- open all folds on file open
		vim.o.foldlevelstart = 99
		vim.o.foldenable    = true
		require("ufo").setup(opts)
	end,
}
