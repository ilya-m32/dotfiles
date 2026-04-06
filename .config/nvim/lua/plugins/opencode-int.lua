local oc = require('opencode')

---@type opencode.Opts
vim.g.opencode_opts = {
}

-- Required for `opts.events.reload`.
vim.o.autoread = true

-- Recommended/example keymaps.
vim.keymap.set({ "n", "x" }, "<Leader>Gr", function() oc.ask("@this: ", { submit = true }) end, { desc = "Ask opencode…" })
vim.keymap.set({ "n", "x" }, "<Leader>Gc", function() oc.select() end,                          { desc = "Execute opencode action…" })
vim.keymap.set({ "n", "t" }, "<Leader>Gt", function() oc.toggle() end,                          { desc = "Toggle opencode" })

vim.keymap.set({ "n", "x" }, "<Leader>Gs",  function() return oc.operator("@this ") end,        { desc = "Add range to opencode", expr = true })

