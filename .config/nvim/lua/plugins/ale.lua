local use_ale_bindings = false

local ale_js_linters = { 'biome', 'eslint' }
local ale_js_fixes = { 'biome', 'prettier', 'eslint' }

require("ale").setup({
  lint_on_text_changed = 'never',
  lint_on_enter = 1,
  completion_enabled = 0,
  completion_autoimport = 0,

  floating_window_border = { '│', '─', '╭', '╮', '╯', '╰', '│', '─' },
  floating_preview = 1,

  linters_explicit = 0,
  hover_to_floating_preview = 1,
  use_neovim_diagnostics_api = 1,
  use_neovim_lsp_api = 1,
  disable_lsp = 'auto', -- Give priority to LSPs

  virtualtext_cursor = "disabled",
  fixers = {
    ['*'] = { 'remove_trailing_lines', 'trim_whitespace' },
    javascript = ale_js_fixes,
    typescript = ale_js_fixes,
    typescriptreact = ale_js_fixes,
    cpp = { 'clang-format' },
    python = { 'black' },
    rust = { 'rustfmt' },
  },
  linters = {
    markdown = {},
    javascript = ale_js_linters,
    jsx = ale_js_linters,
    typescript = ale_js_linters,
    python = { 'flake8', 'pylsp' },
    perl = { 'perl-critic' },
    cpp = { 'clangd' },
    rust = { 'analyzer' },
  }
})

-- ALE key mappings
if use_ale_bindings then
  vim.api.nvim_set_keymap('n', '<Leader>n', '', { callback = function() vim.diagnostic.goto_next() end, noremap = true, desc = 'Go to next issue' })
  vim.api.nvim_set_keymap('n', '[d', '', { callback = function() vim.diagnostic.goto_prev() end, noremap = true, desc = 'Go to previous issue' })
  vim.api.nvim_set_keymap('n', ']d', '', { callback = function() vim.diagnostic.goto_next() end, noremap = true, desc = 'Go to next issue' })
  vim.api.nvim_set_keymap('n', '<Leader>r', '', {
    callback = function()
      local old_name = vim.fn.expand('<cword>')

      vim.ui.input({prompt = "New name: ", default = old_name}, function(new_name)
        vim.call('ale#rename#Execute', new_name)
      end)
    end,
    noremap = true,
    silent = true,
    desc = 'Rename symbol using ALE'
  })

  vim.api.nvim_set_keymap('n', '<Leader>f', ':ALEFix<CR>', { noremap = true, desc = 'Apply ALE fix to the issue' })
  vim.api.nvim_set_keymap('n', '<Leader>gd', ':ALEGoToDefinition<CR>', { noremap = true, desc = 'Go to definition using ALE' })
  vim.api.nvim_set_keymap('n', '<Leader>gi', ':ALEGoToImplementation<CR>', { noremap = true, desc = 'Go to implementation using ALE' })
  vim.api.nvim_set_keymap('n', '<Leader>gt', ':ALEGoToTypeDefinition<CR>', { noremap = true, desc = 'Go to type definition using ALE' })
  vim.api.nvim_set_keymap('n', '<Leader>ai', ':ALEImport<CR>', { noremap = true, desc = 'Import using ALE' })
  vim.api.nvim_set_keymap('n', '<Leader>F', ':ALEFindReferences<CR>', { noremap = true, desc = 'Find references using ALE' })
  vim.api.nvim_set_keymap('n', 'm', ':ALEHover<CR>', { noremap = true, desc = 'Show ALE hover information' })
  vim.api.nvim_set_keymap('n', 'K', ':ALEDocumentation<CR>', { noremap = true, desc = 'Show ALE documentation' })
end

if vim.env.BVIM then
  vim.g.ale_pattern_options = {
    ['.*%.inc$'] = { ale_enabled = 0 },
    ['.*%.tmpl$'] = { ale_enabled = 0 },
  }

  vim.api.nvim_create_augroup('FiletypeGroup', {})
  vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    group = 'FiletypeGroup',
    pattern = '*.inc',
    command = 'set filetype=tmpl',
  })
  vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    group = 'FiletypeGroup',
    pattern = '*.tmpl',
    command = 'set filetype=tmpl',
  })
end
