local char = "¦"

-- Think better here?
vim.api.nvim_set_hl(0, 'Conceal', {ctermfg=239, fg='#525252'})

require('snacks').setup({
  input = { enabled = true },
  indent = {
    indent = {
      priority = 1,
      enabled = true, -- enable indent guides
      char = char,
      only_scope = false, -- only show indent guides of the scope
      only_current = false, -- only show indent guides in the current window
      hl = "Conceal", ---@type string|string[] hl groups for indent guides
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
    },
  },
  picker = {
    enabled = false
  }
})
