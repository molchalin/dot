#!/usr/bin/env bash

set -o errexit
set -o pipefail

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

function prettify_path() {
  local path=$1
  if [[ "$path" =~ ^"$HOME"(/|$) ]]; then
    echo "~${path/#$HOME}"
  else
    echo $path
  fi
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

function install_package() {
  local linux_pkg=$1
  local mac_pkg=${2:-$1}
  # TODO(a.eremeev): ensure_package_manager_installed
  if is_mac; then
    # TODO(andrei): cask?
    execute "brew install $mac_pkg"
  else
    execute "yay $linux_pkg"
  fi
}

function install() {
  local bin=$1
  local linux_pkg=${2:-$bin}
  local mac_pkg=$3
  if ! has "$bin"; then
    install_package "$linux_pkg" "$mac_pkg"
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

  local link_path_pretty=$(prettify_path $link_path)
  local file_path_pretty=$(prettify_path $file_path)
  if [[ -h "$link_path" ]]; then
    log_info "$link_path_pretty -> $file_path_pretty already exists"
  elif [[ -e "$link_path" ]]; then
    log_fatal "some file already exists at $link_path_pretty"
  else
    execute "ln -s '$file_path' '$link_path'"
  fi
}

function link_same_name() {
  link "$1" "$2/"$(basename $1)
}

function link_config() {
  make_dir "$HOME/.config"
  link_same_name "config/$1" "$HOME/.config"
}

function link_bin() {
  make_dir "$HOME/.local/bin"
  link_same_name "bin/$1" "$HOME/.local/bin"
}

function make_dir() {
  local dir_path="$1"
  local dir_path_pretty=$(prettify_path $dir_path)
  if [[ -d "$dir_path" ]]; then
    log_info "$dir_path_pretty already exists"
  elif [[ -e "$dir_path" ]]; then
    log_info "some file already exists at $dir_path_pretty"
  else
    execute "mkdir -p '$dir_path'"
  fi
}

function get_file() {
  local url="$1"
  local path="$2"
  local path_pretty=$(prettify_path $path)
  if [[ -e "$path" ]]; then
    log_info "$path_pretty already exists"
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
    install_package "gnome-shell-extension-emoji-copy"
  else
    log_info "emoji-copy is already installed"
  fi
  execute "gnome-extensions enable emoji-copy@felipeftn"
}

function install_instant_workspace_switcher() {
  local exit_code=0
  gnome-extensions show instantworkspaceswitcher@amalantony.net 2>&1 > /dev/null || exit_code=$?
  if [[ $exit_code -ne 0 ]]; then
    execute "git clone https://github.com/amalantony/gnome-shell-extension-instant-workspace-switcher.git /tmp/instant-workspace"
    make_dir "$HOME/.local/share/gnome-shell/extensions"
    execute "cp -r /tmp/instant-workspace/instantworkspaceswitcher@amalantony.net ~/.local/share/gnome-shell/extensions"
    execute "rm -rf /tmp/instant-workspace"
  else
    log_info "emoji-copy is already installed"
  fi
  execute "gnome-extensions enable instantworkspaceswitcher@amalantony.net"
}

function install_font() {
  local font_name="$1"
  local font_package="$2"
  local font_package_mac_os="$3"
  local exit_code=0
  fc-list -q "${font_name}" || exit_code=$?
  if [[ $exit_code -ne 0 ]]; then
    log_info "font $font_name is not installed"
    install_package "'$font_package'" "'$font_package_mac_os'"
  else
    log_info "font $font_name is already installed"
  fi
}

function install_sf_fonts() {
  install_font "SF Pro Display" "otf-san-francisco" "font-sf-pro"
  install_font "SF Mono" "otf-san-francisco-mono" "font-sf-mono"
}

function install_inter_font() {
  install_font "Inter" "inter-font"
}

function install_jb_font() {
  install_font "JetBrains Mono" "ttf-jetbrains-mono" "font-jetbrains-mono"
}

function install_cryptfs_from_source() {
  if ! has "gocryptfs"; then
    execute "git clone https://github.com/rfjakob/gocryptfs.git /tmp/gocryptfs"
    execute "pushd /tmp/gocryptfs && ./build-without-openssl.bash && popd"
    execute "mv /tmp/gocryptfs/gocryptfs ~/.local/bin/"
  fi
}

function setup_zsh() {
  install "zsh"
  link "config/zshrc" "$HOME/.zshrc"
  link_config "zsh"
  # TODO(andrei): change shell for user
}

function setup_nvim() {
  install "nvim" "neovim"
  link_config "nvim"
  make_dir "$HOME/.local/share/nvim/site/spell"
  get_file "ftp://vim.tsu.ru/pub/vim/runtime/spell/ru.utf-8.spl" "$HOME/.local/share/nvim/site/spell/ru.utf-8.spl"
  get_file "ftp://vim.tsu.ru/pub/vim/runtime/spell/de.utf-8.spl" "$HOME/.local/share/nvim/site/spell/de.utf-8.spl"
}

function setup_tmux() {
  install "tmux"
  link_config "tmux"
  link_bin "tmux-sessionizer"
  link_bin "tmux-realpath"
  link_bin "pomodoro"
}

function setup_gnome() {
  install_emoji_picker
  install_instant_workspace_switcher
  set_gnome_option org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('xkb', 'ru')]"
  set_gnome_option org.gnome.desktop.wm.keybindings switch-input-source "['<Primary>space']"
  set_gnome_option org.gnome.desktop.peripherals.keyboard delay 175
  set_gnome_option org.gnome.desktop.peripherals.keyboard repeat-interval 25
  set_gnome_option org.gnome.desktop.input-sources xkb-options "['caps:escape', 'compose:rctrl']"

  set_gnome_option org.gnome.desktop.interface clock-format '24h'

  install_sf_fonts
  install_inter_font
  set_gnome_option org.gnome.desktop.interface font-name 'Inter 11'
  set_gnome_option org.gnome.desktop.interface monospace-font-name 'JetBrains Mono 10'
  set_gnome_option org.gnome.desktop.interface document-font-name 'Inter 11'

  for ((i = 1 ; i < 10 ; i++)); do
    set_gnome_option org.gnome.shell.keybindings "switch-to-application-$i" '[]'
  done

  for ((i = 1 ; i <= 10 ; i++)); do
    j=$(($i % 10))
    set_gnome_option org.gnome.desktop.wm.keybindings "switch-to-workspace-$i" "['<Super>$j']"
  done

  link_config "environment.d"

  # TODO(andrei): relogin
}

