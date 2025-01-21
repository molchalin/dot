#!/usr/bin/env bash

RED='\033[0;31m'
BLUE='\033[0;34m'
GRAY='\033[1;30m'
NC='\033[0m'

function log_info() {
  if [ "$verbose" == true ]; then
    echo -e "${GRAY}[I] $@${NC}";
  fi
}

function log_fatal() {
  echo -e "${RED}[F] $@${NC}";
  exit 1;
}

function is_mac() {
  [[ $OSTYPE == darwin*   ]]
}

function execute() {
  echo -e "${BLUE}[C] $@${NC}"
  if [ "$execute" == true ]; then
    eval $@;
  fi
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
    execute "ln -s '$file_path' '$link_path'"
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
    execute "mkdir -p '$dir_path'"
  fi
}

function get_file() {
  local url="$1"
  local path="$2"
  if [[ -e "$path" ]]; then
    log_info "$path already exists"
  else
    execute "curl '$url' -o '$path'"
  fi
}

function set_gnome_option() {
  local schema="$1"
  local key="$2"
  local value="$3"
  local prev_value=$(gsettings get "$schema" "$key")
  log_info "gsetings set '$schema' '$key': $prev_value -> '$value'"
  execute "gsettings set '$schema' '$key' '$value'"
}

function install_emoji_picker() {
  local exit_code=0
  gnome-extensions show emoji-copy@felipeftn 2>&1 > /dev/null || exit_code=$?
  if [[ $exit_code -ne 0 ]]; then
    install "gnome-shell-extension-emoji-copy"
  else
    log_info "emoji-copy is already installed"
  fi
  execute "gnome-extensions enable emoji-copy@felipeftn"
}

function install_font() {
  local font_name="$1"
  local font_package="$2"
  local exit_code=0
  fc-list "'$font_name'" -q || exit_code=$?
  if [[ $exit_code -ne 0 ]]; then
    install "'$font_package'"
  else
    log_info "font $1 is already installed"
  fi
}

function install_sf_fonts() {
  # TODO(andrei): Add package for mac os
  install_font "SF Pro" "otf-san-francisco"
  # TODO(andrei): Add package for mac os
  install_font "SF Mono" "otf-san-francisco-mono"
}

set -o errexit
set -o pipefail

function setup_zsh() {
  if ! has zsh; then
    install "zsh"
  fi
  link "config/zshrc" ".zshrc"
  link_same_name "config/zsh/" ".config/"
  # TODO(andrei): change shell for user
}

function setup_nvim() {
  if ! has nvim; then
    install "neovim"
  fi
  link_same_name "config/nvim/" ".config/"
  make_dir "$HOME/.local/share/nvim/site/spell"
  get_file "ftp://vim.tsu.ru/pub/vim/runtime/spell/ru.utf-8.spl" "$HOME/.local/share/nvim/site/spell/ru.utf-8.spl"
  get_file "ftp://vim.tsu.ru/pub/vim/runtime/spell/de.utf-8.spl" "$HOME/.local/share/nvim/site/spell/de.utf-8.spl"
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

function setup_gnome() {
  install_emoji_picker
  set_gnome_option org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('xkb', 'ru')]"
  set_gnome_option org.gnome.desktop.wm.keybindings switch-input-source "['<Primary>space']"
  set_gnome_option org.gnome.desktop.peripherals.keyboard delay 175
  set_gnome_option org.gnome.desktop.peripherals.keyboard repeat-interval 25
  set_gnome_option org.gnome.desktop.input-sources xkb-options "['caps:escape', 'compose:rctrl']"

  install_sf_fonts
  set_gnome_option org.gnome.desktop.interface font-name 'SF Pro Display 11'
  set_gnome_option org.gnome.desktop.interface monospace-font-name 'SF Mono 10'
  set_gnome_option org.gnome.desktop.interface document-font-name 'SF Pro Text 11'

  # TODO(andrei): relogin
}

components=('zsh' 'nvim' 'tmux' 'gnome')

execute=false
verbose=false
while getopts "ev:" arg; do
  case $arg in
    e) execute=true;;
    v) verbose=true;;
  esac
done

input=${@: -1}
for component in "${components[@]}"; do
  if [[ $input == $component ]]; then
    function_name="setup_$input"
	$function_name
	exit 0
  fi
done

echo "unknown component $input"
