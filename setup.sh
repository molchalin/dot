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
  local mac_pkg=${2:-$1}
  # TODO(a.eremeev): ensure_package_manager_installed
  if is_mac; then
    execute "brew install $mac_pkg"
  else
    execute "pacman -S $linux_pkg"
  fi
}

function ensure_installed() {
  local bin=$1
  local linux_pkg=${2:-$bin}
  local mac_pkg=$3
  if ! has "$bin"; then
    install "$linux_pkg" "$mac_pkg"
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
  local link_path="$2"
  if [[ -h "$link_path" ]]; then
    log_info "$link_path -> $file_path already exists"
  elif [[ -e "$link_path" ]]; then
    log_info "some file already exists at $link_path"
  else
    execute "ln -s '$file_path' '$link_path'"
  fi
}

function link_same_name() {
  link "$1" "$2/"$(basename $1)
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
  execute "gsettings set '$schema' '$key' \"$value\""
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
  fc-list -q "${font_name}" || exit_code=$?
  if [[ $exit_code -ne 0 ]]; then
    log_info "font $font_name is not installed"
    install "'$font_package'"
  else
    log_info "font $font_name is already installed"
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
  ensure_installed "zsh"
  link "config/zshrc" "$HOME/.zshrc"
  link_same_name "config/zsh" "$HOME/.config"
  # TODO(andrei): change shell for user
}

function setup_nvim() {
  ensure_installed "nvim" "neovim"
  link_same_name "config/nvim" "$HOME/.config"
  make_dir "$HOME/.local/share/nvim/site/spell"
  get_file "ftp://vim.tsu.ru/pub/vim/runtime/spell/ru.utf-8.spl" "$HOME/.local/share/nvim/site/spell/ru.utf-8.spl"
  get_file "ftp://vim.tsu.ru/pub/vim/runtime/spell/de.utf-8.spl" "$HOME/.local/share/nvim/site/spell/de.utf-8.spl"
}

function setup_tmux() {
  ensure_installed "tmux"
  link_same_name "config/tmux" "$HOME/.config"
  make_dir "$HOME/.local/bin"
  link_same_name "bin/tmux-sessionizer" "$HOME/.local/bin"
  link_same_name "bin/tmux-realpath" "$HOME/.local/bin"
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

FIREFOX_PATH="$HOME/.mozilla/firefox"
FIREFOX_DISTRIBUTION_PATHES=("/usr/lib/firefox/distribution", "/usr/lib64/firefox/distribution")

function setup_firefox() {
  install_sf_fonts
  ensure_installed "firefox"
  local default_profile=$(grep "Default=.*\.default*" "${FIREFOX_PATH}/profiles.ini" | cut -d"=" -f2)
  local default_profile_path="${FIREFOX_PATH}/${default_profile}"
  log_info "default firefox profile: ${default_profile_path}"
  local userjs="${default_profile_path}/user.js"
  local userjs_exists=true
  test -e $userjs || userjs_exists=false
  get_file "https://raw.githubusercontent.com/yokoffing/Betterfox/refs/heads/main/user.js" "$userjs"
  if [[ "$userjs_exists" == false ]]; then
    execute "cat config/firefox/user.js >> ${userjs}"
  fi
  link_same_name "config/firefox/chrome" "$default_profile_path"
  if is_mac; then
    execute "defaults delete ~/Library/Preferences/org.mozilla.firefox"
    execute "cat config/firefox/policies.json | jq '.policies' | plutil -convert xml1 - -o out.plist"
    execute "defaults import ~/Library/Preferences/org.mozilla.firefox out.plist"
    execute "rm out.plist"
  else
    local distribution_path=""
    for e in "${FIREFOX_DISTRIBUTION_PATHES[@]}"; do
      if [[ -e $e ]]; then
        distribution_path=$e
      fi
    done
    log_info "distribution path: $distribution_path"
    test -e "$distribution_path" || log_fatal "distribution_path is empty"
    link_same_name "config/firefox/policies.json" "$distribution_path"
  fi
}

function setup_kitty() {
  ensure_installed "kitty"
  execute "kitten themes --dump-theme 'Gruvbox Material Dark Medium' > config/kitty/gruvbox-material-dark-medium.conf"
  link_same_name "config/kitty" "$HOME/.config"
  install_font "JetBrains Mono" "ttf-jetbrains-mono" "font-jetbrains-mono"
  install_font "SymbolsNerdFont" "ttf-nerd-fonts-symbols" "font-symbols-only-nerd-font"
}

components=('zsh' 'nvim' 'tmux' 'gnome' 'firefox' 'kitty')

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
