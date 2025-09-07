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

vim.keymap.set({ 'n' }, '<Leader>r', vim.lsp.buf.rename,
  { noremap = true, silent = true, desc = 'Rename symbol using LSP' })
vim.keymap.set({ 'n', 'v' }, '<Leader>c', vim.lsp.buf.code_action, { noremap = true, desc = 'Code actions' })
vim.keymap.set({ 'n' }, 'm', function() vim.lsp.buf.hover({ focusable = false, border = 'rounded' }) end, { noremap = true, desc = 'Show hover information' })
vim.keymap.set({ 'n' }, 'K', function() vim.lsp.buf.hover({ focus = true, border = 'rounded' }) end, { noremap = true, desc = 'Show hover information' })
vim.keymap.set({ 'n' }, '<Leader>gd', vim.lsp.buf.definition, { noremap = true, desc = 'Go to definition' })
vim.keymap.set({ 'n' }, '<Leader>gi', vim.lsp.buf.implementation,
  { noremap = true, desc = 'Go to implementation using ALE' })
vim.keymap.set({ 'n' }, '<Leader>gt', vim.lsp.buf.type_definition,
  { noremap = true, desc = 'Go to type definition using ALE' })

vim.keymap.set("n", "<leader>k", function()
  vim.diagnostic.open_float(nil, { focusable = false, source = "if_many" })
end, { desc = "Diagnostic float" })

vim.keymap.set({ 'n' }, '<Leader>F', vim.lsp.buf.references, { noremap = true, desc = 'Find references LSP' })
vim.keymap.set({ 'n' }, '<Leader>f', vim.lsp.buf.format, { noremap = true, desc = 'Apply format fixes' })

vim.keymap.set('n', '[d', function() vim.diagnostic.jump({count= -1, float = true}) end,
  { noremap = true, desc = 'Go to previous issue' })
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({count= 1,float = true}) end,
  { noremap = true, desc = 'Go to next issue with float' })
