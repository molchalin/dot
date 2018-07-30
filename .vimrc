"несовместимость с vi
set nocompatible

#!/usr/local/bin/perl 
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
"nmap <S-F> za

"чистим хвостовые проблемы при сохранении
"au! BufWritePre * %s/\s\+$//e

"если не работает backspace
set backspace=indent,eol,start

call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
Plug 'airblade/vim-gitgutter'
call plug#end()

colorscheme gruvbox
set background=dark

"curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


"my mapps
let mapleader = ","
noremap <leader>n :tabn<cr>
noremap <leader>p :tabp<cr>
noremap <leader>e :tabe 

exec ":iabbrev perlbin #!".system("which perl")
