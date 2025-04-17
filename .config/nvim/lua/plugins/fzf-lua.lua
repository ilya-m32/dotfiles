-- fzf-lua
local FZF_LUA_WINOPTS = {
  height = 0.4,
  width = 1,
  row = 1,
  preview = {
    horizontal = 'right:40%'
  },
}

require('fzf-lua').setup{
  winopts = require('plugins/shared-opts').FZF_LUA_WINOPTS,
  git = {
    files = {
      prompt = 'GFiles❯ ',
      git_icons = true,
      file_icons = true,
      color_icons = true,
      show_cwd_header = true,
    },
  }
}

vim.keymap.set('n', '<C-p>', ':FzfLua git_files<CR>')
vim.keymap.set('n', '<C-f>', ':FzfLua live_grep_native<CR>')
vim.keymap.set('n', '<Leader>t', ':FzfLua tabs<CR>')
vim.keymap.set('n', '<Leader>b', ':FzfLua buffers<CR>')
vim.keymap.set('v', 'gs', '"gy:FzfLua grep_visual<CR>')
