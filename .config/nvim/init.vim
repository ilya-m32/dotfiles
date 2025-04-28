function! s:source_config(path)
  let l:full_path = join([has('nvim') ? stdpath('config') : '~/.config/nvim', a:path], '/')
  execute "source " . l:full_path
endfunction

call s:source_config('configs/editor.vim')
call s:source_config('configs/keymaps.vim')

if has('nvim')
  " Lualine does this in buffers
  set showtabline=0
endif

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
  Plug 'chriskempson/base16-vim'

  " Key plugins
  Plug 'w0rp/ale', {}
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all'  }

  " Domain specific
  Plug 'stevearc/vim-arduino', { 'for': 'arduino' }

  " NVIM-only
  if has('nvim')
    " Tresitter integration
    Plug 'nvim-treesitter/nvim-treesitter'

    " fzf-integration
    Plug 'ibhagwan/fzf-lua'

    " Commonly used functions
    Plug 'nvim-lua/plenary.nvim'
    " Using my fork until https://github.com/folke/snacks.nvim/issues/1537 is resolved
    "Plug 'folke/snacks.nvim'
    Plug 'ilya-m32/snacks.nvim'

    " Navigation
    Plug 'nvim-tree/nvim-tree.lua'

    " visuals
    Plug 'nvim-tree/nvim-web-devicons'

    " line
    Plug 'nvim-lualine/lualine.nvim'

    " text editing
    Plug 'gbprod/yanky.nvim'
    Plug 'kylechui/nvim-surround'

    " Global search & replace
    Plug 'nvim-pack/nvim-spectre'

    " Session
    Plug 'Shatur/neovim-session-manager'

    " Markdown previewer
    Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

    Plug 'lewis6991/gitsigns.nvim'

    " Diff
    Plug 'sindrets/diffview.nvim'

    " Use tmux tabline
    Plug 'vimpostor/vim-tpipeline'

    " == Experimental ==
    Plug 'robitx/gp.nvim'
    Plug 'folke/which-key.nvim'
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
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

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
require('plugins/treesitter')
require('plugins/ale')
require('plugins/lualine')
require('plugins/snacks')
require('plugins/yanky')
require('plugins/nvim-tree')
require('plugins/fzf-lua')
require("nvim-surround").setup({})
require("plugins/gitsigns")
require("plugins/gp")
require("plugins/which-key")
require("plugins/session-manager")
--Spectre
vim.api.nvim_set_keymap('n', '<leader>R', ':Spectre<CR>', { noremap = true, silent = true })
EOF
endif

" Arduino
autocmd!
au BufNewFile,BufRead *.ino set filetype=cpp
augroup FiletypeGroup

  autocmd!
  let b:arduino_dir = '/usr/share/arduino'
augroup END

" Legacy syntax highlight, after theme is loaded
syntax on

" Clipboard fallback
if has('nvim') && !empty($WAYLAND_DISPLAY) && executable('xclip')
 let g:clipboard = {
    \   'name': 'xclipOnWayland',
    \   'copy': {
    \      '+': ['xclip', '-quiet', '-i', '-selection', 'clipboard'],
    \      '*': ['xclip', '-quiet', '-i', '-selection', 'primary'],
    \    },
    \   'paste': {
    \      '+': ['xclip', '-o', '-selection', 'clipboard'],
    \      '*': ['xclip', '-o', '-selection', 'primary'],
    \   },
    \   'cache_enabled': 1,
    \ }
endif

" Spell checking in neovim
" set spelllang=en_us
" set spell
