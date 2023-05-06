#! /bin/bash

### Arch Linux KDE Setup Script - Root Portion ###
# Kenneth Simmons, 2023

echo "Arch Linux Setup for KDE - Root Portion - Kenneth Simmons, 2023"

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
pacman -S --noconfirm audacity audio-convert exa firefox gimp handbrake hplip htop inkscape kid3 libdvdcss libreoffice-fresh libxcrypt-compat man-db musescore neofetch nextcloud-client ntfs-3g obs-studio psensor qemu-base qt6-wayland steam thunderbird virt-manager wireguard-tools
pacman -U --noconfirm https://archive.archlinux.org/packages/q/qt5-webkit-5.212.0alpha4-18-x86_64.pkg.tar.zst

# Create bash aliases
echo "Creating bash aliases:"
echo "if [ -f ~/.bash_aliases ]; then" | tee -a /home/kenneth/.bashrc
echo ". ~/.bash_aliases" | tee -a /home/kenneth/.bashrc
echo "fi" | tee -a /home/kenneth/.bashrc
touch /home/kenneth/.bash_aliases
chown kenneth:users /home/kenneth/.bash_aliases
echo "alias pacup='paru && flatpak update'" | tee -a /home/kenneth/.bash_aliases
echo "alias ls='exa -al --group-directories-first --color=always'" | tee -a /home/kenneth/.bash_aliases
echo "alias wgup='sudo wg-quick up kenneth-home'" | tee -a /home/kenneth/.bash_aliases
echo "alias wgdn='sudo wg-quick down kenneth-home'" | tee -a /home/kenneth/.bash_aliases
echo "alias khome='ssh -i \$HOME/.ssh/kenneth-home -p 314 kenneth@192.168.1.20'" | tee -a /home/kenneth/.bash_aliases

# Configure yt-dlp
echo "Configuring yt-dlp:"
touch /etc/yt-dlp.conf
echo "-P /home/kenneth/Downloads/" | tee -a /etc/yt-dlp.conf
echo "-x" | tee -a /etc/yt-dlp.conf
echo "--audio-format mp3" | tee -a /etc/yt-dlp.conf
echo "-o \"%(title)s.%(ext)s\"" | tee -a /etc/yt-dlp.conf

echo "Root portion complete!"
echo "Run the user portion to continue."
