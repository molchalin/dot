. ~/.localzshrc

export ZSH=~/.oh-my-zsh
export EDITOR=nvim


eval $(ssh-agent)
ssh-add

set -o vi

ZSH_THEME="simple"
plugins=(
  git
  docker
  docker-compose
  golang
  zsh-vi-mode
)

source $ZSH/oh-my-zsh.sh
export PATH=$PATH:$(go env GOPATH)/bin/
alias vi=nvim

if [[ "$(uname)" == 'Linux' ]]; then
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
fi

PROMPT=$PROMPT$'%{%F{166}%}\u03bb%{%f%} '


function git-vimdiff () {
    GIT_EXTERNAL_DIFF=~/.git_diff_wrapper git --no-pager diff $@;
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
