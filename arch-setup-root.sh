#! /bin/bash

### Arch Linux Setup Script - Root Portion ###
# Kenneth Simmons, 2024

echo "Arch Linux Setup - Root Portion - Kenneth Simmons, 2024"

# Install packages
echo "Installing packages:"
pacman -S --noconfirm audacity audio-convert brasero dnsmasq eza gimp handbrake hplip htop inkscape kid3 kleopatra libaacs libdvdcss libreoffice-fresh libxcrypt-compat man-db musescore neofetch nextcloud-client ntfs-3g obs-studio psensor pulseaudio-alsa qemu-full qt6-wayland steam tigervnc timeshift transmission-gtk ttf-roboto ufw virt-manager virtualbox vlc wireguard-tools yt-dlp
systemctl enable --now libvirtd.socket
systemctl enable --now systemd-timesyncd
usermod -aG libvirt kenneth
usermod -aG vboxusers kenneth
cd /home/kenneth/Downloads
QT5_WEBKIT_PKGNAME=qt5-webkit-5.212.0alpha4-22-x86_64.pkg.tar.zst ### Update as new versions release ###
wget https://sourceforge.net/projects/fabiololix-os-archive/files/Packages/$QT5_WEBKIT_PKGNAME
pacman -U --noconfirm $QT5_WEBKIT_PKGNAME
rm $QT5_WEBKIT_PKGNAME
cd -

# Configure bash prompt
echo "Configuring bash prompt:"
echo "PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '" | tee -a /home/kenneth/.bashrc
sed -i '10d' /home/kenneth/.bashrc

# Create bash aliases
echo "Creating bash aliases:"
echo "if [ -f ~/.bash_aliases ]; then" >> /home/kenneth/.bashrc
echo ". ~/.bash_aliases" >> /home/kenneth/.bashrc
echo "fi" >> /home/kenneth/.bashrc
touch /home/kenneth/.bash_aliases
chown kenneth:kenneth /home/kenneth/.bash_aliases
echo "alias pacup='paru && flatpak update'" >> /home/kenneth/.bash_aliases
echo "alias ls='eza -al --group-directories-first'" >> /home/kenneth/.bash_aliases
echo "alias wgup='sudo wg-quick up home'" >> /home/kenneth/.bash_aliases
echo "alias wgdn='sudo wg-quick down home'" >> /home/kenneth/.bash_aliases

# Configure systemd timeouts
echo "Configuring systemd timeouts:"
sed -i 's/#DefaultTimeoutStopSec=90s/DefaultTimeoutStopSec=15s/g' /etc/systemd/system.conf
sed -i 's/#DefaultDeviceTimeoutSec=90s/DefaultDeviceTimeoutSec=15s/g' /etc/systemd/system.conf

# Configure firewall
echo "Configuring firewall:"
systemctl enable --now ufw
ufw default allow outgoing
ufw default deny incoming
ufw enable

# Configure yt-dlp
echo "Configuring yt-dlp:"
touch /etc/yt-dlp.conf
echo "-P /home/kenneth/Downloads/" >> /etc/yt-dlp.conf
echo "-x" >> /etc/yt-dlp.conf
echo "--audio-format mp3" >> /etc/yt-dlp.conf
echo "-o \"%(title)s.%(ext)s\"" | tee -a /etc/yt-dlp.conf

echo "Root portion complete!"
echo "Run the user portion to continue."
