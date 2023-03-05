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

" Arrow-like movements
cmap <M-h> <Left>
cmap <M-l> <Right>

imap <M-h> <Left>
imap <M-l> <Right>
imap <M-j> <Down>
imap <M-k> <Up>

" Open link
function! OpenURLUnderCursor()
  let s:uri = expand('<cWORD>')
  let s:uri = substitute(s:uri, '?', '\\?', '')
  let s:uri = shellescape(s:uri, 1)
  if s:uri != ''
    silent exec "!open '".s:uri."'"
   :redraw!
  endif
endfunction

nnoremap gx :call OpenURLUnderCursor()<CR>
