return {
	"folke/snacks.nvim",
	priority = 1000, -- load before other UI plugins
	lazy = false,
	opts = {
		-- ── Dashboard (replaces alpha-nvim) ─────────────────────────────────
		dashboard = {
			enabled = true,
			preset = {
				header = table.concat({
					"                                                     ",
					"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
					"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
					"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
					"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
					"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
					"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
					"                                                     ",
				}, "\n"),
				-- Mirrors your alpha dashboard buttons
				keys = {
					{ icon = " ", key = "e",          desc = "New File",          action = "<cmd>ene<CR>" },
				{ icon = " ", key = "<leader>ee", desc = "Toggle File Tree",   action = "<cmd>Neotree toggle<CR>" },
					{ icon = "󰱼 ", key = "<leader>ff", desc = "Find File",         action = "<cmd>Telescope find_files<CR>" },
					{ icon = "󰱼 ", key = "<leader>fr", desc = "Recent File",       action = "<cmd>Telescope oldfiles<CR>" },
					{ icon = " ", key = "<leader>fs", desc = "Find Word",          action = "<cmd>Telescope live_grep<CR>" },
					{ icon = " ", key = "<leader>gg", desc = "Lazygit",            action = function() Snacks.lazygit() end },
					{ icon = " ", key = "q",          desc = "Quit",              action = "<cmd>qa<CR>" },
				},
			},
		},

		-- ── Input / Select (replaces dressing.nvim) ──────────────────────────
		input  = { enabled = true },
		-- select handled via vim.ui.select override:
		picker = { enabled = false }, -- keep Telescope as picker

		-- ── Notifier (replaces default vim.notify) ────────────────────────────
		notifier = {
			enabled = true,
			timeout = 3000,
			style   = "compact",
		},

		-- ── Lazygit integration ───────────────────────────────────────────────
		lazygit = { enabled = true },

		-- ── Indent guides ─────────────────────────────────────────────────────
		-- Disabled: snacks.scope calls treesitter node:range() which crashes on
		-- Neovim 0.12.2. Re-enable once snacks.nvim ships a compat fix.
		indent = { enabled = false },

		-- ── Word highlighter (highlights all occurrences of word under cursor) ─
		words = { enabled = true },

		-- ── Bigfile: disable heavy features for large files ───────────────────
		bigfile = { enabled = true },

		-- ── Statuscolumn ─────────────────────────────────────────────────────
		statuscolumn = { enabled = true },

		-- ── Scroll ────────────────────────────────────────────────────────────
		scroll = { enabled = false }, -- off by default, can be jarring

		-- ── Other modules kept off (not needed) ───────────────────────────────
		animate    = { enabled = true },
		terminal   = { enabled = true },
		zen        = { enabled = false },
		dim        = { enabled = false },
		profiler   = { enabled = false },
	},

	keys = {
		-- Lazygit
		{ "<leader>gg", function() Snacks.lazygit() end,            desc = "Lazygit" },
		{ "<leader>gf", function() Snacks.lazygit.log_file() end,   desc = "Lazygit File Log" },
		{ "<leader>gl", function() Snacks.lazygit.log() end,        desc = "Lazygit Branch Log" },
		-- Notifier
		{ "<leader>un", function() Snacks.notifier.hide() end,      desc = "Dismiss Notifications" },
		-- Terminal (floating)
		{ "<leader>tt", function() Snacks.terminal() end,           desc = "Toggle Terminal" },
		-- Words: next/prev reference (works without LSP too)
		{ "]]",         function() Snacks.words.jump(1,  true) end, desc = "Next Word Reference",  mode = { "n", "t" } },
		{ "[[",         function() Snacks.words.jump(-1, true) end, desc = "Prev Word Reference",  mode = { "n", "t" } },
	},

	init = function()
		-- Replace vim.notify with snacks notifier as early as possible
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				_G.Snacks = require("snacks")
				-- override vim.print to use the notifier
				vim.print = function(...) Snacks.debug.inspect(...) end
			end,
		})
	end,
}
