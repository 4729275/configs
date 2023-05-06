#! /bin/bash

### Arch Linux KDE Setup Script - User Portion ###
# Kenneth Simmons, 2023

echo "Arch Linux Setup for KDE - User Portion - Kenneth Simmons, 2023"

# Install AUR helper
cd /home/kenneth
echo "Installing AUR helper - manual confirmation required:"
git clone https://aur.archlinux.org/paru-bin .paru
cd .paru
makepkg -si
cd ..

# Install AUR packages
echo "Installing AUR packages - manual confirmation required:"
paru -S amdgpu-pro-oglp davinci-resolve google-earth-pro gtkpod libtxc_dxtn opencl-amd teamviewer tilem tilp timeshift-bin ttf-ms-fonts ttf-roboto-fontconfig ventoy-bin
paru -R opencl-mesa
sudo systemctl enable --now teamviewerd

# Install Flatpak packages
echo "Installing Flatpak packages:"
flatpak install -y flathub org.onlyoffice.desktopeditors
flatpak install -y flathub us.zoom.Zoom

echo "User portion complete!"
echo "Reboot the system to finalize the changes."
