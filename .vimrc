set nocompatible

filetype plugin on

syntax on
set number
set relativenumber

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
Plug 'ervandew/supertab'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.1' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }


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
