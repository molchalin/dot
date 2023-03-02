set nocompatible

filetype plugin on

syntax on
set number
set relativenumber
set mouse=

set tabstop=4
set smarttab
set smartindent
set shiftwidth=4
set expandtab
autocmd Filetype lua setlocal ts=4 sw=4 noexpandtab
autocmd Filetype yaml setlocal ts=2 sw=2 expandtab
autocmd Filetype go setlocal ts=4 sw=4 noexpandtab

set list
set listchars=tab:│·,trail:·

set scrolloff=8
set sidescrolloff=8

set autoindent
set cindent

set visualbell t_vb=

set showmatch
set hlsearch
set incsearch
set ignorecase
set smartcase

set confirm
set hidden

"omnifunc
set completeopt=longest,menuone
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

if empty(glob('~/.vim/autoload/plug.vim'))
      silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
          \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
      autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"если не работает backspace
set backspace=indent,eol,start

call plug#begin('~/.vim/plugged')
"Design
Plug 'morhetz/gruvbox'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'

Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries', 'for': 'go' }


"Functionality
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-sensible'
Plug 'edkolev/tmuxline.vim'
Plug 'SirVer/ultisnips'
Plug 'easymotion/vim-easymotion'
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}
Plug 'chaoren/vim-wordmotion'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.1' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope-ui-select.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'simrat39/inlay-hints.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'mvllow/modes.nvim'
Plug 'ervandew/supertab'


"syntax support
Plug 'sheerun/vim-polyglot'

"Markdown + TeX
Plug '907th/vim-auto-save', {'for': 'tex'}
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'junegunn/goyo.vim', {'for': 'markdown'}

Plug 'lervag/vimtex', {'for': 'tex'}
call plug#end()

lua <<EOF
require('telescope').load_extension('fzf')
require("telescope").load_extension("ui-select")
require('modes').setup({
  set_cursor = false,
})
EOF


lua <<EOF
  require("inlay-hints").setup({
    renderer = "inlay-hints/render/eol",
    only_current_line = false,
    eol = {
      right_align = true,
      parameter = {
        format = function(hints)
          return string.format(" <- (%s)", hints):gsub(":", "")
        end,
      },
      type = {
        format = function(hints)
          return string.format(" » (%s)", hints):gsub(":", "")
        end,
      },
    },
  })
EOF


lua <<EOF
require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "bash",
    "c",
    "cpp",
    "css",
    "html",
    "json",
    "lua",
    "yaml",
    "go",
    "gomod",
    "gosum",
    "markdown",
    "rust",
    "make",
    "perl",
  },
  highlight = { enable = true },
  indent    = { enable = true },
})
EOF


lua <<EOF
  lspconfig = require "lspconfig"
  util = require "lspconfig/util"
  ih = require("inlay-hints")
  telescope = require("telescope.builtin")

  lspconfig.gopls.setup {
    on_attach = function(c, b)
      ih.on_attach(c, b)
      vim.lsp.codelens.refresh()
      vim.api.nvim_buf_set_option(b, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
      local bufopts = { noremap=true, silent=true, buffer=b }
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
      vim.keymap.set('n', 'gd', telescope.lsp_definitions, bufopts)
      vim.keymap.set('n', 'gr', telescope.lsp_references, bufopts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
      vim.keymap.set('n', 'gi', telescope.lsp_implementations, bufopts)
      vim.keymap.set('n', '<leader>D', telescope.lsp_type_definitions, bufopts)
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
      vim.keymap.set('n', 'ca', vim.lsp.buf.code_action, bufopts)
      vim.keymap.set('n', 'cl', vim.lsp.codelens.run, bufopts)
    end,
    cmd = {"gopls", "serve"},
    filetypes = {"go", "gomod"},
    root_dir = util.root_pattern("go.work", "go.mod", ".git"),
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          -- parameterNames = true,
          rangeVariableTypes = true,
        },
        codelenses = {
          generate   = true,
          tidy       = true,
          vendor     = true,
          gc_details = true,
        },
      },
    },
  }
EOF

"vim-go
let g:go_fmt_command = 'gofmt'
let g:go_fmt_options = {
    \ 'golines': '--shorten-comments -m 120',
    \ 'gofmt': '-s',
    \ }
let g:go_version_warning = 0
let g:go_rename_command = 'gopls'
let g:go_fill_struct_mode = 'gopls'
let g:go_info_mode = 'gopls'
let g:go_metalinter_enabled = []

"ultisnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

"supertab
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&completefunc']

"vimtex
let g:tex_flavor = 'latex'
let g:vimtex_quickfix_mode = 0
let g:vimtex_compiler_engine = 'xelatex'
let g:vimtex_view_method = 'skim'
let g:vimtex_compiler_latexmk_engines = {
    \ '_'                : '-xelatex -shell-escape',
    \ 'pdflatex'         : '-pdf',
    \ 'dvipdfex'         : '-pdfdvi',
    \ 'lualatex'         : '-lualatex',
    \ 'xelatex'          : '-xelatex',
    \ 'context (pdftex)' : '-pdf -pdflatex=texexec',
    \ 'context (luatex)' : '-pdf -pdflatex=context',
    \ 'context (xetex)'  : '-pdf -pdflatex=''texexec --xtx''',
    \}

let g:goyo_width = 120


colorscheme gruvbox
set background=dark

"my mapps
let mapleader = ","
noremap <leader>e :tabedit<space>
noremap <leader>td oTODO(a.eremeev) <esc>:Commentary<cr>A
noremap <leader>q :wqa<cr>
nnoremap * *``
map <Leader> <Plug>(easymotion-prefix)

nnoremap <C-p> <cmd>Telescope find_files<cr>
nnoremap <C-f> <cmd>Telescope live_grep<cr>

augroup MyAu
    autocmd!
    autocmd FileType go nnoremap <buffer> <leader>i :GoIfErr<esc>
    autocmd FileType go noremap <leader>c :GoTestCompile<cr>
    autocmd FileType markdown set tw=120
augroup END


vmap <Leader>y "+y
vmap <Leader>d "+d
vmap <Leader>p "+p
vmap <Leader>P "+P
nmap <Leader>p "+p
nmap <Leader>P "+P

au BufNewFile,BufRead *Jenkinsfile setf groovy


"Напоминает о том, что длинные строки это плохо
highlight ColorColumn ctermbg=LightYellow
call matchadd('ColorColumn', '\%121v', 120)
