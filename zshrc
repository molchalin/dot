if [ -e ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi

export ZSH=~/.oh-my-zsh
export EDITOR=nvim


set -o vi

ZSH_THEME="simple"
plugins=(
  git
  docker
  docker-compose
  golang
  zsh-vi-mode
  zsh-autosuggestions
  fast-syntax-highlighting
  you-should-use
  web-search
  auto-notify
)

source $ZSH/oh-my-zsh.sh

if go env GOPATH 2>&1 > /dev/null; then
    export PATH=$PATH:$(go env GOPATH)/bin/
fi

export PATH=$PATH:$HOME/.local/bin/

alias vim=nvim
alias vi=vim
alias v=vi

if [[ "$(uname)" == 'Linux' ]]; then
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
fi

_DATE='[%D{%Y/%m/%f|%H:%M}]'

PROMPT=$PROMPT$'%{%F{166}%}\u03bb%{%f%} '
RPROMPT="%(?.%F{green}$_DATE.%F{red}$_DATE)" $RPROMPT


export FZF_DEFAULT_OPTS='--cycle --color=bg+:-1 --border rounded'
export FZF_CTRL_R_OPTS='--height=100% --margin 15%'

zvm_after_init_commands+=('[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh')

function git-vimdiff () {
    GIT_EXTERNAL_DIFF=git-diff-wrapper git --no-pager diff $@;
}
