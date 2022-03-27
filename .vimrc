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
set listchars=tab:▶\ ,trail:∙

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
Plug 'morhetz/gruvbox'

Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries', 'for': 'go' }

"Functionality
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'kien/ctrlp.vim'
Plug 'SirVer/ultisnips'
Plug 'mileszs/ack.vim'
Plug 'easymotion/vim-easymotion'
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}

"syntax support
Plug 'HerringtonDarkholme/yats.vim', {'for': 'typescript'}
Plug 'JulesWang/css.vim', {'for': 'css'}
Plug 'neovimhaskell/haskell-vim', {'for': 'haskell'}
Plug 'elmcast/elm-vim', {'for': 'elm'}
Plug 'maxmellon/vim-jsx-pretty', {'for': ['javascript', 'typescript']}

"Markdown + TeX
Plug '907th/vim-auto-save', {'for': 'tex'}
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'junegunn/goyo.vim', {'for': 'markdown'}

Plug 'lervag/vimtex', {'for': 'tex'}
call plug#end()

"vim-go
let g:go_fmt_command = "goimports"
let g:go_version_warning = 0
let g:go_rename_command = 'gopls'
let g:go_fill_struct_mode = 'gopls'

"ack
let s:ignore_paths = '(bin|project|target|node_modules|vendor)'
let g:ackprg = "ag --vimgrep"

"ultisnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

"ctrlp
let g:ctrlp_open_new_file = 't'
let g:ctrlp_regexp = 0
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/]' . s:ignore_paths,
    \ 'file': '\v\.class$',
    \ }

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


colorscheme gruvbox
set background=dark

"my mapps
let mapleader = ","
noremap <leader>n :tabnext<cr>
noremap <leader>p :tabprev<cr>
noremap <leader>e :tabedit<space>
noremap <leader>td oTODO(a.eremeev) <esc>:Commentary<cr>A
nnoremap * *``
map <Leader> <Plug>(easymotion-prefix)

augroup MyAu
    autocmd!
    autocmd FileType go nnoremap <buffer> <leader>i :GoIfErr<esc>
augroup END


"Напоминает о том, что длинные строки это плохо
highlight ColorColumn ctermbg=LightYellow
call matchadd('ColorColumn', '\%81v', 140)
