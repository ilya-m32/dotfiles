" ======================
" ======= Main settings
" ======================
set shell=/bin/zsh

" Colors & theme
set background=dark
set t_co=256
let base16colorspace=256

hi MatchParen cterm=bold ctermbg=none ctermfg=darkred

filetype off
filetype plugin indent on

" ======================
" ======= Plugins
" ======================
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()
  Plugin 'VundleVim/Vundle.vim'
  Plugin 'AndrewRadev/sideways.vim'
  Plugin 'Yggdroot/indentLine'
  Plugin 'airblade/vim-rooter'
  Plugin 'chriskempson/base16-vim'
  Plugin 'RRethy/nvim-base16'
  Plugin 'christoomey/vim-tmux-navigator'
  Plugin 'editorconfig/editorconfig-vim'
  Plugin 'jiangmiao/auto-pairs'
  Plugin 'matze/vim-move'
  Plugin 'mhinz/vim-startify'
  Plugin 'othree/html5.vim'
  Plugin 'tpope/vim-commentary.git'
  Plugin 'tpope/vim-fugitive'
  Plugin 'tpope/vim-repeat'
  Plugin 'tpope/vim-sleuth'
  Plugin 'tpope/vim-surround'
  Plugin 'w0rp/ale'
  Plugin 'wesQ3/vim-windowswap'
  Plugin 'ryanoasis/vim-devicons'

  Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all'  }

  " NVIM-only
  if has('nvim')
    Plugin 'nvim-treesitter/nvim-treesitter'
    Plugin 'nvim-lua/plenary.nvim'
    Plugin 'gbprod/yanky.nvim'
    Plugin 'ibhagwan/fzf-lua'
    Plugin 'stevearc/dressing.nvim'
    Plugin 'nvim-lualine/lualine.nvim'
    Plugin 'nvim-tree/nvim-tree.lua'
    Plugin 'Wansmer/treesj'
    Plugin 'Shatur/neovim-session-manager'
  else
  " Vimscript analogs
    Plugin 'junegunn/fzf.vim'
    Plugin 'HerringtonDarkholme/yats.vim'
    Plugin 'scrooloose/nerdtree'
    Plugin 'pangloss/vim-javascript'
  endif

  if $BVIM
    let plugin_path = $BVIM
    Plugin plugin_path
  endif
call vundle#end()

" ======================
" ======= Common remaps
" ======================
" most useful remap
nnoremap ; :
" Leader for my custom commands
let g:mapleader = ","

" Auto indent pasted text.
nnoremap p p=`]<C-o>
nnoremap P P=`]<C-o>

" To the blackhole if not specified to copy
nnoremap x "_x
nnoremap d "_d
nnoremap D "_D
vnoremap d "_d
nnoremap <leader>d ""d
nnoremap <leader>D ""D
vnoremap <leader>d ""d

" Hide search results
nnoremap <Leader>, :noh<cr>

" replace current selection with default register without yanking it
vnoremap <leader>p "_dP

" Allowing . to work in visual line mode
vnoremap . :normal .<CR>

" Buffers switch hotkey
let c = 1
while c <= 99
    execute "nnoremap " . c . "gb :" . c . "b\<CR>"
        let c += 1
    endwhile

" Better word search
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

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

-- Treesitter
require'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
        },
    },
}

