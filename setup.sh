#!/usr/bin/env bash

source lib.sh

function link_config() {
  make_dir "$HOME/.config"
  link_same_name "config/$1" "$HOME/.config"
}

function link_bin() {
  make_dir "$HOME/.local/bin"
  link_same_name "bin/$1" "$HOME/.local/bin"
}

function install_emoji_picker() {
  install_package "gnome-shell-extension-emoji-copy"
}

function set_mac_plist() {
  local schema="$1"
  execute "plutil -convert xml1 config/plist/$schema.json -o - | defaults import '$schema' -"
}

function tmp_dir_name() {
  echo "$tmp_root_dir/$1"
}

function install_instant_workspace_switcher() {
  local tmp_dir=$(tmp_dir_name "instant-workspace")
  execute "git clone https://github.com/amalantony/gnome-shell-extension-instant-workspace-switcher.git $tmp_dir"
  make_dir "$HOME/.local/share/gnome-shell/extensions"
  execute "cp -r $tmp_dir/instantworkspaceswitcher@amalantony.net ~/.local/share/gnome-shell/extensions"
}

function install_blur_my_shell() {
  # TODO(a.eremeev): save settings of this extension?
  local tmp_dir=$(tmp_dir_name "blur-my-shell")
  execute "git clone https://github.com/aunetx/blur-my-shell $tmp_dir"
  execute "pushd $tmp_dir && make install && popd"
}

function install_grand_theft_focus() {
  local tmp_dir=$(tmp_dir_name "grand-theft-focus")
  execute "git clone https://github.com/zalckos/GrandTheftFocus.git $tmp_dir"
  make_dir "$HOME/.local/share/gnome-shell/extensions"
  execute "cp -r $tmp_dir/grand-theft-focus@zalckos.github.com ~/.local/share/gnome-shell/extensions"
}

function install_shyriiwook() {
  local tmp_dir=$(tmp_dir_name "shyriiwook")
  execute "git clone git@github.com:madhead/shyriiwook.git $tmp_dir"
  execute "pushd $tmp_dir && make install && popd"
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
    local tmp_dir=$(tmp_dir_name "gocryptfs")
    execute "git clone https://github.com/rfjakob/gocryptfs.git $tmp_dir_name"
    execute "pushd $tmp_dir_name && ./build-without-openssl.bash && popd"
    execute "mv $tmp_dir_name/gocryptfs ~/.local/bin/"
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
  make_dir "$HOME/.local/state/tmux-sessionizer"
  local config_exists=true
  test -e "$HOME/.config/tmux-sessionizer/list" || config_exists=false
  if [[ "$config_exists" == false ]]; then
    make_dir "$HOME/.config/tmux-sessionizer"
    execute "cp $PWD/config/tmux-sessionizer/list $HOME/.config/tmux-sessionizer/"
  fi
  link_bin "tmux.plx"
  link_bin "pomodoro"
}

