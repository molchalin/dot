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
    local exit_code=0
    brew list "$mac_pkg" &> /dev/null || exit_code=$?
    if [[ $exit_code -ne 0 ]]; then
      execute "brew install $mac_pkg"
    fi
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

function get_file_func() {
  local path="$1"
  local func=$2
  local path_pretty=$(prettify_path $path)
  if [[ -e "$path" ]]; then
    log_info "$path_pretty already exists"
  else
    $func
  fi
}

function set_gnome_option() {
  local schema="$1"
  local key="$2"
  local value="$3"
  local prev_value=$(gsettings get "$schema" "$key" | sed "s/^'//" | sed "s/'$//")
  if [[ "$prev_value" != "$value" ]]; then
    log_info "gsetings set '$schema' '$key': $prev_value -> '$value'"
    execute "gsettings set '$schema' '$key' \"$value\""
  fi
}

function set_mac_option() {
  local schema="$1"
  local key="$2"
  local type="$3"
  local value="$4"
  local prev_value=$(defaults read "$schema" "$key")
  if [[ "$prev_value" != "$value" ]]; then
    log_info "defaults write '$schema' '$key': $prev_value -> '$value'"
    execute "defaults write '$schema' '$key' $type $value"
  fi
}

must_relogin=false

function install_gnome_extension() {
  local name="$1"
  local install_func=$2

  local exit_code=0
  gnome-extensions show "$name" &> /dev/null || exit_code=$?
  if [[ $exit_code -ne 0 ]]; then
    $install_func
    must_relogin=true
  else
    log_info "$name is already installed"
    gnome-extensions info "$name" | grep -iq 'State: ENABLED' || exit_code=$?
    if [[ $exit_code -ne  0 ]]; then
      execute "gnome-extensions enable $name"
    fi
  fi
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
