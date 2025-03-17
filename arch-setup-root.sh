#! /bin/bash

### Arch Linux Setup Script - Root Portion ###
# Kenneth Simmons, 2025

echo "Arch Linux Setup - Root Portion - Kenneth Simmons, 2025"

# Install packages
echo "Installing packages:"
pacman -S --noconfirm cdrtools chromium dnsmasq dvd+rw-tools eza fastfetch gimp gvfs-dnssd handbrake hplip htop inetutils inkscape jre-openjdk k3b kid3 kleopatra libaacs libdvdcss libgpod libreoffice-fresh musescore nextcloud-client obs-studio plymouth psensor qemu-full qt6-wayland reflector rhythmbox rocm-opencl-runtime steam texlive-latex texstudio timeshift tk transmission-gtk ttf-liberation ttf-roboto udftools ufw v4l2loopback-dkms virt-manager virtualbox vlc wireguard-tools yt-dlp zint-qt
systemctl enable --now avahi-daemon.service
sed -i 's/#firewall_backend = "nftables"/firewall_backend = "iptables"/g' /etc/libvirt/network.conf
systemctl enable --now libvirtd
usermod -aG libvirt kenneth
usermod -aG vboxusers kenneth

# Configure reflector
echo "Configuring reflector:"
if [ -f /etc/xdg/reflector/reflector.conf ]; then
mv /etc/xdg/reflector/reflector.conf /etc/xdg/reflector/reflector.conf.bak
fi
echo "--save /etc/pacman.d/mirrorlist" >> /etc/xdg/reflector/reflector.conf
echo "--protocol https" >> /etc/xdg/reflector/reflector.conf
echo "--country US" >> /etc/xdg/reflector/reflector.conf
echo "--latest 200" >> /etc/xdg/reflector/reflector.conf
echo "--number 20" >> /etc/xdg/reflector/reflector.conf
echo "--sort rate" >> /etc/xdg/reflector/reflector.conf
systemctl enable --now reflector
systemctl enable --now reflector.timer

# Configure plymouth
echo "Configuring plymouth:"
if [ ! -f /boot/loader/entries/arch-nosplash.conf ]; then
cp /boot/loader/entries/arch.conf /boot/loader/entries/arch-nosplash.conf
sed -i 's/title Arch Linux/title Arch Linux (no splash screen)/g' /boot/loader/entries/arch-nosplash.conf
sed -i 's/@ rw/@ rw quiet splash/g' /boot/loader/entries/arch.conf
fi

# Configure bash prompt
echo "Configuring bash prompt:"
if [ -f /home/kenneth/.bashrc ]; then
mv /home/kenneth/.bashrc /home/kenneth/.bashrc.bak
chown kenneth:kenneth /home/kenneth/.bashrc.bak
fi
echo "[[ $- != *i* ]] && return" >> /home/kenneth/.bashrc
echo "PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '" >> /home/kenneth/.bashrc

# Create bash aliases
echo "Creating bash aliases:"
echo "if [ -f ~/.bash_aliases ]; then" >> /home/kenneth/.bashrc
echo ". ~/.bash_aliases" >> /home/kenneth/.bashrc
echo "fi" >> /home/kenneth/.bashrc
if [ -f /home/kenneth/.bash_aliases ]; then
mv /home/kenneth/.bash_aliases /home/kenneth/.bash_aliases.bak
chown kenneth:kenneth /home/kenneth/.bash_aliases.bak
fi
echo "alias pacup='paru && flatpak update'" >> /home/kenneth/.bash_aliases
echo "alias ls='eza -al --group-directories-first'" >> /home/kenneth/.bash_aliases
echo "alias wgup='sudo wg-quick up home'" >> /home/kenneth/.bash_aliases
echo "alias wgdn='sudo wg-quick down home'" >> /home/kenneth/.bash_aliases
chown kenneth:kenneth /home/kenneth/.bashrc
chown kenneth:kenneth /home/kenneth/.bash_aliases

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
if [ -f /etc/yt-dlp.conf ]; then
mv /etc/yt-dlp.conf /etc/yt-dlp.conf.bak
fi
echo "-P /home/kenneth/Downloads/" >> /etc/yt-dlp.conf
echo "-x" >> /etc/yt-dlp.conf
echo "--audio-format mp3" >> /etc/yt-dlp.conf
echo "--audio-quality 4" >> /etc/yt-dlp.conf
echo "-o \"%(title)s.%(ext)s\"" >> /etc/yt-dlp.conf

echo "Root portion complete!"
echo "Run the user portion to continue."
