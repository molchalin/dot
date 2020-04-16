"несовместимость с vi
set nocompatible

"распознование типов файлов
filetype plugin on

"подсветка синтаксиса
syntax on

"включить нумерацию, включить относительную нумерацию
set number
set relativenumber

"таб == 4 пробела
set tabstop=4
set smarttab
set smartindent
set shiftwidth=4
set expandtab

"автоотступы
set ai
set cin

set visualbell t_vb=

"показывать парную скобку при вводе
set showmatch

"поиск: подстветка, регистр
set hlsearch
set incsearch
"set ignorecase

"запрашивать подтверждения (запись файлов)
set confirm
"скрытые буферы
set hidden

"чистим хвостовые проблемы при сохранении
"au! BufWritePre * %s/\s\+$//e

if empty(glob('~/.vim/autoload/plug.vim'))
      silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
          \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 
      autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"если не работает backspace
set backspace=indent,eol,start

call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
Plug 'airblade/vim-gitgutter'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'ternjs/tern_for_vim', { 'do': 'npm install' }
Plug 'lervag/vimtex'
Plug 'luochen1990/rainbow'
Plug 'wellle/context.vim'

Plug 'SirVer/ultisnips'
Plug 'kien/ctrlp.vim'
Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim'
Plug 'scrooloose/nerdcommenter'
Plug 'itchyny/calendar.vim'
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}

Plug 'JulesWang/css.vim'
Plug 'ElmCast/elm-vim'
Plug 'neovimhaskell/haskell-vim'
Plug 'chr4/nginx.vim'
Plug 'posva/vim-vue'
Plug 'leafgarland/typescript-vim'
Plug '907th/vim-auto-save'
Plug 'jiangmiao/auto-pairs'
Plug 'iamcco/markdown-preview.nvim', { 'do':  'cd app & yarn install'  }
call plug#end()
let g:go_fmt_command = "goimports"
let g:rainbow_active = 0
let g:context_enabled = 0

let g:tex_flavor = 'latex'
"let g:vimtex_quickfix_mode = 0

let g:UltiSnipsExpandTrigger="<tab>"                                            
let g:UltiSnipsJumpForwardTrigger="<tab>"                                       
let g:UltiSnipsJumpBackwardTrigger="<s-tab>" 
let g:NERDSpaceDelims = 1
let g:NERDCreateDefaultMappings = 0
let g:ctrlp_open_new_file = 't'
let g:ctrlp_regexp = 0
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/](bin|project|target)',
    \ 'file': '\v\.class$',
    \ }
let g:vimtex_compiler_engine = 'xelatex'
let g:vimtex_view_method = 'skim'

colorscheme gruvbox
set background=dark

"my mapps
let mapleader = ","
noremap <leader>n :tabnext<cr>
noremap <leader>p :tabprev<cr>
noremap <leader>e :tabedit<space>
noremap <leader>td oTODO(a.eremeev) <esc>:call NERDComment(0, 'comment')<cr>A
map <Leader>cc <Leader>c<Space>
nnoremap * *``
map § <Esc>
map! § <Esc>

augroup MyAu
    autocmd!
    autocmd FileType go nnoremap <buffer> <leader>o :GoDef<esc>
    autocmd FileType go nnoremap <buffer> <leader>b :GoDefPop<esc>
    autocmd FileType go nnoremap <buffer> <leader>i :GoIfErr<esc>
augroup END

"Показывать статус лайн ВСЕГДА
set laststatus=2
set statusline=%F%y\ %l\ \/%L
