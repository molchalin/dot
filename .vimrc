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

"фолдинг перлового кода
"let perl_fold = 1
"noremap <leader>f za

"чистим хвостовые проблемы при сохранении
"au! BufWritePre * %s/\s\+$//e

"если не работает backspace
set backspace=indent,eol,start

call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
Plug 'airblade/vim-gitgutter'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
call plug#end()
let g:go_fmt_command = "goimports"
let g:go_auto_type_info = 1


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
    autocmd FileType go nnoremap <buffer> <leader>o :GoDef<esc>
    autocmd FileType go  nnoremap <buffer> <leader>b :GoDefPop<esc>
augroup END

"Показывать статус лайн ВСЕГДА
set laststatus=2
set statusline=%F%y\ %l\ \/%L
