-- Lualine

require'lualine'.setup {
  options = {
    icons_enabled = false,
    theme = 'auto',
    component_separators = { left = '|', right = '|'},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {
      {'b:gitsigns_head'},
    },
    lualine_c = {
      {
        'diagnostics',
        sources = { 'nvim_diagnostic', 'ale' },
        always_visible = true,   -- Show diagnostics even if there are none.
      },
      {
        'buffers',
        show_filename_only = true,
        show_modified_status = true,
        mode = 4,
        max_length = 60,

        buffers_color = {
          active = 'MoreMsg',
        },
      }
    },
    lualine_x = {
      {
        'tabs',
        mode = 2,
        tabs_color = {
          active = 'MoreMsg',
        },
      },
      {
          'searchcount',
          maxcount = 999,
          timeout = 500,
      },
      'selectioncount'
    },
    lualine_y = {
      'encoding', 'fileformat', 'filetype',
    },
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {'nvim-tree', 'fzf', 'fugitive'}
}
