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

set -o errexit
set -o pipefail

function setup_zsh() {
  if ! has zsh; then
    install "zsh"
  fi
  link "config/zshrc" ".zshrc"
  link "config/zsh/" ".config/zsh"
}

components=('zsh')

for component in "${components[@]}"; do
  if [[ $1 == $component ]]; then
    function_name="setup_$1"
	$function_name
	exit 0;
  fi
  echo $e
done

