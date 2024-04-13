return {
	"mrcjkb/rustaceanvim",
	version = "^4", -- Recommended
	ft = { "rust" },
	config = function()
		vim.g.rustaceanvim = {
			inlay_hints = {
				highlight = "NonText",
			},
			tools = {
				hover_actions = {
					auto_focus = true,
				},
			},
			server = {
				on_attach = function(client, bufnr)
					if client.server_capabilities.inlayHintProvider then
						-- TODO: check why this is not correctly visible with nord
						vim.cmd("highlight LspInlayHint guifg=white")
						vim.lsp.inlay_hint(bufnr, true)
					end
				end,
			},
		}
	end,
}
