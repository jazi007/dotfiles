return {
	"saghen/blink.cmp",
	event = { "InsertEnter", "CmdlineEnter" },
	version = "1.*", -- pinned to tagged releases for stability
	dependencies = {
		"rafamadriz/friendly-snippets", -- vscode-style community snippets
	},

	opts = {
		-- ── Keymap ──────────────────────────────────────────────────────────
		-- Mirrors the old nvim-cmp bindings: C-j/k navigate, CR confirms,
		-- C-e aborts, C-b/f scroll docs, Tab/S-Tab jump snippet placeholders.
		keymap = {
			preset = "none",
			["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-e>"]     = { "hide", "fallback" },
			["<CR>"]      = { "accept", "fallback" },
			["<C-k>"]     = { "select_prev", "fallback" },
			["<C-j>"]     = { "select_next", "fallback" },
			["<C-b>"]     = { "scroll_documentation_up", "fallback" },
			["<C-f>"]     = { "scroll_documentation_down", "fallback" },
			["<Tab>"]     = { "snippet_forward", "fallback" },
			["<S-Tab>"]   = { "snippet_backward", "fallback" },
		},

		-- ── Appearance ──────────────────────────────────────────────────────
		appearance = {
			nerd_font_variant = "mono", -- matches Nerd Font Mono patched fonts
		},

		-- ── Completion behaviour ─────────────────────────────────────────────
		completion = {
			accept = {
				auto_brackets = { enabled = true }, -- auto-insert () after function
			},
			documentation = {
				auto_show          = true,
				auto_show_delay_ms = 200,
			},
			list = {
				selection = {
					preselect  = false, -- don't auto-select first item (matches old noselect)
					auto_insert = false,
				},
			},
			menu = {
				draw = {
					treesitter = { "lsp" }, -- treesitter highlighting inside menu
					columns = {
						{ "label", "label_description", gap = 1 },
						{ "kind_icon", "kind" },
					},
				},
			},
		},

		-- ── Sources ──────────────────────────────────────────────────────────
		sources = {
			default = { "lazydev", "lsp", "snippets", "buffer", "path" },
			providers = {
				-- lazydev: Lua API completions (vim.*, require, etc.)
				-- Shows above LSP completions via score_offset
				lazydev = {
					name         = "LazyDev",
					module       = "lazydev.integrations.blink",
					score_offset = 100,
				},
			},
		},

		-- ── Snippets ─────────────────────────────────────────────────────────
		-- Built-in engine; loads rafamadriz/friendly-snippets automatically.
		-- No LuaSnip needed.
		snippets = { preset = "default" },

		-- ── LSP capabilities ─────────────────────────────────────────────────
		-- blink.cmp automatically patches vim.lsp.config to add its capabilities
		-- to every LSP server — no manual capabilities = ... required.
	},

	opts_extend = { "sources.default" },
}
