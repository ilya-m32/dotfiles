-- which-key
-- Hacky but works, otherwise it's not initialized properly
local which_config = {
  ---@type false | "classic" | "modern" | "helix"
  preset = "modern",
  delay = function(ctx)
    return ctx.plugin and 0 or 300
  end,
  filter = function(mapping)
    return true
  end,
  spec = {},
  notify = true,
  triggers = {
    { "<auto>", mode = "nxso" },
  },
  defer = function(ctx)
    return ctx.mode == "V" or ctx.mode == "<C-V>"
  end,
  plugins = {
    marks = true, -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    spelling = {
      enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
    presets = {
      operators = true, -- adds help for operators like d, y, ...
      motions = true, -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true, -- default bindings on <c-w>
      nav = true, -- misc bindings to work with windows
      z = true, -- bindings for folds, spelling and others prefixed with z
      g = true, -- bindings for prefixed with g
    },
  },
  win = {
    no_overlap = true,
    border = "rounded",
    padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
    title = true,
    title_pos = "left",
    zindex = 1000,
    bo = {},
    wo = {
      winblend = 20,
    },
  },
  layout = {
    width = { min = 20 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
  },
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
    ellipsis = "…",
    mappings = false,
    rules = false,
    colors = true,
    keys = {
    },
  },
  show_help = true, -- show a help message in the command line for using WhichKey
  show_keys = true, -- show the currently pressed key and its label as a message in the command line
}
-- Hack but works for first init
(vim.uv or vim.loop).new_timer():start(
  200,
  0,
  vim.schedule_wrap(function()
    require("which-key").setup(which_config)
  end)
)
