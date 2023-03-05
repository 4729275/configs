#! /bin/bash

### Arch Linux Setup Script - Root Portion ###
# Kenneth Simmons, 2023

echo "Arch Linux Setup - Root Portion - Kenneth Simmons, 2023"

# Configure pacman
echo "Configuring pacman:"
sed -i 's/#Color/Color/g' /etc/pacman.conf
sed -i 's/#VerbosePkgLists/VerbosePkgLists/g' /etc/pacman.conf
sed -i 's/#ParallelDownloads/ParallelDownloads/g' /etc/pacman.conf
echo "[multilib]" | tee -a /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" | tee -a /etc/pacman.conf
pacman -Sy

# Install packages
echo "Installing packages:"
pacman -S --noconfirm audacity audio-convert exa firefox gimp hplip htop inkscape kid3 kleopatra libreoffice-still libxcrypt-compat man-db musescore neofetch ntfs-3g obs-studio psensor qemu qt6-wayland rhythmbox steam virt-manager vlc wireguard-tools yt-dlp
pacman -U --noconfirm https://archive.archlinux.org/packages/q/qt5-webkit-5.212.0alpha4-18-x86_64.pkg.tar.zst

# Create bash aliases
echo "Creating bash aliases:"
echo "if [ -f ~/.bash_aliases ]; then" | tee -a /home/kenneth/.bashrc
echo ". ~/.bash_aliases" | tee -a /home/kenneth/.bashrc
echo "fi" | tee -a /home/kenneth/.bashrc
touch /home/kenneth/.bash_aliases
chown kenneth:users /home/kenneth/.bash_aliases
echo "alias ls='exa -al --group-directories-first --color=always'" | tee -a /home/kenneth/.bash_aliases
#echo "alias wgup='sudo wg-quick up kenneth-desktop'" | tee -a /home/kenneth/.bash_aliases
#echo "alias wgdn='sudo wg-quick down kenneth-desktop'" | tee -a /home/kenneth/.bash_aliases
#echo "alias kremote='ssh -i \$HOME/.ssh/kenneth-remote -p 31415 kenneth@kenneth-remote.interstateks.com'" | tee -a /home/kenneth/.bash_aliases
#echo "alias kraspi='ssh -i \$HOME/.ssh/kenneth-raspi -p 31415 kenneth@192.168.1.20'" | tee -a /home/kenneth/.bash_aliases

echo "Root portion complete!"
echo "Run the user portion to continue."
