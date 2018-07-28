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

"маппинг символов в командном режиме
set langmap=ёйцукенгшщзхъфывапролджэячсмитьбю.;`qwertyuiop[]asdfghjkl\;'zxcvbnm\\,./,ЙЦУКЕHГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ\\,;QWERTYUIOP{}ASDFGHJKL:\"ZXCVBNM<>?

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