function setup_gnome() {
  install_gnome_extension "emoji-copy@felipeftn" install_emoji_picker
  install_gnome_extension "instantworkspaceswitcher@amalantony.net" install_instant_workspace_switcher
  install_gnome_extension "blur-my-shell@aunetx" install_blur_my_shell
  install_gnome_extension "grand-theft-focus@zalckos.github.com" install_grand_theft_focus
  install_gnome_extension "shyriiwook@madhead.me" install_shyriiwook

  # default extensions
  install_gnome_extension system-monitor@gnome-shell-extensions.gcampax.github.com

  # keyboard settings
  set_gnome_option org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('xkb', 'ru')]"
  set_gnome_option org.gnome.desktop.wm.keybindings switch-input-source "['<Primary>space']"
  set_gnome_option org.gnome.desktop.peripherals.keyboard delay "uint32 175"
  set_gnome_option org.gnome.desktop.peripherals.keyboard repeat-interval "uint32 25"
  set_gnome_option org.gnome.desktop.input-sources xkb-options "['caps:escape', 'compose:rctrl']"

  local custom_binding="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom"
  local custom_binding0="${custom_binding}0/"
  local custom_binding1="${custom_binding}1/"
  local media_keys="org.gnome.settings-daemon.plugins.media-keys"
  local custom_schema="$media_keys.custom-keybinding"
  local command="gdbus call --session --dest org.gnome.Shell --object-path /me/madhead/Shyriiwook --method me.madhead.Shyriiwook.activate"
  set_gnome_option "$media_keys" custom-keybindings "['$custom_binding0', '$custom_binding1']"
  set_gnome_option "$custom_schema:$custom_binding0" binding "<Super>e"
  set_gnome_option "$custom_schema:$custom_binding0" name "Switch to English"
  set_gnome_option "$custom_schema:$custom_binding0" command "$command us"
  set_gnome_option "$custom_schema:$custom_binding1" binding "<Super>r"
  set_gnome_option "$custom_schema:$custom_binding1" name "Switch to Russian"
  set_gnome_option "$custom_schema:$custom_binding1" command "$command ru"

  set_gnome_option org.gnome.desktop.interface clock-format '24h'
  set_gnome_option org.gnome.desktop.interface show-battery-percentage 'true'
  set_gnome_option org.gnome.desktop.interface enable-hot-corners 'false'
  set_gnome_option org.gnome.desktop.wm.preferences num-workspaces '10'
  set_gnome_option org.gnome.mutter dynamic-workspaces 'false'

  install_sf_fonts
  install_inter_font
  set_gnome_option org.gnome.desktop.interface font-name 'Inter 11'
  set_gnome_option org.gnome.desktop.interface monospace-font-name 'JetBrains Mono 10'
  set_gnome_option org.gnome.desktop.interface document-font-name 'Inter 11'

  # WM settings
  for ((i = 1 ; i < 10 ; i++)); do
    set_gnome_option org.gnome.shell.keybindings "switch-to-application-$i" '@as []'
  done

  for ((i = 1 ; i <= 10 ; i++)); do
    j=$(($i % 10))
    set_gnome_option org.gnome.desktop.wm.keybindings "switch-to-workspace-$i" "['<Super>$j']"
    set_gnome_option org.gnome.desktop.wm.keybindings "move-to-workspace-$i" "['<Super><Shift>$j']"
  done

  set_gnome_option org.gnome.desktop.wm.keybindings "switch-windows" "['<Super>j']"
  set_gnome_option org.gnome.desktop.wm.keybindings "switch-windows-backward" "['<Super>k']"
  set_gnome_option org.gnome.desktop.wm.keybindings "close" "['<Super><Shift>q']"
  set_gnome_option org.gnome.shell.keybindings 'toggle-overview' "['<Super>space']"
  set_gnome_option org.gnome.mutter 'overlay-key' ''

  # monday is the first day of the week
  link_config "environment.d"
  locale -a | grep -q 'en_GB.utf8' || exit_code=$?
  if [[ $exit_code -ne 0 ]]; then
    execute "sudo sed -i 's/#en_GB.UTF-8/en_GB.UTF-8/' /etc/locale.gen"
    execute "sudo locale-gen"
  else
    log_info "locale en_GB.utf-8 already exists"
  fi

  if [[ "$must_relogin" == true ]]; then
    log_fatal "You must relogin to proceed installation"
  fi
}

function setup_desktop_linux() {
  install "zathura"
  install "zathura-pdf-poppler"
  link_config "zathura"
  execute "xdg-mime default org.pwmt.zathura.desktop application/pdf"
}

function setup_desktop_mac() {
  install "karabiner-elements"
  link_config "karabiner"
  set_mac_option "NSGlobalDomain" "KeyRepeat" "-int" "2"
  set_mac_option "NSGlobalDomain" "InitialKeyRepeat" "-int" "15"
  set_mac_option "com.apple.dock" "mru-spaces" "-bool" "0"
  set_mac_option "com.apple.dock" "show-recents" "-bool" "0"
  set_mac_option "NSGlobalDomain" "NSAutomaticSpellingCorrectionEnabled" "-bool" "0"
  set_mac_option "NSGlobalDomain" "NSAutomaticCapitalizationEnabled" "-bool" "0"
  set_mac_plist "com.apple.spotlight"
  set_mac_plist "com.apple.symbolichotkeys"
  execute "mdutil -i off"
}

