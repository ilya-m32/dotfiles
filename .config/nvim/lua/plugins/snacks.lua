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
    -- Explicitly disabled in favor of fzf-lua
    enabled = false
  },
  dashboard = {
    enabled = true,
    formats = {
      key = function(item)
        return { { "[", hl = "special" }, { item.key, hl = "key" }, { "]", hl = "special" } }
      end,
    },
    sections = {
      {
        section = "terminal",
        cmd = "if command -v fortune >/dev/null 2>&1 && command -v cowsay >/dev/null 2>&1; then fortune -s | cowsay; else exit 0; fi",
        hl = "header",
        padding = 1,
        indent = 8
      },
      { title = "MRU", padding = 1 },
      { section = "recent_files", limit = 8, padding = 1 },
      { title = "MRU ", file = vim.fn.fnamemodify(".", ":~"), padding = 1 },
      { section = "recent_files", cwd = true, limit = 8, padding = 1 },
      { title = "Sessions", padding = 1 },
      { section = "projects", padding = 1 },
      { title = "Bookmarks", padding = 1 },
      { section = "keys" },
    },
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
        -- winhighlight = "NormalFloat:FzfLuaNormal,FloatBorder:FzfLuaBorder,FloatTitle:SnacksInputTitle",
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

-- Over-link highlight groups
vim.api.nvim_set_hl(0, 'SnacksInputTitle', {link = 'FzfLuaTitle'})
vim.api.nvim_set_hl(0, 'SnacksInputBorder', {link = 'FzfLuaBorder'})
vim.api.nvim_set_hl(0, 'SnacksInputNormal', {link = 'FzfLuaNormal'})
vim.api.nvim_set_hl(0, 'SnacksDashboardNormal', {link = 'FzfLuaNormal'})
vim.api.nvim_set_hl(0, 'Special', {link = 'MoreMsg'})
vim.api.nvim_set_hl(0, 'Title', {link = 'FzfLuaTitle'})
