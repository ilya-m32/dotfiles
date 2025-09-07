local LSP_SERVERS = {
  'clangd',
  'lua_ls',
  'nil_ls',
  'pylsp',
  'rust_analyzer',
  'bashls',
  -- web world
  'ts_ls',
  'eslint',
  'jsonls',
  'html'
  -- 'jdtls', - done via special plugin
};

vim.lsp.config('*', {
  capabilities = {
    textDocument = {
      publishDiagnostics = {
        severity_limit = "Warning",
      }
    }
  },
})

vim.lsp.enable(LSP_SERVERS)
