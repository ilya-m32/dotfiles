-- fzf-lua
local fzf_lua = require('fzf-lua')

fzf_lua.setup{
  winopts = require('plugins/shared-opts').FZF_LUA_WINOPTS,
  git = {
    files = {
      prompt = 'GFiles❯ ',
      git_icons = true,
      file_icons = true,
      color_icons = true,
      cwd_header = true,
    },
  },
  marks = {
    marks = '%d'
  }
}
fzf_lua.register_ui_select()

vim.keymap.set('n', '<C-f>', ':FzfLua live_grep_native<CR>')
vim.keymap.set('v', '<C-f>', '"gy:FzfLua grep_visual<CR>')
vim.keymap.set('v', 'gs', '"gy:FzfLua grep_visual<CR>')
vim.keymap.set({'n','v'}, '<Leader>q', ':FzfLua quickfix<CR>')
vim.keymap.set({'n','v'}, '<Leader>s', ':FzfLua lsp_document_symbols<CR>')

vim.keymap.set('n', '<Leader>t', ':FzfLua tabs<CR>')
vim.keymap.set('n', '<Leader>b', ':FzfLua buffers<CR>')
