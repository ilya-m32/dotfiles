" ALE Plugin
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 1
let g:ale_completion_enabled = 1
let g:ale_linters = {
  \ 'markdown': [''],
  \ 'javascript': ['eslint', 'biome'],
  \ 'jsx': ['eslint'],
  \ 'typescript': ['eslint', 'tsserver', 'biome'],
  \ 'python': ['flake8'],
  \ 'perl': ['perl-critic'],
  \ 'cpp': ['clangd'],
  \ 'rust': ['analyzer'],
  \}
let g:ale_sign_column_always = 1
let g:ale_sign_error = '>'
let g:ale_sign_warning = '-'
let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰', '│', '─']
let g:ale_floating_preview = 1
let g:ale_hover_to_floating_preview = 1
let g:ale_virtualtext_cursor = 'disabled'
" Disable for now, I prefer ale native signs
let g:ale_use_neovim_diagnostics_api = 0

let g:ale_set_signs = 1
let g:ale_js_fixes = ['biome', 'prettier', 'eslint']
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': g:ale_js_fixes,
\   'typescript': g:ale_js_fixes,
\   'typescriptreact': g:ale_js_fixes,
\   'cpp': ['clang-format'],
\   'rust': ['rustfmt'],
\}

if has('nvim')
lua << EOF
-- ALE key mappings
vim.api.nvim_set_keymap('n', '<Leader>n', ':ALENext<CR>', { noremap = true, desc = 'Go to next ALE issue' })
vim.api.nvim_set_keymap('n', '<Leader>r', ':ALERename<CR>', { noremap = true, desc = 'Rename symbol using ALE' })
vim.api.nvim_set_keymap('n', '<Leader>f', ':ALEFix<CR>', { noremap = true, desc = 'Apply ALE fix to the issue' })
vim.api.nvim_set_keymap('n', '<Leader>gd', ':ALEGoToDefinition<CR>', { noremap = true, desc = 'Go to definition using ALE' })
vim.api.nvim_set_keymap('n', '<Leader>gi', ':ALEGoToImplementation<CR>', { noremap = true, desc = 'Go to implementation using ALE' })
vim.api.nvim_set_keymap('n', '<Leader>gt', ':ALEGoToTypeDefinition<CR>', { noremap = true, desc = 'Go to type definition using ALE' })
vim.api.nvim_set_keymap('n', '<Leader>ai', ':ALEImport<CR>', { noremap = true, desc = 'Import using ALE' })
vim.api.nvim_set_keymap('n', '<Leader>F', ':ALEFindReferences<CR>', { noremap = true, desc = 'Find references using ALE' })
vim.api.nvim_set_keymap('n', 'm', ':ALEHover<CR>', { noremap = true, desc = 'Show ALE hover information' })
vim.api.nvim_set_keymap('n', 'K', ':ALEDocumentation<CR>', { noremap = true, desc = 'Show ALE documentation' })
EOF
endif

highlight ALEError ctermbg=none cterm=underline
highlight ALEWarning ctermbg=none cterm=underline
highlight ALEStyleError ctermfg=darkgrey
highlight ALEStyleWarning ctermfg=darkgrey

highlight! link FloatTitle FzfLuaTitle
highlight! link NormalFloat FzfLuaNormal
highlight! link FloatBorder FzfLuaBorder

if $BVIM
  let g:ale_pattern_options = {
  \ '.*\.inc$': {'ale_enabled': 0},
  \ '.*\.tmpl$': {'ale_enabled': 0},
  \}

  augroup FiletypeGroup
    au BufNewFile,BufRead *.inc set filetype=tmpl
  augroup END
  augroup FiletypeGroup
    au BufNewFile,BufRead *.tmpl set filetype=tmpl
  augroup END
endif
