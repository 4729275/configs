#! /bin/bash

### Arch Linux GNOME Install Script ###
# Kenneth Simmons, 2023

echo "Arch Linux GNOME Installer - Kenneth Simmons, 2023"

# Install packages
echo "Installing GNOME packages:"
pacman -S eog evince gdm gnome-backgrounds gnome-calculator gnome-calendar gnome-clocks gnome-console gnome-control-center gnome-disk-utility gnome-font-viewer gnome-keyring gnome-logs gnome-session gnome-settings-daemon gnome-shell gnome-shell-extensions gnome-system-monitor gnome-text-editor gnome-tweaks gnome-user-share gnome-weather grilo-plugins gvfs gvfs-afc gvfs-goa gvfs-google gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-smb nautilus sushi totem tracker3-miners xdg-desktop-portal xdg-desktop-portal-gnome xdg-user-dirs-gtk
echo "Installing other packages:"
pacman -S firefox thunderbird

# Enable gdm:
echo "Enabling gdm:"
systemctl enable gdm

echo "Done!"
echo "Reboot to enter GNOME."
