function! s:source_config(path)
 let l:full_path = join([has('nvim') ? stdpath('config') : '~/.config/nvim', a:path], '/')
 execute "source " . l:full_path
endfunction

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
  Plug 'Yggdroot/indentLine'
  Plug 'airblade/vim-rooter'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'jiangmiao/auto-pairs'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-sleuth'
  Plug 'wesQ3/vim-windowswap'

  " Visuals
  Plug 'mhinz/vim-startify'
  Plug 'chriskempson/base16-vim'
  Plug 'RRethy/nvim-base16'

  " Key plugins
  Plug 'w0rp/ale', {}
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all'  }

  " Webdev
  Plug 'othree/html5.vim'

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

    " navigation
    Plug 'nvim-tree/nvim-tree.lua'

    " visuals
    Plug 'stevearc/dressing.nvim'
    Plug 'nvim-tree/nvim-web-devicons'

    " line
    Plug 'nvim-lualine/lualine.nvim'

    " text editing
    Plug 'gbprod/yanky.nvim'
    Plug 'Wansmer/treesj'
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

" Spectre
nnoremap <leader>R :Spectre<CR>

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

local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed
    }
  end
end

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
    --  {'diff', source = diff_source}
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

local BORDER_OPTS = { "┌", "─", "┐", "│", "┘", "─", "└", "│" }

