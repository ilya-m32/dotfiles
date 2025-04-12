-- Yanky
require("yanky").setup(
  {
    ring = {
      history_length = 100,
      storage = "shada",
      sync_with_numbered_registers = true,
      cancel_event = "update",
    },
    picker = {
      select = {},
    },
    system_clipboard = {
      sync_with_ring = true,
    },
    highlight = {
      on_put = false,
      on_yank = false,
      timer = 400,
    },
    preserve_cursor_position = {
      enabled = true,
    },
  }
)

vim.keymap.set({"n","x"}, "p", "<Plug>(YankyPutAfter)")
vim.keymap.set({"n","x"}, "P", "<Plug>(YankyPutBefore)")
vim.keymap.set({"n","x"}, "gp", "<Plug>(YankyGPutAfter)")
vim.keymap.set({"n","x"}, "gP", "<Plug>(YankyGPutBefore)")
vim.keymap.set({"n","x"}, "y", "<Plug>(YankyYank)")
vim.keymap.set('n', '<Leader>p', ':YankyRingHistory<CR>')
