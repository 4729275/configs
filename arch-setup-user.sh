#! /bin/bash

### Arch Linux Setup Script - User Portion ###
# Kenneth Simmons, 2024

echo "Arch Linux Setup - User Portion - Kenneth Simmons, 2024"

# Install AUR helper
cd /home/kenneth
echo "Installing AUR helper - manual confirmation required:"
git clone https://aur.archlinux.org/paru-bin
cd paru-bin
makepkg -si
cd ..
rm -rf paru-bin

# Install AUR packages
echo "Installing AUR packages - manual confirmation required:"
paru -S amdgpu-pro-oglp davinci-resolve google-earth-pro gtkpod libtxc_dxtn opencl-amd teamviewer tilem tilp ttf-ms-fonts ventoy-bin
paru -R opencl-mesa
sudo systemctl enable --now teamviewerd

# Install Flatpak packages
echo "Installing Flatpak packages:"
flatpak install -y flathub org.gnome.World.PikaBackup
flatpak install -y flathub org.onlyoffice.desktopeditors
flatpak install -y flathub org.raspberrypi.rpi-imager
flatpak install -y flathub us.zoom.Zoom

echo "User portion complete!"
echo "Reboot the system to finalize the changes."
