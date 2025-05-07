#! /usr/bin/bash

### Arch Linux Setup Script (Plasma), User Portion ###
# Kenneth Simmons, 2025

echo "Arch Linux Setup, User Portion - Kenneth Simmons, 2025"

# Install AUR helper
echo "Installing AUR helper - manual confirmation required:"
cd /home/kenneth
git clone https://aur.archlinux.org/paru-bin
cd paru-bin
makepkg -si
cd ..
rm -rf paru-bin

# Install AUR packages
echo "Installing AUR packages - manual confirmation required:"
paru -S davinci-resolve libhashab-git makemkv minecraft-launcher mullvad-vpn-bin teamviewer ventoy-bin
sudo systemctl enable --now teamviewerd

# Install Flatpak packages
echo "Installing Flatpak packages:"
flatpak install -y flathub com.github.tchx84.Flatseal com.google.EarthPro  org.onlyoffice.desktopeditors org.gnome.World.PikaBackup us.zoom.Zoom

# Installing correct Vulkan drivers
echo "Installing Vulkan drivers - manual confirmation required:"
sudo pacman -S vulkan-radeon
sudo pacman -Rns amdvlk

# Configure bash prompt
echo "Configuring bash prompt:"
if [ -f /home/kenneth/.bashrc ]; then
mv /home/kenneth/.bashrc /home/kenneth/.bashrc.bak
fi
echo "PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '" >> /home/kenneth/.bashrc

# Create bash aliases
echo "Creating bash aliases:"
echo "if [ -f ~/.bash_aliases ]; then" >> /home/kenneth/.bashrc
echo ". ~/.bash_aliases" >> /home/kenneth/.bashrc
echo "fi" >> /home/kenneth/.bashrc
if [ -f /home/kenneth/.bash_aliases ]; then
mv /home/kenneth/.bash_aliases /home/kenneth/.bash_aliases.bak
fi
echo "alias pacup='paru && flatpak update'" >> /home/kenneth/.bash_aliases
echo "alias ls='eza -al --group-directories-first'" >> /home/kenneth/.bash_aliases
echo "alias wgup='sudo wg-quick up home'" >> /home/kenneth/.bash_aliases
echo "alias wgdn='sudo wg-quick down home'" >> /home/kenneth/.bash_aliases

echo "User portion complete!"
echo "Reboot the system to finalize the changes."
