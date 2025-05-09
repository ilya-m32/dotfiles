require('session_manager').setup({
  autoload_mode = require('session_manager.config').AutoloadMode.Disabled,
  autosave_last_session = true,
  autosave_ignore_not_normal = true,
  autosave_ignore_dirs = {},
  autosave_ignore_filetypes = {
    'gitcommit',
  },
  autosave_ignore_buftypes = {},
  autosave_only_in_session = false,
  max_path_length = 120,
})
vim.keymap.set('n', '<Leader>s', ':SessionManager load_session<CR>')
