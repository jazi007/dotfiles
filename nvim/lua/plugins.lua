return {
  'lewis6991/impatient.nvim',
  -- Theme inspired by Atom
  {
    -- 'joshdick/onedark.vim',
    'shaunsingh/nord.nvim',
    lazy = false,
    priority = 1000,
    init = function() require('config.color').config() end,
  },
  {
    'akinsho/bufferline.nvim',
    lazy = false,
    dependencies = 'kyazdani42/nvim-web-devicons',
    config = function() require('bufferline').setup() end,
  },
  -- {
  --   'famiu/feline.nvim',
  --   config = function() require('config.feline').config() end,
  --   lazy = false,
  -- },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = 'kyazdani42/nvim-web-devicons',
    lazy = false,
    config = function() require('lualine').setup() end,
  },
  -- tpope plugins
  {'tpope/vim-unimpaired', lazy = false},
  {'tpope/vim-repeat', lazy = false},
  {'tpope/vim-sensible', lazy = false},
  {
    'tpope/vim-fugitive',
    cmd = {'Gdiffsplit', 'Gvdiffsplit', 'GBrowse', 'Git'},
  },
  -- Add git related info in the signs columns and popups
  {
    'lewis6991/gitsigns.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    config = function() require('gitsigns').setup() end,
    event = 'VeryLazy',
  },
  -- file explorer
  {
    'kyazdani42/nvim-tree.lua',
    dependencies = 'kyazdani42/nvim-web-devicons',
    config = function() require'config.tree'.config {} end,
    event = 'VeryLazy',
  },
  -- UI to select things (files, grep results, open buffers...)
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
    },
    init = function()
      require 'config.telescope_setup'
    end,
    config = function()
      require('config.telescope')
    end,
    cmd = 'Telescope',
  },
  -- tree sitter
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-refactor',
      'RRethy/nvim-treesitter-textsubjects',
      'RRethy/nvim-treesitter-endwise',
    },
    build = ':TSUpdate',
    event = 'VeryLazy',
    config = function()
      require 'config.treesitter'
    end,
  },
  -- Outline
  {
    'simrat39/symbols-outline.nvim',
    config = function() require('config.outline').config() end,
    cmd = { 'SymbolsOutline' },
    event = 'VeryLazy',
  },
  -- LSP
  {
    "williamboman/mason.nvim",
    cmd = {'Mason'},
  },
  {
    'hrsh7th/nvim-cmp', -- Autocompletion plugin
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      'neovim/nvim-lspconfig', -- Collection of configurations for built-in LSP client
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      -- 'hrsh7th/cmp-cmdline',
    },
    config = function() require('config.cmp').config() end,
    ft = {'c', 'cpp', 'python', 'rust', 'sh', 'cmake' },
  },
  {
    'simrat39/rust-tools.nvim',
    ft = { 'rust' },
  },
  -- Debug
  -- {
  --   'mfussenegger/nvim-dap',
  --   init = function()
  --     require 'config.dap_setup'
  --   end,
  --   config = function()
  --     require 'config.dap'
  --   end,
  --   dependencies = 'jbyuki/one-small-step-for-vimkind',
  --   cmd = { 'BreakpointToggle', 'Debug', 'DapREPL' },
  -- },
  -- {
  --   'rcarriga/nvim-dap-ui',
  --   dependencies = 'nvim-dap',
  --   opts = {},
  -- },
}
