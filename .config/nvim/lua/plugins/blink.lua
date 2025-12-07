local colorful_menu = require("colorful-menu")

require('blink.cmp').setup({
  enabled = function()
    return not vim.tbl_contains({ "lua", "markdown" }, vim.bo.filetype)
  end,

  keymap = {
    preset = 'default',
  },

  cmdline = {
    enabled = true,
    keymap = {
      ['<Tab>'] = { 'show', 'accept' },
    },
    completion = { menu = { auto_show = true } },
  },

  appearance = {
    nerd_font_variant = 'mono'
  },

  completion = {
    keyword = {
      range = 'full',
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 500,
    },
    menu = {
      border = 'rounded',
      -- nvim-cmp style menu
      draw = {
        -- We don't need label_description now because label and label_description are already
        -- combined together in label by colorful-menu.nvim.
        columns = {
          { "label", gap = 8 },
          { "kind", "kind_icon", gap = 2 },

          { 'source_name', gap = 2},

        },
        components = {
          label = {
            text = function(ctx)
              return colorful_menu.blink_components_text(ctx)
            end,
            highlight = function(ctx)
              return colorful_menu.blink_components_highlight(ctx)
            end,
          },
        },
      },
    },
    accept = {

    }
  },

  sources = {
    default = { 'lsp', 'path', 'buffer' },
    min_keyword_length = 2
  },

  fuzzy = {
    -- implementation = "prefer_rust_with_warning",
    implementation = "lua",
    prebuilt_binaries = {
      download = false
    },
  },
  signature = { enabled = true },
})