FIREFOX_PATH="$HOME/.mozilla/firefox"
FIREFOX_DISTRIBUTION_PATHES=("/usr/lib/firefox/distribution", "/usr/lib64/firefox/distribution")

function setup_firefox() {
  install_sf_fonts
  install "firefox"
  local default_profile=$(grep "Default=.*\.default*" "${FIREFOX_PATH}/profiles.ini" | cut -d"=" -f2)
  local default_profile_path="${FIREFOX_PATH}/${default_profile}"
  local default_profile_path_pretty=$(prettify_path $default_profile_path)
  log_info "default firefox profile: ${default_profile_path_pretty}"
  local userjs="${default_profile_path}/user.js"
  local userjs_exists=true
  test -e $userjs || userjs_exists=false
  get_file "https://raw.githubusercontent.com/yokoffing/Betterfox/refs/heads/main/user.js" "$userjs"

  local font_mono="JetBrains Mono"
  local font_display="Inter"
  local font_text="Inter"
  if is_mac; then
    font_mono="SF Pro Mono"
    font_display="SF Pro Display"
    font_text="SF Pro Text"
  fi
  if [[ "$userjs_exists" == false ]]; then
    execute "cat config/firefox/user.js | sed 's/__FONT_MONO__/${font_mono}/' | sed 's/__FONT_DISPLAY__/${font_display}/' | sed 's/__FONT_TEXT__/${font_text}/' >> ${userjs}"
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
    local distribution_path_pretty=$(prettify_path $distribution_path)
    log_info "distribution path: $distribution_path_pretty"
    test -e "$distribution_path" || log_fatal "distribution_path is empty"
    link_same_name "config/firefox/policies.json" "$distribution_path"
  fi
}

function setup_kitty() {
  install "kitty"
  execute "kitten themes --dump-theme 'Gruvbox Material Dark Medium' > config/kitty/gruvbox-material-dark-medium.conf"
  link_config "kitty"
  install_font "JetBrains Mono" "ttf-jetbrains-mono" "font-jetbrains-mono"
  install_font "SymbolsNerdFont" "ttf-nerd-fonts-symbols" "font-symbols-only-nerd-font"
}

function setup_tools() {
  install "bat"
  get_file "https://raw.githubusercontent.com/molchalin/gruvbox-material-bat/main/gruvbox-material-dark.tmTheme" "config/bat/themes/gruvbox-material-dark.tmTheme"
  link_config "bat"
  execute "bat cache --build"
  ensure_installed "fzf"
  ensure_installed "fd"
  ensure_installed "jq"
  ensure_installed "rg" "ripgrep"
  ensure_installed "eza"
  install "fzf"
  install "fd"
  install "jq"
  install "rg" "ripgrep"
  install "eza"
  if is_mac; then
    install "gls" "coreutils"
  fi
}

function setup_git() {
  install "git"
  install "delta" "git-delta"
  install "difft" "difftastic"
  link_config "git"
  link_bin "git-diff-wrapper"
}

function setup_docker() {
  install "docker"
  if is_mac; then
    install "colima"
  fi
}

function setup_cryptfs() {
  if is_mac; then
    install_cryptfs_from_source
    # TODO(andrei): macfuse
  else
    install "gocryptfs"
  fi
  link_bin "ensure-gocryptfs-mounted"
}

function setup_homeutil() {
  link_bin "notes"
  link_bin "spotdl"
  link_bin "sync-ssh"
  link_bin "breakfree"
}

# TODO(andrei): desktop apps
components=(
  'zsh'
  'nvim'
  'tmux'
  'gnome'
  'firefox'
  'kitty'
  'tools'
  'git'
  'docker'
  'cryptfs'
  'homeutil'
)

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
