#! /usr/bin/bash

### Arch Linux Setup Script (Plasma), Root Portion ###
# Kenneth Simmons, 2025

echo "Arch Linux Setup, Root Portion - Kenneth Simmons, 2025"

# Install packages
echo "Installing packages:"
pacman -Sy --noconfirm akregator audacity cdrtools devede dnsmasq dvd+rw-tools eza fastfetch gimp handbrake hplip htop inetutils inkscape jre-openjdk k3b kid3 kleopatra ktorrent libaacs libdvdcss libreoffice-fresh mkvtoolnix-gui musescore nextcloud-client obs-studio qemu-full reflector rocm-opencl-runtime rpi-imager steam strawberry texlive-latex texstudio timeshift tk ttf-liberation ttf-roboto udftools ufw v4l2loopback-dkms virt-manager virtualbox vulkan-radeon wireguard-tools yt-dlp
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

# Configure sddm
echo "Configuring sddm:"
if [ -f /etc/sddm.conf ]; then
mv /etc/sddm.conf /etc/sddm.conf.bak
fi
echo "[General]" >> /etc/sddm.conf
echo "InputMethod=" >> /etc/sddm.conf
echo "Numlock=on" >> /etc/sddm.conf

# Configure plymouth
echo "Configuring plymouth:"
if [ ! -f /boot/loader/entries/arch-nosplash.conf ]; then
cp /boot/loader/entries/arch.conf /boot/loader/entries/arch-nosplash.conf
sed -i 's/title Arch Linux/title Arch Linux (no splash screen)/g' /boot/loader/entries/arch-nosplash.conf
sed -i 's/@ rw/@ rw quiet splash/g' /boot/loader/entries/arch.conf
fi

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
echo "--audio-format best" >> /etc/yt-dlp.conf
echo "-o \"%(title)s.%(ext)s\"" >> /etc/yt-dlp.conf

echo "Root portion complete!"
echo "Run the user portion to continue."
