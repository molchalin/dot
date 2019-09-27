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

" russian support
set keymap=russian-jcukenwin
set spelllang=ru_yo,en_us
set iskeyword=@,48-57,_,192-255
set langmap=ёйцукенгшщзхъфывапролджэячсмитьбюЙЦУКЕHГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;`qwertyuiop[]asdfghjkl\\;'zxcvbnm\\,.QWERTYUIOP{}ASDFGHJKL:\\"ZXCVBNM<>
set iminsert=0
set imsearch=0



imap § <Esc>

"если не работает backspace
set backspace=indent,eol,start

call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
Plug 'airblade/vim-gitgutter'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'SirVer/ultisnips'
Plug 'kien/ctrlp.vim'
Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim'
Plug 'neovimhaskell/haskell-vim'
Plug 'chr4/nginx.vim'
Plug 'scrooloose/nerdcommenter'
call plug#end()
let g:go_fmt_command = "goimports"

let g:UltiSnipsExpandTrigger="<tab>"                                            
let g:UltiSnipsJumpForwardTrigger="<tab>"                                       
let g:UltiSnipsJumpBackwardTrigger="<s-tab>" 
let g:NERDSpaceDelims = 1
let g:ctrlp_open_new_file = 't'

colorscheme gruvbox
set background=dark

"curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


"my mapps
let mapleader = ","
noremap <leader>n :tabnext<cr>
noremap <leader>p :tabprev<cr>
noremap <leader>e :tabedit<space>
noremap <leader>td oTODO(a.eremeev) <esc>:call NERDComment(0, "comment")<cr>A

augroup MyAu
    autocmd!
    autocmd FileType go nnoremap <buffer> <leader>o :GoDef<esc>
    autocmd FileType go nnoremap <buffer> <leader>b :GoDefPop<esc>
    autocmd FileType go nnoremap <buffer> <leader>i :GoIfErr<esc>
augroup END

"Показывать статус лайн ВСЕГДА
set laststatus=2
set statusline=%F%y\ %l\ \/%L
