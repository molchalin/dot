export ZSH=~/.oh-my-zsh
ZSH_THEME="simple"
plugins=(
  git
)

source $ZSH/oh-my-zsh.sh
PATH=$PATH:$(go env GOPATH)/bin/
