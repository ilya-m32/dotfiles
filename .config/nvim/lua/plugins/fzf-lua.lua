-- fzf-lua
require('fzf-lua').setup{
  winopts = require('plugins/shared-opts').FZF_LUA_WINOPTS,
  git = {
    files = {
      prompt = 'GFiles❯ ',
      git_icons = true,
      file_icons = true,
      color_icons = true,
      show_cwd_header = true,
    },
  }
}

vim.keymap.set('n', '<C-p>', ':FzfLua git_files<CR>')
vim.keymap.set('n', '<C-f>', ':FzfLua live_grep_native<CR>')
vim.keymap.set('n', '<Leader>t', ':FzfLua tabs<CR>')
vim.keymap.set('n', '<Leader>b', ':FzfLua buffers<CR>')
vim.keymap.set('v', 'gs', '"gy:FzfLua grep_visual<CR>')

-- Define a replacement for vim.ui.select using fzf-lua
vim.ui.select = function(items, opts, on_choice)
  -- Ensure options are initialized correctly
  opts = opts or {}

  -- Configure fzf-lua with options safely
  local fzf_opts = {
    prompt = opts.prompt or 'Select one:',
    format_item = opts.format_item or tostring
  }

  -- Transform items using format_item function if provided
  local fzf_items = {}
  for _, item in ipairs(items) do
    table.insert(fzf_items, fzf_opts.format_item(item))
  end

  -- Use fzf-lua to execute fuzzy finder
  require('fzf-lua').fzf_exec(
    fzf_items,
    {
      prompt = fzf_opts.prompt,
      actions = {
        -- Define the action upon selection
        ['default'] = function(selected)
          if #selected > 0 then
            -- Find the index manually
            local index = nil
            for i, fzf_item in ipairs(fzf_items) do
              if fzf_item == selected[1] then
                index = i
                break
              end
            end

            -- Call on_choice with the correct item and index
            if index then
              on_choice(items[index], index)
            else
              on_choice(nil, nil)
            end
          else
            on_choice(nil, nil)
          end
        end
      }
    }
  )
end
