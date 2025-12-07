local LSP_SERVERS = {
  'clangd',
  'lua_ls',
  'nil_ls',
  'pylsp',
  'rust_analyzer',
  'bashls',
  -- web world
  'ts_ls',
  'biome',
  'eslint',
  'jsonls',
  'html',
  'efm', -- universal for non-lsp
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

-- ELM
local prettier = require('efmls-configs.formatters.prettier')
local languages = {
  typescript = { prettier },
  javascript = { prettier }
}

-- local languages = require('efmls-configs.defaults').languages()
local efmls_config = {
  filetypes = vim.tbl_keys(languages),
  settings = {
    rootMarkers = { '.git/' },
    languages = languages,
  },
  init_options = {
    documentFormatting = true,
    documentRangeFormatting = true,
  },
}

vim.lsp.config('efm', vim.tbl_extend('force', efmls_config, {
  cmd = { 'efm-langserver' },
}))
-- ELM end

vim.lsp.enable(LSP_SERVERS)

vim.keymap.set({ 'n' }, '<Leader>r', vim.lsp.buf.rename,
  { noremap = true, silent = true, desc = 'Rename symbol using LSP' })
vim.keymap.set({ 'n', 'v' }, '<Leader>c', vim.lsp.buf.code_action, { noremap = true, desc = 'Code actions' })
vim.keymap.set({ 'n' }, 'm', function() vim.lsp.buf.hover({ focusable = false, border = 'rounded' }) end, { noremap = true, desc = 'Show hover information' })
vim.keymap.set({ 'n' }, 'K', function() vim.lsp.buf.hover({ focus = true, border = 'rounded' }) end, { noremap = true, desc = 'Show hover information' })
vim.keymap.set({ 'n' }, '<Leader>gd', vim.lsp.buf.definition, { noremap = true, desc = 'Go to definition' })
vim.keymap.set({ 'n' }, '<Leader>gi', vim.lsp.buf.implementation,
  { noremap = true, desc = 'Go to implementation' })
vim.keymap.set({ 'n' }, '<Leader>gt', vim.lsp.buf.type_definition,
  { noremap = true, desc = 'Go to type definition' })

vim.keymap.set("n", "<leader>k", function()
  vim.diagnostic.open_float(nil, { focusable = false, source = "if_many" })
end, { desc = "Diagnostic float" })

vim.keymap.set({ 'n' }, '<Leader>F', vim.lsp.buf.references, { noremap = true, desc = 'Find references LSP' })
vim.keymap.set({ 'n' }, '<Leader>f', function ()
  vim.lsp.buf.format({
    filter = function(client)
      return client.name ~= "ts_ls"
    end
  })
end, { noremap = true, desc = 'Apply format fixes' })

vim.keymap.set('n', '[d', function() vim.diagnostic.jump({count= -1, float = true}) end,
  { noremap = true, desc = 'Go to previous issue' })
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({count= 1,float = true}) end,
  { noremap = true, desc = 'Go to next issue with float' })
