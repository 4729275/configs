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
paru -S amdgpu-pro-oglp davinci-resolve google-earth-pro gtkpod libhashab-git libtxc_dxtn opencl-amd teamviewer tilem tilp ttf-ms-fonts ventoy-bin
paru -R opencl-mesa
sudo systemctl enable --now teamviewerd

# Install Flatpak packages
echo "Installing Flatpak packages:"
flatpak install -y flathub com.github.tchx84.Flatseal io.gitlab.news_flash.NewsFlash org.gnome.World.PikaBackup org.onlyoffice.desktopeditors org.raspberrypi.rpi-imager us.zoom.Zoom

echo "User portion complete!"
echo "Reboot the system to finalize the changes."
