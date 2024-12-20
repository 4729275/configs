#! /bin/bash

### Arch Linux Setup Script - Root Portion ###
# Kenneth Simmons, 2024

echo "Arch Linux Setup - Root Portion - Kenneth Simmons, 2024"

# Install packages
echo "Installing packages:"
pacman -S --noconfirm audacity audio-convert brasero dnsmasq eza fastfetch firefox gimp gvfs-dnssd handbrake hplip htop inetutils inkscape jre-openjdk kid3 kleopatra libaacs libdvdcss libgpod libreoffice-fresh musescore nextcloud-client obs-studio pipewire-alsa psensor qemu-full qt6-wayland reflector rhythmbox rocm-opencl-runtime steam texlive-latex texstudio timeshift transmission-gtk ttf-liberation ttf-roboto ufw v4l2loopback-dkms virt-manager virtualbox vlc wireguard-tools yt-dlp zint-qt
systemctl enable --now avahi-daemon.service
sed -i 's/#firewall_backend = "nftables"/firewall_backend = "iptables"/g' /etc/libvirt/network.conf
systemctl enable --now libvirtd
usermod -aG libvirt kenneth
usermod -aG vboxusers kenneth

# Configure reflector
echo "Configuring reflector:"
rm /etc/xdg/reflector/reflector.conf
touch /etc/xdg/reflector/reflector.conf
echo "--save /etc/pacman.d/mirrorlist" >> /etc/xdg/reflector/reflector.conf
echo "--protocol https" >> /etc/xdg/reflector/reflector.conf
echo "--country 'United States'" >> /etc/xdg/reflector/reflector.conf
echo "--latest 5" >> /etc/xdg/reflector/reflector.conf
echo "--sort rate" >> /etc/xdg/reflector/reflector.conf
systemctl enable --now reflector
systemctl enable --now reflector.timer

# Configure bash prompt
echo "Configuring bash prompt:"
echo "PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '" >> /home/kenneth/.bashrc
sed -i '10d' /home/kenneth/.bashrc

# Create bash aliases
echo "Creating bash aliases:"
echo "if [ -f ~/.bash_aliases ]; then" >> /home/kenneth/.bashrc
echo ". ~/.bash_aliases" >> /home/kenneth/.bashrc
echo "fi" >> /home/kenneth/.bashrc
touch /home/kenneth/.bash_aliases
echo "alias pacup='paru && flatpak update'" >> /home/kenneth/.bash_aliases
echo "alias ls='eza -al --group-directories-first'" >> /home/kenneth/.bash_aliases
echo "alias wgup='sudo wg-quick up home'" >> /home/kenneth/.bash_aliases
echo "alias wgdn='sudo wg-quick down home'" >> /home/kenneth/.bash_aliases
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
touch /etc/yt-dlp.conf
echo "-P /home/kenneth/Downloads/" >> /etc/yt-dlp.conf
echo "-x" >> /etc/yt-dlp.conf
echo "--audio-format mp3" >> /etc/yt-dlp.conf
echo "-o \"%(title)s.%(ext)s\"" >> /etc/yt-dlp.conf

echo "Root portion complete!"
echo "Run the user portion to continue."
