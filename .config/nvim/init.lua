-- Neovim-only config (Neovim 0.12)

vim.g.mapleader = ','
vim.g.maplocalleader = ','

require('config.editor')
require('config.keymaps')

-- Plugin globals that should be set before plugin code loads.
vim.g.rooter_silent_chdir = 0
vim.g.rooter_resolve_links = 1
vim.g.rooter_patterns = { '.git', '*.sln', 'build/env.sh' }

-- nvim-tree: disable netrw early.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local gh = function(repo)
  return 'https://github.com/' .. repo
end

vim.pack.add({
  -- Universal basic
  gh('airblade/vim-rooter'),
  gh('christoomey/vim-tmux-navigator'),
  gh('jiangmiao/auto-pairs'),
  gh('tpope/vim-commentary'),
  gh('tpope/vim-repeat'),
  gh('tpope/vim-sleuth'),
  gh('wesQ3/vim-windowswap'),

  -- Visuals
  gh('mhinz/vim-startify'),
  gh('tinted-theming/tinted-vim'),

  -- Commonly used functions
  gh('nvim-lua/plenary.nvim'),

  -- LSP configs
  { src = gh('creativenull/efmls-configs-nvim'), version = vim.version.range('1.*') },
  gh('neovim/nvim-lspconfig'),

  -- Treesitter integration
  gh('nvim-treesitter/nvim-treesitter'),

  -- fzf integration and picker
  gh('ibhagwan/fzf-lua'),

  -- Using my fork until https://github.com/folke/snacks.nvim/issues/1537 is resolved
  gh('ilya-m32/snacks.nvim'),

  -- UI
  gh('nvim-tree/nvim-web-devicons'),
  gh('nvim-tree/nvim-tree.lua'),
  gh('nvim-lualine/lualine.nvim'),

  -- Text editing
  gh('gbprod/yanky.nvim'),
  gh('kylechui/nvim-surround'),

  -- Tools
  gh('nvim-pack/nvim-spectre'),
  gh('Shatur/neovim-session-manager'),
  gh('lewis6991/gitsigns.nvim'),
  gh('sindrets/diffview.nvim'),
  gh('vimpostor/vim-tpipeline'),
  gh('robitx/gp.nvim'),
  gh('nickjvandyke/opencode.nvim'),
  gh('folke/which-key.nvim'),
  gh('xzbdmw/colorful-menu.nvim'),
  gh('saghen/blink.cmp'),
}, {
  -- Ensure plugins are loaded during startup.
  load = true,
  -- Ask for confirmation on initial installs.
  confirm = true,
})

-- Keep $BVIM behavior: add local runtime dir (not managed by vim.pack).
if vim.env.BVIM and vim.env.BVIM ~= '' then
  vim.opt.rtp:prepend(vim.env.BVIM)
end

-- Legacy UI tweaks.
vim.api.nvim_set_hl(0, 'MsgArea', { link = 'StatusLineNC' })

-- Theme (provided by tinted-vim).
vim.cmd.colorscheme('base16-tomorrow-night')

-- Plugin config
require('plugins/treesitter')
require('plugins/lsp')
-- require('plugins/ale')

require('plugins/lualine')
require('plugins/snacks')
require('plugins/yanky')
require('plugins/nvim-tree')
require('plugins/fzf-lua')
require('nvim-surround').setup({})
require('plugins/gitsigns')
require('plugins/which-key')
require('plugins/session-manager')
require('plugins/blink')
-- require('plugins/gp')
require('plugins/opencode-int')
require('plugins/bookmarks')

vim.keymap.set('n', '<leader>R', '<cmd>Spectre<cr>', { silent = true })

local DEFAULT_SEVERITY = { min = vim.diagnostic.severity.WARN }
vim.diagnostic.config({
  signs = {
    severity = DEFAULT_SEVERITY,
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
  underline = {
    severity = DEFAULT_SEVERITY,
  },
  jump = {
    severity = DEFAULT_SEVERITY,
  },
  float = {
    border = 'rounded',
  },
})

vim.api.nvim_set_hl(0, 'FloatTitle', { link = 'FzfLuaTitle' })
vim.api.nvim_set_hl(0, 'NormalFloat', { link = 'FzfLuaNormal' })
vim.api.nvim_set_hl(0, 'FloatBorder', { link = 'FzfLuaBorder' })
vim.api.nvim_set_hl(0, 'Pmenu', { link = 'NormalFloat' })
vim.api.nvim_set_hl(0, 'PmenuSel', { link = 'FloatShadow' })

-- Legacy syntax highlighting after colorscheme is loaded.
vim.cmd.syntax('on')
