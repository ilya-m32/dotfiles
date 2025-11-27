local char = "¦"

-- Ported from indentLine

local conceal_highlight = vim.o.background == "light" and {ctermfg=249, fg="Grey70"} or {ctermfg=239, fg="Grey30"}
vim.api.nvim_set_hl(0, 'Conceal', conceal_highlight)

local snacks = require('snacks')

snacks.setup({
  indent = {
    indent = {
      priority = 1,
      enabled = true, -- enable indent guides
      char = char,
      only_scope = false, -- only show indent guides of the scope
      only_current = false, -- only show indent guides in the current window
      hl = "Conceal", ---@type string|string[] hl groups for indent guides
      skip_root_level = true
    },
    animate = {
      enabled = vim.fn.has("nvim-0.10") == 1,
      style = "out",
      easing = "linear",
      duration = {
        step = 20, -- ms per step
        total = 500, -- maximum duration
      },
    },
    ---@class snacks.indent.Scope.Config: snacks.scope.Config
    scope = {
      enabled = true, -- enable highlighting the current scope
      priority = 200,
      char = char,
      underline = false, -- underline the start of the scope
      only_current = false, -- only show scope in the current window
      hl = "Comment", ---@type string|string[] hl group for scopes
      skip_root_level = true
    },
  },
  picker = {
    -- Explicitly disabled in favor of fzf-lua
    enabled = false
  },
  notifier = {
    -- your notifier configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  input = {},
  bigfile = {}
})

-- Over-link highlight groups
vim.api.nvim_set_hl(0, 'SnacksInputTitle', {link = 'FzfLuaTitle'})
vim.api.nvim_set_hl(0, 'SnacksInputBorder', {link = 'FzfLuaBorder'})
vim.api.nvim_set_hl(0, 'SnacksInputNormal', {link = 'FzfLuaNormal'})
vim.api.nvim_set_hl(0, 'SnacksDashboardNormal', {link = 'FzfLuaNormal'})

-- For dashboard
-- vim.api.nvim_set_hl(0, 'Special', {link = 'SpecialChar'})
-- vim.api.nvim_set_hl(0, 'Title', {link = 'FzfLuaTitle'})
