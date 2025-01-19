gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('xkb', 'ru')]"
gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['<Primary>space']"
gsettings set org.gnome.desktop.peripherals.keyboard delay 175
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 25
gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape', 'compose:rctrl']"

yay -S gnome-shell-extension-emoji-copy
gnome-extensions enable emoji-copy@felipeftn
# relogin

yay -S otf-san-francisco otf-san-francisco-mono
gsettings set org.gnome.desktop.interface font-name 'SF Pro Display 11'
gsettings set org.gnome.desktop.interface monospace-font-name 'SF Mono 10'
gsettings set org.gnome.desktop.interface document-font-name 'SF Pro Text 11'