function setup_desktop() {
  if is_mac; then
    setup_desktop_mac
  else
    setup_desktop_linux
  fi
  install "telegram-desktop"
}

FIREFOX_PATH="$HOME/.mozilla/firefox"

function detect_profile_path() {
  local default_profile=$(grep "Default=.*\.default*" "${FIREFOX_PATH}/profiles.ini" | cut -d"=" -f2)
  echo "${FIREFOX_PATH}/${default_profile}"
}

function create_user_js() {
  get_file "https://raw.githubusercontent.com/yokoffing/Betterfox/refs/heads/main/user.js" "$userjs"
  local font_mono="JetBrains Mono"
  local font_display="Inter"
  local font_text="Inter"
  if is_mac; then
    font_mono="SF Pro Mono"
    font_display="SF Pro Display"
    font_text="SF Pro Text"
  fi
  execute "cat config/firefox/user.js | sed 's/__FONT_MONO__/${font_mono}/' | sed 's/__FONT_DISPLAY__/${font_display}/' | sed 's/__FONT_TEXT__/${font_text}/' >> ${userjs}"
}

FIREFOX_DISTRIBUTION_PATHES=("/usr/lib/firefox/distribution" "/usr/lib64/firefox/distribution")
function set_firefox_profile_options() {
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

function setup_firefox() {
  install_sf_fonts
  install "firefox"

  local default_profile_path=$(detect_profile_path)
  local default_profile_path_pretty=$(prettify_path $default_profile_path)
  log_info "default firefox profile: ${default_profile_path_pretty}"

  userjs="${default_profile_path}/user.js"
  get_file_func "$userjs" create_user_js
  link_same_name "config/firefox/chrome" "$default_profile_path"

  set_firefox_profile_options
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
  make_dir "$PWD/config/bat/themes"
  get_file "https://raw.githubusercontent.com/molchalin/gruvbox-material-bat/main/gruvbox-material-dark.tmTheme" "config/bat/themes/gruvbox-material-dark.tmTheme"
  link_config "bat"
  execute "bat cache --build"
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
  else
    local has_docker_group=true
    groups | grep -q 'docker' || has_docker_group=false
    if [[ "$has_docker_group" == false ]]; then
      execute "sudo usermod -aG docker $USER"
    fi
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
  setup_cryptfs
  link_bin "notes"

  install "aria2c" "aria2"
  link_bin "breakfree"

  link_bin "yohoho"
  install "yt-dlp"
  install "ffmpeg"
  if is_mac; then
    install "pipx"
    if ! has "spotdl"; then
      execute "pipx install spotdl"
    fi
  else
    install "spotdl"
  fi
  install "syncthing"
  if is_mac; then
    execute "brew services start syncthing"
  else
    execute "systemctl --user enable syncthing.service"
    execute "systemctl --user start syncthing.service"
  fi
  install "outline"

  link_bin "sync-ssh"
  make_dir "$HOME/.ssh"
  link_same_name "config/ssh/config" "$HOME/.ssh"
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
  'homeutil'
  'desktop'
)

execute=false
verbose=false
while getopts "ev:" arg; do
  case $arg in
    e) execute=true;;
    v) verbose=true;;
  esac
done

tmp_root_dir=$(mktemp -d)
log_info "temporary directory: $tmp_root_dir"

function cleanup() {
  log_info "remove temporary $tmp_root_dir"
  rm -rf "$tmp_root_dir"
}

trap cleanup EXIT

input=${@: -1}
for component in "${components[@]}"; do
  if [[ $input == $component ]]; then
    function_name="setup_$input"
	$function_name
	exit 0
  fi
done

echo "unknown component $input"
