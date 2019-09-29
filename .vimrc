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

"показывать парную скобку при вводе
set showmatch

"поиск: подстветка, регистр
set hlsearch
set incsearch
set ignorecase

"запрашивать подтверждения (запись файлов)
set confirm

"скрытые буферы
set hidden

"чистим хвостовые проблемы при сохранении
"au! BufWritePre * %s/\s\+$//e

"если не работает backspace
set backspace=indent,eol,start
set keymap=russian-jcukenmac
set iminsert=0
set imsearch=0
highlight lCursor guifg=NONE guibg=Cyan

call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
Plug 'airblade/vim-gitgutter'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'SirVer/ultisnips'
Plug 'kien/ctrlp.vim'
Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim'
Plug 'JulesWang/css.vim'
Plug 'ElmCast/elm-vim'
call plug#end()
let g:go_fmt_command = "goimports"


colorscheme gruvbox
set background=dark

"curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


"my mapps
let mapleader = ","
noremap <leader>n :tabnext<cr>
noremap <leader>p :tabprev<cr>
noremap <leader>e :tabedit<space>

augroup MyAu
    autocmd!
    autocmd FileType go,c nnoremap <buffer> <leader>c I//<esc>
    autocmd FileType go nnoremap <buffer> <leader>o :GoDef<esc>
    autocmd FileType go nnoremap <buffer> <leader>b :GoDefPop<esc>
    autocmd FileType perl nnoremap <buffer> <leader>c I#<esc>
augroup END

"Показывать статус лайн ВСЕГДА
set laststatus=2
set statusline=%F%y\ %l\ \/%L
