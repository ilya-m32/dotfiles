#!/usr/bin/env bash

# Workspaces
for i in {1..7}
do
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-$i "[\"<Alt>$i\"]"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-$i "[\"<Shift><Alt>$i\"]"
done

gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "[\"<Shift><Control><Alt>f\"]"
gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "[\"<Control><Alt>f\"]"
gsettings set org.gnome.desktop.wm.keybindings close "[\"<Primary><Alt>q\"]"
gsettings set org.gnome.shell.keybindings toggle-application-view "[\"<Alt>r\"]"

