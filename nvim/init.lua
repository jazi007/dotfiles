-- Leader/local leader - lazy.nvim needs these set first
vim.g.mapleader = [[ ]]
vim.g.maplocalleader = [[ ]]
-- start directory
vim.g.start_directory = vim.fn.getcwd()

-- core nvim configuration (options/keymaps/...)
require("core")
-- vim.lsp.set_log_level("info")

-----------------------------------------------------------
-- Lazy
-----------------------------------------------------------
if vim.g.vscode then
	-- VSCode extension
else
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	if not vim.loop.fs_stat(lazypath) then
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/folke/lazy.nvim.git",
			"--branch=stable", -- latest stable release
			lazypath,
		})
	end
	vim.opt.rtp:prepend(lazypath)
	require("lazy").setup({ { import = "plugins" }, { import = "plugins.lsp" } }, {
		checker = {
			enabled = true,
			notify = false,
		},
		change_detection = {
			notify = false,
		},
	})
end
