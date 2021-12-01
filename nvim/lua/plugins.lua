local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
local packer_bootstrap = false
local map = vim.api.nvim_set_keymap
local opts = {noremap = true, silent = true}
local vscode = not fn.exists('g:vscode')

if fn.empty(fn.glob(install_path)) > 0 then
  print('Installing packer ...', install_path)
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  print('Install done', packer_bootstrap)
end

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- packer can manage itself

  -- Theme inspired by Atom
  use {
    'joshdick/onedark.vim',
    config = function() require('config.color').config() end,
    disable = vscode,
  }

  use {
    'akinsho/bufferline.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function() require('bufferline').setup() end,
    disable = vscode,
  }

  use {
    'famiu/feline.nvim',
    config = function() require('config.feline').config() end,
    disable = vscode,
  }

  -- tpope plugins
  use 'tpope/vim-surround'
  use {
    'tpope/vim-dispatch',
    opt = true,
    cmd = {'Dispatch', 'Make', 'Focus', 'Start'},
    disable = vscode,
  }
  use 'tpope/vim-unimpaired'
  -- use 'tpope/vim-eunuch'
  use 'tpope/vim-repeat'
  use 'tpope/vim-sensible'
  use {
    'tpope/vim-fugitive',
    opt = true,
    cmd = {'Gdiffsplit', 'Gvdiffsplit', 'GBrowse', 'Git'},
    disable = vscode,
  }

  -- Add git related info in the signs columns and popups
  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function() require('gitsigns').setup() end,
    disable = vscode,
  }
  -- file explorer
  use {
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function() require'config.tree'.config {} end,
    disable = vscode,
  }

  -- UI to select things (files, grep results, open buffers...)
  use {
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function () require('config.telescope').config() end,
    disable = vscode,
  }

  -- Highlights
  use {
    'nvim-treesitter/nvim-treesitter',
    requires = {
      'nvim-treesitter/nvim-treesitter-refactor',
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function() require('config.treesitter').config() end,
    run = ':TSUpdate',
    disable = vscode,
  }

  -- Auto-complete
  use {
    'hrsh7th/nvim-cmp', -- Autocompletion plugin
    requires = {
      'neovim/nvim-lspconfig', -- Collection of configurations for built-in LSP client
      'hrsh7th/cmp-nvim-lsp',
      'williamboman/nvim-lsp-installer',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      -- 'hrsh7th/cmp-cmdline',
    },
    config = function() require('config.cmp').config() end,
    disable = vscode,
  }

  -- Outline
  use {
    'simrat39/symbols-outline.nvim',
    cmd = { 'SymbolsOutline' },
    config = function() require('config.outline').config() end,
    disable = vscode,
  }
  map('', '<F9>', ':SymbolsOutline<CR>', opts)

  -- Dashboard
  use {
    'glepnir/dashboard-nvim',
    requires = {'nvim-telescope/telescope.nvim'},
    config = function() require('config.dashboard').config() end,
    disable = vscode,
  }

  if packer_bootstrap then
    require('packer').sync()
  end

end)

