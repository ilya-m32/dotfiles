-- Nvim-tree

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  sync_root_with_cwd = true,
  view = {
    adaptive_size = true,
    side = 'right',
    width = 40,
  },
  update_focused_file = {
    enable = false,
    update_root = false,
    ignore_list = {},
  },
  renderer = {
    group_empty = true,
    indent_markers = {
      enable = true,
      inline_arrows = true,
    },
    icons = {
      webdev_colors = true,
      git_placement = "signcolumn",
      show = {
        git = true,
        file = true,
        folder = true,
        folder_arrow = true,
      },
      glyphs = {
        folder = {
          arrow_closed = "▸",
          arrow_open = "▾",
        },
        git = {
          unstaged = "◌",
          staged = "✓",
          unmerged = "⌥",
          renamed = "➜",
          untracked = "★",
          deleted = "⊖",
          ignored = "✗",
        },
      },
    },
  },
  filters = {
    dotfiles = true,
    custom = { "^.git$" },
  },
  actions = {
    change_dir = {
      enable = false,
      global = false,
      restrict_above_cwd = false,
    },
    open_file = {
      quit_on_open = true,
    },
  },
})

local tree_open_find_safe = function()
  local currentPath = vim.api.nvim_buf_get_name(0)

  if (currentPath == "" or vim.fn.filereadable(currentPath) == 0) then
    vim.api.nvim_cmd({cmd = 'NvimTreeOpen'}, {})
    return
  end

  vim.api.nvim_cmd({cmd = 'NvimTreeFindFile'}, {})
end

vim.api.nvim_create_user_command('TreeOpen', tree_open_find_safe, {})
vim.keymap.set('n', '<Leader><tab>', ':TreeOpen<CR>')
