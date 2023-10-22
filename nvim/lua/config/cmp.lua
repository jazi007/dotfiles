local M = {}

function M.config()
  -- LSP settings
  local on_attach = function(_, bufnr)
    local map = vim.api.nvim_buf_set_keymap
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    local opts = { noremap = true, silent = true }
    map(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    map(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    map(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    map(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    map(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    map(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    map(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    map(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    map(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    map(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    map(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    map(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    -- map(bufnr, 'v', '<leader>ca', '<cmd>lua vim.lsp.buf.range_code_action()<CR>', opts)
    map(bufnr, 'n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    map(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev({ float =  { border = "single" }})<CR>', opts)
    map(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next({ float =  { border = "single" }})<CR>', opts)
    map(bufnr, 'n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
    map(bufnr, 'n', '<leader>so', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts)
    vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
  end

  -- nvim-cmp supports additional completion capabilities
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = false
  local servers = { 'clangd', 'pyright', 'rust_analyzer', 'bashls', 'cmake' }
  require("mason").setup()
  require("mason-lspconfig").setup { ensure_installed = servers }
  local nvim_lsp = require 'lspconfig'

  -- clangd function to  get root dir
  local function get_dir(...)
    return function(startpath)
      return vim.g.start_directory;
    end
  end

  -- clangd
  nvim_lsp.clangd.setup {
    on_attach = on_attach;
    capabilities = capabilities;
    cmd = {"clangd", "--background-index", "--compile-commands-dir", vim.g.start_directory};
    root_dir = get_dir();
    single_file_support = false,
  }
  -- python
  nvim_lsp.pyright.setup {
    on_attach = on_attach;
    capabilities = capabilities;
    settings = {
      python = {
        formatting = {
          provider = 'yapf'
        },
        linting = {
          pytypeEnabled = true
        }
      }
    };
  }
  -- rust
  local rt = require("rust-tools")
  rt.setup({
    server = {
      on_attach = on_attach;
      capabilities = capabilities;
      settings = {
        ['rust-analyzer'] = {
          cargo = { allFeatures = false },
          checkOnSave = {
            command = 'clippy',
            extraArgs = { '--no-deps' },
          },
        },
      };
    },
  })
  -- nvim_lsp.rust_analyzer.setup {
  --   on_attach = on_attach;
  --   capabilities = capabilities;
  --   settings = {
  --     ['rust-analyzer'] = {
  --       cargo = { allFeatures = true },
  --       checkOnSave = {
  --         command = 'clippy',
  --         extraArgs = { '--no-deps' },
  --       },
  --     },
  --   };
  -- }
  -- bash
  nvim_lsp.bashls.setup {
    on_attach = on_attach;
    capabilities = capabilities;
  }
  -- cmake
  nvim_lsp.cmake.setup {
    on_attach = on_attach;
    capabilities = capabilities;
  }

  -- Set completeopt to have a better completion experience
  vim.o.completeopt = 'menuone,noselect'

  -- nvim-cmp setup
  local cmp = require 'cmp'
  cmp.setup {
    snippet = { },
    mapping = {
      ['<C-p>'] = cmp.mapping.select_prev_item(),
      ['<C-n>'] = cmp.mapping.select_next_item(),
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      ['<CR>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },
      ['<Tab>'] = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end,
      ['<S-Tab>'] = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end,
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'buffer' },
    },
  }
  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  -- cmp.setup.cmdline(':', {
  --   sources = cmp.config.sources({
  --     { name = 'path' }
  --   }, {
  --       { name = 'cmdline' }
  --     })
  -- })
end

return M
