" ======================
" ======= Main settings
" ======================
set shell=/bin/zsh

" Colors & theme
set background=dark
set t_co=256

hi MatchParen cterm=bold ctermbg=none ctermfg=darkred

filetype off
filetype plugin indent on

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
set signcolumn=yes:1

" Splits
set splitbelow
set splitright

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

" Clipboard fallback
if has('nvim') && executable('xclip')
  let g:clipboard = 'xclip'
  set clipboard=""
endif
