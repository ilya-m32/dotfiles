local ale_border = {'│', '─', '╭', '╮', '╯', '╰', '│', '─'}
local border = {'╭', '─', '╮', '│', '╯', '─', '╰', '│'}

-- Not ALE but for it
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '>',
      [vim.diagnostic.severity.WARN] = '-',
    },
    linehl = {},
    numhl = {
      [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
      [vim.diagnostic.severity.WARN] = 'WarningMsg',
    },
  },
  float = {
    border = border
  }
})
vim.keymap.set("n", "<leader>k", function()
  vim.diagnostic.open_float(nil, { focusable = false, source = "if_many" })
end, { desc = "Diagnostic float" })

local ale_js_linters = { 'eslint', 'tsserver', 'biome' }
local ale_js_fixes = { 'biome', 'prettier', 'eslint' }

require("ale").setup({
  lint_on_text_changed = 'never',
  lint_on_enter = 1,
  completion_enabled = 1,

  floating_window_border = ale_border,
  floating_preview = 1,

  linters_explicit = 0,
  hover_to_floating_preview = 1,
  use_neovim_diagnostics_api = 1,
  use_neovim_lsp_api = 1,

  virtualtext_cursor = "disabled",
  fixers = {
    ['*'] = {'remove_trailing_lines', 'trim_whitespace'},
    javascript = ale_js_fixes,
    typescript = ale_js_fixes,
    typescriptreact = ale_js_fixes,
    cpp = {'clang-format'},
    rust = {'rustfmt'},
  },
  linters = {
    markdown = {},
    javascript = ale_js_linters,
    jsx = ale_js_linters,
    typescript = ale_js_linters,
    python = {'flake8'},
    perl = {'perl-critic'},
    cpp = {'clangd'},
    rust = {'analyzer'},
  }
})

require('ale.util').aleFileSelectAsync = function (params)
  local item_list = params.item_list
  local options = params.options or {}

  local format_item = function(item)
    return string.format("%s:%s", item.filename, item.line, item.match)
  end

  local fzf_items = {}
  local items_map = {}
  for _, item in ipairs(item_list) do
    local formatted = format_item(item)
    items_map[formatted] = item
    table.insert(fzf_items, formatted)
  end

  require('fzf-lua').fzf_exec(
    fzf_items,
    {
      prompt = options.prompt or 'Select one file: ',
      previewer = 'builtin',
      actions = {
        -- Define the action upon selection
        ['default'] = function(selected)
          local selected_item = items_map[selected[1]]
          if selected_item then
            vim.api.nvim_command('edit ' .. selected_item.filename)
            vim.api.nvim_win_set_cursor(0, {selected_item.line, selected_item.column})
          end
        end
      }
    }
  )
end

-- ALE key mappings
vim.api.nvim_set_keymap('n', '<Leader>n', '', { callback = function() vim.diagnostic.goto_next() end, noremap = true, desc = 'Go to next issue' })
vim.api.nvim_set_keymap('n', '[d', '', { callback = function() vim.diagnostic.goto_prev() end, noremap = true, desc = 'Go to previous issue' })
vim.api.nvim_set_keymap('n', ']d', '', { callback = function() vim.diagnostic.goto_next() end, noremap = true, desc = 'Go to next issue' })
vim.api.nvim_set_keymap('n', '<Leader>r', '', {
  callback = function()
    local old_name = vim.fn.expand('<cword>')

    vim.ui.input({prompt = "New name: ", default = old_name}, function(new_name)
      vim.call('ale#rename#Execute', new_name)
    end)
  end,
  noremap = true,
  silent = true,
  desc = 'Rename symbol using ALE'
})

vim.api.nvim_set_keymap('n', '<Leader>f', ':ALEFix<CR>', { noremap = true, desc = 'Apply ALE fix to the issue' })
vim.api.nvim_set_keymap('n', '<Leader>gd', ':ALEGoToDefinition<CR>', { noremap = true, desc = 'Go to definition using ALE' })
vim.api.nvim_set_keymap('n', '<Leader>gi', ':ALEGoToImplementation<CR>', { noremap = true, desc = 'Go to implementation using ALE' })
vim.api.nvim_set_keymap('n', '<Leader>gt', ':ALEGoToTypeDefinition<CR>', { noremap = true, desc = 'Go to type definition using ALE' })
vim.api.nvim_set_keymap('n', '<Leader>ai', ':ALEImport<CR>', { noremap = true, desc = 'Import using ALE' })
vim.api.nvim_set_keymap('n', '<Leader>F', ':ALEFindReferences<CR>', { noremap = true, desc = 'Find references using ALE' })
vim.api.nvim_set_keymap('n', 'm', ':ALEHover<CR>', { noremap = true, desc = 'Show ALE hover information' })
vim.api.nvim_set_keymap('n', 'K', ':ALEDocumentation<CR>', { noremap = true, desc = 'Show ALE documentation' })

vim.api.nvim_set_hl(0, 'FloatTitle', {link='FzfLuaTitle'})
vim.api.nvim_set_hl(0, 'NormalFloat', {link='FzfLuaNormal'})
vim.api.nvim_set_hl(0, 'FloatBorder', {link='FzfLuaBorder'})
vim.api.nvim_set_hl(0, 'PmenuSel', {link='TabLineSel'})

if vim.env.BVIM then
  vim.g.ale_pattern_options = {
    ['.*%.inc$'] = {ale_enabled = 0},
    ['.*%.tmpl$'] = {ale_enabled = 0},
  }

  vim.api.nvim_create_augroup('FiletypeGroup', {})
  vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
    group = 'FiletypeGroup',
    pattern = '*.inc',
    command = 'set filetype=tmpl',
  })
  vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
    group = 'FiletypeGroup',
    pattern = '*.tmpl',
    command = 'set filetype=tmpl',
  })
end
