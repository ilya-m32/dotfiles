function! s:source_config(path)
  let l:full_path = join([has('nvim') ? stdpath('config') : '~/.config/nvim', a:path], '/')
  execute "source " . l:full_path
endfunction

call s:source_config('configs/editor.vim')
call s:source_config('configs/keymaps.vim')

" ======================
" ======= Plugins
" ======================
call plug#begin()
  " Universal basic
  Plug 'airblade/vim-rooter'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'jiangmiao/auto-pairs'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-sleuth'
  Plug 'wesQ3/vim-windowswap'

  " Visuals
  Plug 'mhinz/vim-startify'
  Plug 'tinted-theming/tinted-vim'

  " Plug 'w0rp/ale', {}

  " Domain specific
  Plug 'stevearc/vim-arduino', { 'for': 'arduino' }

  " NVIM-only
  if has('nvim')
    " Commonly used functions
    Plug 'nvim-lua/plenary.nvim'

    " LSP configs
    Plug 'neovim/nvim-lspconfig'

    " Java exp - after LSP config
    Plug 'mfussenegger/nvim-jdtls'

    " Tresitter integration
    Plug 'nvim-treesitter/nvim-treesitter'

    " fzf-integration and picker
    Plug 'ibhagwan/fzf-lua'

    " Using my fork until https://github.com/folke/snacks.nvim/issues/1537 is resolved
    "Plug 'folke/snacks.nvim'
    Plug 'ilya-m32/snacks.nvim'

    Plug 'nvim-tree/nvim-web-devicons' " visuals

    Plug 'nvim-tree/nvim-tree.lua' " navigation
    Plug 'nvim-lualine/lualine.nvim' " topline

    " text editing
    Plug 'gbprod/yanky.nvim'
    Plug 'kylechui/nvim-surround'

    Plug 'nvim-pack/nvim-spectre' " Global search & replace
    Plug 'Shatur/neovim-session-manager' " Session
    Plug 'lewis6991/gitsigns.nvim' " Git
    Plug 'sindrets/diffview.nvim' " Diff
    Plug 'vimpostor/vim-tpipeline' " Use tmux tabline
    Plug 'robitx/gp.nvim' " LLM integration
    Plug 'folke/which-key.nvim' " Nice hints
    Plug 'xzbdmw/colorful-menu.nvim' " Nice autocomplete colors
    Plug 'saghen/blink.cmp' " Autocomplete
  endif

  if $BVIM
    let plugin_path = $BVIM
    Plug plugin_path
  endif
call plug#end()

" call s:source_config('plug.snapshot')

" Tmux pipe
if has('nvim')
  let &t_fe = "\<Esc>[?1004h"
  let &t_fd = "\<Esc>[?1004l"
  set cmdheight=1
  highlight link MsgArea StatusLineNC
endif

" ======================
" ======= Plugin options
" ======================
" Base 16 theme
colorscheme base16-tomorrow-night

" Rooter
let g:rooter_silent_chdir = 0
let g:rooter_resolve_links = 1
let g:rooter_patterns = ['.git', '*.sln', 'build/env.sh']

" editorconfig
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" ===========
" === NVIM-only part
" ===========
if has('nvim')
lua << EOF
-- base
require('plugins/treesitter')
require('plugins/lsp')
--require('plugins/ale')
-- extras
require('plugins/lualine')
require('plugins/snacks')
require('plugins/yanky')
require('plugins/nvim-tree')
require('plugins/fzf-lua')
require("nvim-surround").setup({})
require("plugins/gitsigns")
require("plugins/which-key")
require("plugins/session-manager")
require("plugins/blink")
require("plugins/gp")
require('plugins/bookmarks')
--Spectre
vim.api.nvim_set_keymap('n', '<leader>R', ':Spectre<CR>', { noremap = true, silent = true })

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
    severity = DEFAULT_SEVERITY
  },
  jump = {
    severity = DEFAULT_SEVERITY
  },
  float = {
    border = 'rounded'
  },
})

vim.api.nvim_set_hl(0, 'FloatTitle', { link = 'FzfLuaTitle' })
vim.api.nvim_set_hl(0, 'NormalFloat', { link = 'FzfLuaNormal' })
vim.api.nvim_set_hl(0, 'FloatBorder', { link = 'FzfLuaBorder' })

vim.api.nvim_set_hl(0, 'Pmenu', { link = 'NormalFloat' })
vim.api.nvim_set_hl(0, 'PmenuSel', { link = 'FloatShadow' })

EOF
endif

" Legacy syntax highlight, after theme is loaded
syntax on
