export ZSH=~/.oh-my-zsh
export PATH=$PATH:~/homebrew/bin/

ZSH_THEME="simple"
plugins=(
  git
)

source $ZSH/oh-my-zsh.sh
PATH=$PATH:$(go env GOPATH)/bin/
