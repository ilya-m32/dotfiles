require('dressing').setup({
  input = {
    enabled = true,
    default_prompt = ">:",
    prompt_align = "left",

    insert_only = false,
    start_in_insert = true,

    -- These are passed to nvim_open_win
    border = "rounded",
    -- 'editor' and 'win' will default to being centered
    relative = "cursor",

    -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
    prefer_width = 0.4,
    width = nil,
    max_width = 0.66,
    min_width = 0.2,

    buf_options = {},
    win_options = {
      winblend = 10,
      wrap = true,
    },

    -- Set to `false` to disable
    mappings = {
      n = {
        ["<Esc>"] = "Close",
        ["<CR>"] = "Confirm",
      },
      i = {
        ["<C-c>"] = "Close",
        ["<CR>"] = "Confirm",
        ["<Up>"] = "HistoryPrev",
        ["<Down>"] = "HistoryNext",
      },
    },
    override = function(conf)
      conf.row = 1
      conf.anchor = "NW"
      return conf
    end,
  },
  select = {
    enabled = true,
    backend = { "fzf_lua", "builtin"},
    -- Trim trailing `:` from prompt
    trim_prompt = true,

    -- Options for fzf_lua selector
    fzf_lua = {
      winopts = require('plugins/shared-opts').FZF_LUA_WINOPTS,
    },
  },
})
