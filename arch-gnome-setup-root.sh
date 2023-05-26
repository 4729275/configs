#! /bin/bash

### Arch Linux GNOME Setup Script - Root Portion ###
# Kenneth Simmons, 2023

echo "Arch Linux Setup for GNOME - Root Portion - Kenneth Simmons, 2023"

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
pacman -S --noconfirm audacity audio-convert brasero exa firefox gimp handbrake hplip htop inkscape kid3 kleopatra libdvdcss libreoffice-fresh libxcrypt-compat man-db musescore neofetch nextcloud-client ntfs-3g obs-studio psensor qemu-base qt6-wayland rhythmbox steam thunderbird virt-manager vlc wireguard-tools yt-dlp
cd /home/kenneth/Downloads
wget https://sourceforge.net/projects/fabiololix-os-archive/files/Packages/qt5-webkit-5.212.0alpha4-19-x86_64.pkg.tar.zst ### UPDATE LINK IF IT BECOMES OBSOLETE ###
cd
pacman -U --noconfirm /home/kenneth/Downloads/qt5-webkit-5.212.0alpha4-19-x86_64.pkg.tar.zst

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