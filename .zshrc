export ZSH=~/.oh-my-zsh
export PATH=$PATH:$HOME/brew/bin/
export EDITOR=nvim

eval $(ssh-agent)
ssh-add

ZSH_THEME="simple"
plugins=(
  git
  docker
  docker-compose
  golang
)

source $ZSH/oh-my-zsh.sh
export PATH=$PATH:$(go env GOPATH)/bin/
alias vi=nvim

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
