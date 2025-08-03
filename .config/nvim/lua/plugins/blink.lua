local colorful_menu = require("colorful-menu")

require('blink.cmp').setup({
  enabled = function()
    return not vim.tbl_contains({ "lua", "markdown" }, vim.bo.filetype)
  end,

  keymap = {
    preset = 'default',
    ['<Tab>'] = { 'select_and_accept' },
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
    implementation = "prefer_rust_with_warning",
    prebuilt_binaries = {
      download = false
    },
  },
  signature = { enabled = true },
})

vim.keymap.set({ 'n' }, '<Leader>r', vim.lsp.buf.rename,
  { noremap = true, silent = true, desc = 'Rename symbol using LSP' })
vim.keymap.set({ 'n', 'v' }, '<Leader>c', vim.lsp.buf.code_action, { noremap = true, desc = 'Code actions' })
vim.keymap.set({ 'n' }, 'm', function() vim.lsp.buf.hover({ focusable = false, border = 'rounded' }) end, { noremap = true, desc = 'Show hover information' })
vim.keymap.set({ 'n' }, 'K', function() vim.lsp.buf.hover({ focus = true, border = 'rounded' }) end, { noremap = true, desc = 'Show hover information' })
vim.keymap.set({ 'n' }, '<Leader>gd', vim.lsp.buf.definition, { noremap = true, desc = 'Go to definition' })
vim.keymap.set({ 'n' }, '<Leader>gi', vim.lsp.buf.implementation,
  { noremap = true, desc = 'Go to implementation using ALE' })
vim.keymap.set({ 'n' }, '<Leader>gt', vim.lsp.buf.type_definition,
  { noremap = true, desc = 'Go to type definition using ALE' })

vim.keymap.set("n", "<leader>k", function()
  vim.diagnostic.open_float(nil, { focusable = false, source = "if_many" })
end, { desc = "Diagnostic float" })

vim.keymap.set({ 'n' }, '<Leader>F', vim.lsp.buf.references, { noremap = true, desc = 'Find references LSP' })
vim.keymap.set({ 'n' }, '<Leader>f', vim.lsp.buf.format, { noremap = true, desc = 'Apply format fixes' })

vim.keymap.set('n', '[d', function() vim.diagnostic.jump({count= -1, float = true}) end,
  { noremap = true, desc = 'Go to previous issue' })
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({count= 1,float = true}) end,
  { noremap = true, desc = 'Go to next issue with float' })

local LSP_SERVERS = {
  'clangd',
  'lua_ls',
  'nil_ls',
  'pylsp',
  'rust_analyzer',
  'ts_ls',
};

vim.lsp.config('*', {
  capabilities = {
    textDocument = {
      publishDiagnostics = {
        severity_limit = "Warning",
      }
    }
  },
})

vim.lsp.enable(LSP_SERVERS)
