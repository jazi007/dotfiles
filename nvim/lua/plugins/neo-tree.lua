return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	lazy = false, -- load on startup so the tree is available immediately
	opts = {
		close_if_last_window = true, -- close neo-tree if it's the last window
		popup_border_style   = "rounded",

		default_component_configs = {
			indent = {
				indent_size        = 2,
				padding            = 1,
				with_markers       = true,
				indent_marker      = "│",
				last_indent_marker = "└",
				highlight          = "NeoTreeIndentMarker",
				with_expanders     = true, -- expander icons for empty dirs
				expander_collapsed = "",
				expander_expanded  = "",
				expander_highlight = "NeoTreeExpander",
			},
			icon = {
				folder_closed = "",
				folder_open   = "",
				folder_empty  = "󰜌",
				default       = "",   -- fallback for unknown filetypes
				highlight     = "NeoTreeFileIcon",
			},
			git_status = {
				symbols = {
					added     = "",
					modified  = "",
					deleted   = "✖",
					renamed   = "󰁕",
					untracked = "",
					ignored   = "",
					unstaged  = "󰄱",
					staged    = "",
					conflict  = "",
				},
			},
		},

		window = {
			width    = 35,
			position = "left",
			mappings = {
				["<space>"] = "none", -- don't steal <leader>
				["l"]       = "open",
				["h"]       = "close_node",
				["H"]       = "toggle_hidden",
			},
		},

		filesystem = {
			filtered_items = {
				hide_dotfiles      = false, -- show dotfiles (matches git.ignore=false in old nvim-tree)
				hide_gitignored    = false,
				hide_by_name       = { ".DS_Store", "thumbs.db" },
				always_show        = { ".gitignored" },
				never_show         = {},
			},
			follow_current_file   = { enabled = true },  -- auto-reveal on buffer switch
			use_libuv_file_watcher = true,               -- auto-refresh on fs changes
			hijack_netrw_behavior  = "open_default",
		},

		buffers = {
			follow_current_file = { enabled = true },
		},

		git_status = { window = { position = "float" } },
	},

	config = function(_, opts)
		-- Ensure devicons is set up before neo-tree renders any icons
		require("nvim-web-devicons").setup({ default = true })

		-- Disable netrw completely (same as old nvim-tree setting)
		vim.g.loaded_netrw       = 1
		vim.g.loaded_netrwPlugin = 1

		require("neo-tree").setup(opts)
	end,

	keys = {
		{ "<leader>ee", "<cmd>Neotree toggle<CR>",                     desc = "Toggle file explorer" },
		{ "<leader>ef", "<cmd>Neotree reveal<CR>",                     desc = "Reveal current file in explorer" },
		{ "<leader>ec", "<cmd>Neotree close<CR>",                      desc = "Close file explorer" },
		{ "<leader>eb", "<cmd>Neotree buffers toggle<CR>",             desc = "Toggle buffer list" },
		{ "<leader>eg", "<cmd>Neotree git_status toggle float<CR>",    desc = "Toggle git status panel" },
	},
}
