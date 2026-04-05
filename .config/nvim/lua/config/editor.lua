-- Editor options (ported from configs/editor.vim)

vim.opt.shell = '/bin/zsh'

vim.opt.background = 'dark'
vim.cmd('hi MatchParen cterm=bold ctermbg=none ctermfg=darkred')

-- Ensure filetype plugins/indent are enabled.
vim.cmd('filetype plugin indent on')

vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 0
vim.opt.history = 500

-- Don't bother highlighting anything over N chars.
vim.opt.synmaxcol = 900

-- Cursor style
vim.opt.guicursor = 'a:ver25-blinkwait150-blinkon200-blinkoff150'

vim.opt.cmdheight = 1
vim.opt.hidden = true
vim.opt.wildignore:append({ '.git', '.hg', '.svn', '*.o', '*.aux', '*.png', '*.jpg', '*.pdf' })

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.lazyredraw = true
vim.opt.magic = true
vim.opt.showmatch = true
vim.opt.mat = 1
vim.opt.foldcolumn = '0'
vim.opt.backspace = { 'eol', 'start', 'indent' }
vim.cmd('set whichwrap+=<,>,h,l')

vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

vim.opt.linebreak = true
vim.opt.textwidth = 500

vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.re = 0

vim.opt.list = true
vim.opt.listchars = { tab = '  ', trail = '·' }

vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 5
vim.opt.sidescroll = 1

vim.opt.incsearch = true
vim.opt.hlsearch = true

if vim.fn.has('clipboard') == 1 then
  vim.keymap.set({ 'n', 'v', 'o' }, '<F2>', '"+p', { noremap = true })
  vim.keymap.set({ 'n', 'v', 'o' }, '<F3>', '"+y', { noremap = true })
end

vim.opt.colorcolumn = '120'
vim.opt.cursorline = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 2
vim.opt.signcolumn = 'yes:1'

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.path:append({ '.', 'src' })
vim.opt.suffixesadd:append({ '.js', '.jsx' })

vim.api.nvim_create_user_command('CopyBuffer', function()
  vim.fn.setreg('+', vim.fn.expand('%:p'))
end, {})

local function set_us_layout()
  vim.system({ 'gsettings', 'set', 'org.gnome.desktop.input-sources', 'current', '0' }, { detach = true })
end

if vim.fn.has('linux') == 1 then
  vim.api.nvim_create_autocmd('InsertLeave', {
    callback = set_us_layout,
  })
end

-- Clipboard provider fallback (xclip)
if vim.fn.executable('xclip') == 1 then
  vim.g.clipboard = {
    name = 'xclip',
    copy = {
      ['+'] = 'xclip -selection clipboard',
      ['*'] = 'xclip -selection primary',
    },
    paste = {
      ['+'] = 'xclip -selection clipboard -o',
      ['*'] = 'xclip -selection primary -o',
    },
    cache_enabled = 1,
  }
end
