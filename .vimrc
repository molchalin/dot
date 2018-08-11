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
noremap <leader>n :tabnext<cr>
noremap <leader>p :tabprev<cr>
noremap <leader>e :tabedit<space>

augroup MyAu
    autocmd!
    autocmd BufWritePost *.go :!go fmt %
    autocmd FileType go nnoremap <buffer> <leader>c I//<esc>
    autocmd FileType perl nnoremap <buffer> <leader>c I#<esc>
    "autocmd FileType perl iabbrev <buffer> perlbin #!/usr/bin/env perl
augroup END

inoremap <Up> <nop>
inoremap <Down> <nop>
inoremap <Left> <nop>
inoremap <Right> <nop>


"Показывать статус лайн ВСЕГДА
set laststatus=2
set statusline=%F%y\ %l\ \/%L






"мои функции
function! PerlBin()
    execute "normal! ggO#!/usr/bin/env perl"
endfunction

function! PerlPackage()
    let list = split(expand("%:p:r"), '/')
    let idx = index(list, "lib")
    if idx == -1
        echo "Can't find lib in path"
        return
    endif
    execute "normal! ggOpackage " . join(list[idx+1:], "::") . ";"
endfunction
