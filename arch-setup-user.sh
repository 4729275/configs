#! /bin/bash

### Arch Linux Setup Script - User Portion ###
# Kenneth Simmons, 2023

echo "Arch Linux Setup - User Portion - Kenneth Simmons, 2023"

# Install AUR helper
cd /home/kenneth
echo "Installing AUR helper:"
git clone https://aur.archlinux.org/paru-bin .paru
cd .paru
makepkg -si
cd ..

# Install AUR packages
echo "Installing AUR packages - manual confirmation required:"
paru -S adw-gtk3 amdgpu-pro-oglp davinci-resolve google-earth-pro gradience gtkpod libtxc_dxtn onlyoffice-bin opencl-amd tilem tilp timeshift-bin ttf-ms-fonts ttf-roboto-fontconfig ventoy-bin zoom
paru -R opencl-mesa

echo "User portion complete!"
echo "Reboot the system to finalize the changes."