-- Lualine
require'lualine'.setup {
  options = {
    icons_enabled = false,
    theme = 'auto',
    component_separators = { left = '|', right = '|'},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {},
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
  tabline = {
    lualine_a = {},
    lualine_b = {
      {
        'buffers',
        show_filename_only = true,
        show_modified_status = true,
        mode = 2,

        buffers_color = {
          active = 'MoreMsg',
        },
      }
    },
    lualine_c = {},
    lualine_x = {},
    lualine_y = {
      {
        'tabs',
        mode = 2,
        tabs_color = {
          active = 'MoreMsg',
        },
      }
    },
    lualine_z = {},
  },
  extensions = {'nvim-tree', 'fzf', 'fugitive'}
}

local BORDER_OPTS = { "┌", "─", "┐", "│", "┘", "─", "└", "│" }

local FZF_LUA_WINOPTS = {
  height = 0.4,
  width = 1,
  row = 1,
  -- border = "none",
  preview = {
    horizontal = 'right:40%'
  },
}

-- dressing.nvim
require('dressing').setup({
  input = {
    enabled = true,
    default_prompt = ">:",
    prompt_align = "left",

    insert_only = false,
    start_in_insert = true,

    -- These are passed to nvim_open_win
    anchor = "NW",
    border = "rounded",
    -- 'editor' and 'win' will default to being centered
    relative = "editor",

    -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
    prefer_width = 0.5,
    width = nil,
    max_width = 0.66,
    min_width = 0.2,

    buf_options = {},
    win_options = {
      winblend = 10,
      wrap = true,
      winhighlight = 'FloatTitle:FzfLuaTitle,NormalFloat:FzfLuaNormal,FloatBorder:FzfLuaNormal',
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
      -- This is the config that will be passed to nvim_open_win.
      -- Change values here to customize the layout
      -- print(vim.inspect(conf))
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
      winopts = FZF_LUA_WINOPTS,
    },
  },
})

-- Yankring
require("yanky").setup(
{
  ring = {
    history_length = 100,
    storage = "shada",
    sync_with_numbered_registers = true,
    cancel_event = "update",
  },
  picker = {
    select = {},
  },
  system_clipboard = {
    sync_with_ring = true,
  },
  highlight = {
    on_put = false,
    on_yank = false,
    timer = 400,
  },
  preserve_cursor_position = {
    enabled = true,
  },
})

vim.keymap.set({"n","x"}, "p", "<Plug>(YankyPutAfter)")
vim.keymap.set({"n","x"}, "P", "<Plug>(YankyPutBefore)")
vim.keymap.set({"n","x"}, "gp", "<Plug>(YankyGPutAfter)")
vim.keymap.set({"n","x"}, "gP", "<Plug>(YankyGPutBefore)")
vim.keymap.set({"n","x"}, "y", "<Plug>(YankyYank)")
vim.keymap.set('n', '<Leader>p', ':YankyRingHistory<CR>')

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

-- Nvim-tree
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  sync_root_with_cwd = true,
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
    side = 'right',
    width = 40
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
        file = false,
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

function tree_open_find_safe(args)
  local currentPath = vim.api.nvim_buf_get_name(0)

  if (currentPath == "" or vim.fn.filereadable(currentPath) == 0) then
    vim.api.nvim_cmd({cmd = 'NvimTreeOpen'}, {})
    return
  end

  vim.api.nvim_cmd({cmd = 'NvimTreeFindFile'}, {})
end

vim.api.nvim_create_user_command('TreeOpen', tree_open_find_safe, {})
vim.keymap.set('n', '<Leader><tab>', ':TreeOpen<CR>')

-- FZF-LUA
require('fzf-lua').setup{
  winopts = FZF_LUA_WINOPTS,
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

-- TreeSJ
local tsj = require('treesj')
local langs = {}

tsj.setup({
  use_default_keymaps = false,
  check_syntax_error = true,
  max_join_length = 120,
  cursor_behavior = 'hold',
  notify = true,
  langs = langs,
})

vim.keymap.set('n', 'gJ', ':TSJSplit<CR>')
vim.keymap.set('n', 'gK', ':TSJJoin<CR>')

-- Session manager
require('session_manager').setup({
  autoload_mode = require('session_manager.config').AutoloadMode.Disabled,
  autosave_last_session = true,
  autosave_ignore_not_normal = true,
  autosave_ignore_dirs = {},
  autosave_ignore_filetypes = {
    'gitcommit',
  },
  autosave_ignore_buftypes = {},
  autosave_only_in_session = false,
  max_path_length = 120,
})
vim.keymap.set('n', '<Leader>s', ':SessionManager load_session<CR>')
EOF
endif

" JSON highlighter
set conceallevel=0
" Disable quote concealing in JSON files
let g:vim_json_conceal=0

" ======================
" ======= Other options
" ======================
" timeouts for fast esc and normal mode
set timeoutlen=1000 ttimeoutlen=0

set history=500

" Speedup
set synmaxcol=250 " Don't bother highlighting anything over 200 chars

" Not using gui cursor: default is fine
set guicursor=

set cmdheight=1
set hid

set wildignore+=.git,.hg,.svn,*.o,*.aux,*.png,*.jpg,*.pdf

"When searching try to be smart about cases 
set smartcase

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=1

" Add a bit extra margin to the left
set foldcolumn=0

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase
set smartcase

set nobackup
set nowb
set noswapfile

set expandtab
set smarttab

" Copy current filepath
command! CopyBuffer let @+ = expand('%:p')

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

" Old regex engine disabled
set re=0

set list listchars=tab:\ \ ,trail:·

set nowrap
set linebreak

" Scrolling
set scrolloff=8
set sidescrolloff=5
set sidescroll=1

" Search
set incsearch
set hlsearch
set ignorecase
set smartcase

" Working with system buffer
if has('clipboard')
  map <F2> "+p
  map <F3> "+y
endif

" Lines
set colorcolumn=120
set cursorline
set synmaxcol=900

" Number lines
set number relativenumber
set numberwidth=2

" Splits
set splitbelow
set splitright

" Ale
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 1
let g:ale_completion_enabled = 1
let g:ale_linters = {
  \ 'javascript': ['eslint'],
  \ 'jsx': ['eslint'],
  \ 'typescript': ['eslint', 'tsserver'],
  \ 'python': ['flake8'],
  \ 'perl': ['perl-critic'],
  \}
let g:ale_sign_column_always = 1
let g:ale_sign_error = '>'
let g:ale_sign_warning = '-'
let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰', '│', '─']
let g:ale_fljating_preview = 1
let g:ale_hover_to_floating_preview = 1

let g:ale_set_signs = 1
let g:ale_fixers = ['prettier', 'eslint']

" ALE Hotkeys
nnoremap <Leader>j :ALENext<CR>
nnoremap <Leader>k :ALEPrevious<CR>
nnoremap <Leader>r :ALERename<CR>

" Hover
nnoremap m :ALEHover<CR>

highlight ALEError ctermbg=none cterm=underline
highlight ALEWarning ctermbg=none cterm=underline
highlight ALEStyleError ctermfg=darkgrey
highlight ALEStyleWarning ctermfg=darkgrey

if $BVIM
  let g:ale_pattern_options = {
  \ '.*\.inc$': {'ale_enabled': 0},
  \ '.*\.tmpl$': {'ale_enabled': 0},
  \}

  augroup FiletypeGroup
    au BufNewFile,BufRead *.inc set filetype=tmpl
  augroup END
  augroup FiletypeGroup
    au BufNewFile,BufRead *.tmpl set filetype=tmpl
  augroup END
endif

" Vim node gf
set path+=.,src
set suffixesadd+=.js,.jsx

" ======================
" ======= Crutches & stuff
" ======================

" Going to English when leaving insert mode
function! SetUsLayout()
  silent !gsettings set org.gnome.desktop.input-sources current 0
endfunction

if has('linux')
  autocmd InsertLeave * call SetUsLayout()
endif
