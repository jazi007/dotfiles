return {
  "mrcjkb/rustaceanvim",
  version = "^5", -- v5+ uses the correct vim.lsp.inlay_hint filter table API
  ft = { "rust" },
  opts = {
    tools = {
      hover_actions = {
        auto_focus = true,
      },
    },
    server = {
      on_attach = function(client, bufnr)
        if client.server_capabilities.inlayHintProvider then
          -- Enable inlay hints for this buffer using the new API (Neovim 0.10+)
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
      end,
    },
  },
  config = function(_, opts)
    vim.g.rustaceanvim = opts
  end,
}
