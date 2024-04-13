return {
	"saecki/crates.nvim",
	tag = "stable",
	config = function()
		require("crates").setup()
		local crates = require("crates")
		local opts = { silent = true }
		opts.desc = "Crates toggler"
		vim.keymap.set("n", "<leader>ct", crates.toggle, opts)
		opts.desc = "Crates reload"
		vim.keymap.set("n", "<leader>cr", crates.reload, opts)
		opts.desc = "Crates show Versions"
		vim.keymap.set("n", "<leader>cv", crates.show_versions_popup, opts)
		opts.desc = "Crates show features"
		vim.keymap.set("n", "<leader>cf", crates.show_features_popup, opts)
		opts.desc = "Crates show dependencies"
		vim.keymap.set("n", "<leader>cd", crates.show_dependencies_popup, opts)
		opts.desc = "Update crate"
		vim.keymap.set("n", "<leader>cu", crates.update_crate, opts)
		opts.desc = "Update crates"
		vim.keymap.set("v", "<leader>cu", crates.update_crates, opts)
		opts.desc = "Update all crates"
		vim.keymap.set("n", "<leader>ca", crates.update_all_crates, opts)
		opts.desc = "Upgrade crate"
		vim.keymap.set("n", "<leader>cU", crates.upgrade_crate, opts)
		opts.desc = "Upgrade crates"
		vim.keymap.set("v", "<leader>cU", crates.upgrade_crates, opts)
		opts.desc = "Upgrade all crates"
		vim.keymap.set("n", "<leader>cA", crates.upgrade_all_crates, opts)
		--vim.keymap.set("n", "<leader>cx", crates.expand_plain_crate_to_inline_table, opts)
		--vim.keymap.set("n", "<leader>cX", crates.extract_crate_into_table, opts)
		--vim.keymap.set("n", "<leader>cH", crates.open_homepage, opts)
		--vim.keymap.set("n", "<leader>cR", crates.open_repository, opts)
		--vim.keymap.set("n", "<leader>cD", crates.open_documentation, opts)
		--vim.keymap.set("n", "<leader>cC", crates.open_crates_io, opts)
	end,
	ft = { "toml" },
}
