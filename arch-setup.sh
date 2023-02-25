#! /bin/bash

### Arch Linux Setup Script ###
# Kenneth Simmons, 2023

echo "Arch Linux Setup - Kenneth Simmons, 2023"

# Configure pacman
echo "Configuring pacman:"
sed -i 's/#Color/Color/g' /etc/pacman.conf
sed -i 's/#VerbosePkgLists/VerbosePkgLists/g' /etc/pacman.conf
sed -i 's/#ParallelDownloads/ParallelDownloads/g' /etc/pacman.conf
sed -i 's/#[multilib]/[multilib]/g' /etc/pacman.conf
sed -i '$ s/#Include/Include/' /etc/pacman.conf
pacman -Sy

# Install AUR helper
echo "Installing AUR helper:"
git clone https://aur.archlinux.org/paru-bin .paru
cd .paru
makepkg -si
cd ..

# Install packages
echo "Installing packages:"
pacman -S --noconfirm audacity audio-convert exa firefox gimp hplip htop inkscape kid3 kleopatra libxcrypt-compat man-db musescore neofetch ntfs-3g obs-studio psensor qt6-wayland rhythmbox steam virt-manager vlc wireguard-tools yt-dlp
echo "Installing AUR packages - manual confirmation required:"
paru -S amdgpu-pro-libgl davinci-resolve google-earth-pro gradience gtkpod libtxc_dxtn onlyoffice-bin opencl-amd paru-bin tilem tilp timeshift ttf-ms-fonts ttf-roboto-fontconfig ventoy-bin zoom

# Create bash aliases
echo "Creating bash aliases:"
echo "if [ -f ~/.bash_aliases ]; then" | tee -a /home/kenneth/.bashrc
echo ". ~/.bash_aliases" | tee -a /home/kenneth/.bashrc
echo "fi" | tee -a /home/kenneth/.bashrc
touch /home/kenneth/.bash_aliases
chown kenneth:users /home/kenneth/.bash_aliases
echo "alias ls='exa -al --group-directories-first --color=always'" | tee -a /home/kenneth/.bash_aliases
echo "alias wgup='sudo wg-quick up kenneth-desktop'" | tee -a /home/kenneth/.bash_aliases
echo "alias wgdn='sudo wg-quick down kenneth-desktop'" | tee -a /home/kenneth/.bash_aliases
echo "alias kremote='ssh -i $HOME/.ssh/kenneth-remote -p 31415 kenneth@kenneth-remote.interstateks.com'" | tee -a /home/kenneth/.bash_aliases
echo "alias kraspi='ssh -i $HOME/.ssh/kenneth-raspi -p 31415 kenneth@192.168.1.20'" | tee -a /home/kenneth/.bash_aliases

echo "Complete!"
echo "Reboot the computer to finalize the changes."
