#! /bin/bash

### Arch Linux Setup Script - User Portion ###
# Kenneth Simmons, 2025

echo "Arch Linux Setup - User Portion - Kenneth Simmons, 2025"

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
paru -S davinci-resolve google-earth-pro libhashab-git makemkv teamviewer tilem tilp ventoy-bin
sudo systemctl enable --now teamviewerd

# Install Flatpak packages
echo "Installing Flatpak packages:"
flatpak install -y flathub com.github.tchx84.Flatseal io.gitlab.news_flash.NewsFlash org.audacityteam.Audacity org.gnome.World.PikaBackup org.onlyoffice.desktopeditors org.raspberrypi.rpi-imager us.zoom.Zoom

# Installing correct Vulkan drivers
echo "Installing Vulkan drivers - manual confirmation required:"
sudo pacman -S vulkan-radeon
sudo pacman -Rns amdvlk
 
echo "User portion complete!"
echo "Reboot the system to finalize the changes."
