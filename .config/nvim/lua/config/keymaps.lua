-- Keymaps (ported from configs/keymaps.vim)

-- most useful remap
vim.keymap.set('n', ';', ':', { noremap = true })

-- Auto indent pasted text.
-- NOTE: `p`/`P` are remapped by yanky.nvim.

-- To the blackhole if not specified to copy
vim.keymap.set('n', 'x', '"_x', { noremap = true })
vim.keymap.set('n', 'd', '"_d', { noremap = true })
vim.keymap.set('n', 'D', '"_D', { noremap = true })
vim.keymap.set('v', 'd', '"_d', { noremap = true })
vim.keymap.set('n', '<leader>D', '""D', { noremap = true })

-- Hide search results
vim.keymap.set('n', '<leader>,', '<cmd>noh<cr>', { silent = true, noremap = true })

-- replace current selection with default register without yanking it
vim.keymap.set('v', '<leader>p', '"_dP', { noremap = true })

-- Allowing . to work in visual line mode
vim.keymap.set('v', '.', '<cmd>normal .<cr>', { silent = true, noremap = true })

-- Buffers switch hotkey
for i = 1, 99 do
  vim.keymap.set('n', tostring(i) .. 'gb', '<cmd>' .. i .. 'b<cr>', { noremap = true, silent = true })
end

-- Arrow-like movements
vim.keymap.set('c', '<M-h>', '<Left>')
vim.keymap.set('c', '<M-l>', '<Right>')

vim.keymap.set('i', '<M-h>', '<Left>')
vim.keymap.set('i', '<M-l>', '<Right>')
vim.keymap.set('i', '<M-j>', '<Down>')
vim.keymap.set('i', '<M-k>', '<Up>')

-- Open link
vim.keymap.set('n', 'gx', function()
  local uri = vim.fn.expand('<cWORD>')
  if uri == nil or uri == '' then
    return
  end
  vim.ui.open(uri)
end, { noremap = true })
