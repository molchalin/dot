#!/usr/bin/env bash

function log_info() {
  echo "[I] $@";
}

function log_fatal() {
  echo "[F] $@";
  exit 1;
}

function is_mac() {
  [[ $OSTYPE == darwin*   ]]
}

function execute() {
  echo "[E] $@"
}

function install() {
  local linux_pkg=$1
  local mac_pkg=$2
  if [[ -z $mac_pkg ]]; then
    mac_pkg="$linux_pkg"
  fi
  # TODO(a.eremeev): ensure_package_manager_installed
  if is_mac; then
    execute "brew install $mac_pkg"
  else
    execute "pacman -S $linux_pkg"
  fi
}

function has() {
  if [ -x "$(command -v $1)" ]; then
    log_info "$1 installed"
  else
    log_info "$1 is not installed"
  fi
  [ -x "$(command -v $1)" ]
}

function link() {
  local file_path="$PWD/$1"
  local link_path="$HOME/$2"
  if [[ -h "$link_path" ]]; then
    log_info "$link_path -> $file_path already exists"
  elif [[ -e "$link_path" ]]; then
    log_info "some file already exists at $link_path"
  else
    execute 'ln -s "'$file_path'" "'$link_path'"'
  fi
}

function link_same_name() {
  link "$1" "$2"$(basename $1)
}

function make_dir() {
  local dir_path="$1"
  if [[ -d "$dir_path" ]]; then
    log_info "$dir_path already exists"
  elif [[ -e "$dir_path" ]]; then
    log_info "some file already exists at $dir_path"
  else
    execute 'mkdir -p "'$dir_path'"'
  fi
}

function get_file() {
  local url="$1"
  local path="$2"
  if [[ -e "$path" ]]; then
    log_info "$path already exists"
  else
    execute 'curl "'$url'" -o "'$path'"'
  fi
}

set -o errexit
set -o pipefail

function setup_zsh() {
  if ! has zsh; then
    install "zsh"
  fi
  link "config/zshrc" ".zshrc"
  link_same_name "config/zsh/" ".config/"
}

function setup_nvim() {
  if ! has nvim; then
    install "neovim"
  fi
  link_same_name "config/nvim/" ".config/"
  make_dir "$HOME/.local/share/nvim/site/spell"
  get_file "http://ftp.vim.org/pub/vim/runtime/spell/ru.utf-8.spl" "$HOME/.local/share/nvim/site/spell/ru.utf-8.spl"
  get_file "http://ftp.vim.org/pub/vim/runtime/spell/de.utf-8.spl" "$HOME/.local/share/nvim/site/spell/de.utf-8.spl"
}

function setup_tmux() {
  if ! has tmux; then
    install "tmux"
  fi
  link_same_name "config/tmux/" ".config/"
  make_dir "$HOME/.local/bin"
  link_same_name "bin/tmux-sessionizer" ".local/bin/"
  link_same_name "bin/tmux-realpath" ".local/bin/"
}

components=('zsh' 'nvim' 'tmux')

for component in "${components[@]}"; do
  if [[ $1 == $component ]]; then
    function_name="setup_$1"
	$function_name
	exit 0
  fi
done

echo "unknown component $1"
