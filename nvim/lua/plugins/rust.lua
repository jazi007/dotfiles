return {
  "mrcjkb/rustaceanvim",
  -- version = "4.22.8", -- Recommended
  version = "4", -- Recommended
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
            vim.cmd("highlight LspInlayHint guifg=#B3B6B7")
            vim.lsp.inlay_hint.enable(true)
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
        --   },
        -- },
      },
    }
  end,
}
