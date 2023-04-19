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
  zsh-syntax-highlighting
  you-should-use
  web-search
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

PROMPT=$PROMPT$'%{%F{166}%}\u03bb%{%f%} '


export FZF_DEFAULT_OPTS='--cycle --color=bg+:-1 --border rounded'
export FZF_CTRL_R_OPTS='--height=100% --margin 15%'

zvm_after_init_commands+=('[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh')

function git-vimdiff () {
    GIT_EXTERNAL_DIFF=git-diff-wrapper git --no-pager diff $@;
}

# temporary fix. Remove when the PR is merged.
# https://github.com/jeffreytse/zsh-vi-mode/pull/188
function zvm_after_init() {
  autoload add-zle-hook-widget
  add-zle-hook-widget zle-line-pre-redraw zvm_zle-line-pre-redraw
}

function rmake() {
    dir=$(basename $PWD)
    remote=$1
    shift 1
    params=$@
    rsync -av ./ ${remote}:~/repo/${dir}
    ssh  $remote " \
        source ~/.profile &&
        cd repo/$dir &&
        make $params \
    " 2>&1 | tee build.log
}
complete -o default -o nospace -F _ssh rmake
