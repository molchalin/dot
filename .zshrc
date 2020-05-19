export ZSH=~/.oh-my-zsh
export PATH=$PATH:~/homebrew/bin/
export PATH=$PATH:$HOME/brew/bin/
export EDITOR=nvim

ZSH_THEME="simple"
plugins=(
  git
  docker
  docker-compose
  golang
  zshmarks
)

source $ZSH/oh-my-zsh.sh
export PATH=$PATH:$(go env GOPATH)/bin/
alias vi=nvim

PROMPT=$PROMPT$'%{%F{166}%}\u03bb%{%f%} '
