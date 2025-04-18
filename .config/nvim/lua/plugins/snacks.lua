local char = "¦"

-- Think better here?
vim.api.nvim_set_hl(0, 'Conceal', {ctermfg=239, fg='#525252'})

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
  },
  input = {},
  styles = {
    input = {
      backdrop = false,
      position = "float",
      border = "rounded",
      title_pos = "center",
      -- relative = "editor",
      noautocmd = true,
      relative = "cursor",

      height = 1,
      width = 40,

      wo = {
        winhighlight = "NormalFloat:FzfLuaNormal,FloatBorder:FzfLuaBorder,FloatTitle:FzfLuaTitle",
        winblend = 10,
        wrap = true,
      },
      bo = {
        filetype = "snacks_input",
        buftype = "prompt",
      },
      b = {
        completion = true,
      },
      keys = {
        n_esc = { "<esc>", { "cmp_close", "cancel" }, mode = "n", expr = true },
        i_esc = { "<esc>", { "cmp_close", "stopinsert" }, mode = "i", expr = true },
        i_cr = { "<cr>", { "cmp_accept", "confirm" }, mode = { "i", "n" }, expr = true },
        i_tab = { "<tab>", { "cmp_select_next", "cmp" }, mode = "i", expr = true },
        i_ctrl_w = { "<c-w>", "<c-s-w>", mode = "i", expr = true },
        i_up = { "<up>", { "hist_up" }, mode = { "i", "n" } },
        i_down = { "<down>", { "hist_down" }, mode = { "i", "n" } },
        q = "cancel",
      },
    }
  }
})
