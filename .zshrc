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
