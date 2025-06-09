return {
  "mrcjkb/rustaceanvim",
  -- version = "4.22.8", -- Recommended
  -- version = "6", -- Recommended
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
        -- cmd = function()
        --   local mason_registry = require("mason-registry")
        --   if mason_registry.is_installed("rust-analyzer") then
        --     -- This may need to be tweaked depending on the operating system.
        --     local ra = mason_registry.get_package("rust-analyzer")
        --     local ra_filename = ra:get_receipt():get().links.bin["rust-analyzer"]
        --     return { ("%s/%s"):format(ra:get_install_path(), ra_filename or "rust-analyzer") }
        --   else
        --     -- global installation
        --     return { "rust-analyzer" }
        --   end
        -- end,
        on_attach = function(client, bufnr)
          if client.server_capabilities.inlayHintProvider then
            -- TODO: check why this is not correctly visible with nord
            vim.cmd("highlight LspInlayHint guifg=#B3B6B7")
            -- vim.lsp.inlay_hint.enable(true)
          end
        end,
        -- default_settings = {
        --   -- rust-analyzer language server configuration
        --   ["rust-analyzer"] = {
        --     cargo = {
        --       loadOutDirsFromCheck = true,
        --       allFeatures = false,
        --     },
        --     checkOnSave = {
        --       allFeatures = false,
        --     },
        --     procMacro = {
        --       enable = true,
        --     },
        --     diagnostic = {
        --       refreshSupport = false,
        --     },
        --   },
        -- },
      },
    }
  end,
}