local FZF_LUA_WINOPTS = {
  height = 0.4,
  width = 1,
  row = 1,
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
    border = "rounded",
    -- 'editor' and 'win' will default to being centered
    relative = "cursor",

    -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
    prefer_width = 0.4,
    width = nil,
    max_width = 0.66,
    min_width = 0.2,

    buf_options = {},
    win_options = {
      winblend = 10,
      wrap = true,
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
      conf.row = 1
      conf.anchor = "NW"
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

-- Surround.nvim
require("nvim-surround").setup({})

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

require('gitsigns').setup {
  signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    -- Actions
    map('n', '<leader>hs', gs.stage_hunk)
    map('n', '<leader>hr', gs.reset_hunk)
    map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('n', '<leader>hS', gs.stage_buffer)
    map('n', '<leader>hu', gs.undo_stage_hunk)
    map('n', '<leader>hR', gs.reset_buffer)
    map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>hb', function() gs.blame_line{full=true} end)

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}

local conf = {
  providers = {
    openai = {
      endpoint = "https://api.openai.com/v1/chat/completions",
      secret = os.getenv("GPT_KEY")
    }
  },
  whisper = {
    disable = false,
  },
  default_command_agent = CodeGPT4,
  default_chat_agent = ChatGPT4,
  agents = {
    {
        name = "ChatGPT4",
        chat = true,
        command = false,
        -- string with model name or table with model name and parameters
        model = { model = "gpt-4-1106-preview", temperature = 1.1, top_p = 1 },
        -- system prompt (use this to specify the persona/role of the AI)
        system_prompt = "You are a general AI assistant.\n\n"
        .. "The user provided the additional info about how they would like you to respond:\n\n"
        .. "- If you're unsure don't guess and say you don't know instead.\n"
        .. "- Ask question if you need clarification to provide better answer.\n"
        .. "- Think deeply and carefully from first principles step by step.\n"
        .. "- Zoom out first to see the big picture and then zoom in to details.\n"
        .. "- Use Socratic method to improve your thinking and coding skills.\n"
        .. "- Don't elide any code from your output if the answer requires coding.\n"
    },
    {
        name = "CodeGPT4",
        chat = false,
        command = true,
        -- string with model name or table with model name and parameters
        model = { model = "gpt-4-1106-preview", temperature = 0.8, top_p = 1 },
        -- system prompt (use this to specify the persona/role of the AI)
        system_prompt = "You are an AI working as a code editor.\n\n"
        .. "Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.\n"
        .. "START AND END YOUR ANSWER WITH:\n\n```",
    },
  },
  hooks = {
    UnitTests = function(gp, params)
      local template = "I have the following code from {{filename}}:\n\n"
      .. "```{{filetype}}\n{{selection}}\n```\n\n"
      .. "Please respond by writing table driven unit tests for the code above."
      local agent = gp.get_command_agent()
      gp.Prompt(params, gp.Target.vnew, agent, template)
    end,
      CodeReview = function(gp, params)
      local template = "I have the following code from {{filename}}:\n\n"
      .. "```{{filetype}}\n{{selection}}\n```\n\n"
      .. "Please analyze for code smells and suggest improvements."
      local agent = gp.get_chat_agent()
      gp.Prompt(params, gp.Target.enew("markdown"), agent, template)
    end,
    -- example of making :%GpChatNew a dedicated command which
    -- opens new chat with the entire current buffer as a context
    BufferChatNew = function(gp, _)
      -- call GpChatNew command in range mode on whole buffer
      vim.api.nvim_command("%" .. gp.config.cmd_prefix .. "ChatNew")
    end,
  }
}
require("gp").setup(conf)
local function keymapOptions(desc)
  return {
    noremap = true,
    silent = true,
    nowait = true,
    desc = "GPT prompt " .. desc,
  }
end
-- Chat commands
vim.keymap.set({"n", "i"}, "<Leader>GC", "<cmd>GpChatNew vsplit<cr>", keymapOptions("New Chat"))
vim.keymap.set({"n", "i"}, "<Leader>GT", "<cmd>GpChatToggle vsplit<cr>", keymapOptions("Toggle Chat"))

vim.keymap.set({"n", "i"}, "<Leader>GA", "<cmd>GpAppend<cr>", keymapOptions("Append (after)"))
vim.keymap.set({"n", "i"}, "<Leader>GX", "<cmd>GpContext<cr>", keymapOptions("Toggle Context"))


vim.keymap.set({"n", "v"}, "<Leader>GI", ":<C-u>'<,'>GpImplement<cr>", keymapOptions("Implement selection"))
vim.keymap.set({"n", "v"}, "<Leader>GR", ":<C-u>'<,'>GpRewrite<cr>", keymapOptions("Visual rewrite"))
vim.keymap.set({"n", "v"}, "<Leader>GX", ":<C-u>'<,'>GpContext<cr>", keymapOptions("Visual GpContext"))

EOF
endif

" Ale
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 1
let g:ale_completion_enabled = 1
let g:ale_linters = {
  \ 'markdown': [''],
  \ 'javascript': ['eslint'],
  \ 'jsx': ['eslint'],
  \ 'typescript': ['eslint', 'tsserver'],
  \ 'python': ['flake8'],
  \ 'perl': ['perl-critic'],
  \ 'cpp': ['clangd'],
  \ 'rust': ['analyzer'],
  \}
let g:ale_sign_column_always = 1
let g:ale_sign_error = '>'
let g:ale_sign_warning = '-'
let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰', '│', '─']
let g:ale_floating_preview = 1
let g:ale_hover_to_floating_preview = 1
let g:ale_virtualtext_cursor = 'disabled'
" Disable for now, I prefer ale native signs
let g:ale_use_neovim_diagnostics_api = 0

let g:ale_set_signs = 1
let g:ale_js_fixes = ['prettier', 'eslint']
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': g:ale_js_fixes,
\   'typescript': g:ale_js_fixes,
\   'typescriptreact': g:ale_js_fixes,
\   'cpp': ['clang-format'],
\   'rust': ['rustfmt'],
\}

" ALE Hotkeys
nnoremap <Leader>n :ALENext<CR>
nnoremap <Leader>r :ALERename<CR>
nnoremap <Leader>f :ALEFix<CR>
nnoremap <Leader>gd :ALEGoToDefinition<CR>
nnoremap <Leader>gi :ALEGoToImplementation<CR>
nnoremap <Leader>gt :ALEGoToTypeDefinition<CR>
nnoremap <Leader>ai :ALEImport<CR>
nnoremap <Leader>F :ALEFindReferences<CR>
nnoremap m :ALEHover<CR>
nnoremap K :ALEDocumentation<CR>

highlight ALEError ctermbg=none cterm=underline
highlight ALEWarning ctermbg=none cterm=underline
highlight ALEStyleError ctermfg=darkgrey
highlight ALEStyleWarning ctermfg=darkgrey

highlight! link FloatTitle FzfLuaTitle
highlight! link NormalFloat FzfLuaNormal
highlight! link FloatBorder FzfLuaBorder

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

" Arduino
autocmd!
au BufNewFile,BufRead *.ino set filetype=cpp
augroup FiletypeGroup

  autocmd!
  let b:arduino_dir = '/usr/share/arduino'
augroup END

" Legacy syntax highlight, after theme is loaded
syntax on

" Spell checking in neovim
" set spelllang=en_us
" set spell
